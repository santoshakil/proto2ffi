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
    #[inline]
    pub const fn default_string_size() -> usize {
        256
    }

    #[inline]
    pub const fn default_bytes_size() -> usize {
        1024
    }

    #[inline]
    pub const fn alignment(&self) -> usize {
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

    #[inline]
    pub fn size(&self) -> usize {
        match self {
            FieldType::Int32 | FieldType::Uint32 | FieldType::Sint32 | FieldType::Fixed32 | FieldType::Sfixed32 => 4,
            FieldType::Int64 | FieldType::Uint64 | FieldType::Sint64 | FieldType::Fixed64 | FieldType::Sfixed64 => 8,
            FieldType::Float => 4,
            FieldType::Double => 8,
            FieldType::Bool => 1,
            FieldType::String { max_length } => *max_length,
            FieldType::Bytes { max_length } => *max_length,
            FieldType::Message(_) => 8,
            FieldType::Enum(_) => 4,
        }
    }

    #[inline]
    pub const fn is_integer(&self) -> bool {
        matches!(
            self,
            FieldType::Int32
                | FieldType::Int64
                | FieldType::Uint32
                | FieldType::Uint64
                | FieldType::Sint32
                | FieldType::Sint64
                | FieldType::Fixed32
                | FieldType::Fixed64
                | FieldType::Sfixed32
                | FieldType::Sfixed64
        )
    }

    #[inline]
    pub const fn is_floating_point(&self) -> bool {
        matches!(self, FieldType::Float | FieldType::Double)
    }

    #[inline]
    pub const fn is_numeric(&self) -> bool {
        self.is_integer() || self.is_floating_point()
    }

    #[inline]
    pub const fn is_signed(&self) -> bool {
        matches!(
            self,
            FieldType::Int32
                | FieldType::Int64
                | FieldType::Sint32
                | FieldType::Sint64
                | FieldType::Sfixed32
                | FieldType::Sfixed64
                | FieldType::Float
                | FieldType::Double
        )
    }

    #[inline]
    pub const fn is_fixed_width(&self) -> bool {
        matches!(
            self,
            FieldType::Fixed32 | FieldType::Fixed64 | FieldType::Sfixed32 | FieldType::Sfixed64
        )
    }

    #[inline]
    pub const fn is_variable_length(&self) -> bool {
        matches!(self, FieldType::String { .. } | FieldType::Bytes { .. })
    }
}
