use std::collections::HashMap;

#[derive(Debug, Clone)]
pub struct GeneratorConfig {
    pub rust: RustConfig,
    pub dart: DartConfig,
    pub c: CConfig,
    pub pool: PoolConfig,
    pub simd: SimdConfig,
}

impl Default for GeneratorConfig {
    fn default() -> Self {
        Self {
            rust: RustConfig::default(),
            dart: DartConfig::default(),
            c: CConfig::default(),
            pool: PoolConfig::default(),
            simd: SimdConfig::default(),
        }
    }
}

#[derive(Debug, Clone)]
pub struct RustConfig {
    pub derive_traits: Vec<String>,
    pub add_doc_comments: bool,
    pub add_safety_comments: bool,
    pub add_examples: bool,
    pub module_name: Option<String>,
    pub visibility: Visibility,
    pub custom_attributes: Vec<String>,
}

impl Default for RustConfig {
    fn default() -> Self {
        Self {
            derive_traits: vec!["Copy".into(), "Clone".into()],
            add_doc_comments: true,
            add_safety_comments: true,
            add_examples: false,
            module_name: None,
            visibility: Visibility::Public,
            custom_attributes: Vec::new(),
        }
    }
}

#[derive(Debug, Clone)]
pub struct DartConfig {
    pub add_doc_comments: bool,
    pub add_examples: bool,
    pub class_prefix: Option<String>,
    pub class_suffix: Option<String>,
    pub use_finals: bool,
    pub add_to_string: bool,
    pub add_equality: bool,
}

impl Default for DartConfig {
    fn default() -> Self {
        Self {
            add_doc_comments: true,
            add_examples: false,
            class_prefix: None,
            class_suffix: None,
            use_finals: true,
            add_to_string: false,
            add_equality: false,
        }
    }
}

#[derive(Debug, Clone)]
pub struct CConfig {
    pub include_guards: bool,
    pub add_doc_comments: bool,
    pub header_prefix: Option<String>,
    pub extern_c: bool,
    pub pragma_pack: bool,
}

impl Default for CConfig {
    fn default() -> Self {
        Self {
            include_guards: true,
            add_doc_comments: true,
            header_prefix: None,
            extern_c: true,
            pragma_pack: true,
        }
    }
}

#[derive(Debug, Clone)]
pub struct PoolConfig {
    pub default_chunk_size: usize,
    pub default_capacity: usize,
    pub enable_stats: bool,
    pub enable_double_free_check: bool,
    pub enable_reset: bool,
    pub enable_batch_operations: bool,
}

impl Default for PoolConfig {
    fn default() -> Self {
        Self {
            default_chunk_size: 100,
            default_capacity: 1000,
            enable_stats: true,
            enable_double_free_check: true,
            enable_reset: true,
            enable_batch_operations: true,
        }
    }
}

#[derive(Debug, Clone)]
pub struct SimdConfig {
    pub enable_simd: bool,
    pub target_features: Vec<String>,
    pub generate_scalar_fallback: bool,
    pub enable_batch_ops: bool,
    pub enable_reduce_ops: bool,
    pub enable_comparison_ops: bool,
    pub min_array_size: usize,
}

impl Default for SimdConfig {
    fn default() -> Self {
        Self {
            enable_simd: true,
            target_features: vec!["avx2".into()],
            generate_scalar_fallback: true,
            enable_batch_ops: true,
            enable_reduce_ops: true,
            enable_comparison_ops: true,
            min_array_size: 8,
        }
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Visibility {
    Public,
    Crate,
    Private,
}

impl Visibility {
    pub fn as_rust_str(&self) -> &'static str {
        match self {
            Visibility::Public => "pub",
            Visibility::Crate => "pub(crate)",
            Visibility::Private => "",
        }
    }
}

impl GeneratorConfig {
    pub fn builder() -> GeneratorConfigBuilder {
        GeneratorConfigBuilder::default()
    }

    pub fn with_rust(mut self, rust: RustConfig) -> Self {
        self.rust = rust;
        self
    }

    pub fn with_dart(mut self, dart: DartConfig) -> Self {
        self.dart = dart;
        self
    }

    pub fn with_c(mut self, c: CConfig) -> Self {
        self.c = c;
        self
    }

    pub fn with_pool(mut self, pool: PoolConfig) -> Self {
        self.pool = pool;
        self
    }

    pub fn with_simd(mut self, simd: SimdConfig) -> Self {
        self.simd = simd;
        self
    }
}

#[derive(Debug, Default)]
pub struct GeneratorConfigBuilder {
    rust: Option<RustConfig>,
    dart: Option<DartConfig>,
    c: Option<CConfig>,
    pool: Option<PoolConfig>,
    simd: Option<SimdConfig>,
}

impl GeneratorConfigBuilder {
    pub fn rust(mut self, rust: RustConfig) -> Self {
        self.rust = Some(rust);
        self
    }

    pub fn dart(mut self, dart: DartConfig) -> Self {
        self.dart = Some(dart);
        self
    }

    pub fn c(mut self, c: CConfig) -> Self {
        self.c = Some(c);
        self
    }

    pub fn pool(mut self, pool: PoolConfig) -> Self {
        self.pool = Some(pool);
        self
    }

    pub fn simd(mut self, simd: SimdConfig) -> Self {
        self.simd = Some(simd);
        self
    }

    pub fn build(self) -> GeneratorConfig {
        GeneratorConfig {
            rust: self.rust.unwrap_or_default(),
            dart: self.dart.unwrap_or_default(),
            c: self.c.unwrap_or_default(),
            pool: self.pool.unwrap_or_default(),
            simd: self.simd.unwrap_or_default(),
        }
    }
}

#[derive(Debug, Clone)]
pub struct FieldOptions {
    pub options: HashMap<String, String>,
}

impl FieldOptions {
    pub fn new() -> Self {
        Self {
            options: HashMap::new(),
        }
    }

    pub fn get(&self, key: &str) -> Option<&String> {
        self.options.get(key)
    }

    pub fn get_bool(&self, key: &str) -> bool {
        self.options
            .get(key)
            .and_then(|v| v.parse().ok())
            .unwrap_or(false)
    }

    pub fn get_usize(&self, key: &str) -> Option<usize> {
        self.options.get(key).and_then(|v| v.parse().ok())
    }

    pub fn set(&mut self, key: String, value: String) {
        self.options.insert(key, value);
    }

    pub fn has(&self, key: &str) -> bool {
        self.options.contains_key(key)
    }
}

impl Default for FieldOptions {
    fn default() -> Self {
        Self::new()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_default_config() {
        let cfg = GeneratorConfig::default();
        assert!(cfg.rust.add_doc_comments);
        assert!(cfg.dart.add_doc_comments);
        assert!(cfg.simd.enable_simd);
    }

    #[test]
    fn test_builder_pattern() {
        let cfg = GeneratorConfig::builder()
            .rust(RustConfig {
                derive_traits: vec!["Debug".into()],
                ..Default::default()
            })
            .build();

        assert_eq!(cfg.rust.derive_traits.len(), 1);
    }

    #[test]
    fn test_visibility() {
        assert_eq!(Visibility::Public.as_rust_str(), "pub");
        assert_eq!(Visibility::Crate.as_rust_str(), "pub(crate)");
        assert_eq!(Visibility::Private.as_rust_str(), "");
    }

    #[test]
    fn test_field_options() {
        let mut opts = FieldOptions::new();
        opts.set("max_length".into(), "256".into());

        assert_eq!(opts.get_usize("max_length"), Some(256));
        assert!(opts.has("max_length"));
    }
}
