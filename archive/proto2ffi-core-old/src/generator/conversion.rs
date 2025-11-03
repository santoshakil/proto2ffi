use crate::layout::{Layout, MessageLayout, FieldLayout};
use crate::error::Result;
use quote::quote;
use proc_macro2::TokenStream;
use std::path::Path;
use std::fs;

/// Generate conversion layer between proto models and FFI structs (Layer 3)
/// This makes FFI completely transparent to users
pub fn generate_rust_conversions(layout: &Layout, output: &Path) -> Result<()> {
    let mut tokens = TokenStream::new();

    for message in &layout.messages {
        tokens.extend(generate_message_conversions(message, layout));
    }

    let output_code = quote! {
        #![allow(dead_code)]

        use super::proto::*;  // Proto models
        use super::ffi::*;    // FFI structs

        #tokens
    };

    fs::write(output, output_code.to_string())?;

    // Format the output
    let _ = std::process::Command::new("rustfmt")
        .arg(output)
        .status();

    Ok(())
}

fn generate_message_conversions(message: &MessageLayout, layout: &Layout) -> TokenStream {
    let proto_name = syn::Ident::new(&message.name, proc_macro2::Span::call_site());
    let ffi_name = syn::Ident::new(&format!("{}FFI", message.name), proc_macro2::Span::call_site());

    // Generate to_ffi method
    let to_ffi_fields = message.fields.iter().map(|field| {
        generate_to_ffi_field(field, layout)
    });

    // Generate from_ffi method
    let from_ffi_fields = message.fields.iter().map(|field| {
        generate_from_ffi_field(field, layout)
    });

    quote! {
        impl #proto_name {
            /// Convert to FFI representation (zero-copy where possible)
            pub fn to_ffi(&self) -> #ffi_name {
                let mut ffi = #ffi_name::default();

                #(#to_ffi_fields)*

                ffi
            }

            /// Convert from FFI representation
            pub fn from_ffi(ffi: &#ffi_name) -> Self {
                Self {
                    #(#from_ffi_fields),*
                }
            }
        }
    }
}

fn generate_to_ffi_field(field: &FieldLayout, _layout: &Layout) -> TokenStream {
    let field_name = syn::Ident::new(&field.name, proc_macro2::Span::call_site());

    match field.rust_type.as_str() {
        // Primitives - direct copy
        "u8" | "u16" | "u32" | "u64" | "i8" | "i16" | "i32" | "i64" | "f32" | "f64" | "bool" => {
            quote! {
                ffi.#field_name = self.#field_name;
            }
        }

        // String field - copy to fixed array with length
        s if s.starts_with('[') && s.contains("u8") && !field.repeated => {
            // Extract array size from [u8; N]
            let len_field = syn::Ident::new(&format!("{}_len", field.name), proc_macro2::Span::call_site());

            quote! {
                {
                    let bytes = self.#field_name.as_bytes();
                    let copy_len = bytes.len().min(ffi.#field_name.len());
                    ffi.#field_name[..copy_len].copy_from_slice(&bytes[..copy_len]);
                    ffi.#len_field = copy_len as u32;
                }
            }
        }

        // Vec/repeated primitives - copy to fixed array with count
        s if !s.starts_with('[') && field.repeated => {
            let count_field = syn::Ident::new(&format!("{}_count", field.name), proc_macro2::Span::call_site());

            quote! {
                {
                    let copy_count = self.#field_name.len().min(ffi.#field_name.len());
                    ffi.#field_name[..copy_count].copy_from_slice(&self.#field_name[..copy_count]);
                    ffi.#count_field = copy_count as u32;
                }
            }
        }

        // Nested message - recursive conversion
        _ => {
            if field.repeated {
                let count_field = syn::Ident::new(&format!("{}_count", field.name), proc_macro2::Span::call_site());
                quote! {
                    {
                        let copy_count = self.#field_name.len().min(ffi.#field_name.len());
                        for i in 0..copy_count {
                            ffi.#field_name[i] = self.#field_name[i].to_ffi();
                        }
                        ffi.#count_field = copy_count as u32;
                    }
                }
            } else {
                quote! {
                    ffi.#field_name = self.#field_name.to_ffi();
                }
            }
        }
    }
}

fn generate_from_ffi_field(field: &FieldLayout, _layout: &Layout) -> TokenStream {
    let field_name = syn::Ident::new(&field.name, proc_macro2::Span::call_site());

    match field.rust_type.as_str() {
        // Primitives - direct copy
        "u8" | "u16" | "u32" | "u64" | "i8" | "i16" | "i32" | "i64" | "f32" | "f64" | "bool" => {
            quote! {
                #field_name: ffi.#field_name
            }
        }

        // String field - convert from fixed array using length
        s if s.starts_with('[') && s.contains("u8") && !field.repeated => {
            let len_field = syn::Ident::new(&format!("{}_len", field.name), proc_macro2::Span::call_site());

            quote! {
                #field_name: {
                    let len = ffi.#len_field as usize;
                    String::from_utf8_lossy(&ffi.#field_name[..len]).into_owned()
                }
            }
        }

        // Vec/repeated primitives - convert from fixed array using count
        s if !s.starts_with('[') && field.repeated => {
            let count_field = syn::Ident::new(&format!("{}_count", field.name), proc_macro2::Span::call_site());

            quote! {
                #field_name: {
                    let count = ffi.#count_field as usize;
                    ffi.#field_name[..count].to_vec()
                }
            }
        }

        // Nested message - recursive conversion
        _ => {
            let field_type = syn::Ident::new(&field.rust_type, proc_macro2::Span::call_site());

            if field.repeated {
                let count_field = syn::Ident::new(&format!("{}_count", field.name), proc_macro2::Span::call_site());
                quote! {
                    #field_name: {
                        let count = ffi.#count_field as usize;
                        (0..count)
                            .map(|i| #field_type::from_ffi(&ffi.#field_name[i]))
                            .collect()
                    }
                }
            } else {
                quote! {
                    #field_name: #field_type::from_ffi(&ffi.#field_name)
                }
            }
        }
    }
}

/// Generate Dart conversion extensions
pub fn generate_dart_conversions(layout: &Layout, output: &Path) -> Result<()> {
    let mut code = String::new();

    code.push_str("// Generated conversions between proto models and FFI\n");
    code.push_str("// This layer is transparent to users\n\n");
    code.push_str("import 'dart:ffi';\n");
    code.push_str("import 'dart:typed_data';\n");
    code.push_str("import 'dart:convert';\n");
    code.push_str("import 'package:ffi/ffi.dart';\n\n");
    code.push_str("import 'proto.dart';\n");
    code.push_str("import 'ffi.dart';\n\n");

    for message in &layout.messages {
        code.push_str(&generate_dart_message_conversions(message, layout));
        code.push_str("\n\n");
    }

    fs::write(output, code)?;
    Ok(())
}

fn generate_dart_message_conversions(message: &MessageLayout, _layout: &Layout) -> String {
    let class_name = &message.name;
    let ffi_class_name = format!("{}FFI", class_name);

    // toFFI method
    let to_ffi_fields = message.fields.iter().map(|field| {
        generate_dart_to_ffi_field(field)
    }).collect::<Vec<_>>().join("\n    ");

    // fromFFI factory
    let from_ffi_params = message.fields.iter().map(|field| {
        format!("      {}: {},", field.name, generate_dart_from_ffi_expr(field))
    }).collect::<Vec<_>>().join("\n");

    format!(
        r#"extension {}Conversions on {} {{
  /// Convert to FFI representation
  Pointer<{}> toFFI() {{
    final ptr = calloc<{}>();
    final ref = ptr.ref;

    {}

    return ptr;
  }}

  /// Free FFI pointer (call this when done)
  static void freeFFI(Pointer<{}> ptr) {{
    calloc.free(ptr);
  }}
}}

extension {}FromFFI on {} {{
  /// Convert from FFI representation
  static {} fromFFI(Pointer<{}> ptr) {{
    final ref = ptr.ref;
    return {}(
{}
    );
  }}
}}"#,
        class_name, class_name,
        ffi_class_name,
        ffi_class_name,
        to_ffi_fields,
        ffi_class_name,
        class_name, ffi_class_name,
        class_name, ffi_class_name,
        class_name,
        from_ffi_params
    )
}

fn extract_array_size(rust_type: &str) -> Option<usize> {
    // Extract size from "[T; N]" format
    if let Some(start) = rust_type.rfind(';') {
        if let Some(end) = rust_type.rfind(']') {
            let size_str = rust_type[start + 1..end].trim();
            return size_str.parse().ok();
        }
    }
    None
}

fn generate_dart_to_ffi_field(field: &FieldLayout) -> String {
    let field_name = &field.name;

    match field.dart_type.as_str() {
        "int" | "double" if !field.repeated => {
            format!("ref.{} = this.{};", field_name, field_name)
        }

        "String" if !field.repeated => {
            let array_size = extract_array_size(&field.rust_type).unwrap_or(256);
            format!(
                r#"{{
      final bytes = utf8.encode(this.{});
      final maxLen = {};
      final copyLen = bytes.length < maxLen ? bytes.length : maxLen;
      for (var i = 0; i < copyLen; i++) {{
        ref.{}[i] = bytes[i];
      }}
      ref.{}_len = copyLen;
    }}"#,
                field_name, array_size, field_name, field_name
            )
        }

        "Uint8List" if !field.repeated => {
            let array_size = extract_array_size(&field.rust_type).unwrap_or(256);
            format!(
                r#"{{
      final bytes = this.{};
      final maxLen = {};
      final copyLen = bytes.length < maxLen ? bytes.length : maxLen;
      for (var i = 0; i < copyLen; i++) {{
        ref.{}[i] = bytes[i];
      }}
      ref.{}_len = copyLen;
    }}"#,
                field_name, array_size, field_name, field_name
            )
        }

        _ if field.repeated => {
            let array_size = field.max_count.unwrap_or(32);
            format!(
                r#"{{
      final maxCount = {};
      final copyCount = this.{}.length < maxCount ? this.{}.length : maxCount;
      for (var i = 0; i < copyCount; i++) {{
        ref.{}[i] = this.{}[i];
      }}
      ref.{}_count = copyCount;
    }}"#,
                array_size, field_name, field_name,
                field_name, field_name, field_name
            )
        }

        _ => {
            format!("ref.{} = this.{};", field_name, field_name)
        }
    }
}

fn generate_dart_from_ffi_expr(field: &FieldLayout) -> String {
    let field_name = &field.name;

    match field.dart_type.as_str() {
        "int" | "double" if !field.repeated => {
            format!("ref.{}", field_name)
        }

        "String" if !field.repeated => {
            format!(
                "() {{ final bytes = <int>[]; for (var i = 0; i < ref.{}_len; i++) {{ bytes.add(ref.{}[i]); }} return utf8.decode(bytes); }}()",
                field_name, field_name
            )
        }

        "Uint8List" if !field.repeated => {
            format!(
                "() {{ final bytes = <int>[]; for (var i = 0; i < ref.{}_len; i++) {{ bytes.add(ref.{}[i]); }} return Uint8List.fromList(bytes); }}()",
                field_name, field_name
            )
        }

        _ if field.repeated => {
            format!(
                "List.generate(ref.{}_count, (i) => ref.{}[i])",
                field_name, field_name
            )
        }

        _ => {
            format!("ref.{}", field_name)
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::layout::{Layout, MessageLayout, FieldLayout};
    use std::collections::HashMap;

    #[test]
    fn test_generate_simple_conversion() {
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
            }],
            enums: vec![],
            alignment: 8,
        };

        let tokens = generate_message_conversions(&layout.messages[0], &layout);
        let code = tokens.to_string();

        assert!(code.contains("impl User"));
        assert!(code.contains("pub fn to_ffi"));
        assert!(code.contains("pub fn from_ffi"));
        assert!(code.contains("ffi . id = self . id"));
        assert!(code.contains("String :: from_utf8_lossy"));
    }

    #[test]
    fn test_dart_conversion_generation() {
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

        let layout = Layout {
            messages: vec![message.clone()],
            enums: vec![],
            alignment: 8,
        };

        let code = generate_dart_message_conversions(&message, &layout);
        assert!(code.contains("extension UserConversions"));
        assert!(code.contains("toFFI()"));
        assert!(code.contains("fromFFI"));
    }
}
