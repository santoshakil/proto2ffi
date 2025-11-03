pub mod byte_buffer;
pub mod error;

pub use byte_buffer::ByteBuffer;
pub use error::Error;

pub type Result<T> = std::result::Result<T, Error>;

pub trait Proto2FfiService: Send + Sync {
    fn service_name(&self) -> &'static str;
}
