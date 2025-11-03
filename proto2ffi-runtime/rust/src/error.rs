use thiserror::Error;

#[derive(Error, Debug)]
pub enum Error {
    #[error("Protobuf encoding error: {0}")]
    EncodeError(String),

    #[error("Protobuf decoding error: {0}")]
    DecodeError(String),

    #[error("Service error: {0}")]
    ServiceError(String),

    #[error("FFI error: {0}")]
    FfiError(String),
}

impl From<prost::EncodeError> for Error {
    fn from(e: prost::EncodeError) -> Self {
        Error::EncodeError(e.to_string())
    }
}

impl From<prost::DecodeError> for Error {
    fn from(e: prost::DecodeError) -> Self {
        Error::DecodeError(e.to_string())
    }
}
