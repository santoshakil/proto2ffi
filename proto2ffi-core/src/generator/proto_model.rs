use crate::layout::{Layout, MessageLayout, FieldLayout};
use crate::error::Result;
use quote::quote;
use proc_macro2::TokenStream;
use std::path::Path;
use std::fs;

/// Generate user-facing proto models in Rust (Layer 1 - idiomatic types)
pub fn generate_rust_proto_models(layout: &Layout, output: &Path) -> Result<()> {
    let mut tokens = TokenStream::new();

    // Generate enums first (no dependencies)
    for enum_layout in &layout.enums {
        tokens.extend(generate_rust_proto_enum(enum_layout));
    }

    // Generate message structs
    for message in &layout.messages {
        tokens.extend(generate_rust_proto_struct(message));
    }

    let output_code = quote! {
        #![allow(dead_code)]

        #tokens
    };

    fs::write(output, output_code.to_string())?;

    // Format the output
    let _ = std::process::Command::new("rustfmt")
        .arg(output)
        .status();

    Ok(())
}

fn generate_rust_proto_struct(message: &MessageLayout) -> TokenStream {
    let struct_name = syn::Ident::new(&message.name, proc_macro2::Span::call_site());

    // Generate field declarations
    let field_decls: Vec<TokenStream> = message.fields.iter().map(|field| {
        let field_name = syn::Ident::new(&field.name, proc_macro2::Span::call_site());
        let field_type = rust_proto_type_from_field(field);
        quote! { pub #field_name: #field_type }
    }).collect();

    // Generate default field values
    let default_fields: Vec<TokenStream> = message.fields.iter().map(|field| {
        let field_name = syn::Ident::new(&field.name, proc_macro2::Span::call_site());
        let default_value = rust_default_value_for_field(field);
        quote! { #field_name: #default_value }
    }).collect();

    quote! {
        #[derive(Debug, Clone, PartialEq)]
        pub struct #struct_name {
            #(#field_decls),*
        }

        impl #struct_name {
            pub fn new() -> Self {
                Self::default()
            }
        }

        impl Default for #struct_name {
            fn default() -> Self {
                Self {
                    #(#default_fields),*
                }
            }
        }
    }
}

fn rust_proto_type_from_field(field: &FieldLayout) -> TokenStream {
    // Convert FFI types to idiomatic Rust types
    let base_type = match field.rust_type.as_str() {
        // Primitives stay the same
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

        // Array types become Vec for user
        s if s.starts_with('[') && s.contains("u8") => {
            // String or bytes - becomes String
            quote! { String }
        }

        s if s.starts_with('[') => {
            // Extract element type from [T; N] and make it Vec<T>
            if let Some(inner) = s.strip_prefix('[').and_then(|s| s.split(';').next()) {
                let inner = inner.trim();
                if inner == "u8" {
                    quote! { Vec<u8> }
                } else {
                    let inner_ident = syn::Ident::new(inner, proc_macro2::Span::call_site());
                    quote! { Vec<#inner_ident> }
                }
            } else {
                quote! { Vec<u8> }
            }
        }

        // Other types (enums, nested messages)
        other => {
            let ty = syn::Ident::new(other, proc_macro2::Span::call_site());
            quote! { #ty }
        }
    };

    if field.repeated {
        quote! { Vec<#base_type> }
    } else {
        base_type
    }
}

fn rust_default_value_for_field(field: &FieldLayout) -> TokenStream {
    if field.repeated {
        return quote! { Vec::new() };
    }

    match field.rust_type.as_str() {
        "u8" | "u16" | "u32" | "u64" | "i8" | "i16" | "i32" | "i64" => quote! { 0 },
        "f32" | "f64" => quote! { 0.0 },
        "bool" => quote! { false },
        s if s.starts_with('[') && s.contains("u8") => quote! { String::new() },
        s if s.starts_with('[') => quote! { Vec::new() },
        _ => {
            let ty = syn::Ident::new(&field.rust_type, proc_macro2::Span::call_site());
            quote! { #ty::default() }
        }
    }
}

fn generate_rust_proto_enum(enum_layout: &crate::layout::EnumLayout) -> TokenStream {
    let enum_name = syn::Ident::new(&enum_layout.name, proc_macro2::Span::call_site());

    let variants: Vec<TokenStream> = enum_layout.variants.iter().map(|(variant_name, value)| {
        let variant_ident = syn::Ident::new(variant_name, proc_macro2::Span::call_site());
        let val = *value;
        quote! { #variant_ident = #val }
    }).collect();

    let first_variant = enum_layout.variants.first()
        .map(|(name, _)| syn::Ident::new(name, proc_macro2::Span::call_site()));

    let default_impl = if let Some(first) = first_variant {
        quote! {
            impl Default for #enum_name {
                fn default() -> Self {
                    Self::#first
                }
            }
        }
    } else {
        TokenStream::new()
    };

    let from_u32_arms: Vec<TokenStream> = enum_layout.variants.iter().map(|(name, value)| {
        let variant = syn::Ident::new(name, proc_macro2::Span::call_site());
        let val = *value as u32;
        quote! { #val => Self::#variant }
    }).collect();

    quote! {
        #[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
        #[repr(u32)]
        pub enum #enum_name {
            #(#variants),*
        }

        #default_impl

        impl From<u32> for #enum_name {
            fn from(value: u32) -> Self {
                match value {
                    #(#from_u32_arms),*,
                    _ => Self::default()
                }
            }
        }

        impl From<#enum_name> for u32 {
            fn from(value: #enum_name) -> u32 {
                value as u32
            }
        }
    }
}

/// Generate user-facing proto models in Dart (Layer 1 - idiomatic types)
pub fn generate_dart_proto_models(layout: &Layout, output: &Path) -> Result<()> {
    let mut code = String::new();

    code.push_str("// Generated proto models - user-facing idiomatic Dart\n");
    code.push_str("// Users interact with these classes, FFI is hidden\n\n");

    // Generate enums first
    for enum_layout in &layout.enums {
        code.push_str(&generate_dart_proto_enum(enum_layout));
        code.push_str("\n\n");
    }

    // Generate classes
    for message in &layout.messages {
        code.push_str(&generate_dart_proto_class(message));
        code.push_str("\n\n");
    }

    fs::write(output, code)?;
    Ok(())
}

fn generate_dart_proto_class(message: &MessageLayout) -> String {
    let class_name = &message.name;

    // Generate fields with idiomatic Dart types
    let fields: Vec<String> = message.fields.iter().map(|field| {
        let dart_type = dart_proto_type_from_field(field);
        format!("  final {} {};", dart_type, field.name)
    }).collect();

    // Constructor parameters
    let constructor_params: Vec<String> = message.fields.iter().map(|field| {
        format!("required this.{}", field.name)
    }).collect();

    // Generate copyWith method
    let copy_with_params: Vec<String> = message.fields.iter().map(|field| {
        let dart_type = dart_proto_type_from_field(field);
        format!("    {}? {}", dart_type, field.name)
    }).collect();

    let copy_with_fields: Vec<String> = message.fields.iter().map(|field| {
        format!("      {}: {} ?? this.{}", field.name, field.name, field.name)
    }).collect();

    format!(
        "class {} {{\n{}\n\n  const {}({{{}}});\n\n  {} copyWith({{\n{},\n  }}) {{\n    return {}(\n{},\n    );\n  }}\n}}",
        class_name,
        fields.join("\n"),
        class_name,
        constructor_params.join(", "),
        class_name,
        copy_with_params.join(",\n"),
        class_name,
        copy_with_fields.join(",\n")
    )
}

fn dart_proto_type_from_field(field: &FieldLayout) -> String {
    // Convert FFI types to idiomatic Dart types
    let base_type = match field.dart_type.as_str() {
        "int" | "double" | "bool" => field.dart_type.clone(),
        "Pointer<Utf8>" | "Pointer<Uint8>" => "String".to_string(),
        s if s.starts_with("Pointer") => {
            // Extract inner type from Pointer<T>
            if let Some(inner) = s.strip_prefix("Pointer<").and_then(|s| s.strip_suffix(">")) {
                inner.to_string()
            } else {
                "dynamic".to_string()
            }
        }
        _ => field.dart_type.clone(),
    };

    if field.repeated {
        format!("List<{}>", base_type)
    } else {
        base_type
    }
}

fn generate_dart_proto_enum(enum_layout: &crate::layout::EnumLayout) -> String {
    let enum_name = &enum_layout.name;
    let variants: Vec<String> = enum_layout.variants.iter()
        .map(|(name, _)| name.clone())
        .collect();

    format!("enum {} {{ {} }}", enum_name, variants.join(", "))
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::layout::{MessageLayout, FieldLayout};
    use std::collections::HashMap;

    #[test]
    fn test_rust_proto_type_primitive() {
        let field = FieldLayout {
            name: "age".into(),
            rust_type: "u32".into(),
            dart_type: "int".into(),
            dart_annotation: "Uint32()".into(),
            c_type: "uint32_t".into(),
            offset: 0,
            size: 4,
            alignment: 4,
            repeated: false,
            max_count: None,
        };

        let tokens = rust_proto_type_from_field(&field);
        assert_eq!(tokens.to_string(), "u32");
    }

    #[test]
    fn test_rust_proto_type_string() {
        let field = FieldLayout {
            name: "name".into(),
            rust_type: "[u8; 256]".into(),
            dart_type: "Pointer<Utf8>".into(),
            dart_annotation: "".into(),
            c_type: "char".into(),
            offset: 0,
            size: 256,
            alignment: 1,
            repeated: false,
            max_count: None,
        };

        let tokens = rust_proto_type_from_field(&field);
        assert_eq!(tokens.to_string(), "String");
    }

    #[test]
    fn test_rust_proto_type_repeated() {
        let field = FieldLayout {
            name: "ids".into(),
            rust_type: "u32".into(),
            dart_type: "int".into(),
            dart_annotation: "Uint32()".into(),
            c_type: "uint32_t".into(),
            offset: 0,
            size: 4,
            alignment: 4,
            repeated: true,
            max_count: Some(100),
        };

        let tokens = rust_proto_type_from_field(&field);
        assert_eq!(tokens.to_string(), "Vec < u32 >");
    }

    #[test]
    fn test_generate_simple_struct() {
        let message = MessageLayout {
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
                    name: "name".into(),
                    rust_type: "[u8; 256]".into(),
                    dart_type: "Pointer<Utf8>".into(),
                    dart_annotation: "".into(),
                    c_type: "char".into(),
                    offset: 4,
                    size: 256,
                    alignment: 1,
                    repeated: false,
                    max_count: None,
                },
            ],
            options: HashMap::new(),
        };

        let tokens = generate_rust_proto_struct(&message);
        let code = tokens.to_string();

        assert!(code.contains("pub struct User"));
        assert!(code.contains("pub id : u32"));
        assert!(code.contains("pub name : String"));
        assert!(code.contains("impl Default for User"));
    }

    #[test]
    fn test_dart_proto_class() {
        let message = MessageLayout {
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
            ],
            options: HashMap::new(),
        };

        let code = generate_dart_proto_class(&message);
        assert!(code.contains("class User"));
        assert!(code.contains("final int id"));
        assert!(code.contains("copyWith"));
    }
}
