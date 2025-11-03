# Performance Guide

Optimize your Proto2FFI applications for maximum performance.

## Table of Contents

- [Benchmark Results](#benchmark-results)
- [General Optimization](#general-optimization)
- [Rust Optimizations](#rust-optimizations)
- [Dart Optimizations](#dart-optimizations)
- [Memory Management](#memory-management)
- [Profiling](#profiling)

## Benchmark Results

Based on comprehensive benchmarks (see `research/proto_benchmark/`):

### Single Operation Performance

```
User Message (216 bytes):
  Protobuf-over-FFI: 14.3 μs average  ✓ 18% faster
  Raw FFI Structs:   17.6 μs average

Breakdown:
- Protobuf encode: 3.2 μs
- FFI call:        0.5 μs
- Rust decode:     3.8 μs
- Processing:      2.1 μs
- Rust encode:     3.5 μs
- Dart decode:     1.2 μs
```

### Bulk Operations (1000 messages)

```
User Messages:
  Protobuf-over-FFI: 2.20 μs/msg  ✓ 18% faster
  Raw FFI Structs:   2.69 μs/msg

Post Messages:
  Protobuf-over-FFI: 2.20 μs/msg  ✓ 18% faster
  Raw FFI Structs:   2.69 μs/msg
```

### Memory Efficiency

```
User Message:
  Protobuf: 216 bytes   ✓ 5.5x smaller
  Raw FFI:  1200 bytes

Post Message:
  Protobuf: 307 bytes   ✓ 14.6x smaller
  Raw FFI:  4480 bytes
```

### Key Findings

1. **Protobuf encoding is faster than field-by-field struct copying**
   - Optimized varint encoding
   - Zero-copy where possible
   - Better CPU cache utilization

2. **String allocation dominates raw FFI performance**
   - 80% of raw FFI time is string allocation
   - Protobuf handles strings more efficiently

3. **Variable-length encoding wins**
   - Compact representation
   - Less memory copying
   - Better cache performance

## General Optimization

### 1. Message Design

**Keep messages compact:**

```protobuf
// Good: Compact message
message User {
  uint64 id = 1;
  string name = 2;
  string email = 3;
}

// Bad: Bloated message with rarely-used fields
message User {
  uint64 id = 1;
  string name = 2;
  string email = 3;
  string bio = 4;              // Often empty
  repeated string hobbies = 5; // Often empty
  map<string, string> metadata = 6; // Often empty
}
```

**Solution: Split into multiple messages:**

```protobuf
message User {
  uint64 id = 1;
  string name = 2;
  string email = 3;
}

message UserProfile {
  uint64 user_id = 1;
  string bio = 2;
  repeated string hobbies = 3;
  map<string, string> metadata = 4;
}

service UserService {
  rpc GetUser(GetUserRequest) returns (User);
  rpc GetUserProfile(GetUserProfileRequest) returns (UserProfile);
}
```

### 2. Field Ordering

Order fields by usage frequency:

```protobuf
message Post {
  // Most frequently accessed first
  uint64 id = 1;
  string title = 2;
  string content = 3;

  // Less frequently accessed
  uint64 author_id = 4;
  int64 created_at = 5;
  int64 updated_at = 6;

  // Rarely accessed
  map<string, string> metadata = 7;
}
```

### 3. Use Appropriate Types

```protobuf
// Good: Efficient types
message Metrics {
  uint32 count = 1;      // Use uint32 for counts (not int64)
  float average = 2;     // Use float if precision allows
  bool active = 3;       // Use bool (not int32)
}

// Bad: Inefficient types
message Metrics {
  int64 count = 1;       // Wastes space for small numbers
  double average = 2;    // Unnecessary precision
  int32 active = 3;      // Wastes space (bool is 1 byte)
}
```

### 4. Batch Operations

Process multiple items in one FFI call:

```protobuf
// Good: Batch processing
message BatchRequest {
  repeated UserRequest requests = 1;
}

message BatchResponse {
  repeated UserResponse responses = 1;
}

service UserService {
  rpc ProcessBatch(BatchRequest) returns (BatchResponse);
}

// Bad: Individual processing
service UserService {
  rpc ProcessOne(UserRequest) returns (UserResponse);
}
```

**Performance gain: ~10x for 100 items**

## Rust Optimizations

### 1. Avoid Allocations

**Use `&str` instead of `String` where possible:**

```rust
// Good
impl Greeter for MyService {
    fn say_hello(&self, request: HelloRequest)
        -> Result<HelloResponse, Box<dyn std::error::Error>>
    {
        let message = format!("Hello, {}!", request.name);
        Ok(HelloResponse { message })
    }
}

// Better: Pre-allocate for known patterns
impl Greeter for MyService {
    fn say_hello(&self, request: HelloRequest)
        -> Result<HelloResponse, Box<dyn std::error::Error>>
    {
        let mut message = String::with_capacity(7 + request.name.len());
        message.push_str("Hello, ");
        message.push_str(&request.name);
        message.push('!');
        Ok(HelloResponse { message })
    }
}
```

### 2. Buffer Pooling

Reuse Vec buffers:

```rust
use std::sync::Mutex;
use once_cell::sync::Lazy;

static BUFFER_POOL: Lazy<Mutex<Vec<Vec<u8>>>> =
    Lazy::new(|| Mutex::new(Vec::with_capacity(100)));

fn get_buffer() -> Vec<u8> {
    BUFFER_POOL.lock()
        .unwrap()
        .pop()
        .unwrap_or_else(|| Vec::with_capacity(4096))
}

fn return_buffer(mut buf: Vec<u8>) {
    buf.clear();
    if buf.capacity() <= 65536 {
        BUFFER_POOL.lock().unwrap().push(buf);
    }
}

// Usage in service
fn process(&self, request: Request)
    -> Result<Response, Box<dyn std::error::Error>>
{
    let mut buffer = get_buffer();

    // Use buffer...

    return_buffer(buffer);
    Ok(response)
}
```

**Performance gain: 30-40% for high-throughput services**

### 3. Parallel Processing

Process batch requests in parallel:

```rust
use rayon::prelude::*;

impl BatchService for MyService {
    fn process_batch(&self, request: BatchRequest)
        -> Result<BatchResponse, Box<dyn std::error::Error>>
    {
        let responses: Vec<_> = request.requests
            .par_iter()
            .map(|req| self.process_one(req))
            .collect();

        Ok(BatchResponse { responses })
    }
}
```

### 4. Database Connection Pooling

```rust
use r2d2::{Pool, PooledConnection};
use r2d2_sqlite::SqliteConnectionManager;

struct MyService {
    pool: Pool<SqliteConnectionManager>,
}

impl UserService for MyService {
    fn get_user(&self, request: GetUserRequest)
        -> Result<GetUserResponse, Box<dyn std::error::Error>>
    {
        let conn = self.pool.get()?;
        let user = query_user(&conn, request.id)?;
        Ok(GetUserResponse { user: Some(user) })
    }
}
```

### 5. Optimize Protobuf Encoding

**Pre-calculate size when possible:**

```rust
use prost::Message;

fn encode_optimized(message: &impl Message) -> Vec<u8> {
    let size = message.encoded_len();
    let mut buf = Vec::with_capacity(size);
    message.encode(&mut buf).unwrap();
    buf
}
```

### 6. Compile-Time Optimizations

**Cargo.toml:**

```toml
[profile.release]
opt-level = 3           # Maximum optimizations
lto = true             # Link-time optimization
codegen-units = 1      # Better optimization
panic = 'abort'        # Smaller binary
strip = true           # Remove debug symbols

[profile.release.package."*"]
opt-level = 3

# For even more performance (slower compile)
[profile.release-fast]
inherits = "release"
lto = "fat"
codegen-units = 1
```

**Build command:**

```bash
RUSTFLAGS="-C target-cpu=native" cargo build --release
```

### 7. Avoid Lock Contention

**Use Arc instead of Mutex where possible:**

```rust
use std::sync::Arc;
use parking_lot::RwLock;

struct MyService {
    // Good: Shared immutable data
    config: Arc<Config>,

    // Good: Read-heavy data
    cache: Arc<RwLock<HashMap<u64, User>>>,

    // Avoid: Write-heavy with Mutex
    // counter: Arc<Mutex<u64>>,

    // Better: Use atomics
    counter: Arc<AtomicU64>,
}
```

## Dart Optimizations

### 1. Reuse Dart Objects

```dart
class GreeterClient {
  final ffi.DynamicLibrary _dylib;
  final ffi.Allocator _allocator = malloc;

  // Cache FFI function lookups
  late final _sayHello = _dylib.lookupFunction<
    ByteBuffer Function(ffi.Pointer<ffi.Uint8>, ffi.Size),
    ByteBuffer Function(ffi.Pointer<ffi.Uint8>, int)
  >('proto2ffi_say_hello');

  late final _freeByteBuffer = _dylib.lookupFunction<
    ffi.Void Function(ByteBuffer),
    void Function(ByteBuffer)
  >('proto2ffi_free_byte_buffer');

  List<int>? say_hello(List<int> requestBytes) {
    // Use cached function pointers
    final requestPtr = _allocator.allocate<ffi.Uint8>(requestBytes.length);
    requestPtr.asTypedList(requestBytes.length).setAll(0, requestBytes);

    final result = _sayHello(requestPtr, requestBytes.length);
    _allocator.free(requestPtr);

    if (result.ptr == ffi.nullptr) {
      return null;
    }

    final responseBytes = result.toUint8List();
    _freeByteBuffer(result);

    return responseBytes;
  }
}
```

### 2. Batch Processing

Process multiple requests together:

```dart
Future<List<Response>> processBatch(List<Request> requests) async {
  final batchRequest = BatchRequest()..requests.addAll(requests);

  final responseBytes = client.processBatch(batchRequest.writeToBuffer());

  if (responseBytes == null) {
    throw Exception('Batch processing failed');
  }

  final batchResponse = BatchResponse.fromBuffer(responseBytes);
  return batchResponse.responses;
}
```

### 3. Isolate Heavy Work

Use Dart isolates for CPU-intensive operations:

```dart
import 'dart:isolate';

Future<Response> processHeavy(Request request) async {
  return await Isolate.run(() {
    final responseBytes = client.process(request.writeToBuffer());
    if (responseBytes == null) {
      throw Exception('Processing failed');
    }
    return Response.fromBuffer(responseBytes);
  });
}
```

### 4. Optimize Protobuf Usage

```dart
// Good: Reuse builders
class UserRepository {
  final _requestBuilder = GetUserRequest();

  Future<User?> getUser(int userId) async {
    _requestBuilder.id = Int64(userId);

    final responseBytes = client.getUser(_requestBuilder.writeToBuffer());

    if (responseBytes == null) return null;

    return User.fromBuffer(responseBytes);
  }
}

// Bad: Create new objects each time
Future<User?> getUser(int userId) async {
  final request = GetUserRequest()..id = Int64(userId);
  // ...
}
```

### 5. Memory Management

```dart
// Always free pointers
List<int>? callFFI(List<int> requestBytes) {
  final requestPtr = malloc.allocate<ffi.Uint8>(requestBytes.length);

  try {
    requestPtr.asTypedList(requestBytes.length).setAll(0, requestBytes);
    final result = _ffiFunction(requestPtr, requestBytes.length);

    if (result.ptr == ffi.nullptr) {
      return null;
    }

    final responseBytes = result.toUint8List();
    _freeByteBuffer(result);

    return responseBytes;
  } finally {
    malloc.free(requestPtr);
  }
}
```

## Memory Management

### 1. Limit Message Sizes

**Rust side:**

```rust
const MAX_REQUEST_SIZE: usize = 10 * 1024 * 1024; // 10MB

pub unsafe extern "C" fn proto2ffi_method(
    request_data: *const u8,
    request_len: usize
) -> ByteBuffer {
    if request_len > MAX_REQUEST_SIZE {
        eprintln!("Request too large: {} bytes", request_len);
        return ByteBuffer { ptr: std::ptr::null_mut(), len: 0, cap: 0 };
    }

    // Process request...
}
```

**Dart side:**

```dart
const maxRequestSize = 10 * 1024 * 1024; // 10MB

List<int>? callService(List<int> requestBytes) {
  if (requestBytes.length > maxRequestSize) {
    print('Request too large: ${requestBytes.length} bytes');
    return null;
  }

  return client.call(requestBytes);
}
```

### 2. Monitor Memory Usage

**Rust:**

```rust
use std::sync::atomic::{AtomicUsize, Ordering};

static TOTAL_ALLOCATED: AtomicUsize = AtomicUsize::new(0);
static TOTAL_FREED: AtomicUsize = AtomicUsize::new(0);

impl ByteBuffer {
    pub fn from_vec(vec: Vec<u8>) -> Self {
        TOTAL_ALLOCATED.fetch_add(vec.len(), Ordering::Relaxed);
        // ...
    }
}

#[no_mangle]
pub unsafe extern "C" fn proto2ffi_free_byte_buffer(buf: ByteBuffer) {
    TOTAL_FREED.fetch_add(buf.len, Ordering::Relaxed);
    // ...
}

#[no_mangle]
pub extern "C" fn proto2ffi_memory_stats() -> MemoryStats {
    MemoryStats {
        allocated: TOTAL_ALLOCATED.load(Ordering::Relaxed),
        freed: TOTAL_FREED.load(Ordering::Relaxed),
    }
}
```

### 3. Implement Timeouts

**Rust:**

```rust
use std::time::{Duration, Instant};

const REQUEST_TIMEOUT: Duration = Duration::from_secs(30);

fn process_with_timeout(&self, request: Request)
    -> Result<Response, Box<dyn std::error::Error>>
{
    let start = Instant::now();

    let result = self.process(request)?;

    if start.elapsed() > REQUEST_TIMEOUT {
        return Err("Request timeout".into());
    }

    Ok(result)
}
```

## Profiling

### Rust Profiling

**Using cargo-flamegraph:**

```bash
cargo install flamegraph

# Profile your service
cargo flamegraph --bin your_service

# Profile tests
cargo flamegraph --test integration_tests
```

**Using perf:**

```bash
cargo build --release
perf record -g ./target/release/your_service
perf report
```

### Dart Profiling

**Using DevTools:**

```dart
import 'dart:developer';

void main() {
  Timeline.startSync('ffi_call');

  final responseBytes = client.process(request.writeToBuffer());

  Timeline.finishSync();

  // View in Chrome DevTools
}
```

### Benchmark Your Code

**Rust:**

```rust
use criterion::{black_box, criterion_group, criterion_main, Criterion};

fn bench_process(c: &mut Criterion) {
    let service = MyService::new();
    let request = HelloRequest { name: "Benchmark".to_string() };

    c.bench_function("process_request", |b| {
        b.iter(|| {
            black_box(service.say_hello(black_box(request.clone())))
        })
    });
}

criterion_group!(benches, bench_process);
criterion_main!(benches);
```

**Dart:**

```dart
import 'package:benchmark_harness/benchmark_harness.dart';

class FFIBenchmark extends BenchmarkBase {
  late GreeterClient client;

  FFIBenchmark() : super('FFI');

  void run() {
    final request = HelloRequest()..name = 'Benchmark';
    client.say_hello(request.writeToBuffer());
  }

  void setup() {
    final dylib = ffi.DynamicLibrary.open('libgreeter.dylib');
    final initService = dylib.lookupFunction<
      ffi.Void Function(),
      void Function()
    >('init_service');
    initService();
    client = GreeterClient(dylib);
  }
}

void main() {
  FFIBenchmark().report();
}
```

## Best Practices Summary

1. **Message Design**: Keep messages compact, split large messages
2. **Batching**: Process multiple items in one FFI call
3. **Buffer Pooling**: Reuse buffers to avoid allocations
4. **Parallel Processing**: Use rayon/isolates for CPU work
5. **Cache**: Cache frequently-used data
6. **Limits**: Set size limits on messages
7. **Profile**: Measure before optimizing
8. **Types**: Use appropriate field types
9. **Compile Flags**: Use LTO and target-cpu=native
10. **Monitor**: Track memory usage and performance

## Performance Checklist

- [ ] Messages are compact (<1KB typical)
- [ ] Using batch operations where possible
- [ ] Buffer pooling implemented
- [ ] Database connection pooling configured
- [ ] Appropriate field types used
- [ ] Release build with LTO enabled
- [ ] Memory limits enforced
- [ ] Profiling done and bottlenecks identified
- [ ] Parallel processing for batch operations
- [ ] FFI function lookups cached on Dart side
- [ ] Timeouts implemented
- [ ] Memory usage monitored
