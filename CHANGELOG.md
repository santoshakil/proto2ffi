# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.1] - 2025-11-02

### Security & Safety Improvements
- **BREAKING (internal)**: Removed unsafe `Sync` implementation from generated pool allocators
  - Pools are now correctly marked as `!Sync`
  - Users needing thread-safe pools should wrap in `Arc<Mutex<_>>`

### Fixed
- Eliminated all `unwrap()` calls in parser - now returns proper errors instead of panicking
- Fixed FFI pointer validation - added null and alignment checks via `debug_assert!()`
- Fixed string encoding bug in Dart generator - now uses UTF-8 (`utf8.encode()`) instead of UTF-16
- Fixed thread safety issue in memory pool generator

### Added
- Debug assertions for FFI pointer validation (null and alignment checks)
- Proper error propagation in parser for invalid field numbers and enum values
- New complex example schemas:
  - `social_media.proto` - Social media platform (15 messages, 4 enums)
  - `blockchain.proto` - Blockchain/distributed ledger (20 messages, 2 enums)

### Changed
- Parser error messages now include context (e.g., "Invalid field number: ...")
- Pool allocator uses `expect()` with descriptive message instead of `unwrap()`

## [0.1.0] - 2025-11-02

### Added
- Initial release
- Protobuf parser with full proto3 syntax support (Pest-based)
- Memory layout calculator with proper alignment
- Rust code generator with `#[repr(C)]` structs
- Dart code generator with `dart:ffi` bindings
- Memory pool generator for high-performance allocation
- SIMD batch operations (AVX2 vectorization)
- Comprehensive test suite (76 tests)
- CLI tool with `generate`, `validate`, and `layout` commands
- Example schemas covering:
  - Basic types (Phase 1)
  - Nested messages and arrays (Phase 2)
  - Memory pools (Phase 3)
  - SIMD operations (Phase 4)
  - Edge cases (Phase 5)
- Real-world benchmark schemas:
  - Game engine (physics, rendering)
  - IoT sensors (100K+ sensors)
  - High-frequency trading (100K+ orders/sec)
- CI/CD with GitHub Actions
- Comprehensive documentation

### Performance
- Zero-copy FFI with direct memory access
- 10-1000x faster than serialization-based solutions
- Memory pools 1.7x faster than malloc
- SIMD batch operations: 2.78B ops/sec (32-bit), 204M ops/sec (64-bit)

[0.1.1]: https://github.com/yourusername/proto2ffi/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/yourusername/proto2ffi/releases/tag/v0.1.0
