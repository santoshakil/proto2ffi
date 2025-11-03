use crate::error::Result;
use crate::layout::{Layout, MessageLayout, EnumLayout};
use quote::{quote, format_ident};
use proc_macro2::{TokenStream, Ident, Span};
use std::fs;
use std::path::Path;

fn escape_rust_keyword(name: &str) -> Ident {
    const RUST_KEYWORDS: &[&str] = &[
        "as", "break", "const", "continue", "crate", "else", "enum", "extern",
        "false", "fn", "for", "if", "impl", "in", "let", "loop", "match", "mod",
        "move", "mut", "pub", "ref", "return", "self", "Self", "static", "struct",
        "super", "trait", "true", "type", "unsafe", "use", "where", "while",
        "async", "await", "dyn", "abstract", "become", "box", "do", "final",
        "macro", "override", "priv", "typeof", "unsized", "virtual", "yield", "try",
    ];

    if RUST_KEYWORDS.contains(&name) {
        Ident::new_raw(name, Span::call_site())
    } else {
        format_ident!("{}", name)
    }
}

pub fn generate_rust(layout: &Layout, output_dir: &Path) -> Result<()> {
    fs::create_dir_all(output_dir)?;

    let mut tokens = TokenStream::new();

    tokens.extend(quote! {
        #![allow(dead_code)]
        #![allow(non_camel_case_types)]
        #![allow(non_snake_case)]
        #![allow(unused_imports)]

        use std::mem;
        use std::slice;
        use std::marker::PhantomData;
    });

    for enum_layout in &layout.enums {
        tokens.extend(generate_enum(enum_layout)?);
    }

    for message in &layout.messages {
        tokens.extend(generate_message_struct(message)?);
        tokens.extend(generate_message_impl(message)?);
        tokens.extend(generate_message_ffi(message)?);

        if message.options.get("proto2ffi.pool_size").is_some() {
            tokens.extend(super::pool::generate_pool_allocator(message));
        }

        if let Some(simd_ops) = super::simd::generate_simd_operations(message) {
            tokens.extend(simd_ops);
        }
    }

    let output_file = output_dir.join("generated.rs");
    fs::write(&output_file, tokens.to_string())?;

    let _ = std::process::Command::new("rustfmt")
        .arg(&output_file)
        .status();

    Ok(())
}

fn generate_enum(enum_layout: &EnumLayout) -> Result<TokenStream> {
    let name = format_ident!("{}", enum_layout.name);
    let variants: Vec<_> = enum_layout.variants.iter().map(|(var_name, value)| {
        let variant = format_ident!("{}", var_name);
        let val = proc_macro2::Literal::u32_unsuffixed(*value as u32);
        quote! { #variant = #val }
    }).collect();

    Ok(quote! {
        #[repr(u32)]
        #[derive(Copy, Clone, Debug, PartialEq, Eq)]
        pub enum #name {
            #(#variants,)*
        }
    })
}

fn generate_message_struct(message: &MessageLayout) -> Result<TokenStream> {
    let name = format_ident!("{}", message.name);
    let alignment = proc_macro2::Literal::usize_unsuffixed(message.alignment);

    let mut fields = Vec::new();

    for field in &message.fields {
        if field.repeated && field.max_count.is_some() {
            let count_field = format_ident!("{}_count", field.name);
            fields.push(quote! { pub #count_field: u32 });
        }

        let field_name = escape_rust_keyword(&field.name);
        let field_type = parse_rust_type(&field.rust_type);
        fields.push(quote! { pub #field_name: #field_type });
    }

    Ok(quote! {
        #[repr(C, align(#alignment))]
        #[derive(Copy, Clone, Debug)]
        pub struct #name {
            #(#fields,)*
        }
    })
}

fn generate_message_impl(message: &MessageLayout) -> Result<TokenStream> {
    let name = format_ident!("{}", message.name);
    let size = proc_macro2::Literal::usize_unsuffixed(message.size);
    let alignment = proc_macro2::Literal::usize_unsuffixed(message.alignment);

    let mut methods = Vec::new();

    for field in &message.fields {
        if field.repeated {
            if let Some(max_count_val) = field.max_count {
                let field_name = escape_rust_keyword(&field.name);
                let count_field = format_ident!("{}_count", field.name);
                let max_count = proc_macro2::Literal::usize_unsuffixed(max_count_val);

                let element_type = if field.rust_type.starts_with('[') {
                    field.rust_type
                        .trim_start_matches('[')
                        .split(';')
                        .next()
                        .map(|s| s.trim().to_string())
                        .unwrap_or_else(|| field.rust_type.clone())
                } else {
                    field.rust_type.clone()
                };
                let elem_type = parse_rust_type(&element_type);

                methods.push(quote! {
                    #[inline(always)]
                    pub fn #field_name(&self) -> &[#elem_type] {
                        &self.#field_name[..self.#count_field as usize]
                    }
                });

                let getter_mut = format_ident!("{}_mut", field.name);
                methods.push(quote! {
                    #[inline(always)]
                    pub fn #getter_mut(&mut self) -> &mut [#elem_type] {
                        let count = self.#count_field as usize;
                        &mut self.#field_name[..count]
                    }
                });

                let add_method = format_ident!("add_{}", field.name.trim_end_matches('s'));
                methods.push(quote! {
                    pub fn #add_method(&mut self, item: #elem_type) -> Result<(), &'static str> {
                        if self.#count_field >= #max_count as u32 {
                            return Err("Array full");
                        }
                        self.#field_name[self.#count_field as usize] = item;
                        self.#count_field += 1;
                        Ok(())
                    }
                });
            }
        }
    }

    Ok(quote! {
        impl #name {
            pub const SIZE: usize = #size;
            pub const ALIGNMENT: usize = #alignment;

            #[inline(always)]
            pub unsafe fn from_ptr(ptr: *const u8) -> &'static Self {
                assert!(!ptr.is_null(), "Null pointer passed to from_ptr");
                assert!(
                    ptr as usize % Self::ALIGNMENT == 0,
                    "Misaligned pointer passed to from_ptr: {:p} (alignment: {})",
                    ptr, Self::ALIGNMENT
                );
                &*(ptr as *const Self)
            }

            #[inline(always)]
            pub unsafe fn from_ptr_mut(ptr: *mut u8) -> &'static mut Self {
                assert!(!ptr.is_null(), "Null pointer passed to from_ptr_mut");
                assert!(
                    ptr as usize % Self::ALIGNMENT == 0,
                    "Misaligned pointer passed to from_ptr_mut: {:p} (alignment: {})",
                    ptr, Self::ALIGNMENT
                );
                &mut *(ptr as *mut Self)
            }

            #(#methods)*
        }

        impl Default for #name {
            fn default() -> Self {
                unsafe { mem::zeroed() }
            }
        }
    })
}

fn generate_message_ffi(message: &MessageLayout) -> Result<TokenStream> {
    let name = format_ident!("{}", message.name);
    let size_fn = format_ident!("{}_size", message.name.to_lowercase());
    let align_fn = format_ident!("{}_alignment", message.name.to_lowercase());

    Ok(quote! {
        #[no_mangle]
        pub extern "C" fn #size_fn() -> usize {
            #name::SIZE
        }

        #[no_mangle]
        pub extern "C" fn #align_fn() -> usize {
            #name::ALIGNMENT
        }
    })
}

fn parse_rust_type(type_str: &str) -> TokenStream {
    if type_str.starts_with('[') || type_str.starts_with('*') {
        type_str.parse().unwrap_or_else(|e| {
            panic!(
                "Failed to parse Rust type '{}': {}. This is a bug in the code generator.",
                type_str, e
            )
        })
    } else {
        let ident = format_ident!("{}", type_str);
        quote! { #ident }
    }
}
