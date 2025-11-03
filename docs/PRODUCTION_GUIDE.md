# Production Deployment Guide

Best practices for deploying Proto2FFI services in production.

## Table of Contents

- [Security](#security)
- [Error Handling](#error-handling)
- [Logging](#logging)
- [Testing](#testing)
- [Build & Deployment](#build--deployment)
- [Monitoring](#monitoring)
- [Platform-Specific](#platform-specific)

## Security

### 1. Input Validation

**Always validate inputs on Rust side:**

```rust
impl UserService for MyService {
    fn get_user(&self, request: GetUserRequest)
        -> Result<GetUserResponse, Box<dyn std::error::Error>>
    {
        // Validate ID
        if request.id == 0 {
            return Err("Invalid user ID".into());
        }

        // Validate ID range
        if request.id > u32::MAX as u64 {
            return Err("User ID out of range".into());
        }

        // Process...
        Ok(response)
    }
}
```

### 2. Message Size Limits

Prevent DoS attacks with size limits:

```rust
const MAX_REQUEST_SIZE: usize = 10 * 1024 * 1024; // 10MB
const MAX_RESPONSE_SIZE: usize = 50 * 1024 * 1024; // 50MB

pub unsafe extern "C" fn proto2ffi_method(
    request_data: *const u8,
    request_len: usize
) -> ByteBuffer {
    if request_len == 0 || request_len > MAX_REQUEST_SIZE {
        return ByteBuffer::null();
    }

    // Process...

    if response_bytes.len() > MAX_RESPONSE_SIZE {
        eprintln!("Response too large: {} bytes", response_bytes.len());
        return ByteBuffer::null();
    }

    ByteBuffer::from_vec(response_bytes)
}
```

### 3. Rate Limiting

Implement per-client rate limiting:

```rust
use std::sync::Arc;
use parking_lot::RwLock;
use std::time::{Duration, Instant};
use std::collections::HashMap;

struct RateLimiter {
    requests: Arc<RwLock<HashMap<String, (u32, Instant)>>>,
    max_requests: u32,
    window: Duration,
}

impl RateLimiter {
    pub fn check(&self, client_id: &str) -> bool {
        let mut requests = self.requests.write();
        let now = Instant::now();

        let (count, start) = requests
            .entry(client_id.to_string())
            .or_insert((0, now));

        if now.duration_since(*start) > self.window {
            *count = 1;
            *start = now;
            true
        } else if *count < self.max_requests {
            *count += 1;
            true
        } else {
            false
        }
    }
}

struct MyService {
    rate_limiter: Arc<RateLimiter>,
}

impl UserService for MyService {
    fn get_user(&self, request: GetUserRequest)
        -> Result<GetUserResponse, Box<dyn std::error::Error>>
    {
        let client_id = request.client_id;

        if !self.rate_limiter.check(&client_id) {
            return Err("Rate limit exceeded".into());
        }

        // Process...
    }
}
```

### 4. Sanitize Error Messages

Don't leak sensitive information:

```rust
impl UserService for MyService {
    fn get_user(&self, request: GetUserRequest)
        -> Result<GetUserResponse, Box<dyn std::error::Error>>
    {
        match self.db.get_user(request.id) {
            Ok(user) => Ok(GetUserResponse { user: Some(user) }),
            Err(e) => {
                // Log detailed error internally
                error!("Database error for user {}: {}", request.id, e);

                // Return generic error to client
                Err("Failed to retrieve user".into())
            }
        }
    }
}
```

### 5. Secure Defaults

```rust
// Default deny
const DEFAULT_ALLOW_ANONYMOUS: bool = false;

// Constant-time comparison for secrets
use subtle::ConstantTimeEq;

fn verify_token(token: &[u8], expected: &[u8]) -> bool {
    token.ct_eq(expected).into()
}
```

## Error Handling

### 1. Structured Errors

Define clear error types:

```rust
use thiserror::Error;

#[derive(Error, Debug)]
pub enum ServiceError {
    #[error("Invalid input: {0}")]
    InvalidInput(String),

    #[error("Not found: {0}")]
    NotFound(String),

    #[error("Database error")]
    Database(#[from] DatabaseError),

    #[error("Internal error")]
    Internal,
}

impl UserService for MyService {
    fn get_user(&self, request: GetUserRequest)
        -> Result<GetUserResponse, Box<dyn std::error::Error>>
    {
        if request.id == 0 {
            return Err(Box::new(ServiceError::InvalidInput(
                "User ID cannot be 0".to_string()
            )));
        }

        let user = self.db.get_user(request.id)
            .map_err(|e| ServiceError::Database(e))?;

        if user.is_none() {
            return Err(Box::new(ServiceError::NotFound(
                format!("User {} not found", request.id)
            )));
        }

        Ok(GetUserResponse { user })
    }
}
```

### 2. Error Codes in Proto

Define error codes in your proto:

```protobuf
message Response {
  oneof result {
    SuccessResponse success = 1;
    ErrorResponse error = 2;
  }
}

message ErrorResponse {
  ErrorCode code = 1;
  string message = 2;
}

enum ErrorCode {
  UNKNOWN = 0;
  INVALID_INPUT = 1;
  NOT_FOUND = 2;
  UNAUTHORIZED = 3;
  RATE_LIMITED = 4;
  INTERNAL_ERROR = 5;
}
```

**Implementation:**

```rust
fn get_user(&self, request: GetUserRequest)
    -> Result<GetUserResponse, Box<dyn std::error::Error>>
{
    let response = match self.get_user_internal(request) {
        Ok(user) => Response {
            result: Some(response::Result::Success(SuccessResponse {
                user: Some(user),
            })),
        },
        Err(ServiceError::InvalidInput(msg)) => Response {
            result: Some(response::Result::Error(ErrorResponse {
                code: ErrorCode::InvalidInput as i32,
                message: msg,
            })),
        },
        Err(ServiceError::NotFound(msg)) => Response {
            result: Some(response::Result::Error(ErrorResponse {
                code: ErrorCode::NotFound as i32,
                message: msg,
            })),
        },
        Err(_) => Response {
            result: Some(response::Result::Error(ErrorResponse {
                code: ErrorCode::InternalError as i32,
                message: "Internal error".to_string(),
            })),
        },
    };

    Ok(GetUserResponse { response: Some(response) })
}
```

### 3. Panic Handling

Catch panics at FFI boundary:

```rust
use std::panic;

pub unsafe extern "C" fn proto2ffi_method(
    request_data: *const u8,
    request_len: usize
) -> ByteBuffer {
    let result = panic::catch_unwind(|| {
        // Process request...
        process_request_internal(request_data, request_len)
    });

    match result {
        Ok(buf) => buf,
        Err(e) => {
            error!("Panic in FFI call: {:?}", e);
            ByteBuffer::null()
        }
    }
}
```

## Logging

### 1. Structured Logging

Use `tracing` for structured logs:

```rust
use tracing::{info, warn, error, instrument};

#[instrument(skip(self))]
impl UserService for MyService {
    fn get_user(&self, request: GetUserRequest)
        -> Result<GetUserResponse, Box<dyn std::error::Error>>
    {
        info!(user_id = request.id, "Getting user");

        match self.db.get_user(request.id) {
            Ok(Some(user)) => {
                info!(user_id = request.id, "User found");
                Ok(GetUserResponse { user: Some(user) })
            }
            Ok(None) => {
                warn!(user_id = request.id, "User not found");
                Err("User not found".into())
            }
            Err(e) => {
                error!(user_id = request.id, error = %e, "Database error");
                Err("Internal error".into())
            }
        }
    }
}
```

### 2. Log Initialization

**Rust:**

```rust
use tracing_subscriber::{layer::SubscriberExt, util::SubscriberInitExt};

#[no_mangle]
pub extern "C" fn init_logging() {
    tracing_subscriber::registry()
        .with(tracing_subscriber::fmt::layer())
        .with(tracing_subscriber::EnvFilter::from_default_env())
        .init();
}
```

**Dart:**

```dart
void initService() {
  final dylib = ffi.DynamicLibrary.open('libservice.dylib');

  // Initialize logging
  final initLogging = dylib.lookupFunction<
    ffi.Void Function(),
    void Function()
  >('init_logging');
  initLogging();

  // Initialize service
  final initService = dylib.lookupFunction<
    ffi.Void Function(),
    void Function()
  >('init_service');
  initService();
}
```

### 3. Log Levels

```bash
# Development
RUST_LOG=debug cargo run

# Production
RUST_LOG=info,my_service=debug cargo run --release
```

## Testing

### 1. Unit Tests

```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_get_user_success() {
        let service = MyService::new_test();
        let request = GetUserRequest { id: 1 };

        let response = service.get_user(request).unwrap();

        assert!(response.user.is_some());
        assert_eq!(response.user.unwrap().id, 1);
    }

    #[test]
    fn test_get_user_not_found() {
        let service = MyService::new_test();
        let request = GetUserRequest { id: 999 };

        let result = service.get_user(request);

        assert!(result.is_err());
    }

    #[test]
    fn test_get_user_invalid_id() {
        let service = MyService::new_test();
        let request = GetUserRequest { id: 0 };

        let result = service.get_user(request);

        assert!(result.is_err());
    }
}
```

### 2. Integration Tests

```rust
#[cfg(test)]
mod integration_tests {
    use super::*;

    #[test]
    fn test_ffi_roundtrip() {
        unsafe {
            init_user_service(Box::new(MyService::new_test()));

            let request = GetUserRequest { id: 1 };
            let request_bytes = request.encode_to_vec();

            let response_buf = proto2ffi_get_user(
                request_bytes.as_ptr(),
                request_bytes.len()
            );

            assert!(!response_buf.ptr.is_null());

            let response_bytes = response_buf.into_vec();
            let response = GetUserResponse::decode(&response_bytes[..]).unwrap();

            assert!(response.user.is_some());
            assert_eq!(response.user.unwrap().id, 1);
        }
    }
}
```

### 3. Dart Tests

```dart
import 'package:test/test.dart';

void main() {
  late UserServiceClient client;

  setUpAll(() {
    final dylib = ffi.DynamicLibrary.open('libservice.dylib');
    final initService = dylib.lookupFunction<
      ffi.Void Function(),
      void Function()
    >('init_service');
    initService();
    client = UserServiceClient(dylib);
  });

  group('UserService', () {
    test('get_user returns user when found', () {
      final request = GetUserRequest()..id = Int64(1);
      final responseBytes = client.get_user(request.writeToBuffer());

      expect(responseBytes, isNotNull);

      final response = GetUserResponse.fromBuffer(responseBytes!);
      expect(response.hasUser(), isTrue);
      expect(response.user.id, equals(Int64(1)));
    });

    test('get_user returns null when not found', () {
      final request = GetUserRequest()..id = Int64(999);
      final responseBytes = client.get_user(request.writeToBuffer());

      expect(responseBytes, isNull);
    });

    test('get_user handles invalid input', () {
      final request = GetUserRequest()..id = Int64(0);
      final responseBytes = client.get_user(request.writeToBuffer());

      expect(responseBytes, isNull);
    });
  });
}
```

### 4. Property-Based Testing

```rust
use proptest::prelude::*;

proptest! {
    #[test]
    fn test_user_id_validation(id in 1u64..=u32::MAX as u64) {
        let service = MyService::new_test();
        let request = GetUserRequest { id };

        // Should not panic
        let _ = service.get_user(request);
    }

    #[test]
    fn test_name_validation(name in "\\PC{1,100}") {
        let service = MyService::new_test();
        let request = CreateUserRequest { name };

        // Should handle any valid UTF-8 string
        let _ = service.create_user(request);
    }
}
```

## Build & Deployment

### 1. Build Script

```bash
#!/bin/bash
set -e

echo "Building Rust service..."
cd rust_service

# Clean build
cargo clean

# Build release with optimizations
RUSTFLAGS="-C target-cpu=native" \
  cargo build --release

# Strip symbols
strip target/release/libservice.dylib

# Copy to deployment location
cp target/release/libservice.dylib ../deploy/

echo "Building Dart client..."
cd ../dart_client

# Get dependencies
dart pub get

# Generate protobuf code
protoc --dart_out=lib/proto \
  -I ../proto \
  ../proto/*.proto

# Build
dart compile exe lib/main.dart -o ../deploy/client

echo "Build complete!"
```

### 2. Docker Deployment

**Dockerfile:**

```dockerfile
FROM rust:1.70 AS rust-builder

WORKDIR /app
COPY rust_service/ .

RUN cargo build --release && \
    strip target/release/libservice.so

FROM dart:3.0 AS dart-builder

WORKDIR /app
COPY dart_client/ .

RUN dart pub get && \
    dart compile exe lib/main.dart -o client

FROM debian:bookworm-slim

RUN apt-get update && \
    apt-get install -y ca-certificates && \
    rm -rf /var/lib/apt/lists/*

COPY --from=rust-builder /app/target/release/libservice.so /usr/lib/
COPY --from=dart-builder /app/client /usr/local/bin/

CMD ["/usr/local/bin/client"]
```

### 3. CI/CD Pipeline

**GitHub Actions:**

```yaml
name: CI/CD

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Install Rust
        uses: actions-rs/toolchain@v1
        with:
          profile: minimal
          toolchain: stable

      - name: Install Dart
        uses: dart-lang/setup-dart@v1

      - name: Run Rust tests
        run: |
          cd rust_service
          cargo test --release

      - name: Run Dart tests
        run: |
          cd dart_client
          dart pub get
          dart test

      - name: Build
        run: ./build.sh

      - name: Upload artifacts
        uses: actions/upload-artifact@v3
        with:
          name: binaries
          path: deploy/

  deploy:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - name: Download artifacts
        uses: actions/download-artifact@v3

      - name: Deploy to production
        run: |
          # Your deployment script
          ./deploy.sh
```

## Monitoring

### 1. Metrics Collection

```rust
use std::sync::atomic::{AtomicU64, Ordering};

static REQUEST_COUNT: AtomicU64 = AtomicU64::new(0);
static ERROR_COUNT: AtomicU64 = AtomicU64::new(0);
static TOTAL_LATENCY_US: AtomicU64 = AtomicU64::new(0);

impl UserService for MyService {
    fn get_user(&self, request: GetUserRequest)
        -> Result<GetUserResponse, Box<dyn std::error::Error>>
    {
        let start = Instant::now();
        REQUEST_COUNT.fetch_add(1, Ordering::Relaxed);

        let result = self.get_user_internal(request);

        let latency = start.elapsed().as_micros() as u64;
        TOTAL_LATENCY_US.fetch_add(latency, Ordering::Relaxed);

        if result.is_err() {
            ERROR_COUNT.fetch_add(1, Ordering::Relaxed);
        }

        result
    }
}

#[repr(C)]
pub struct ServiceMetrics {
    pub request_count: u64,
    pub error_count: u64,
    pub avg_latency_us: u64,
}

#[no_mangle]
pub extern "C" fn proto2ffi_get_metrics() -> ServiceMetrics {
    let count = REQUEST_COUNT.load(Ordering::Relaxed);
    let errors = ERROR_COUNT.load(Ordering::Relaxed);
    let total_latency = TOTAL_LATENCY_US.load(Ordering::Relaxed);

    ServiceMetrics {
        request_count: count,
        error_count: errors,
        avg_latency_us: if count > 0 { total_latency / count } else { 0 },
    }
}
```

### 2. Health Checks

```rust
#[repr(C)]
pub struct HealthStatus {
    pub healthy: bool,
    pub uptime_seconds: u64,
}

static START_TIME: once_cell::sync::Lazy<Instant> =
    once_cell::sync::Lazy::new(|| Instant::now());

#[no_mangle]
pub extern "C" fn proto2ffi_health_check() -> HealthStatus {
    let uptime = START_TIME.elapsed().as_secs();

    HealthStatus {
        healthy: true,
        uptime_seconds: uptime,
    }
}
```

### 3. Dart Monitoring

```dart
class MetricsCollector {
  int _requestCount = 0;
  int _errorCount = 0;
  final _latencies = <Duration>[];

  Future<T> track<T>(Future<T> Function() operation) async {
    _requestCount++;
    final start = DateTime.now();

    try {
      final result = await operation();
      final latency = DateTime.now().difference(start);
      _latencies.add(latency);
      return result;
    } catch (e) {
      _errorCount++;
      rethrow;
    }
  }

  Map<String, dynamic> getMetrics() {
    final avgLatency = _latencies.isEmpty
        ? Duration.zero
        : _latencies.reduce((a, b) => a + b) ~/ _latencies.length;

    return {
      'request_count': _requestCount,
      'error_count': _errorCount,
      'error_rate': _requestCount > 0 ? _errorCount / _requestCount : 0.0,
      'avg_latency_ms': avgLatency.inMilliseconds,
    };
  }
}
```

## Platform-Specific

### macOS

```bash
# Build universal binary
cargo build --release --target x86_64-apple-darwin
cargo build --release --target aarch64-apple-darwin

lipo -create \
  target/x86_64-apple-darwin/release/libservice.dylib \
  target/aarch64-apple-darwin/release/libservice.dylib \
  -output libservice.dylib
```

### Linux

```bash
# Build for Linux
cargo build --release

# Check dependencies
ldd target/release/libservice.so

# Set RPATH
patchelf --set-rpath '$ORIGIN' target/release/libservice.so
```

### Windows

```bash
# Build for Windows
cargo build --release --target x86_64-pc-windows-msvc

# Output: service.dll
```

### iOS

```bash
# Install targets
rustup target add aarch64-apple-ios
rustup target add x86_64-apple-ios

# Build
cargo build --release --target aarch64-apple-ios

# Create framework
# (Additional steps for iOS framework creation)
```

### Android

```bash
# Install targets
rustup target add aarch64-linux-android
rustup target add armv7-linux-androideabi
rustup target add x86_64-linux-android

# Build
cargo ndk build --release

# Output: .so files in target/
```

## Production Checklist

- [ ] Input validation implemented
- [ ] Rate limiting configured
- [ ] Message size limits enforced
- [ ] Error handling with proper codes
- [ ] Panic handling at FFI boundary
- [ ] Structured logging enabled
- [ ] Unit tests passing
- [ ] Integration tests passing
- [ ] Build optimizations enabled (LTO, strip)
- [ ] CI/CD pipeline configured
- [ ] Metrics collection implemented
- [ ] Health checks implemented
- [ ] Documentation complete
- [ ] Security audit completed
- [ ] Load testing completed
- [ ] Monitoring dashboards created
