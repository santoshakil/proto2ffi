# Concurrent Memory Pool Tests

This example contains comprehensive concurrent access tests for the Proto2FFI memory pool implementation. It is designed to expose thread-safety issues and verify proper synchronization.

## Structure

```
07_concurrent_pools/
├── proto/
│   └── concurrent.proto      # Proto definitions with different pool sizes
├── rust/
│   ├── Cargo.toml            # Rust dependencies
│   ├── build.rs              # Build configuration with pool allocators
│   └── src/
│       └── lib.rs            # Multi-threaded pool tests
├── lib/
│   └── bindings.dart         # FFI bindings
├── test/
│   └── concurrent_test.dart  # Dart isolate tests
└── pubspec.yaml              # Dart dependencies
```

## Pool Configurations

- **SmallMessage**: Pool size 100
- **MediumMessage**: Pool size 1000
- **LargeMessage**: Pool size 10000
- **StressTestMessage**: Pool size 5000

## Test Coverage

### Rust Tests (Native Threads)

1. **Basic Concurrent Tests**
   - Small pool: 4 threads × 100 operations
   - Medium pool: 4 threads × 100 operations
   - Large pool: 4 threads × 50 operations

2. **Stress Tests**
   - 10 threads, 1000ms duration
   - 20 threads, 1000ms duration
   - 50 threads, 2000ms duration (extreme)

3. **Pool Integrity Tests**
   - Pool exhaustion handling
   - Free list integrity (1000 iterations)
   - Mixed operations (8 threads, 500 ops)

4. **Performance Tests**
   - Contention measurement (shared vs isolated pools)

### Dart Tests (Isolates)

1. **Isolate Concurrent Access**
   - 4 isolates × small pool
   - 4 isolates × medium pool
   - 4 isolates × large pool
   - 8 isolates × stress test

2. **Rapid Allocation/Deallocation**
   - Sequential rapid operations
   - Burst tests with multiple cycles

3. **Memory Corruption Detection**
   - Integrity verification after heavy load
   - Integrity after mixed operations
   - Integrity after pool exhaustion

4. **Pool Statistics Under Load**
   - Performance comparison across pool sizes
   - Scalability test (1-32 threads)
   - Throughput measurement (ops/sec)

## Running the Tests

### Build Rust Library

```bash
cd examples/07_concurrent_pools/rust
cargo build --release
cargo test
```

### Run Dart Tests

```bash
cd examples/07_concurrent_pools
dart pub get
dart test
```

## Expected Issues

The current implementation has `Send` but not `Sync`, which means:

1. **Data Races**: Multiple threads accessing the same pool allocator
2. **Free List Corruption**: Concurrent modifications to the free list
3. **Use-After-Free**: Potential double-free issues
4. **Memory Leaks**: Lost pool entries during concurrent access

## Thread Safety Requirements

To fix the issues, the pool allocator needs:

1. **Mutex Protection**: Wrap pool state in `Mutex<T>` or `RwLock<T>`
2. **Atomic Operations**: Use atomics for counters and flags
3. **Sync Implementation**: Properly implement `Sync` trait
4. **Lock-Free Design**: Consider lock-free data structures for better performance

## Performance Metrics

The tests measure:

- **Latency**: Time per operation (ms)
- **Throughput**: Operations per second
- **Contention**: Shared vs isolated pool performance
- **Scalability**: Performance with increasing thread count
- **Integrity**: Free list correctness after operations

## Notes

- Tests intentionally stress the system to expose bugs
- Some tests may fail or crash if thread-safety issues exist
- Performance degradation under load indicates contention problems
- Memory corruption may manifest as segfaults or data corruption
