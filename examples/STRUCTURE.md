# Examples Directory Structure

All examples are now organized in a clean, numbered structure for progressive learning.

## 📁 Directory Layout

```
examples/
├── README.md                    # You are here! Main examples guide
├── STRUCTURE.md                 # This file - quick reference
│
├── 01_basic/                    # ⭐ START HERE
│   ├── rust/                    # Rust FFI implementation
│   ├── lib/                     # Dart bindings
│   ├── test/                    # Comprehensive tests
│   └── pubspec.yaml
│
├── 02_flutter_plugin/           # Flutter plugin template
│   ├── lib/generated.dart
│   ├── rust/src/generated.rs
│   └── pubspec.yaml
│
├── 03_benchmarks/               # Performance benchmarks
│   ├── src/main.rs
│   ├── schemas/
│   └── Cargo.toml
│
├── 04_image_processing/         # ⭐ REAL-WORLD EXAMPLE
│   ├── proto/image.proto        # 21 messages, 3 enums
│   ├── rust/                    # 430+ lines SIMD code
│   │   ├── src/lib.rs
│   │   ├── src/generated.rs
│   │   └── Cargo.toml
│   ├── flutter/                 # Dart wrapper + tests
│   │   ├── lib/
│   │   ├── test/                # 15 tests, all passing
│   │   └── pubspec.yaml
│   └── benchmarks/              # Performance data
│
└── 05_database_engine/          # ⭐ COMPLEX EXAMPLE
    ├── proto/database.proto     # 14 messages, 4 enums
    ├── rust/                    # Generated code
    │   ├── src/lib.rs           # TBD: Implementation
    │   ├── src/generated.rs
    │   └── Cargo.toml
    └── flutter/                 # Dart bindings
        ├── lib/generated.dart
        └── pubspec.yaml
```

## 🎯 Quick Navigation

### For Beginners:
```bash
cd examples/01_basic
dart test
```

### For Flutter Developers:
```bash
cd examples/02_flutter_plugin
# Use this as a template for your plugins
```

### For Performance Optimization:
```bash
cd examples/03_benchmarks
cargo bench
```

### For Real-World Applications:
```bash
# High-performance image processing
cd examples/04_image_processing/flutter
dart test

# Complex database operations
cd examples/05_database_engine/rust
cargo check
```

## 📊 Complexity Levels

| Example | Complexity | Lines of Code | Tests | Purpose |
|---------|------------|---------------|-------|---------|
| 01_basic | ⭐ Easy | ~200 | ✅ 10+ | Learn basics |
| 02_flutter_plugin | ⭐⭐ Medium | ~100 | ❌ | Template |
| 03_benchmarks | ⭐⭐ Medium | ~500 | ✅ Built-in | Measure perf |
| 04_image_processing | ⭐⭐⭐ Advanced | 630+ | ✅ 15 | Production use |
| 05_database_engine | ⭐⭐⭐ Advanced | 600+ | ⚠️ Pending | Complex patterns |

## 🚀 Learning Path

### Path 1: Beginner
```
01_basic (2 hours)
  → 02_flutter_plugin (1 hour)
  → 04_image_processing (read code, 1 hour)
```

### Path 2: Performance Engineer
```
01_basic (1 hour)
  → 03_benchmarks (2 hours)
  → 04_image_processing (deep dive, 4 hours)
```

### Path 3: System Architect
```
01_basic (30 min)
  → 05_database_engine (code review, 2 hours)
  → 04_image_processing (code review, 2 hours)
  → Create your own complex plugin
```

## 📈 Performance Highlights

**From 04_image_processing benchmarks:**
- ✅ 3,518 Mpx/sec - Grayscale conversion (SIMD)
- ✅ 3,023 Mpx/sec - Brightness adjustment (SIMD)
- ✅ 284μs - 1 megapixel operation
- ✅ 90%+ - Memory allocation reduction (pools)

## 🔧 Workspace Configuration

All examples are registered in the root `Cargo.toml`:

```toml
[workspace]
members = [
    "examples/01_basic/rust",
    "examples/02_flutter_plugin/rust",
    "examples/03_benchmarks",
    "examples/04_image_processing/rust",
    "examples/05_database_engine/rust",
]
```

Build all examples at once:
```bash
cargo build --release --workspace
```

## 📚 Documentation Index

- **README.md** - Detailed guide for each example (this directory)
- **../EXAMPLES.md** - Project-wide examples documentation
- **../TESTING_REPORT.md** - Bug fixes and performance data
- **../README.md** - Main project README
- **../CHANGELOG.md** - Version history

## ✨ What Changed

### Before (messy):
```
proto2ffil/
├── ffi_example/           # Confusing name
├── examples/
│   ├── benchmark_suite/   # Not numbered
│   └── flutter_plugin/
└── plugins/               # Separate from examples!
    ├── image_processing/
    └── database_engine/
```

### After (clean):
```
proto2ffil/
└── examples/              # Everything in one place! ⭐
    ├── 01_basic/          # Numbered for clarity
    ├── 02_flutter_plugin/
    ├── 03_benchmarks/
    ├── 04_image_processing/
    └── 05_database_engine/
```

## 🎓 Example Selection Guide

**Choose an example based on your goal:**

| Your Goal | Recommended Example | Why |
|-----------|---------------------|-----|
| Learn proto2ffi | 01_basic | Complete tutorial |
| Build Flutter plugin | 02_flutter_plugin | Ready template |
| Optimize performance | 03_benchmarks | Measurement tools |
| Production FFI code | 04_image_processing | Battle-tested |
| Complex architectures | 05_database_engine | Advanced patterns |

## 🐛 Bugs Fixed

These examples helped discover and fix **6 critical bugs**:

1. ✅ Enum value type mismatch
2. ✅ Dart enum syntax compatibility
3. ✅ Array type annotations
4. ✅ Enum field representation
5. ✅ Array field accessibility
6. ✅ Rust keyword escaping

See `../TESTING_REPORT.md` for details.

---

*Last updated: 2025-11-03*
*All examples organized and documented*
