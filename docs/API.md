# API Reference

Complete API documentation for Proto2FFI.

## Table of Contents

- [CLI Commands](#cli-commands)
- [Core Library API](#core-library-api)
- [Generated Code API](#generated-code-api)
- [Runtime Libraries](#runtime-libraries)

## CLI Commands

### `proto2ffi generate`

Generate FFI bindings from proto files.

```bash
proto2ffi generate [OPTIONS]
```

**Options:**

- `-p, --proto <FILE>` - Proto file to parse (can be specified multiple times)
- `-r, --rust-out <DIR>` - Output directory for Rust code
- `-d, --dart-out <DIR>` - Output directory for Dart code
- `-i, --includes <DIR>` - Include paths for proto imports (can be specified multiple times)
- `-h, --help` - Print help
- `-V, --version` - Print version

**Examples:**

```bash
# Single proto file
proto2ffi generate \
  --proto services/user.proto \
  --rust-out backend/src/generated \
  --dart-out app/lib/generated

# Multiple proto files
proto2ffi generate \
  --proto services/user.proto \
  --proto services/auth.proto \
  --rust-out backend/src/generated \
  --dart-out app/lib/generated

# With include paths
proto2ffi generate \
  --proto services/user.proto \
  --rust-out backend/src/generated \
  --dart-out app/lib/generated \
  --includes services \
  --includes third_party/protos
```

## Core Library API

### `proto2ffi_core::parse`

Parse proto files and extract service definitions.

```rust
use proto2ffi_core::{ProtoParser, ProtoFile};
use std::path::Path;

let parser = ProtoParser::new();
let proto_files = parser.parse_file(Path::new("service.proto"))?;
```

### `proto2ffi_core::generate`

Generate code from parsed proto files.

```rust
use proto2ffi_core::{generator, ProtoFile};
use std::path::Path;

// Generate Rust code
generator::rust::generate(&proto_files, Path::new("output/rust"))?;

// Generate Dart code
generator::dart::generate(&proto_files, Path::new("output/dart"))?;
```

### Data Models

#### `ProtoFile`

Represents a parsed proto file.

```rust
pub struct ProtoFile {
    pub package: String,
    pub services: Vec<ProtoService>,
    pub messages: HashMap<String, MessageType>,
}
```

#### `ProtoService`

Represents a service definition.

```rust
pub struct ProtoService {
    pub name: String,
    pub methods: Vec<ServiceMethod>,
    pub comments: Vec<String>,
}

impl ProtoService {
    pub fn snake_case_name(&self) -> String;
    pub fn camel_case_name(&self) -> String;
}
```

#### `ServiceMethod`

Represents an RPC method.

```rust
pub struct ServiceMethod {
    pub name: String,
    pub input_type: String,
    pub output_type: String,
    pub client_streaming: bool,
    pub server_streaming: bool,
    pub comments: Vec<String>,
}

impl ServiceMethod {
    pub fn is_unary(&self) -> bool;
    pub fn snake_case_name(&self) -> String;
    pub fn camel_case_name(&self) -> String;
    pub fn ffi_function_name(&self) -> String;
}
```

#### `MessageType`

Represents a protobuf message.

```rust
pub struct MessageType {
    pub name: String,
    pub fields: Vec<MessageField>,
    pub nested_messages: Vec<MessageType>,
}
```

## Generated Code API

### Rust Side

#### Service Trait

For each service in your proto file, a trait is generated:

```rust
// Generated from:
// service Greeter {
//   rpc SayHello(HelloRequest) returns (HelloResponse);
// }

pub trait Greeter {
    fn say_hello(&self, request: HelloRequest)
        -> Result<HelloResponse, Box<dyn std::error::Error>>;
}
```

**Usage:**

```rust
struct MyGreeter;

impl Greeter for MyGreeter {
    fn say_hello(&self, request: HelloRequest)
        -> Result<HelloResponse, Box<dyn std::error::Error>>
    {
        Ok(HelloResponse {
            message: format!("Hello, {}", request.name),
        })
    }
}
```

#### FFI Exports

FFI functions are automatically generated:

```rust
#[no_mangle]
pub unsafe extern "C" fn proto2ffi_say_hello(
    request_data: *const u8,
    request_len: usize
) -> ByteBuffer;
```

**Service Initialization:**

```rust
#[no_mangle]
pub unsafe extern "C" fn init_greeter(service: Box<dyn Greeter>);
```

You must call this before using the service:

```rust
#[no_mangle]
pub extern "C" fn init_service() {
    unsafe {
        init_greeter(Box::new(MyGreeter));
    }
}
```

#### ByteBuffer

Memory-safe byte passing structure:

```rust
#[repr(C)]
pub struct ByteBuffer {
    pub ptr: *mut u8,
    pub len: usize,
    pub cap: usize,
}

impl ByteBuffer {
    pub fn from_vec(vec: Vec<u8>) -> Self;
    pub fn into_vec(self) -> Vec<u8>;
}
```

**Memory Management:**

```rust
// Free a ByteBuffer
#[no_mangle]
pub unsafe extern "C" fn proto2ffi_free_byte_buffer(buf: ByteBuffer);
```

### Dart Side

#### Client Class

For each service, a client class is generated:

```dart
class GreeterClient {
  final ffi.DynamicLibrary _dylib;

  GreeterClient(this._dylib);

  List<int>? say_hello(List<int> requestBytes);
}
```

**Usage:**

```dart
// Load library
final dylib = ffi.DynamicLibrary.open('libgreeter.dylib');

// Initialize service (call Rust init function)
final initService = dylib.lookupFunction<
  ffi.Void Function(),
  void Function()
>('init_service');
initService();

// Create client
final client = GreeterClient(dylib);

// Make RPC call
final request = HelloRequest()..name = 'World';
final responseBytes = client.say_hello(request.writeToBuffer());

if (responseBytes != null) {
  final response = HelloResponse.fromBuffer(responseBytes);
  print(response.message);
}
```

#### ByteBuffer Structure

```dart
class ByteBuffer extends ffi.Struct {
  external ffi.Pointer<ffi.Uint8> ptr;
  @ffi.Size()
  external int len;
  @ffi.Size()
  external int cap;

  Uint8List toUint8List();
}
```

#### Memory Management

```dart
// Automatically managed by client methods
// Free function is called after extracting bytes
typedef FreeByteBufferFunc = ffi.Void Function(ByteBuffer);
```

## Runtime Libraries

### Rust Runtime

Located in `proto2ffi-runtime/rust/`

**ByteBuffer utilities:**

```rust
use proto2ffi_runtime::ByteBuffer;

// Create from Vec
let buf = ByteBuffer::from_vec(vec![1, 2, 3]);

// Convert to Vec
let vec = buf.into_vec();
```

### Dart Runtime

Located in `proto2ffi-runtime/dart/`

**FFI helpers:**

```dart
import 'package:proto2ffi_runtime/proto2ffi_runtime.dart';

// ByteBuffer conversion
final list = byteBuffer.toUint8List();
```

## Error Handling

### Rust Side

Return errors from service methods:

```rust
impl UserService for MyService {
    fn get_user(&self, req: GetUserRequest)
        -> Result<GetUserResponse, Box<dyn std::error::Error>>
    {
        if req.id == 0 {
            return Err("Invalid user ID".into());
        }

        let user = self.db.get_user(req.id)
            .ok_or("User not found")?;

        Ok(GetUserResponse { user: Some(user) })
    }
}
```

**Error Propagation:**

- Service method errors → FFI function returns null ByteBuffer
- Decode errors → FFI function returns null ByteBuffer
- Encode errors → FFI function returns null ByteBuffer

### Dart Side

Check for null responses:

```dart
final responseBytes = client.get_user(request.writeToBuffer());

if (responseBytes == null) {
  // Error occurred on Rust side
  print('Failed to get user');
  return;
}

final response = GetUserResponse.fromBuffer(responseBytes);
```

## Type Mapping

### Protobuf to Rust (via prost)

| Proto Type | Rust Type |
|------------|-----------|
| `double` | `f64` |
| `float` | `f32` |
| `int32` | `i32` |
| `int64` | `i64` |
| `uint32` | `u32` |
| `uint64` | `u64` |
| `sint32` | `i32` |
| `sint64` | `i64` |
| `fixed32` | `u32` |
| `fixed64` | `u64` |
| `sfixed32` | `i32` |
| `sfixed64` | `i64` |
| `bool` | `bool` |
| `string` | `String` |
| `bytes` | `Vec<u8>` |
| `repeated T` | `Vec<T>` |
| `map<K,V>` | `HashMap<K,V>` |
| `message` | `struct` |
| `enum` | `enum` (i32) |
| `oneof` | `enum` |

### Protobuf to Dart (via protobuf.dart)

| Proto Type | Dart Type |
|------------|-----------|
| `double` | `double` |
| `float` | `double` |
| `int32` | `int` |
| `int64` | `Int64` |
| `uint32` | `int` |
| `uint64` | `Int64` |
| `bool` | `bool` |
| `string` | `String` |
| `bytes` | `List<int>` |
| `repeated T` | `List<T>` |
| `map<K,V>` | `Map<K,V>` |
| `message` | `GeneratedMessage` |
| `enum` | `ProtobufEnum` |

## Advanced Features

### Multiple Services

Define multiple services in one proto file:

```protobuf
service UserService {
  rpc GetUser(GetUserRequest) returns (GetUserResponse);
  rpc CreateUser(CreateUserRequest) returns (CreateUserResponse);
}

service AuthService {
  rpc Login(LoginRequest) returns (LoginResponse);
  rpc Logout(LogoutRequest) returns (LogoutResponse);
}
```

Each service gets:
- Its own trait (`UserService`, `AuthService`)
- Its own FFI exports (`proto2ffi_get_user`, `proto2ffi_login`, etc.)
- Its own client class (`UserServiceClient`, `AuthServiceClient`)

### Complex Messages

All protobuf features are supported:

```protobuf
message ComplexMessage {
  // Nested messages
  message Address {
    string street = 1;
    string city = 2;
  }
  Address address = 1;

  // Repeated fields
  repeated string tags = 2;

  // Maps
  map<string, string> metadata = 3;

  // Enums
  enum Status {
    ACTIVE = 0;
    INACTIVE = 1;
  }
  Status status = 4;

  // Oneofs
  oneof payload {
    string text = 5;
    bytes binary = 6;
  }
}
```

### Service Inheritance

Services can extend other services:

```protobuf
service BaseService {
  rpc Health(HealthRequest) returns (HealthResponse);
}

service UserService extends BaseService {
  rpc GetUser(GetUserRequest) returns (GetUserResponse);
}
```

## Performance Considerations

### Buffer Pooling

Reuse buffers for better performance:

```rust
use std::sync::Mutex;

static BUFFER_POOL: Mutex<Vec<Vec<u8>>> = Mutex::new(Vec::new());

fn get_buffer() -> Vec<u8> {
    BUFFER_POOL.lock().unwrap().pop().unwrap_or_default()
}

fn return_buffer(mut buf: Vec<u8>) {
    buf.clear();
    BUFFER_POOL.lock().unwrap().push(buf);
}
```

### Batch Operations

Process multiple messages efficiently:

```rust
impl BatchService for MyService {
    fn process_batch(&self, requests: Vec<Request>)
        -> Result<Vec<Response>, Box<dyn std::error::Error>>
    {
        requests.into_iter()
            .map(|req| self.process_one(req))
            .collect()
    }
}
```

### Memory Limits

Set size limits for incoming messages:

```rust
const MAX_MESSAGE_SIZE: usize = 1024 * 1024; // 1MB

pub unsafe extern "C" fn proto2ffi_method(
    request_data: *const u8,
    request_len: usize
) -> ByteBuffer {
    if request_len > MAX_MESSAGE_SIZE {
        return ByteBuffer { ptr: std::ptr::null_mut(), len: 0, cap: 0 };
    }
    // ...
}
```

## Debugging

### Enable Logging

Rust side:

```rust
use log::{info, error};

fn say_hello(&self, request: HelloRequest)
    -> Result<HelloResponse, Box<dyn std::error::Error>>
{
    info!("Received request: {:?}", request);
    let response = /* ... */;
    info!("Sending response: {:?}", response);
    Ok(response)
}
```

Dart side:

```dart
final responseBytes = client.say_hello(request.writeToBuffer());
print('Request: $request');
print('Response bytes: ${responseBytes?.length ?? 0}');
```

### Memory Leaks

Check for leaked ByteBuffers:

```rust
static ALLOCATED_BUFFERS: AtomicUsize = AtomicUsize::new(0);

impl ByteBuffer {
    pub fn from_vec(vec: Vec<u8>) -> Self {
        ALLOCATED_BUFFERS.fetch_add(1, Ordering::Relaxed);
        // ...
    }
}

#[no_mangle]
pub unsafe extern "C" fn proto2ffi_free_byte_buffer(buf: ByteBuffer) {
    ALLOCATED_BUFFERS.fetch_sub(1, Ordering::Relaxed);
    // ...
}
```

## Testing

### Rust Tests

```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_service() {
        let service = MyGreeter;
        let request = HelloRequest { name: "Test".to_string() };
        let response = service.say_hello(request).unwrap();
        assert_eq!(response.message, "Hello, Test!");
    }

    #[test]
    fn test_ffi_export() {
        unsafe {
            init_greeter(Box::new(MyGreeter));

            let request = HelloRequest { name: "FFI".to_string() };
            let request_bytes = request.encode_to_vec();

            let response_buf = proto2ffi_say_hello(
                request_bytes.as_ptr(),
                request_bytes.len()
            );

            assert!(!response_buf.ptr.is_null());

            let response_bytes = response_buf.into_vec();
            let response = HelloResponse::decode(&response_bytes[..]).unwrap();
            assert_eq!(response.message, "Hello, FFI!");
        }
    }
}
```

### Dart Tests

```dart
import 'package:test/test.dart';

void main() {
  late GreeterClient client;

  setUpAll(() {
    final dylib = ffi.DynamicLibrary.open('libgreeter.dylib');
    final initService = dylib.lookupFunction<
      ffi.Void Function(),
      void Function()
    >('init_service');
    initService();
    client = GreeterClient(dylib);
  });

  test('say_hello returns correct response', () {
    final request = HelloRequest()..name = 'Test';
    final responseBytes = client.say_hello(request.writeToBuffer());

    expect(responseBytes, isNotNull);

    final response = HelloResponse.fromBuffer(responseBytes!);
    expect(response.message, equals('Hello, Test!'));
  });

  test('handles errors gracefully', () {
    final invalidBytes = [0xFF, 0xFF, 0xFF];
    final responseBytes = client.say_hello(invalidBytes);

    expect(responseBytes, isNull);
  });
}
```

## Versioning

Follow semantic versioning for your services:

```protobuf
// v1
package myservice.v1;

service UserService {
  rpc GetUser(GetUserRequest) returns (GetUserResponse);
}

// v2
package myservice.v2;

service UserService {
  rpc GetUser(GetUserRequest) returns (GetUserResponse);
  rpc ListUsers(ListUsersRequest) returns (ListUsersResponse);
}
```

Generate code for each version separately:

```bash
proto2ffi generate \
  --proto services/v1/user.proto \
  --rust-out backend/src/generated/v1 \
  --dart-out app/lib/generated/v1

proto2ffi generate \
  --proto services/v2/user.proto \
  --rust-out backend/src/generated/v2 \
  --dart-out app/lib/generated/v2
```
