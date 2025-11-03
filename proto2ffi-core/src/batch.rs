use crate::types::ProtoFile;
use crate::layout::Layout;
use crate::error::{Result, Proto2FFIError};
use crate::parser::parse_proto_file;
use crate::layout::calculate_layout;
use crate::generator;
use crate::codegen_cache::{CodegenCache, hash_file};
use std::path::{Path, PathBuf};
use std::collections::HashMap;

#[derive(Debug, Clone)]
pub struct BatchConfig {
    pub rust_output_dir: PathBuf,
    pub dart_output_dir: PathBuf,
    pub cache_dir: Option<PathBuf>,
    pub alignment: usize,
    pub parallel: bool,
    pub max_threads: usize,
    pub fail_fast: bool,
}

impl Default for BatchConfig {
    fn default() -> Self {
        Self {
            rust_output_dir: PathBuf::from("generated/rust"),
            dart_output_dir: PathBuf::from("generated/dart"),
            cache_dir: Some(PathBuf::from(".proto2ffi-cache")),
            alignment: 8,
            parallel: true,
            max_threads: num_cpus::get(),
            fail_fast: true,
        }
    }
}

pub struct BatchGenerator {
    config: BatchConfig,
    cache: Option<CodegenCache>,
}

#[derive(Debug)]
pub struct BatchResult {
    pub total: usize,
    pub generated: usize,
    pub cached: usize,
    pub failed: usize,
    pub errors: Vec<(PathBuf, String)>,
}

impl BatchGenerator {
    pub fn new(config: BatchConfig) -> Self {
        let cache = config.cache_dir.as_ref().map(|dir| {
            let mut cache = CodegenCache::new(dir);
            let _ = cache.load();
            cache
        });

        Self { config, cache }
    }

    pub fn generate(&mut self, proto_files: &[PathBuf]) -> Result<BatchResult> {
        let mut result = BatchResult {
            total: proto_files.len(),
            generated: 0,
            cached: 0,
            failed: 0,
            errors: Vec::new(),
        };

        if self.config.parallel {
            self.generate_parallel(proto_files, &mut result)?;
        } else {
            self.generate_sequential(proto_files, &mut result)?;
        }

        if let Some(cache) = &self.cache {
            let _ = cache.save();
        }

        Ok(result)
    }

    fn generate_sequential(&mut self, proto_files: &[PathBuf], result: &mut BatchResult) -> Result<()> {
        for proto_file in proto_files {
            match self.generate_single(proto_file) {
                Ok(cached) => {
                    if cached {
                        result.cached += 1;
                    } else {
                        result.generated += 1;
                    }
                }
                Err(e) => {
                    result.failed += 1;
                    result.errors.push((proto_file.clone(), e.to_string()));

                    if self.config.fail_fast {
                        return Err(e);
                    }
                }
            }
        }

        Ok(())
    }

    fn generate_parallel(&mut self, proto_files: &[PathBuf], result: &mut BatchResult) -> Result<()> {
        use std::sync::{Arc, Mutex};
        use std::thread;

        let num_threads = self.config.max_threads.min(proto_files.len());
        if num_threads == 0 {
            return Ok(());
        }

        let chunk_size = (proto_files.len() + num_threads - 1) / num_threads;
        let results = Arc::new(Mutex::new(Vec::new()));
        let mut handles = Vec::new();

        for chunk in proto_files.chunks(chunk_size) {
            let chunk = chunk.to_vec();
            let config = self.config.clone();
            let results = Arc::clone(&results);

            let handle = thread::spawn(move || {
                let mut local_results = Vec::new();

                for proto_file in &chunk {
                    let gen_result = Self::generate_single_static(&config, proto_file, None);
                    local_results.push((proto_file.clone(), gen_result));
                }

                if let Ok(mut r) = results.lock() {
                    r.extend(local_results);
                }
            });

            handles.push(handle);
        }

        for handle in handles {
            let _ = handle.join();
        }

        let thread_results = Arc::try_unwrap(results)
            .map_err(|_| Proto2FFIError::CodeGenError("failed to unwrap results".into()))?
            .into_inner()
            .map_err(|_| Proto2FFIError::CodeGenError("failed to get inner results".into()))?;

        for (proto_file, gen_result) in thread_results {
            match gen_result {
                Ok(cached) => {
                    if cached {
                        result.cached += 1;
                    } else {
                        result.generated += 1;
                    }
                }
                Err(e) => {
                    result.failed += 1;
                    result.errors.push((proto_file, e.to_string()));

                    if self.config.fail_fast {
                        return Err(e);
                    }
                }
            }
        }

        Ok(())
    }

    fn generate_single(&mut self, proto_file: &Path) -> Result<bool> {
        Self::generate_single_static(&self.config, proto_file, self.cache.as_mut())
    }

    fn generate_single_static(
        config: &BatchConfig,
        proto_file: &Path,
        cache: Option<&mut CodegenCache>,
    ) -> Result<bool> {
        let input_hash = hash_file(proto_file)?;

        if let Some(ref cache) = cache {
            if cache.is_valid(proto_file, &input_hash) {
                return Ok(true);
            }
        }

        let proto = parse_proto_file(proto_file)?;
        let layout = calculate_layout(&proto, config.alignment)?;

        let rust_output = config.rust_output_dir.join(format!(
            "{}.rs",
            proto_file.file_stem().unwrap_or_default().to_string_lossy()
        ));

        let dart_output = config.dart_output_dir.join(format!(
            "{}.dart",
            proto_file.file_stem().unwrap_or_default().to_string_lossy()
        ));

        generator::rust::generate_rust(&layout, &rust_output)?;
        generator::dart::generate_dart(&layout, &dart_output)?;

        if let Some(cache) = cache {
            let layout_hash = crate::codegen_cache::hash_layout(&layout)?;
            let entry = crate::codegen_cache::CacheEntry::new(
                input_hash,
                vec![rust_output, dart_output],
                layout_hash,
            );
            cache.insert(proto_file, entry);
        }

        Ok(false)
    }

    pub fn clear_cache(&mut self) -> Result<()> {
        if let Some(cache) = &mut self.cache {
            cache.clear();
            cache.save()?;
        }
        Ok(())
    }
}

pub fn find_proto_files(dir: &Path, recursive: bool) -> Result<Vec<PathBuf>> {
    let mut proto_files = Vec::new();

    if !dir.exists() {
        return Err(Proto2FFIError::IoError(std::io::Error::new(
            std::io::ErrorKind::NotFound,
            format!("directory not found: {}", dir.display()),
        )));
    }

    find_proto_files_recursive(dir, recursive, &mut proto_files)?;

    Ok(proto_files)
}

fn find_proto_files_recursive(
    dir: &Path,
    recursive: bool,
    proto_files: &mut Vec<PathBuf>,
) -> Result<()> {
    for entry in std::fs::read_dir(dir)? {
        let entry = entry?;
        let path = entry.path();

        if path.is_file() {
            if let Some(ext) = path.extension() {
                if ext == "proto" {
                    proto_files.push(path);
                }
            }
        } else if path.is_dir() && recursive {
            find_proto_files_recursive(&path, recursive, proto_files)?;
        }
    }

    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use tempfile::TempDir;
    use std::fs;

    #[test]
    fn test_batch_config_default() {
        let config = BatchConfig::default();
        assert_eq!(config.alignment, 8);
        assert!(config.parallel);
    }

    #[test]
    fn test_find_proto_files() {
        let temp = TempDir::new().unwrap();

        fs::write(temp.path().join("test1.proto"), "syntax = \"proto3\";").unwrap();
        fs::write(temp.path().join("test2.proto"), "syntax = \"proto3\";").unwrap();
        fs::write(temp.path().join("other.txt"), "not a proto").unwrap();

        let files = find_proto_files(temp.path(), false).unwrap();
        assert_eq!(files.len(), 2);
    }

    #[test]
    fn test_find_proto_files_recursive() {
        let temp = TempDir::new().unwrap();
        let sub = temp.path().join("subdir");
        fs::create_dir(&sub).unwrap();

        fs::write(temp.path().join("test1.proto"), "syntax = \"proto3\";").unwrap();
        fs::write(sub.join("test2.proto"), "syntax = \"proto3\";").unwrap();

        let files_non_recursive = find_proto_files(temp.path(), false).unwrap();
        assert_eq!(files_non_recursive.len(), 1);

        let files_recursive = find_proto_files(temp.path(), true).unwrap();
        assert_eq!(files_recursive.len(), 2);
    }
}
