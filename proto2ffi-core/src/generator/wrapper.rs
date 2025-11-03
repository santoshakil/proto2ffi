use crate::layout::{Layout, MessageLayout};
use crate::error::Result;
use quote::quote;
use proc_macro2::TokenStream;
use std::path::Path;
use std::fs;

/// Generate FFI wrapper functions that accept proto models
pub fn generate_rust_wrappers(layout: &Layout, output: &Path) -> Result<()> {
    let mut tokens = TokenStream::new();

    tokens.extend(quote! {
        #![allow(dead_code)]

        use super::ffi::*;
        use super::proto::*;
        use std::ptr;
    });

    for message in &layout.messages {
        tokens.extend(generate_message_wrappers(message));
    }

    fs::write(output, tokens.to_string())?;

    let _ = std::process::Command::new("rustfmt")
        .arg(output)
        .status();

    Ok(())
}

fn generate_message_wrappers(message: &MessageLayout) -> TokenStream {
    let msg_name = syn::Ident::new(&message.name, proc_macro2::Span::call_site());
    let ffi_name = syn::Ident::new(&format!("{}FFI", message.name), proc_macro2::Span::call_site());

    let create_fn = syn::Ident::new(&format!("{}_create", message.name.to_lowercase()), proc_macro2::Span::call_site());
    let free_fn = syn::Ident::new(&format!("{}_free", message.name.to_lowercase()), proc_macro2::Span::call_site());
    let clone_fn = syn::Ident::new(&format!("{}_clone", message.name.to_lowercase()), proc_macro2::Span::call_site());

    let send_fn = syn::Ident::new(&format!("send_{}", message.name.to_lowercase()), proc_macro2::Span::call_site());
    let receive_fn = syn::Ident::new(&format!("receive_{}", message.name.to_lowercase()), proc_macro2::Span::call_site());
    let receive_and_free_fn = syn::Ident::new(&format!("receive_and_free_{}", message.name.to_lowercase()), proc_macro2::Span::call_site());

    quote! {
        // ========================================
        // FFI Exports (extern "C" for Dart/C)
        // ========================================

        #[doc = concat!("Creates a new ", stringify!(#msg_name), " on the heap")]
        #[doc = ""]
        #[doc = "Returns a pointer to the allocated FFI struct."]
        #[doc = "Must be freed with the corresponding free function."]
        #[no_mangle]
        pub extern "C" fn #create_fn() -> *mut #ffi_name {
            let ffi = unsafe { std::mem::zeroed::<#ffi_name>() };
            Box::into_raw(Box::new(ffi))
        }

        #[doc = concat!("Frees a ", stringify!(#msg_name), " allocated on the heap")]
        #[doc = ""]
        #[doc = "# Safety"]
        #[doc = ""]
        #[doc = "The pointer must have been allocated by the create function."]
        #[doc = "The pointer must not be used after calling this function."]
        #[no_mangle]
        pub unsafe extern "C" fn #free_fn(ptr: *mut #ffi_name) {
            if !ptr.is_null() {
                let _ = Box::from_raw(ptr);
            }
        }

        #[doc = concat!("Clones a ", stringify!(#msg_name), " FFI struct")]
        #[doc = ""]
        #[doc = "Returns a new heap-allocated copy."]
        #[doc = "Must be freed with the corresponding free function."]
        #[no_mangle]
        pub unsafe extern "C" fn #clone_fn(ptr: *const #ffi_name) -> *mut #ffi_name {
            if ptr.is_null() {
                return ptr::null_mut();
            }
            let ffi = *ptr;
            Box::into_raw(Box::new(ffi))
        }

        // ========================================
        // High-Level Rust Wrappers (proto models)
        // ========================================

        #[doc = concat!("Sends a ", stringify!(#msg_name), " proto model to FFI")]
        #[doc = ""]
        #[doc = "Converts the proto model to FFI representation and allocates it on the heap."]
        #[doc = "Returns a pointer that can be passed across FFI boundary."]
        #[doc = ""]
        #[doc = "# Example"]
        #[doc = ""]
        #[doc = "```"]
        #[doc = concat!("let user = ", stringify!(#msg_name), " { /* fields */ };")]
        #[doc = concat!("let ptr = ", stringify!(#send_fn), "(&user);")]
        #[doc = "// Pass ptr to Dart/C"]
        #[doc = concat!("// Later: unsafe { ", stringify!(#free_fn), "(ptr); }")]
        #[doc = "```"]
        pub fn #send_fn(msg: &#msg_name) -> *mut #ffi_name {
            let ffi = msg.to_ffi();
            Box::into_raw(Box::new(ffi))
        }

        #[doc = concat!("Receives a ", stringify!(#msg_name), " from FFI pointer")]
        #[doc = ""]
        #[doc = "Converts the FFI representation back to a proto model."]
        #[doc = "Does NOT free the pointer - caller must manage memory."]
        #[doc = ""]
        #[doc = "# Safety"]
        #[doc = ""]
        #[doc = "The pointer must be valid and properly aligned."]
        #[doc = ""]
        #[doc = "# Example"]
        #[doc = ""]
        #[doc = "```"]
        #[doc = "// Received ptr from Dart/C"]
        #[doc = concat!("let user = unsafe { ", stringify!(#receive_fn), "(ptr) };")]
        #[doc = "// Use user as normal proto model"]
        #[doc = "```"]
        pub unsafe fn #receive_fn(ptr: *const #ffi_name) -> #msg_name {
            assert!(!ptr.is_null(), "Null pointer passed to receive function");
            #msg_name::from_ffi(&*ptr)
        }

        #[doc = concat!("Receives and consumes a ", stringify!(#msg_name), " from FFI pointer")]
        #[doc = ""]
        #[doc = "Converts the FFI representation to proto model and FREES the pointer."]
        #[doc = ""]
        #[doc = "# Safety"]
        #[doc = ""]
        #[doc = "The pointer must have been allocated by send or create function."]
        #[doc = "The pointer must not be used after calling this function."]
        pub unsafe fn #receive_and_free_fn(ptr: *mut #ffi_name) -> #msg_name {
            assert!(!ptr.is_null(), "Null pointer passed to receive_and_free");
            let ffi = Box::from_raw(ptr);
            #msg_name::from_ffi(&*ffi)
        }
    }
}

/// Generate Dart FFI bindings that call the wrapper functions
pub fn generate_dart_wrappers(layout: &Layout, output: &Path) -> Result<()> {
    let mut code = String::new();

    code.push_str("// Generated FFI wrapper functions\n");
    code.push_str("// These call the Rust FFI exports\n\n");
    code.push_str("import 'dart:ffi' as ffi;\n");
    code.push_str("import 'package:ffi/ffi.dart';\n\n");
    code.push_str("import 'ffi.dart';\n");
    code.push_str("import 'proto.dart';\n");
    code.push_str("import 'conversion.dart';\n\n");

    for message in &layout.messages {
        code.push_str(&generate_dart_message_wrappers(message));
        code.push_str("\n\n");
    }

    fs::write(output, code)?;
    Ok(())
}

fn generate_dart_message_wrappers(message: &MessageLayout) -> String {
    let class_name = &message.name;
    let ffi_class_name = format!("{}FFI", class_name);
    let wrapper_class_name = format!("{}API", class_name);  // Different name to avoid conflict!
    let lower_name = class_name.to_lowercase();

    format!(
        r#"/// FFI wrapper functions for {}
class {} {{
  late final ffi.DynamicLibrary _lib;

  {}(this._lib);

  /// Creates a new {} FFI struct on the heap
  ffi.Pointer<{}> create() {{
    final createFn = _lib.lookupFunction<
        ffi.Pointer<{}> Function(),
        ffi.Pointer<{}> Function()>('{}_create');
    return createFn();
  }}

  /// Frees a {} FFI struct
  void free(ffi.Pointer<{}> ptr) {{
    final freeFn = _lib.lookupFunction<
        ffi.Void Function(ffi.Pointer<{}>),
        void Function(ffi.Pointer<{}>)>('{}_free');
    freeFn(ptr);
  }}

  /// Clones a {} FFI struct
  ffi.Pointer<{}> clone(ffi.Pointer<{}> ptr) {{
    final cloneFn = _lib.lookupFunction<
        ffi.Pointer<{}> Function(ffi.Pointer<{}>),
        ffi.Pointer<{}> Function(ffi.Pointer<{}>)>('{}_clone');
    return cloneFn(ptr);
  }}

  /// Sends a {} proto model to Rust (returns FFI pointer)
  ffi.Pointer<{}> send({} msg) {{
    final ptr = create();
    // Convert proto to FFI
    final ffiMsg = msg.toFFI();
    ptr.ref = ffiMsg.ref;
    calloc.free(ffiMsg);
    return ptr;
  }}

  /// Receives a {} proto model from Rust (does not free pointer)
  {} receive(ffi.Pointer<{}> ptr) {{
    return {}FromFFI.fromFFI(ptr);
  }}

  /// Receives and frees a {} proto model from Rust
  {} receiveAndFree(ffi.Pointer<{}> ptr) {{
    final msg = receive(ptr);
    free(ptr);
    return msg;
  }}
}}"#,
        class_name,           // 1: doc comment
        wrapper_class_name,   // 2: class name
        wrapper_class_name,   // 3: constructor name
        class_name,     // 4: create doc
        ffi_class_name, // 5: create return type
        ffi_class_name, // 6: lookupFunction generic arg 1
        ffi_class_name, // 7: lookupFunction generic arg 2
        lower_name,     // 8: _create function name
        class_name,     // 9: free doc
        ffi_class_name, // 10: free param type
        ffi_class_name, // 11: lookupFunction param type 1
        ffi_class_name, // 12: lookupFunction param type 2
        lower_name,     // 13: _free function name
        class_name,     // 14: clone doc
        ffi_class_name, // 15: clone return type
        ffi_class_name, // 16: clone param type
        ffi_class_name, // 17: lookupFunction return inner type
        ffi_class_name, // 18: lookupFunction param inner type
        ffi_class_name, // 19: lookupFunction return inner type (2nd sig)
        ffi_class_name, // 20: lookupFunction param inner type (2nd sig)
        lower_name,     // 21: _clone function name
        class_name,     // 22: send doc
        ffi_class_name, // 23: send return type
        class_name,     // 24: send param type
        class_name,     // 25: receive doc
        class_name,     // 26: receive return type
        ffi_class_name, // 27: receive param type
        class_name,     // 28: FromFFI class name
        class_name,     // 29: receiveAndFree doc
        class_name,     // 30: receiveAndFree return type
        ffi_class_name  // 31: receiveAndFree param type
    )
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::layout::{Layout, MessageLayout, FieldLayout};
    use std::collections::HashMap;

    #[test]
    fn test_generate_wrappers() {
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
                ],
                options: HashMap::new(),
            }],
            enums: vec![],
            alignment: 8,
        };

        let tokens = generate_message_wrappers(&layout.messages[0]);
        let code = tokens.to_string();

        assert!(code.contains("pub extern \"C\" fn user_create"));
        assert!(code.contains("pub unsafe extern \"C\" fn user_free"));
        assert!(code.contains("pub fn send_user"));
        assert!(code.contains("pub unsafe fn receive_user"));
    }
}
