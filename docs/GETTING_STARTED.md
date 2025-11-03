# Getting Started with Proto2FFI

This guide will walk you through creating your first FFI service with Proto2FFI.

## Prerequisites

- Rust toolchain (1.70+)
- Dart SDK (3.0+)
- protoc (Protocol Buffer compiler)
- Basic understanding of protobuf and FFI

## Installation

### Install Proto2FFI CLI

```bash
cargo install proto2ffi
```

Or build from source:

```bash
git clone https://github.com/santoshakil/proto2ffi
cd proto2ffi
cargo build --release
cargo install --path proto2ffi-cli
```

### Verify Installation

```bash
proto2ffi --version
```

## Step-by-Step Tutorial

### 1. Create Project Structure

```bash
mkdir my_ffi_service
cd my_ffi_service

# Create directories
mkdir -p proto
mkdir -p rust_service/src
mkdir -p dart_client/lib
```

### 2. Define Your Service

Create `proto/calculator.proto`:

```protobuf
syntax = "proto3";

package calculator;

message AddRequest {
  double a = 1;
  double b = 2;
}

message AddResponse {
  double result = 1;
}

message MultiplyRequest {
  double a = 1;
  double b = 2;
}

message MultiplyResponse {
  double result = 1;
}

service Calculator {
  rpc Add(AddRequest) returns (AddResponse);
  rpc Multiply(MultiplyRequest) returns (MultiplyResponse);
}
```

### 3. Generate FFI Bindings

```bash
proto2ffi generate \
  --proto proto/calculator.proto \
  --rust-out rust_service/src/generated \
  --dart-out dart_client/lib/generated
```

You should see:

```
→ Generating FFI bindings from proto/calculator.proto
  ✓ Found 1 service(s), 4 message(s)
→ Generating Rust code...
  ✓ Generated Rust FFI exports
→ Generating Dart code...
  ✓ Generated Dart client

✓ Code generation complete!
```

### 4. Set Up Rust Service

**Create `rust_service/Cargo.toml`:**

```toml
[package]
name = "calculator_service"
version = "0.1.0"
edition = "2021"

[workspace]

[lib]
crate-type = ["cdylib"]

[dependencies]
prost = "0.12"

[build-dependencies]
prost-build = "0.12"
```

**Create `rust_service/build.rs`:**

```rust
fn main() {
    prost_build::Config::new()
        .out_dir("src/proto")
        .compile_protos(&["../proto/calculator.proto"], &["../proto"])
        .unwrap();
}
```

**Create `rust_service/src/lib.rs`:**

```rust
// Include protobuf-generated code
mod proto {
    include!("proto/calculator.rs");
}

// Re-export protobuf messages
pub use proto::{AddRequest, AddResponse, MultiplyRequest, MultiplyResponse};

// Include proto2ffi-generated code
mod generated;
use generated::*;

// Implement the Calculator service
struct CalculatorService;

impl Calculator for CalculatorService {
    fn add(&self, request: AddRequest)
        -> Result<AddResponse, Box<dyn std::error::Error>>
    {
        Ok(AddResponse {
            result: request.a + request.b,
        })
    }

    fn multiply(&self, request: MultiplyRequest)
        -> Result<MultiplyResponse, Box<dyn std::error::Error>>
    {
        Ok(MultiplyResponse {
            result: request.a * request.b,
        })
    }
}

// Initialize the service (called from Dart)
#[no_mangle]
pub extern "C" fn init_service() {
    unsafe {
        init_calculator(Box::new(CalculatorService));
    }
}
```

**Copy generated code:**

```bash
mkdir -p rust_service/src/proto
cp -r rust_service/src/generated rust_service/src/
```

### 5. Build Rust Library

```bash
cd rust_service
cargo build --release
```

The library will be at:
- macOS: `target/release/libcalculator_service.dylib`
- Linux: `target/release/libcalculator_service.so`
- Windows: `target/release/calculator_service.dll`

### 6. Set Up Dart Client

**Create `dart_client/pubspec.yaml`:**

```yaml
name: calculator_client
description: Calculator FFI client
version: 1.0.0

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  ffi: ^2.1.0
  protobuf: ^3.1.0
```

**Generate Dart protobuf code:**

```bash
# Install protoc-gen-dart if needed
dart pub global activate protoc_plugin

# Generate
protoc --dart_out=dart_client/lib/proto \
  -I proto \
  proto/calculator.proto
```

**Create `dart_client/lib/main.dart`:**

```dart
import 'dart:ffi' as ffi;
import 'dart:io';
import 'package:ffi/ffi.dart';

// Import proto2ffi generated client
import 'generated/proto2ffi_generated.dart';

// Import protobuf messages
import 'proto/calculator.pb.dart';

void main() {
  // Load the native library
  final dylib = _loadLibrary();

  // Initialize the service
  final initService = dylib.lookupFunction<
    ffi.Void Function(),
    void Function()
  >('init_service');
  initService();

  // Create the client
  final client = CalculatorClient(dylib);

  // Test Add operation
  print('Testing Add...');
  final addRequest = AddRequest()
    ..a = 10.5
    ..b = 20.3;

  final addResponseBytes = client.add(addRequest.writeToBuffer());
  if (addResponseBytes != null) {
    final addResponse = AddResponse.fromBuffer(addResponseBytes);
    print('10.5 + 20.3 = ${addResponse.result}');
  }

  // Test Multiply operation
  print('\nTesting Multiply...');
  final multiplyRequest = MultiplyRequest()
    ..a = 5.0
    ..b = 7.0;

  final multiplyResponseBytes = client.multiply(multiplyRequest.writeToBuffer());
  if (multiplyResponseBytes != null) {
    final multiplyResponse = MultiplyResponse.fromBuffer(multiplyResponseBytes);
    print('5.0 * 7.0 = ${multiplyResponse.result}');
  }
}

ffi.DynamicLibrary _loadLibrary() {
  if (Platform.isMacOS) {
    return ffi.DynamicLibrary.open('../rust_service/target/release/libcalculator_service.dylib');
  } else if (Platform.isLinux) {
    return ffi.DynamicLibrary.open('../rust_service/target/release/libcalculator_service.so');
  } else if (Platform.isWindows) {
    return ffi.DynamicLibrary.open('../rust_service/target/release/calculator_service.dll');
  } else {
    throw UnsupportedError('Unsupported platform');
  }
}
```

### 7. Run Your Application

```bash
cd dart_client
dart pub get
dart run lib/main.dart
```

Expected output:

```
Testing Add...
10.5 + 20.3 = 30.8

Testing Multiply...
5.0 * 7.0 = 35.0
```

## Understanding the Generated Code

### Rust Side

**Service Trait** (`generated/calculator.rs`):

```rust
pub trait Calculator {
    fn add(&self, request: AddRequest)
        -> Result<AddResponse, Box<dyn std::error::Error>>;

    fn multiply(&self, request: MultiplyRequest)
        -> Result<MultiplyResponse, Box<dyn std::error::Error>>;
}
```

**FFI Exports** (`generated/calculator_ffi.rs`):

```rust
#[no_mangle]
pub unsafe extern "C" fn proto2ffi_add(
    request_data: *const u8,
    request_len: usize
) -> ByteBuffer {
    // 1. Decode protobuf request
    // 2. Call service trait method
    // 3. Encode protobuf response
    // 4. Return ByteBuffer
}
```

### Dart Side

**Client** (`generated/calculator_client.dart`):

```dart
class CalculatorClient {
  final ffi.DynamicLibrary _dylib;

  List<int>? add(List<int> requestBytes) {
    // 1. Allocate memory for request
    // 2. Call FFI function
    // 3. Extract response bytes
    // 4. Free memory
    // 5. Return response
  }
}
```

## Error Handling

### Rust Side

Return errors from your service:

```rust
impl Calculator for CalculatorService {
    fn divide(&self, request: DivideRequest)
        -> Result<DivideResponse, Box<dyn std::error::Error>>
    {
        if request.b == 0.0 {
            return Err("Division by zero".into());
        }

        Ok(DivideResponse {
            result: request.a / request.b,
        })
    }
}
```

### Dart Side

Check for null response:

```dart
final responseBytes = client.divide(request.writeToBuffer());
if (responseBytes == null) {
  print('Error: Operation failed');
  return;
}

final response = DivideResponse.fromBuffer(responseBytes);
print('Result: ${response.result}');
```

## Next Steps

- **Multiple Services**: Define multiple services in one proto file
- **Complex Messages**: Use nested messages, repeated fields, maps
- **Production Setup**: See [Production Guide](PRODUCTION_GUIDE.md)
- **Performance Tuning**: See [Performance Guide](PERFORMANCE.md)
- **Advanced Examples**: Check `examples/` directory

## Troubleshooting

### "Cannot find module 'generated'"

Make sure you copied the generated code to `src/`:

```bash
cp -r rust_service/src/generated rust_service/src/
```

### "Symbol not found" on Dart side

Ensure you:
1. Built the Rust library: `cargo build --release`
2. Used correct path in `DynamicLibrary.open()`
3. Called `init_service()` before using the client

### "Failed to parse proto file"

Check:
1. Proto syntax is correct (`syntax = "proto3"`)
2. All imports are available
3. Use `--includes` flag for import paths

### Compilation errors in generated code

If you see errors about missing types:
1. Make sure you're re-exporting protobuf messages in `lib.rs`
2. Regenerate code after proto changes
3. Copy generated code to `src/` directory

## Additional Resources

- [API Documentation](API.md)
- [Examples](../examples/)
- [Benchmark Results](../research/proto_benchmark/BENCHMARK_RESULTS.md)
- [Contributing Guide](../CONTRIBUTING.md)
