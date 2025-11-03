use thiserror::Error;

#[derive(Debug, Error)]
pub enum Proto2FFIError {
    #[error("Parse error: {0}")]
    ParseError(String),

    #[error("IO error: {0}")]
    IoError(#[from] std::io::Error),

    #[error("Missing field: {0}")]
    MissingField(String),

    #[error("Invalid field type: {0}")]
    InvalidFieldType(String),

    #[error("Unsupported type: {0}")]
    UnsupportedType(String),

    #[error("Layout error: {0}")]
    LayoutError(String),

    #[error("Code generation error: {0}")]
    CodeGenError(String),

    #[error("Validation error in message '{message}': {reason}")]
    ValidationError {
        message: String,
        reason: String,
    },

    #[error("Field number {field_number} in message '{message}' is out of valid range (1-536870911)")]
    InvalidFieldNumber {
        message: String,
        field_number: i32,
    },

    #[error("Duplicate field number {field_number} in message '{message}'")]
    DuplicateFieldNumber {
        message: String,
        field_number: i32,
    },

    #[error("Duplicate field name '{field_name}' in message '{message}'")]
    DuplicateFieldName {
        message: String,
        field_name: String,
    },

    #[error("Reserved field number {field_number} in message '{message}'")]
    ReservedFieldNumber {
        message: String,
        field_number: i32,
    },

    #[error("Option '{option}' has invalid value '{value}': {reason}")]
    InvalidOption {
        option: String,
        value: String,
        reason: String,
    },

    #[error("Circular dependency detected: {0}")]
    CircularDependency(String),

    #[error("Undefined message type: {0}")]
    UndefinedMessage(String),

    #[error("Maximum nesting depth exceeded: {0}")]
    MaxNestingDepthExceeded(usize),

    #[error("Memory alignment error: {0}")]
    AlignmentError(String),

    #[error("Buffer overflow in field '{field}': size {size} exceeds maximum {max}")]
    BufferOverflow {
        field: String,
        size: usize,
        max: usize,
    },
}

pub type Result<T> = std::result::Result<T, Proto2FFIError>;
