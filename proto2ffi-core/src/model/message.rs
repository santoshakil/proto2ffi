use heck::{AsSnakeCase, AsPascalCase};

#[derive(Debug, Clone)]
pub struct MessageType {
    pub name: String,
    pub fields: Vec<Field>,
    pub comments: Vec<String>,
}

impl MessageType {
    pub fn new(name: String) -> Self {
        Self {
            name,
            fields: Vec::new(),
            comments: Vec::new(),
        }
    }

    pub fn add_field(&mut self, field: Field) {
        self.fields.push(field);
    }

    pub fn add_comment(&mut self, comment: String) {
        self.comments.push(comment);
    }

    pub fn snake_case_name(&self) -> String {
        AsSnakeCase(&self.name).to_string()
    }

    pub fn camel_case_name(&self) -> String {
        AsPascalCase(&self.name).to_string()
    }
}

#[derive(Debug, Clone)]
pub struct Field {
    pub name: String,
    pub number: i32,
    pub field_type: FieldType,
    pub repeated: bool,
    pub optional: bool,
    pub comments: Vec<String>,
}

impl Field {
    pub fn new(name: String, number: i32, field_type: FieldType) -> Self {
        Self {
            name,
            number,
            field_type,
            repeated: false,
            optional: false,
            comments: Vec::new(),
        }
    }

    pub fn snake_case_name(&self) -> String {
        AsSnakeCase(&self.name).to_string()
    }

    pub fn camel_case_name(&self) -> String {
        AsPascalCase(&self.name).to_string()
    }
}

#[derive(Debug, Clone, PartialEq)]
pub enum FieldType {
    Double,
    Float,
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
    Bool,
    String,
    Bytes,
    Message(String),
    Enum(String),
}

impl FieldType {
    pub fn from_proto_type(proto_type: &str) -> Option<Self> {
        match proto_type {
            "double" => Some(Self::Double),
            "float" => Some(Self::Float),
            "int32" => Some(Self::Int32),
            "int64" => Some(Self::Int64),
            "uint32" => Some(Self::Uint32),
            "uint64" => Some(Self::Uint64),
            "sint32" => Some(Self::Sint32),
            "sint64" => Some(Self::Sint64),
            "fixed32" => Some(Self::Fixed32),
            "fixed64" => Some(Self::Fixed64),
            "sfixed32" => Some(Self::Sfixed32),
            "sfixed64" => Some(Self::Sfixed64),
            "bool" => Some(Self::Bool),
            "string" => Some(Self::String),
            "bytes" => Some(Self::Bytes),
            _ => None,
        }
    }

    pub fn is_primitive(&self) -> bool {
        !matches!(self, Self::Message(_) | Self::Enum(_))
    }
}
