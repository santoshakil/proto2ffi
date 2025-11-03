use crate::layout::Layout;
use crate::error::Result;
use std::collections::HashMap;
use std::fs;
use std::path::{Path, PathBuf};
use std::time::SystemTime;
use sha2::{Sha256, Digest};

#[derive(Debug, Clone)]
pub struct CodegenCache {
    cache_dir: PathBuf,
    entries: HashMap<String, CacheEntry>,
}

#[derive(Debug, Clone)]
struct CacheEntry {
    input_hash: String,
    output_paths: Vec<PathBuf>,
    timestamp: SystemTime,
    layout_hash: String,
}

impl CodegenCache {
    pub fn new(cache_dir: impl AsRef<Path>) -> Self {
        Self {
            cache_dir: cache_dir.as_ref().to_path_buf(),
            entries: HashMap::new(),
        }
    }

    pub fn load(&mut self) -> Result<()> {
        if !self.cache_dir.exists() {
            fs::create_dir_all(&self.cache_dir)?;
            return Ok(());
        }

        let manifest_path = self.cache_dir.join("manifest.json");
        if manifest_path.exists() {
            let content = fs::read_to_string(&manifest_path)?;
            self.entries = serde_json::from_str(&content).unwrap_or_default();
        }

        Ok(())
    }

    pub fn save(&self) -> Result<()> {
        if !self.cache_dir.exists() {
            fs::create_dir_all(&self.cache_dir)?;
        }

        let manifest_path = self.cache_dir.join("manifest.json");
        let content = serde_json::to_string_pretty(&self.entries)
            .map_err(|e| crate::error::Proto2FFIError::CodeGenError(e.to_string()))?;
        fs::write(&manifest_path, content)?;

        Ok(())
    }

    pub fn get(&self, proto_path: &Path) -> Option<&CacheEntry> {
        let key = proto_path.to_string_lossy().to_string();
        self.entries.get(&key)
    }

    pub fn insert(&mut self, proto_path: &Path, entry: CacheEntry) {
        let key = proto_path.to_string_lossy().to_string();
        self.entries.insert(key, entry);
    }

    pub fn is_valid(&self, proto_path: &Path, input_hash: &str) -> bool {
        if let Some(entry) = self.get(proto_path) {
            if entry.input_hash != input_hash {
                return false;
            }

            for output_path in &entry.output_paths {
                if !output_path.exists() {
                    return false;
                }

                if let Ok(metadata) = fs::metadata(output_path) {
                    if let Ok(modified) = metadata.modified() {
                        if modified < entry.timestamp {
                            return false;
                        }
                    }
                }
            }

            true
        } else {
            false
        }
    }

    pub fn invalidate(&mut self, proto_path: &Path) -> bool {
        let key = proto_path.to_string_lossy().to_string();
        self.entries.remove(&key).is_some()
    }

    pub fn clear(&mut self) {
        self.entries.clear();
    }

    pub fn entry_count(&self) -> usize {
        self.entries.len()
    }
}

impl CacheEntry {
    pub fn new(
        input_hash: String,
        output_paths: Vec<PathBuf>,
        layout_hash: String,
    ) -> Self {
        Self {
            input_hash,
            output_paths,
            timestamp: SystemTime::now(),
            layout_hash,
        }
    }
}

pub fn hash_file(path: &Path) -> Result<String> {
    let content = fs::read(path)?;
    let mut hasher = Sha256::new();
    hasher.update(&content);
    let result = hasher.finalize();
    Ok(format!("{:x}", result))
}

pub fn hash_layout(layout: &Layout) -> Result<String> {
    let serialized = serde_json::to_string(layout)
        .map_err(|e| crate::error::Proto2FFIError::CodeGenError(e.to_string()))?;
    let mut hasher = Sha256::new();
    hasher.update(serialized.as_bytes());
    let result = hasher.finalize();
    Ok(format!("{:x}", result))
}

pub fn hash_string(s: &str) -> String {
    let mut hasher = Sha256::new();
    hasher.update(s.as_bytes());
    let result = hasher.finalize();
    format!("{:x}", result)
}

use serde::{Deserialize, Serialize};

impl Serialize for CacheEntry {
    fn serialize<S>(&self, serializer: S) -> std::result::Result<S::Ok, S::Error>
    where
        S: serde::Serializer,
    {
        use serde::ser::SerializeStruct;
        let mut state = serializer.serialize_struct("CacheEntry", 4)?;
        state.serialize_field("input_hash", &self.input_hash)?;
        state.serialize_field("output_paths", &self.output_paths)?;
        state.serialize_field("layout_hash", &self.layout_hash)?;

        let timestamp_secs = self.timestamp
            .duration_since(SystemTime::UNIX_EPOCH)
            .map(|d| d.as_secs())
            .unwrap_or(0);
        state.serialize_field("timestamp", &timestamp_secs)?;

        state.end()
    }
}

impl<'de> Deserialize<'de> for CacheEntry {
    fn deserialize<D>(deserializer: D) -> std::result::Result<Self, D::Error>
    where
        D: serde::Deserializer<'de>,
    {
        #[derive(Deserialize)]
        struct CacheEntryHelper {
            input_hash: String,
            output_paths: Vec<PathBuf>,
            layout_hash: String,
            timestamp: u64,
        }

        let helper = CacheEntryHelper::deserialize(deserializer)?;

        let timestamp = SystemTime::UNIX_EPOCH + std::time::Duration::from_secs(helper.timestamp);

        Ok(CacheEntry {
            input_hash: helper.input_hash,
            output_paths: helper.output_paths,
            timestamp,
            layout_hash: helper.layout_hash,
        })
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use tempfile::TempDir;

    #[test]
    fn test_cache_creation() {
        let temp = TempDir::new().unwrap();
        let cache = CodegenCache::new(temp.path());
        assert_eq!(cache.entry_count(), 0);
    }

    #[test]
    fn test_cache_insert_get() {
        let temp = TempDir::new().unwrap();
        let mut cache = CodegenCache::new(temp.path());

        let proto_path = PathBuf::from("test.proto");
        let entry = CacheEntry::new(
            "hash123".into(),
            vec![PathBuf::from("output.rs")],
            "layout_hash".into(),
        );

        cache.insert(&proto_path, entry);
        assert!(cache.get(&proto_path).is_some());
        assert_eq!(cache.entry_count(), 1);
    }

    #[test]
    fn test_cache_invalidate() {
        let temp = TempDir::new().unwrap();
        let mut cache = CodegenCache::new(temp.path());

        let proto_path = PathBuf::from("test.proto");
        let entry = CacheEntry::new(
            "hash123".into(),
            vec![PathBuf::from("output.rs")],
            "layout_hash".into(),
        );

        cache.insert(&proto_path, entry);
        assert!(cache.invalidate(&proto_path));
        assert_eq!(cache.entry_count(), 0);
    }

    #[test]
    fn test_hash_string() {
        let hash1 = hash_string("hello");
        let hash2 = hash_string("hello");
        let hash3 = hash_string("world");

        assert_eq!(hash1, hash2);
        assert_ne!(hash1, hash3);
    }
}
