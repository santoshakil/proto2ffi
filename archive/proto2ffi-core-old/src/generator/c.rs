use crate::error::Result;
use crate::layout::{Layout, MessageLayout, EnumLayout};
use std::fs;
use std::path::Path;

pub fn generate_c_header(layout: &Layout, output_dir: &Path) -> Result<()> {
    fs::create_dir_all(output_dir)?;

    let mut code = String::new();

    code.push_str("#ifndef PROTO2FFI_GENERATED_H\n");
    code.push_str("#define PROTO2FFI_GENERATED_H\n\n");

    code.push_str("#include <stdint.h>\n");
    code.push_str("#include <stddef.h>\n");
    code.push_str("#include <stdbool.h>\n\n");

    code.push_str("#ifdef __cplusplus\n");
    code.push_str("extern \"C\" {\n");
    code.push_str("#endif\n\n");

    for enum_layout in &layout.enums {
        code.push_str(&generate_c_enum(enum_layout)?);
        code.push_str("\n");
    }

    for message in &layout.messages {
        code.push_str(&generate_c_struct(message)?);
        code.push_str("\n");
        code.push_str(&generate_c_functions(message)?);
        code.push_str("\n");
    }

    code.push_str("#ifdef __cplusplus\n");
    code.push_str("}\n");
    code.push_str("#endif\n\n");

    code.push_str("#endif /* PROTO2FFI_GENERATED_H */\n");

    let output_file = output_dir.join("generated.h");
    fs::write(&output_file, code)?;

    Ok(())
}

fn generate_c_enum(enum_layout: &EnumLayout) -> Result<String> {
    let mut code = String::new();

    code.push_str(&format!("/* Proto enum: {} ({} variants) */\n", enum_layout.name, enum_layout.variants.len()));
    code.push_str(&format!("typedef enum {} {{\n", enum_layout.name));

    for (variant, value) in &enum_layout.variants {
        code.push_str(&format!("    {}_{} = {},\n", enum_layout.name.to_uppercase(), variant.to_uppercase(), value));
    }

    code.push_str(&format!("}} {};\n", enum_layout.name));

    Ok(code)
}

fn generate_c_struct(message: &MessageLayout) -> Result<String> {
    let mut code = String::new();

    code.push_str(&format!("/* Proto message: {} */\n", message.name));
    code.push_str(&format!("/* Size: {} bytes, Alignment: {} bytes */\n", message.size, message.alignment));
    code.push_str(&format!("/* Internal FFI type - users interact with proto models instead */\n"));
    code.push_str(&format!("#pragma pack(push, {})\n", message.alignment));
    code.push_str(&format!("typedef struct {}FFI {{\n", message.name));

    for field in &message.fields {
        if field.repeated && field.max_count.is_some() {
            code.push_str(&format!("    uint32_t {}_count;\n", field.name));
        }

        let c_type = &field.c_type;
        code.push_str(&format!("    {} {};\n", c_type, field.name));
    }

    code.push_str(&format!("}} {}FFI;\n", message.name));
    code.push_str("#pragma pack(pop)\n");

    Ok(code)
}

fn generate_c_functions(message: &MessageLayout) -> Result<String> {
    let mut code = String::new();

    code.push_str(&format!("/* Returns the size of {} in bytes */\n", message.name));
    code.push_str(&format!("size_t {}_size(void);\n\n", message.name.to_lowercase()));

    code.push_str(&format!("/* Returns the alignment of {} in bytes */\n", message.name));
    code.push_str(&format!("size_t {}_alignment(void);\n", message.name.to_lowercase()));

    Ok(code)
}
