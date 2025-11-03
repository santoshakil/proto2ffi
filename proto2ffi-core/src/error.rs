use std::path::PathBuf;
use thiserror::Error;

#[derive(Error, Debug)]
pub enum Error {
    #[error("Failed to parse proto file: {0}")]
    ParseError(String),

    #[error("Invalid service definition: {0}")]
    InvalidService(String),

    #[error("Invalid method definition: {0}")]
    InvalidMethod(String),

    #[error("Invalid message definition: {0}")]
    InvalidMessage(String),

    #[error("File not found: {0}")]
    FileNotFound(PathBuf),

    #[error("IO error: {0}")]
    Io(#[from] std::io::Error),

    #[error("Code generation failed: {0}")]
    CodeGenError(String),

    #[error("Missing required field: {0}")]
    MissingField(String),

    #[error("Unsupported feature: {0}")]
    UnsupportedFeature(String),

    #[error("Protobuf parse error: {0}")]
    ProtobufParse(String),
}

pub type Result<T> = std::result::Result<T, Error>;
