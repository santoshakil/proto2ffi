use crate::error::Result;
use crate::layout::{Layout, MessageLayout, EnumLayout};
use std::fs;
use std::path::Path;

pub fn generate_dart(layout: &Layout, output_dir: &Path) -> Result<()> {
    fs::create_dir_all(output_dir)?;

    let mut code = String::new();

    code.push_str("// ignore_for_file: camel_case_types\n");
    code.push_str("// ignore_for_file: non_constant_identifier_names\n");
    code.push_str("// ignore_for_file: constant_identifier_names\n\n");
    code.push_str("import 'dart:ffi' as ffi;\n");
    code.push_str("import 'package:ffi/ffi.dart';\n");
    code.push_str("import 'dart:typed_data';\n");
    code.push_str("import 'dart:io';\n");
    code.push_str("import 'dart:convert';\n\n");

    for enum_layout in &layout.enums {
        code.push_str(&generate_dart_enum(enum_layout)?);
        code.push_str("\n");
    }

    for message in &layout.messages {
        code.push_str(&generate_dart_class(message)?);
        code.push_str("\n");
    }

    code.push_str(&generate_bindings(layout)?);

    let output_file = output_dir.join("generated.dart");
    fs::write(&output_file, code)?;

    Ok(())
}

fn generate_dart_enum(enum_layout: &EnumLayout) -> Result<String> {
    let mut code = String::new();

    code.push_str(&format!("enum {} {{\n", enum_layout.name));

    for (variant, value) in &enum_layout.variants {
        code.push_str(&format!("  {}({}),\n", variant, value));
    }

    code.push_str("\n  const ");
    code.push_str(&format!("{}(this.value);\n", enum_layout.name));
    code.push_str("  final int value;\n");
    code.push_str("}\n");

    Ok(code)
}

fn generate_dart_class(message: &MessageLayout) -> Result<String> {
    let mut code = String::new();

    // Generate size/alignment constants outside the struct
    code.push_str(&format!("const int {}_SIZE = {};\n", message.name.to_uppercase(), message.size));
    code.push_str(&format!("const int {}_ALIGNMENT = {};\n\n", message.name.to_uppercase(), message.alignment));

    code.push_str(&format!("final class {} extends ffi.Struct {{\n", message.name));

    let mut count_fields = Vec::new();

    for field in &message.fields {
        if field.repeated && field.max_count.is_some() {
            count_fields.push(format!("{}_count", field.name));
            code.push_str("  @ffi.Uint32()\n");
            code.push_str(&format!("  external int {}_count;\n\n", field.name));
        }

        if field.dart_annotation.starts_with('@') {
            code.push_str(&format!("  {}\n", field.dart_annotation));

            if field.dart_type == "String" || field.dart_type == "Uint8List" {
                code.push_str(&format!("  external ffi.Array<ffi.Uint8> _{};\n\n", field.name));
            } else if field.repeated && field.max_count.is_some() {
                let inner_type = field.rust_type
                    .trim_start_matches('[')
                    .split(';')
                    .next()
                    .unwrap()
                    .trim();
                code.push_str(&format!("  external ffi.Array<{}> _{};\n\n",
                    rust_to_dart_struct_type(inner_type), field.name));
            } else {
                code.push_str(&format!("  external {} {};\n\n", field.dart_type, field.name));
            }
        } else if field.dart_annotation.starts_with("external") {
            code.push_str(&format!("  {} {};\n\n", field.dart_annotation, field.name));
        }
    }

    for field in &message.fields {
        if field.dart_type == "String" {
            code.push_str(&generate_string_getter(&field.name, field.size));
            code.push_str(&generate_string_setter(&field.name, field.size));
        } else if field.repeated && field.max_count.is_some() {
            code.push_str(&generate_array_getter(&field.name, &field.dart_type));
            code.push_str(&generate_array_adder(&field.name, &field.dart_type, field.max_count.unwrap()));
        }
    }

    code.push_str(&format!(
        "  static ffi.Pointer<{}> allocate() {{\n",
        message.name
    ));
    code.push_str(&format!("    return calloc<{}>();\n", message.name));
    code.push_str("  }\n");

    code.push_str("}\n");

    Ok(code)
}

fn generate_string_getter(field_name: &str, max_len: usize) -> String {
    format!(
        r#"  String get {} {{
    final bytes = <int>[];
    for (int i = 0; i < {}; i++) {{
      if (_{}[i] == 0) break;
      bytes.add(_{}[i]);
    }}
    return String.fromCharCodes(bytes);
  }}

"#,
        field_name, max_len, field_name, field_name
    )
}

fn generate_string_setter(field_name: &str, max_len: usize) -> String {
    format!(
        r#"  set {}(String value) {{
    final bytes = utf8.encode(value);
    final len = bytes.length < {} ? bytes.length : {};
    for (int i = 0; i < len; i++) {{
      _{}[i] = bytes[i];
    }}
    if (len < {}) {{
      _{}[len] = 0;
    }}
  }}

"#,
        field_name,
        max_len - 1,
        max_len - 1,
        field_name,
        max_len,
        field_name
    )
}

fn generate_array_getter(field_name: &str, dart_type: &str) -> String {
    let inner_type = dart_type.trim_start_matches("List<").trim_end_matches('>');
    format!(
        r#"  List<{}> get {} {{
    return List.generate(
      {}_count,
      (i) => _{}[i],
      growable: false,
    );
  }}

"#,
        inner_type, field_name, field_name, field_name
    )
}

fn generate_array_adder(field_name: &str, dart_type: &str, max_count: usize) -> String {
    let inner_type = dart_type.trim_start_matches("List<").trim_end_matches('>');
    let singular = field_name.trim_end_matches('s');

    let is_primitive = matches!(
        inner_type,
        "int" | "double" | "bool" | "ffi.Uint8" | "ffi.Uint16" | "ffi.Uint32" | "ffi.Uint64" |
        "ffi.Int8" | "ffi.Int16" | "ffi.Int32" | "ffi.Int64" | "ffi.Float" | "ffi.Double"
    );

    if is_primitive {
        format!(
            r#"  void add_{}({} item) {{
    if ({}_count >= {}) {{
      throw Exception('{} array full');
    }}
    _{}[{}_count] = item;
    {}_count++;
  }}

"#,
            singular,
            inner_type,
            field_name,
            max_count,
            field_name,
            field_name,
            field_name,
            field_name
        )
    } else {
        format!(
            r#"  {} get_next_{}() {{
    if ({}_count >= {}) {{
      throw Exception('{} array full');
    }}
    final idx = {}_count;
    {}_count++;
    return _{}[idx];
  }}

"#,
            inner_type,
            singular,
            field_name,
            max_count,
            field_name,
            field_name,
            field_name,
            field_name
        )
    }
}

fn generate_bindings(layout: &Layout) -> Result<String> {
    let mut code = String::new();

    code.push_str("class FFIBindings {\n");
    code.push_str("  static final _dylib = _loadLibrary();\n\n");

    code.push_str("  static ffi.DynamicLibrary _loadLibrary() {\n");
    code.push_str("    if (Platform.isAndroid) {\n");
    code.push_str("      return ffi.DynamicLibrary.open('libgenerated.so');\n");
    code.push_str("    } else if (Platform.isIOS) {\n");
    code.push_str("      return ffi.DynamicLibrary.process();\n");
    code.push_str("    } else if (Platform.isMacOS) {\n");
    code.push_str("      return ffi.DynamicLibrary.open('libgenerated.dylib');\n");
    code.push_str("    } else if (Platform.isWindows) {\n");
    code.push_str("      return ffi.DynamicLibrary.open('generated.dll');\n");
    code.push_str("    } else {\n");
    code.push_str("      return ffi.DynamicLibrary.open('libgenerated.so');\n");
    code.push_str("    }\n");
    code.push_str("  }\n");

    for message in &layout.messages {
        let size_fn = format!("{}_size", message.name.to_lowercase());
        let align_fn = format!("{}_alignment", message.name.to_lowercase());

        code.push_str(&format!(
            r#"
  late final {}_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('{}');

  late final {}_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('{}');
"#,
            message.name.to_lowercase(),
            size_fn,
            message.name.to_lowercase(),
            align_fn
        ));
    }

    code.push_str("}\n");

    Ok(code)
}

fn rust_to_dart_struct_type(rust_type: &str) -> String {
    match rust_type {
        "i32" | "u32" => "ffi.Int32",
        "i64" | "u64" => "ffi.Int64",
        "f32" => "ffi.Float",
        "f64" => "ffi.Double",
        "u8" => "ffi.Uint8",
        custom => custom,
    }.to_string()
}
