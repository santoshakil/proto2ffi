pub mod rust;
pub mod dart;
pub mod c;
pub mod pool;
pub mod simd;
pub mod proto_model;

pub use rust::generate_rust;
pub use dart::generate_dart;
pub use c::generate_c_header;
pub use proto_model::{generate_rust_proto_models, generate_dart_proto_models};
