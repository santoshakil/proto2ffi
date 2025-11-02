# Proto2FFI Stress Tests

Aggressive stress testing suite designed to push the FFI system to its limits and identify scalability issues.

## Features

### Protocol Buffer Definition
- **100+ message types** with complex interconnections
- **20-level deep nesting** structures
- **100+ field messages** (WideMessage)
- **Large messages** with multi-KB payloads
- **Repeated fields** at multiple nesting levels
- **All supported data types** (integers, floats, strings, bytes, booleans)

### Rust Implementation
- Manual memory allocation/deallocation functions
- Memory block management
- Deep recursion handling
- Array filling operations
- Memory size measurement utilities

### Dart Test Suite

#### Memory Stress Tests
- **10k object allocation** - Mass allocation and cleanup
- **Mixed allocation patterns** - 1k of each type (4k total objects)
- **Interleaved allocation/deallocation** - Dynamic memory management
- **Rapid cycles** - 1000 fast allocation-deallocation cycles

#### Deep Nesting Tests
- Traverse 20-level deep nested structures
- Multiple deep nesting roots (100 instances)

#### Wide Message Tests
- 100-field message allocation
- Array of 1000 wide messages
- Memory size measurement

#### Huge Message Tests
- Multi-KB message allocation
- 100 huge message instances
- Memory footprint analysis

#### Performance Benchmarks
- **Allocation speed** tests for each message type
- **Deallocation speed** measurement
- Performance metrics (operations/second)

#### Memory Leak Detection
- **100k allocation-deallocation cycles** without crashes
- **Sustained load test** - 10k active objects with rotation
- Long-running stability verification

#### Edge Cases
- Null pointer handling
- Repeated allocation patterns
- Mixed type rapid cycling
- Boundary condition testing

#### Scalability Tests
- Linear scaling from 1k to 10k objects
- Performance characteristic analysis

## Running the Tests

### Build Rust Library
```bash
cargo build --release -p stress_tests
```

### Run Dart Tests
```bash
cd examples/09_stress_tests
dart test
```

## Test Coverage

### Memory Management
- Allocation patterns
- Deallocation patterns
- Memory leak detection
- Fragmentation handling

### Performance
- Allocation speed
- Deallocation speed
- Throughput measurement
- Scalability characteristics

### Stability
- Long-running tests
- Sustained load
- Rapid cycling
- Edge case handling

### Structure Complexity
- Deep nesting (20 levels)
- Wide structures (100+ fields)
- Large payloads (multi-KB)
- Recursive structures

## Expected Results

### Performance Targets
- Deep nesting: >1000 allocations/sec
- Wide messages: >1000 allocations/sec
- Huge messages: >100 allocations/sec
- Deallocation: >1000 deallocations/sec

### Stability Requirements
- No crashes in 100k cycles
- No memory leaks detected
- Consistent performance under sustained load

## What This Tests

1. **FFI Boundary Stress**
   - Pointer management across thousands of calls
   - Memory safety at scale
   - Performance characteristics

2. **Memory Allocator Behavior**
   - Allocation patterns
   - Fragmentation
   - Large allocations

3. **Structure Layout Correctness**
   - Deep nesting alignment
   - Wide structure padding
   - Repeated field handling

4. **Scalability Limits**
   - Maximum practical object counts
   - Performance degradation patterns
   - Memory usage patterns

5. **Edge Case Robustness**
   - Null handling
   - Rapid cycling
   - Mixed patterns

## Interpreting Results

### Performance Metrics
The tests output operations/second for key operations. Lower numbers indicate:
- Memory allocation overhead
- FFI call overhead
- Structure complexity impact

### Memory Leak Detection
Tests should complete without growing memory usage or crashes. Any consistent growth indicates leaks.

### Scalability
Linear scaling tests should show roughly proportional time increases. Non-linear growth indicates scalability issues.

## Known Limitations

- Tests run sequentially (no true concurrency in Dart isolates)
- Memory measurement is approximate
- Platform-specific performance variations expected

## Future Enhancements

- Concurrent allocation tests (when isolate support added)
- Real-time memory monitoring
- Heap fragmentation measurement
- GC interaction analysis
- Platform comparison benchmarks
