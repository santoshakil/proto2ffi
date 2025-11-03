pub mod error;
pub mod model;
pub mod parser;
pub mod generator;

pub use error::{Error, Result};
pub use model::{ProtoFile, ProtoService, ServiceMethod, MessageType, Field, FieldType};

pub struct Proto2Ffi {
    proto_files: Vec<ProtoFile>,
}

impl Proto2Ffi {
    pub fn new() -> Self {
        Self {
            proto_files: Vec::new(),
        }
    }

    pub fn add_proto_file(&mut self, proto_file: ProtoFile) {
        self.proto_files.push(proto_file);
    }

    pub fn proto_files(&self) -> &[ProtoFile] {
        &self.proto_files
    }

    pub fn generate_rust(&self, output_dir: &std::path::Path) -> Result<()> {
        generator::rust::generate(&self.proto_files, output_dir)
    }

    pub fn generate_dart(&self, output_dir: &std::path::Path) -> Result<()> {
        generator::dart::generate(&self.proto_files, output_dir)
    }
}

impl Default for Proto2Ffi {
    fn default() -> Self {
        Self::new()
    }
}
