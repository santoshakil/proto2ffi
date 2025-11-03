use crate::layout::{Layout, MessageLayout, FieldLayout};
use crate::types::FieldType;
use crate::error::Result;
use quote::quote;
use proc_macro2::TokenStream;
use std::path::Path;
use std::fs;

pub fn generate_rust_proto_models(layout: &Layout, output: &Path) -> Result<()> {
    let mut tokens = TokenStream::new();

    for message in &layout.messages {
        tokens.extend(generate_proto_model(message));
    }

    for enum_layout in &layout.enums {
        tokens.extend(generate_proto_enum(enum_layout));
    }

    let output_code = quote! {
        #![allow(dead_code)]

        #tokens
    };

    fs::write(output, output_code.to_string())?;
    Ok(())
}

fn generate_proto_model(message: &MessageLayout) -> TokenStream {
    let name = syn::Ident::new(&message.name, proc_macro2::Span::call_site());
    let fields = message.fields.iter().map(|f| generate_proto_field(f));

    quote! {
        #[derive(Debug, Clone, PartialEq)]
        pub struct #name {
            #(#fields),*
        }

        impl #name {
            pub fn new() -> Self {
                Self::default()
            }
        }

        impl Default for #name {
            fn default() -> Self {
                Self {
                    #(#(generate_default_field_values(message.fields.iter()))),*
                }
            }
        }
    }
}

fn generate_proto_field(field: &FieldLayout) -> TokenStream {
    let name = syn::Ident::new(&field.name, proc_macro2::Span::call_site());
    let rust_type = field_to_proto_type(field);

    quote! {
        pub #name: #rust_type
    }
}

fn field_to_proto_type(field: &FieldLayout) -> TokenStream {
    let base_type = match field.rust_type.as_str() {
        "u8" => quote! { u8 },
        "u16" => quote! { u16 },
        "u32" => quote! { u32 },
        "u64" => quote! { u64 },
        "i8" => quote! { i8 },
        "i16" => quote! { i16 },
        "i32" => quote! { i32 },
        "i64" => quote! { i64 },
        "f32" => quote! { f32 },
        "f64" => quote! { f64 },
        "bool" => quote! { bool },
        t if t.starts_with('[') => {
            // Array type - convert to Vec
            let inner = t.trim_start_matches('[').trim_end_matches(']');
            let parts: Vec<&str> = inner.split(';').collect();
            if parts.len() == 2 {
                let element_type = syn::Ident::new(parts[0].trim(), proc_macro2::Span::call_site());
                return quote! { Vec<#element_type> };
            }
            quote! { Vec<u8> }
        }
        t => {
            let ty = syn::Ident::new(t, proc_macro2::Span::call_site());
            quote! { #ty }
        }
    };

    if field.repeated {
        quote! { Vec<#base_type> }
    } else {
        base_type
    }
}

fn generate_default_field_values<'a>(fields: impl Iterator<Item = &'a FieldLayout>) -> impl Iterator<Item = TokenStream> + 'a {
    fields.map(|f| {
        let name = syn::Ident::new(&f.name, proc_macro2::Span::call_site());
        let default_val = get_default_value(f);
        quote! { #name: #default_val }
    })
}

fn get_default_value(field: &FieldLayout) -> TokenStream {
    if field.repeated {
        return quote! { Vec::new() };
    }

    match field.rust_type.as_str() {
        "u8" | "u16" | "u32" | "u64" | "i8" | "i16" | "i32" | "i64" => quote! { 0 },
        "f32" | "f64" => quote! { 0.0 },
        "bool" => quote! { false },
        t if t.starts_with('[') => quote! { Vec::new() },
        _ => {
            let ty = syn::Ident::new(&field.rust_type, proc_macro2::Span::call_site());
            quote! { #ty::default() }
        }
    }
}

fn generate_proto_enum(enum_layout: &crate::layout::EnumLayout) -> TokenStream {
    let name = syn::Ident::new(&enum_layout.name, proc_macro2::Span::call_site());
    let variants = enum_layout.variants.iter().map(|(variant_name, value)| {
        let variant = syn::Ident::new(variant_name, proc_macro2::Span::call_site());
        let val = *value;
        quote! { #variant = #val }
    });

    quote! {
        #[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
        #[repr(u32)]
        pub enum #name {
            #(#variants),*
        }

        impl Default for #name {
            fn default() -> Self {
                Self:: #(#(enum_layout.variants.first().map(|(n, _)| syn::Ident::new(n, proc_macro2::Span::call_site()))))*
            }
        }

        impl From<u32> for #name {
            fn from(value: u32) -> Self {
                match value {
                    #(#(enum_layout.variants.iter().map(|(n, v)| {
                        let variant = syn::Ident::new(n, proc_macro2::Span::call_site());
                        let val = *v as u32;
                        quote! { #val => Self::#variant }
                    }))),*,
                    _ => Self::default()
                }
            }
        }

        impl From<#name> for u32 {
            fn from(value: #name) -> u32 {
                value as u32
            }
        }
    }
}

pub fn generate_dart_proto_models(layout: &Layout, output: &Path) -> Result<()> {
    let mut code = String::new();

    code.push_str("// Generated proto models - user-facing idiomatic Dart\n\n");

    for message in &layout.messages {
        code.push_str(&generate_dart_proto_class(message));
        code.push_str("\n\n");
    }

    for enum_layout in &layout.enums {
        code.push_str(&generate_dart_proto_enum(enum_layout));
        code.push_str("\n\n");
    }

    fs::write(output, code)?;
    Ok(())
}

fn generate_dart_proto_class(message: &MessageLayout) -> String {
    let fields = message
        .fields
        .iter()
        .map(|f| {
            let dart_type = field_to_dart_proto_type(f);
            format!("  final {} {};", dart_type, f.name)
        })
        .collect::<Vec<_>>()
        .join("\n");

    let constructor_params = message
        .fields
        .iter()
        .map(|f| format!("required this.{}", f.name))
        .collect::<Vec<_>>()
        .join(", ");

    format!(
        "class {} {{\n{}\n\n  const {}({{{}}});\n}}",
        message.name, fields, message.name, constructor_params
    )
}

fn field_to_dart_proto_type(field: &FieldLayout) -> String {
    let base_type = match field.dart_type.as_str() {
        "int" | "double" | "bool" => field.dart_type.clone(),
        "Pointer<Utf8>" | "Pointer<Uint8>" => "String".to_string(),
        _ => field.dart_type.clone(),
    };

    if field.repeated {
        format!("List<{}>", base_type)
    } else {
        base_type
    }
}

fn generate_dart_proto_enum(enum_layout: &crate::layout::EnumLayout) -> String {
    let variants = enum_layout
        .variants
        .iter()
        .map(|(name, _)| name.clone())
        .collect::<Vec<_>>()
        .join(", ");

    format!("enum {} {{ {} }}", enum_layout.name, variants)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::layout::{Layout, MessageLayout, FieldLayout, EnumLayout};
    use std::collections::HashMap;

    #[test]
    fn test_generate_simple_proto_model() {
        let layout = Layout {
            messages: vec![MessageLayout {
                name: "User".into(),
                size: 16,
                alignment: 8,
                fields: vec![
                    FieldLayout {
                        name: "id".into(),
                        rust_type: "u32".into(),
                        dart_type: "int".into(),
                        dart_annotation: "Uint32()".into(),
                        c_type: "uint32_t".into(),
                        offset: 0,
                        size: 4,
                        alignment: 4,
                        repeated: false,
                        max_count: None,
                    },
                    FieldLayout {
                        name: "age".into(),
                        rust_type: "u32".into(),
                        dart_type: "int".into(),
                        dart_annotation: "Uint32()".into(),
                        c_type: "uint32_t".into(),
                        offset: 4,
                        size: 4,
                        alignment: 4,
                        repeated: false,
                        max_count: None,
                    },
                ],
                options: HashMap::new(),
            }],
            enums: vec![],
            alignment: 8,
        };

        let tokens = generate_proto_model(&layout.messages[0]);
        let code = tokens.to_string();

        assert!(code.contains("pub struct User"));
        assert!(code.contains("pub id : u32"));
        assert!(code.contains("pub age : u32"));
    }
}
