//! Generated FFI bindings from Protocol Buffers
//!
//! Users interact with proto models - FFI is transparent

pub mod ffi;
pub mod proto;
mod conversion;
pub mod wrapper;

pub use proto::*;
pub use wrapper::*;
