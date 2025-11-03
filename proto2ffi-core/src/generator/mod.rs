pub mod rust;
pub mod dart;
pub mod c;
pub mod pool;
pub mod simd;
pub mod proto_model;
pub mod conversion;
pub mod wrapper;

pub use rust::generate_rust;
pub use dart::generate_dart;
pub use c::generate_c_header;
pub use proto_model::{generate_rust_proto_models, generate_dart_proto_models};
pub use conversion::{generate_rust_conversions, generate_dart_conversions};
pub use wrapper::{generate_rust_wrappers, generate_dart_wrappers};
