# Proto2FFI

**Zero-Copy FFI Code Generation from Protocol Buffers for Dart & Rust**

[![Crates.io](https://img.shields.io/crates/v/proto2ffi)](https://crates.io/crates/proto2ffi)
[![Documentation](https://docs.rs/proto2ffi/badge.svg)](https://docs.rs/proto2ffi)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Proto2FFI generates high-performance, zero-copy FFI bindings between Dart and Rust using Protocol Buffer schemas as the source of truth. Perfect for Flutter plugins, native extensions, and high-performance applications.

## ✨ Features

- **🚀 Zero-Copy**: Direct memory sharing between Dart and Rust
- **⚡ High Performance**: Billions of operations per second with SIMD
- **🔒 Memory Safe**: Proper alignment and layout guarantees
- **📦 Memory Pools**: Optional pooled allocation for hot paths
- **🎯 SIMD Support**: Batch operations with AVX2/SSE acceleration
- **🛠️ Type Safe**: Generated code is fully type-safe in both languages
- **📝 Protocol Buffers**: Use familiar .proto files as schema
- **✅ Production-Ready**: Extensively tested with 10 comprehensive examples
- **🐛 Battle-Tested**: 6 critical bugs discovered and fixed

## 🚀 Quick Start

### Installation

```bash
# Install CLI tool
cargo install proto2ffi

# Or build from source
git clone https://github.com/yourusername/proto2ffi
cd proto2ffi
cargo build --release
```

### Basic Usage

1. **Define your schema** (`schema.proto`):

```protobuf
syntax = "proto3";

package myapp;

message Point {
  double x = 1;
  double y = 2;
}

message Stats {
  int64 count = 1;
  double sum = 2;
  double avg = 3;
}
```

2. **Generate bindings**:

```bash
proto2ffi generate schema.proto \
  --rust-out src/generated \
  --dart-out lib/generated
```

3. **Use in Rust**:

```rust
use crate::generated::*;

#[no_mangle]
pub extern "C" fn point_distance(p1: *const Point, p2: *const Point) -> f64 {
    unsafe {
        let p1 = &*p1;
        let p2 = &*p2;
        let dx = p2.x - p1.x;
        let dy = p2.y - p1.y;
        (dx * dx + dy * dy).sqrt()
    }
}
```

4. **Use in Dart**:

```dart
import 'package:ffi/ffi.dart';
import 'generated/generated.dart';

void main() {
  final p1 = Point.allocate();
  final p2 = Point.allocate();

  p1.ref.x = 0.0;
  p1.ref.y = 0.0;
  p2.ref.x = 3.0;
  p2.ref.y = 4.0;

  final distance = pointDistance(p1, p2);
  print('Distance: $distance'); // 5.0

  calloc.free(p1);
  calloc.free(p2);
}
```

## 📊 Performance

Proto2FFI achieves exceptional performance through zero-copy design:

| Operation | Throughput | Latency |
|-----------|-----------|---------|
| Image grayscale (SIMD) | 3.5B pixels/sec | 0.28μs/Mpx |
| Image brightness (SIMD) | 3.0B pixels/sec | 0.33μs/Mpx |
| SIMD batch operations | 2.8B vectors/sec | 0.0004μs |
| Pool allocations | 6.7M allocs/sec | 0.15μs |
| Simple FFI calls | 43M ops/sec | 0.02μs |

See [examples/03_benchmarks](./examples/03_benchmarks) for detailed performance metrics and [examples/04_image_processing](./examples/04_image_processing) for real-world SIMD benchmarks.

## 📚 Documentation

- [Examples Guide](./examples/README.md) - 10 comprehensive examples
- [Testing Report](./TESTING_REPORT.md) - Bug fixes and validation
- [Examples Documentation](./EXAMPLES.md) - Detailed examples overview
- [Changelog](./CHANGELOG.md) - Version history and improvements
- [API Documentation](https://docs.rs/proto2ffi) - Rust API reference

## 🎯 Advanced Features

### Memory Pools

Enable pooled allocation for high-performance scenarios:

```protobuf
message Particle {
  option (proto2ffi.pool_size) = 10000;

  double x = 1;
  double y = 2;
  double z = 3;
}
```

### SIMD Batch Operations

Generate vectorized operations automatically:

```protobuf
message Vector4 {
  option (proto2ffi.simd) = true;

  float x = 1;
  float y = 2;
  float z = 3;
  float w = 4;
}
```

### Repeated Fields

Fixed-size arrays with bounds checking:

```protobuf
message Triangle {
  repeated Vertex vertices = 1 [(proto2ffi.max_count) = 3];
}
```

## 📦 Examples

Proto2FFI includes **10 comprehensive examples** demonstrating progressive complexity:

1. **01_basic** - Learn the fundamentals (scalar types, arrays, nested messages)
2. **02_flutter_plugin** - Flutter plugin template ready to use
3. **03_benchmarks** - Performance measurement suite
4. **04_image_processing** - Real-world SIMD image operations (3.5 Gpx/sec)
5. **05_database_engine** - Complex database with transactions
6. **06_edge_cases** - Boundary condition testing
7. **07_concurrent_pools** - Thread-safe memory pool validation
8. **08_simd_operations** - Comprehensive SIMD testing
9. **09_stress_tests** - High-load stress testing
10. **10_real_world_scenarios** - Production-ready applications:
    - Video streaming
    - Game engine
    - Trading system
    - IoT aggregation
    - ML pipeline

See [examples/README.md](./examples/README.md) for detailed guides and [EXAMPLES.md](./EXAMPLES.md) for comprehensive documentation.

## 🐛 Quality Assurance

During extensive testing, we discovered and fixed **6 critical bugs**:

1. ✅ Enum value type mismatch (i32 vs u32)
2. ✅ Dart enum syntax compatibility (Dart 3.0+)
3. ✅ Array type annotations (ffi.Uint32 vs u32)
4. ✅ Enum field representation in structs
5. ✅ Array field accessibility (public vs private)
6. ✅ Rust keyword escaping (r#type for reserved words)

All bugs have been fixed and verified with comprehensive test suites. See [TESTING_REPORT.md](./TESTING_REPORT.md) for details.

## 🏗️ Architecture

```
┌─────────────────┐
│  .proto Schema  │
└────────┬────────┘
         │ Parse
         ▼
┌─────────────────┐
│ Layout Calculator│  ← Compute sizes, offsets, alignment
└────────┬────────┘
         │
         ▼
    ┌────────┴────────┐
    │                 │
    ▼                 ▼
┌─────────┐      ┌─────────┐
│  Rust   │      │  Dart   │
│ #[repr(C)]     │ ffi.Struct│
│ Generator│      │Generator│
└─────────┘      └─────────┘
```

## 🤝 Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](./CONTRIBUTING.md) for guidelines.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.

## 🙏 Acknowledgments

- Inspired by the need for high-performance Flutter native extensions
- Built on the excellent [pest](https://pest.rs/) parser library
- Uses [Protocol Buffers](https://developers.google.com/protocol-buffers) for schema definition

## 📞 Support

- 🐛 [Issue Tracker](https://github.com/yourusername/proto2ffi/issues)
- 💬 [Discussions](https://github.com/yourusername/proto2ffi/discussions)
- 📧 Email: your.email@example.com

---

**Built with ❤️ for the Dart and Rust communities**
