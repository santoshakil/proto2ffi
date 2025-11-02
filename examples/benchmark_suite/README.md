# Proto2FFI Benchmark Suite

Comprehensive benchmarks demonstrating proto2ffi performance across real-world scenarios.

## Scenarios

### 1. Game Engine (`game_engine.proto`)

High-performance 3D game engine data structures:
- **Physics simulation**: 5000 rigid bodies
- **Particle systems**: 50,000 particles
- **Transform hierarchies**: Nested position/rotation/scale
- **Collision detection**: AABB, Sphere, and complex colliders

**Performance Targets**:
- Physics updates: >1M objects/sec
- Particle updates: >10M particles/sec
- SIMD vector operations: >2B ops/sec

### 2. Trading System (`trading_system.proto`)

High-frequency trading and market data:
- **Order matching**: 100K orders/sec
- **Market data processing**: 500K ticks/sec
- **Order book updates**: Real-time bid/ask management
- **Risk calculations**: Portfolio-level metrics

**Performance Targets**:
- Order processing: >100K orders/sec
- Market data ingestion: >500K ticks/sec
- Order book updates: <10μs latency

### 3. IoT Sensors (`iot_sensors.proto`)

Massive-scale sensor data processing:
- **Sensor readings**: 100K sensors, 1M readings/sec
- **Data buffering**: 1024-sample batches
- **Statistical aggregation**: Real-time analytics
- **Alert processing**: Threshold monitoring

**Performance Targets**:
- Sensor data ingestion: >1M readings/sec
- Batch processing: >10M samples/sec
- Statistical calculations: <100ns per reading

## Running Benchmarks

### Quick Start

```bash
# Build and run
cargo run --release

# Results written to results/benchmarks.json
```

### Full Benchmark Suite

```bash
# Run all benchmarks
cargo bench

# Run specific benchmark
cargo bench -- memory_operations

# Generate HTML reports
cargo bench --bench memory_operations -- --output-format html
```

## Benchmark Categories

### Memory Operations
- Stack allocation patterns
- Heap allocation patterns
- Cache efficiency
- Memory alignment impact

### Allocation Patterns
- Pool vs malloc comparison
- Batch allocation
- Deallocation patterns
- Fragmentation impact

### Throughput Patterns
- Sequential processing
- Batch operations
- SIMD acceleration
- Data structure traversal

### Latency Patterns
- Single operation latency
- Percentile analysis (p50, p99, p999)
- Worst-case scenarios
- Jitter measurement

## Understanding Results

### Output Format

```json
{
  "name": "Benchmark name",
  "category": "memory|allocation|throughput|latency",
  "operations": 1000000,
  "duration_micros": 1500,
  "ops_per_sec": 666666.67,
  "latency_ns": 1.5
}
```

### Interpreting Metrics

- **ops_per_sec**: Higher is better (throughput)
- **latency_ns**: Lower is better (responsiveness)
- **duration_micros**: Total time for benchmark

### Baseline Expectations

| Category | Operation | Expected Throughput |
|----------|-----------|-------------------|
| Memory | Small struct (16B) | >10M/sec |
| Memory | Medium struct (64B) | >5M/sec |
| Memory | Large struct (224B) | >1M/sec |
| Allocation | Pool allocation | >5M/sec |
| Allocation | Heap allocation | >1M/sec |
| Throughput | Physics updates | >1M/sec |
| Throughput | SIMD batch ops | >2B/sec |
| Latency | Single operation | <100ns |

## Advanced Benchmarking

### Custom Scenarios

Add your own benchmarks by editing `src/main.rs`:

```rust
fn run_custom_benchmark(suite: &mut BenchmarkSuite) {
    suite.bench("My custom test", "custom", 1_000_000, || {
        // Your benchmark code here
    });
}
```

### Profiling

```bash
# CPU profiling
cargo flamegraph --bench memory_operations

# Memory profiling
valgrind --tool=massif target/release/benchmarks

# Performance analysis
perf record -g target/release/benchmarks
perf report
```

### Cross-Platform Testing

```bash
# Linux
cargo build --release --target x86_64-unknown-linux-gnu

# macOS Intel
cargo build --release --target x86_64-apple-darwin

# macOS ARM
cargo build --release --target aarch64-apple-darwin

# Windows
cargo build --release --target x86_64-pc-windows-msvc
```

## CI Integration

Benchmarks run automatically on:
- Every push to main
- Pull requests
- Release tags

Results are archived and tracked over time for regression detection.

## Contributing

When adding new scenarios:
1. Create a `.proto` schema in `schemas/`
2. Generate code with proto2ffi
3. Add benchmark in `src/` or `benches/`
4. Document expected performance
5. Add to CI pipeline

## Performance Tips

1. **Batch Operations**: Process data in batches for better cache utilization
2. **SIMD**: Use SIMD-enabled types for vector operations
3. **Memory Pools**: Use pools for frequently allocated objects
4. **Alignment**: Ensure proper struct alignment for performance
5. **Zero-Copy**: Avoid unnecessary copying between Dart and Rust

## Troubleshooting

### Low Performance

- Check CPU governor (should be "performance" mode)
- Disable CPU frequency scaling
- Close background applications
- Run on dedicated hardware

### Inconsistent Results

- Run multiple iterations
- Use criterion for statistical analysis
- Check for thermal throttling
- Verify no background tasks running

## License

MIT - See LICENSE file
