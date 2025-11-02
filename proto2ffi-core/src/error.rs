use thiserror::Error;

#[derive(Debug, Error)]
#[allow(dead_code)]
pub enum Proto2FFIError {
    #[error("Parse error: {0}")]
    ParseError(String),

    #[error("IO error: {0}")]
    IoError(#[from] std::io::Error),

    #[error("Unsupported proto feature: {0}")]
    UnsupportedFeature(String),

    #[error("Layout constraint violation: {0}")]
    LayoutError(String),

    #[error("Code generation failed: {0}")]
    GenerationError(String),

    #[error("Invalid type: {0}")]
    InvalidType(String),

    #[error("Missing field: {0}")]
    MissingField(String),
}

pub type Result<T> = std::result::Result<T, Proto2FFIError>;
