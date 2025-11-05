# Proto2FFI - High-Performance Protobuf over FFI

Ultra-fast Dart ↔ Rust interop using Protocol Buffers over FFI with auto-generated bindings.

## Performance

**Fastest Configuration: 139ns per operation (7.7M ops/sec)**

- Individual calls: ~3µs (294K ops/sec)
- Batch 100 ops: ~0.17µs per op (6.25M ops/sec) - **3.6x faster**
- Batch 1000 ops: **~0.14µs per op (7.7M ops/sec) - 4.3x faster**
- Complex nested data (400KB): ~7ms with 56MB/sec throughput

### vs Alternatives

| Method | Latency | Speedup |
|--------|---------|---------|
| HTTP REST | 1-10ms | 7,000-50,000x slower |
| gRPC (local) | 100-500µs | 700-3,500x slower |
| **FFI+Protobuf** | **0.14µs** | **⚡ Baseline** |

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Build Process                             │
├─────────────────────────────────────────────────────────────┤
│  Proto Definition (calculator.proto, complex_data.proto)     │
│    ├─ prost-build: Proto → Rust structs                     │
│    └─ protoc: Proto → Dart classes                          │
│                                                              │
│  Rust FFI Layer                                              │
│    └─ cbindgen: Rust → C header (rust_lib.h)                │
│                                                              │
│  Dart FFI Layer                                              │
│    └─ ffigen: C header → Dart bindings (generated_bindings) │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                    Runtime Flow                              │
├─────────────────────────────────────────────────────────────┤
│  Dart Application                                            │
│    ↓ Create protobuf request                                │
│  Protobuf Serialization (~4.2% overhead)                     │
│    ↓ Binary bytes                                            │
│  FFI Boundary (~0.1% overhead)                               │
│    ↓ Pass pointer + length                                   │
│  Rust Processing (~91% of time)                              │
│    ↓ Deserialize, compute, serialize                         │
│  FFI Return (~0.1% overhead)                                 │
│    ↓ ByteBuffer struct                                       │
│  Protobuf Deserialization (~0.3% overhead)                   │
│    ↓ Parse response                                          │
│  Dart Application                                            │
└─────────────────────────────────────────────────────────────┘
```

## Features

- **Auto-Generated Bindings**: Zero manual FFI code via cbindgen + ffigen
- **Type-Safe**: Full compile-time type checking across FFI boundary
- **Memory-Safe**: Rust ownership + proper buffer lifecycle management
- **Batch Operations**: Process multiple operations in single FFI call
- **Complex Data**: Handle deeply nested protobuf structures efficiently
- **SOLID Principles**: Clean architecture without Clean Architecture overhead

## Quick Start

### Prerequisites

```bash
# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Dart
brew install dart

# Protocol Buffers compiler
brew install protobuf

# Dart protoc plugin
dart pub global activate protoc_plugin
export PATH="$PATH:$HOME/.pub-cache/bin"
```

### Build

```bash
# Build Rust library
cd examples/rust_lib
cargo build --release

# Generate Dart protobuf code
cd ../
protoc --dart_out=dart_ffi_lib/lib/generated/proto \
  -I proto \
  proto/calculator.proto \
  proto/complex_data.proto

# Generate Dart FFI bindings
cd dart_ffi_lib
dart pub get
dart run ffigen

# Copy library
cp ../rust_lib/target/release/librust_lib.dylib .
```

### Run Examples

```bash
# Basic test
dart run example/main.dart

# Single call latency
dart run example/single_call_benchmark.dart

# Comprehensive benchmarks
dart run example/benchmark.dart

# Optimization benchmarks
dart run example/optimization_benchmark.dart
```

## Project Structure

```
proto2ffil/
├── examples/
│   ├── proto/
│   │   ├── calculator.proto          # Simple operations
│   │   └── complex_data.proto        # Nested data structures
│   ├── rust_lib/
│   │   ├── src/
│   │   │   ├── core/
│   │   │   │   └── calculator.rs     # Business logic (SOLID)
│   │   │   └── lib.rs                # FFI exports
│   │   ├── build.rs                  # Protobuf + cbindgen codegen
│   │   ├── cbindgen.toml             # C header generation config
│   │   └── Cargo.toml
│   └── dart_ffi_lib/
│       ├── lib/
│       │   ├── src/
│       │   │   ├── calculator.dart           # Abstract interface
│       │   │   ├── calculator_impl.dart      # FFI implementation
│       │   │   ├── native_loader.dart        # Cross-platform loader
│       │   │   └── generated_bindings.dart   # Auto-generated FFI
│       │   └── generated/proto/              # Auto-generated protobuf
│       ├── example/
│       │   ├── main.dart                     # Basic demo
│       │   ├── benchmark.dart                # Detailed benchmarks
│       │   ├── single_call_benchmark.dart    # Latency analysis
│       │   └── optimization_benchmark.dart   # Batch + complex data
│       └── pubspec.yaml
└── README.md
```

## Benchmark Results

### Simple Operations

```
Operation: ADD
  Iterations: 1,000,000
  Avg per call: 0.68µs
  Throughput: 1,461,475 ops/sec

Operation: SUBTRACT
  Avg per call: 0.64µs
  Throughput: 1,561,292 ops/sec

Operation: MULTIPLY
  Avg per call: 0.63µs
  Throughput: 1,579,791 ops/sec

Operation: DIVIDE
  Avg per call: 0.63µs
  Throughput: 1,578,903 ops/sec
```

### Timing Breakdown

```
Average across all operations:
  Serialization:     27.0ns (4.2%)
  FFI Call:          0.4ns (0.1%)
  Deserialization:   2.0ns (0.3%)
  ──────────────────────────
  Total:             647.8ns

Overhead Analysis:
  Protobuf overhead: 29.1ns (4.5%)
  FFI overhead:      0.4ns (0.1%)
  Rust processing:   618.3ns (95.4%)
```

### Batch Operations

```
Batch Size: 10
  Avg per operation: 0.602µs
  Throughput: 1,666,667 ops/sec

Batch Size: 100
  Avg per operation: 0.168µs
  Throughput: 6,250,000 ops/sec
  Speedup: 3.6x

Batch Size: 1,000
  Avg per operation: 0.139µs
  Throughput: 7,692,308 ops/sec
  Speedup: 4.3x ⚡
```

### Complex Nested Data

```
10 transactions (3.88 KB):
  Avg per call: 80.7µs
  Data throughput: 48 MB/sec

100 transactions (39.31 KB):
  Avg per call: 536.9µs
  Data throughput: 74 MB/sec

1,000 transactions (401.52 KB):
  Avg per call: 7,138.7µs
  Data throughput: 56 MB/sec
```

## Optimization Strategies

### 1. Batch Processing (Recommended)

Instead of:
```dart
for (var item in items) {
  calc.add(item.a, item.b);  // 1,000 FFI calls
}
```

Do this:
```dart
final batch = BatchOperation(
  operations: items.map((item) =>
    BinaryOp(a: item.a, b: item.b)
  ).toList(),
);
final result = processRequest(ComplexCalculationRequest(batch: batch));
// 1 FFI call - 4.3x faster!
```

### 2. Use Complex Data Structures

Protobuf handles nested objects efficiently:
```dart
final transaction = Transaction(
  sender: Person(
    homeAddress: Address(...),
    metadata: {...},
  ),
  receiver: Person(...),
  tags: [...],
);
// ~80µs for complete round-trip with 3.88KB of data
```

### 3. Cold Start Optimization

First call is slow (~12ms). Warm up during initialization:
```dart
final calc = CalculatorImpl();
calc.add(0, 0); // Warmup call
// Subsequent calls: ~11-15µs
```

### 4. Memory Management

Always dispose resources:
```dart
final calc = CalculatorImpl();
try {
  // Use calc
} finally {
  calc.dispose();
}
```

## Development Workflow

### Adding New Operations

1. **Update Proto**:
```protobuf
// proto/calculator.proto
message NewOperation {
  int64 value = 1;
}

message CalculatorRequest {
  oneof operation {
    // ... existing
    NewOperation new_op = 5;
  }
}
```

2. **Implement in Rust**:
```rust
// src/lib.rs
Operation::NewOp(op) => {
    let result = process_new_op(op.value);
    success_result(result)
}
```

3. **Regenerate Code**:
```bash
# Rust (automatic on build)
cd rust_lib && cargo build

# Dart
cd ..
protoc --dart_out=dart_ffi_lib/lib/generated/proto -I proto proto/*.proto
cd dart_ffi_lib && dart run ffigen
```

4. **Use in Dart**:
```dart
final request = ComplexCalculationRequest(
  newOp: NewOperation(value: fixnum.Int64(42)),
);
final response = processRequest(request);
```

## Design Decisions

### Why Not Clean Architecture?

Clean Architecture's multiple layers (entities, use cases, interfaces, frameworks) add unnecessary complexity for FFI projects:

- **Too Many Abstractions**: FFI boundary is already a natural layer
- **Overhead**: Multiple object allocations per call
- **Complexity**: 5+ files for simple operations

### Our Approach: SOLID Without Clean

- **Single Responsibility**: Each module has one job
- **Open/Closed**: Trait-based extensibility
- **Liskov Substitution**: Abstract interfaces for testing
- **Interface Segregation**: Focused, minimal interfaces
- **Dependency Inversion**: Depend on abstractions

Result: Clean code without architectural overhead.

### Why Protobuf Over JSON?

| Metric | Protobuf | JSON |
|--------|----------|------|
| Serialization | 27ns | ~500ns |
| Size (100 items) | 39KB | ~120KB |
| Type Safety | Compile-time | Runtime |
| Schema | Required | Optional |
| Speed | **18x faster** | Baseline |

### Why cbindgen + ffigen?

Manual FFI bindings are error-prone:
- Wrong struct layouts = crashes
- Missing functions = compile errors
- Type mismatches = undefined behavior

Auto-generation guarantees:
- ✅ Correct struct alignment
- ✅ All functions exported
- ✅ Type safety
- ✅ Zero maintenance

## Troubleshooting

### Library Not Found

```bash
# macOS
cp rust_lib/target/release/librust_lib.dylib dart_ffi_lib/

# Linux
cp rust_lib/target/release/librust_lib.so dart_ffi_lib/

# Windows
copy rust_lib\target\release\rust_lib.dll dart_ffi_lib\
```

### Protobuf Import Errors

```bash
# Use -I flag to specify include path
protoc --dart_out=dart_ffi_lib/lib/generated/proto \
  -I proto \
  proto/*.proto
```

### FFI Generation Warnings

Ignore warnings about system types (pthread, etc.). Only `ByteBuffer` and function exports matter.

### Build Errors After Proto Changes

```bash
cd rust_lib
cargo clean
cargo build --release

cd ../dart_ffi_lib
dart run ffigen
```

## Performance Tips

1. **Batch operations** when possible (4.3x speedup)
2. **Reuse calculator instances** (avoid cold starts)
3. **Use release builds** (`cargo build --release`)
4. **Pre-allocate buffers** in hot paths
5. **Profile first** - don't optimize blindly

## License

MIT

## Contributing

1. Fork the repository
2. Create your feature branch
3. Add tests
4. Run benchmarks
5. Submit a pull request

## Acknowledgments

Built with:
- [prost](https://github.com/tokio-rs/prost) - Rust protobuf implementation
- [cbindgen](https://github.com/mozilla/cbindgen) - C header generation
- [ffigen](https://pub.dev/packages/ffigen) - Dart FFI bindings generation
- [dart:ffi](https://dart.dev/guides/libraries/c-interop) - Dart FFI support
