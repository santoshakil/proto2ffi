use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ProtoFile {
    pub package: Option<String>,
    pub messages: Vec<Message>,
    pub enums: Vec<Enum>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Message {
    pub name: String,
    pub fields: Vec<Field>,
    pub options: Vec<MessageOption>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Field {
    pub name: String,
    pub field_type: FieldType,
    pub number: u32,
    pub repeated: bool,
    pub optional: bool,
    pub options: Vec<FieldOption>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum FieldType {
    Int32,
    Int64,
    Uint32,
    Uint64,
    Sint32,
    Sint64,
    Fixed32,
    Fixed64,
    Sfixed32,
    Sfixed64,
    Float,
    Double,
    Bool,
    String { max_length: usize },
    Bytes { max_length: usize },
    Message(String),
    Enum(String),
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct MessageOption {
    pub name: String,
    pub value: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct FieldOption {
    pub name: String,
    pub value: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Enum {
    pub name: String,
    pub variants: Vec<EnumVariant>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct EnumVariant {
    pub name: String,
    pub number: i32,
}

impl FieldType {
    pub fn default_string_size() -> usize {
        256
    }

    pub fn default_bytes_size() -> usize {
        1024
    }

    pub fn alignment(&self) -> usize {
        match self {
            FieldType::Int32 | FieldType::Uint32 | FieldType::Sint32 | FieldType::Fixed32 | FieldType::Sfixed32 => 4,
            FieldType::Int64 | FieldType::Uint64 | FieldType::Sint64 | FieldType::Fixed64 | FieldType::Sfixed64 => 8,
            FieldType::Float => 4,
            FieldType::Double => 8,
            FieldType::Bool => 1,
            FieldType::String { .. } => 1,
            FieldType::Bytes { .. } => 1,
            FieldType::Message(_) => 8,
            FieldType::Enum(_) => 4,
        }
    }
}
