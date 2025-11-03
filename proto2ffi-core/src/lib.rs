//! # proto2ffi-core
//!
//! Core library for generating zero-copy FFI bindings from Protocol Buffer definitions.
//!
//! This library provides:
//! - Protocol Buffer schema parsing
//! - Memory layout calculation with proper alignment
//! - Code generation for Rust (#[repr(C)] structs)
//! - Code generation for Dart (dart:ffi bindings)
//! - Memory pool generation for high-performance allocation
//! - SIMD batch operations generation
//!
//! ## Example
//!
//! ```rust,no_run
//! use proto2ffi_core::{parse_proto_file, calculate_layout, generate_all};
//! use std::path::Path;
//!
//! let proto_file = Path::new("schema.proto");
//! let proto = parse_proto_file(proto_file)?;
//! let layout = calculate_layout(&proto, 8)?;
//! generate_all(&layout, Path::new("output/rust"), Path::new("output/dart"))?;
//! # Ok::<(), Box<dyn std::error::Error>>(())
//! ```

pub mod error;
pub mod types;
pub mod parser;
pub mod layout;
pub mod generator;
pub mod validator;
pub mod benchmark;

pub use error::{Proto2FFIError, Result};
pub use types::{ProtoFile, Message, Field, FieldType, Enum, EnumVariant};
pub use parser::{parse_proto_file, parse_proto_string};
pub use layout::{Layout, MessageLayout, FieldLayout, EnumLayout, calculate_layout};
pub use validator::{validate_proto_file, ValidationReport};
pub use benchmark::{Benchmark, BenchmarkResult};

use std::path::Path;

/// Generate all code (Rust + Dart) from a layout
pub fn generate_all(
    layout: &Layout,
    rust_output: &Path,
    dart_output: &Path,
) -> Result<()> {
    generator::rust::generate_rust(layout, rust_output)?;
    generator::dart::generate_dart(layout, dart_output)?;
    Ok(())
}

/// Generate only Rust code
pub fn generate_rust_only(layout: &Layout, output: &Path) -> Result<()> {
    generator::rust::generate_rust(layout, output)
}

/// Generate only Dart code
pub fn generate_dart_only(layout: &Layout, output: &Path) -> Result<()> {
    generator::dart::generate_dart(layout, output)
}

/// Complete code generation pipeline from proto file
pub fn generate_from_proto(
    proto_path: &Path,
    rust_output: &Path,
    dart_output: &Path,
) -> Result<()> {
    let proto = parse_proto_file(proto_path)?;
    let layout = calculate_layout(&proto, 8)?;
    generate_all(&layout, rust_output, dart_output)?;
    Ok(())
}
