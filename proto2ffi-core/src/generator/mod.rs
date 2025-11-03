pub mod rust;
pub mod dart;

use crate::error::Result;
use crate::model::ProtoFile;
use std::path::Path;

pub trait CodeGenerator {
    fn generate(&self, proto_files: &[ProtoFile], output_dir: &Path) -> Result<()>;
}
