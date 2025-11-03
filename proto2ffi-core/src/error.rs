use thiserror::Error;

#[derive(Debug, Error)]
pub enum Proto2FFIError {
    #[error("Parse error: {0}")]
    ParseError(String),

    #[error("IO error: {0}")]
    IoError(#[from] std::io::Error),

    #[error("Missing field: {0}")]
    MissingField(String),
}

pub type Result<T> = std::result::Result<T, Proto2FFIError>;
