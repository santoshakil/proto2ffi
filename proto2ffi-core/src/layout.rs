use crate::error::Result;
use crate::types::*;
use serde::{Deserialize, Serialize};
use std::collections::HashMap;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Layout {
    pub messages: Vec<MessageLayout>,
    pub enums: Vec<EnumLayout>,
    pub alignment: usize,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct MessageLayout {
    pub name: String,
    pub size: usize,
    pub alignment: usize,
    pub fields: Vec<FieldLayout>,
    pub options: HashMap<String, String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct FieldLayout {
    pub name: String,
    pub rust_type: String,
    pub dart_type: String,
    pub dart_annotation: String,
    pub c_type: String,
    pub offset: usize,
    pub size: usize,
    pub alignment: usize,
    pub repeated: bool,
    pub max_count: Option<usize>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct EnumLayout {
    pub name: String,
    pub variants: Vec<(String, i32)>,
}

pub fn calculate_layout(proto: &ProtoFile, default_alignment: usize) -> Result<Layout> {
    let mut layout = Layout {
        messages: Vec::new(),
        enums: Vec::new(),
        alignment: default_alignment,
    };

    for enum_def in &proto.enums {
        layout.enums.push(EnumLayout {
            name: enum_def.name.clone(),
            variants: enum_def.variants.iter().map(|v| (v.name.clone(), v.number)).collect(),
        });
    }

    let mut message_sizes = HashMap::new();

    for message in &proto.messages {
        let msg_layout = calculate_message_layout(message, default_alignment, &message_sizes)?;
        message_sizes.insert(message.name.clone(), (msg_layout.size, msg_layout.alignment));
        layout.messages.push(msg_layout);
    }

    Ok(layout)
}

fn calculate_message_layout(
    message: &Message,
    default_alignment: usize,
    message_sizes: &HashMap<String, (usize, usize)>,
) -> Result<MessageLayout> {
    let mut options_map = HashMap::new();
    for opt in &message.options {
        options_map.insert(opt.name.clone(), opt.value.clone());
    }

    let align = options_map
        .get("proto2ffi.align")
        .and_then(|s| s.parse().ok())
        .unwrap_or(default_alignment);

    let mut fields = Vec::new();
    let mut sorted_fields = message.fields.clone();

    sorted_fields.sort_by_key(|f| {
        let align = if f.repeated {
            8
        } else {
            f.field_type.alignment()
        };
        std::cmp::Reverse(align)
    });

    let mut current_offset = 0;
    let mut max_alignment = 1;

    for field in sorted_fields {
        let max_count = if field.repeated {
            field.options.iter()
                .find(|opt| opt.name == "proto2ffi.max_count")
                .and_then(|opt| opt.value.parse().ok())
        } else {
            None
        };

        let max_length = field.options.iter()
            .find(|opt| opt.name == "proto2ffi.max_length")
            .and_then(|opt| opt.value.parse().ok());

        let field_type = if let Some(len) = max_length {
            match field.field_type {
                FieldType::String { .. } => FieldType::String { max_length: len },
                FieldType::Bytes { .. } => FieldType::Bytes { max_length: len },
                _ => field.field_type.clone(),
            }
        } else {
            field.field_type.clone()
        };

        let (rust_type, dart_type, dart_annotation, c_type, size, field_alignment) =
            get_type_info(&field_type, field.repeated, max_count, message_sizes)?;

        current_offset = align_up(current_offset, field_alignment);

        fields.push(FieldLayout {
            name: field.name.clone(),
            rust_type,
            dart_type,
            dart_annotation,
            c_type,
            offset: current_offset,
            size,
            alignment: field_alignment,
            repeated: field.repeated,
            max_count,
        });

        current_offset += size;
        max_alignment = max_alignment.max(field_alignment);
    }

    max_alignment = max_alignment.max(align);
    let total_size = align_up(current_offset, max_alignment);

    Ok(MessageLayout {
        name: message.name.clone(),
        size: total_size,
        alignment: max_alignment,
        fields,
        options: options_map,
    })
}

fn get_type_info(
    field_type: &FieldType,
    repeated: bool,
    max_count: Option<usize>,
    message_sizes: &HashMap<String, (usize, usize)>,
) -> Result<(String, String, String, String, usize, usize)> {
    let (base_rust, base_dart, base_annotation, base_c, base_size, base_align) = match field_type {
        FieldType::Int32 | FieldType::Sint32 | FieldType::Sfixed32 =>
            ("i32".into(), "int".into(), "@ffi.Int32()".into(), "int32_t".into(), 4, 4),
        FieldType::Int64 | FieldType::Sint64 | FieldType::Sfixed64 =>
            ("i64".into(), "int".into(), "@ffi.Int64()".into(), "int64_t".into(), 8, 8),
        FieldType::Uint32 | FieldType::Fixed32 =>
            ("u32".into(), "int".into(), "@ffi.Uint32()".into(), "uint32_t".into(), 4, 4),
        FieldType::Uint64 | FieldType::Fixed64 =>
            ("u64".into(), "int".into(), "@ffi.Uint64()".into(), "uint64_t".into(), 8, 8),
        FieldType::Float =>
            ("f32".into(), "double".into(), "@ffi.Float()".into(), "float".into(), 4, 4),
        FieldType::Double =>
            ("f64".into(), "double".into(), "@ffi.Double()".into(), "double".into(), 8, 8),
        FieldType::Bool =>
            ("u8".into(), "int".into(), "@ffi.Uint8()".into(), "uint8_t".into(), 1, 1),
        FieldType::String { max_length } => (
            format!("[u8; {}]", max_length),
            "String".into(),
            format!("@ffi.Array<ffi.Uint8>({})", max_length),
            format!("char[{}]", max_length),
            *max_length,
            1,
        ),
        FieldType::Bytes { max_length } => (
            format!("[u8; {}]", max_length),
            "Uint8List".into(),
            format!("@ffi.Array<ffi.Uint8>({})", max_length),
            format!("uint8_t[{}]", max_length),
            *max_length,
            1,
        ),
        FieldType::Message(name) => {
            let (msg_size, msg_align) = message_sizes
                .get(name)
                .copied()
                .unwrap_or((0, 8));
            (
                name.clone(),
                name.clone(),
                format!("external {}", name),
                format!("struct {}", name),
                msg_size,
                msg_align,
            )
        },
        FieldType::Enum(name) => (
            "u32".into(),
            "int".into(),
            "@ffi.Uint32()".into(),
            format!("enum {}", name),
            4,
            4,
        ),
    };

    if repeated {
        if let Some(count) = max_count {
            let array_size = base_size * count;
            Ok((
                format!("[{}; {}]", base_rust, count),
                format!("List<{}>", base_dart),
                format!("@ffi.Array<{}>({})",
                    base_rust.trim_start_matches("external "), count),
                format!("{}[{}]", base_c, count),
                array_size + 4,
                base_align.max(4),
            ))
        } else {
            Ok((
                format!("*const {}", base_rust),
                format!("List<{}>", base_dart),
                format!("@ffi.Pointer<{}>", base_rust),
                format!("{}*", base_c),
                16,
                8,
            ))
        }
    } else {
        Ok((base_rust, base_dart, base_annotation, base_c, base_size, base_align))
    }
}

fn align_up(offset: usize, alignment: usize) -> usize {
    (offset + alignment - 1) & !(alignment - 1)
}

pub fn optimize_for_cache(mut layout: Layout) -> Result<Layout> {
    for message in &mut layout.messages {
        message.alignment = message.alignment.max(64);
    }
    Ok(layout)
}
