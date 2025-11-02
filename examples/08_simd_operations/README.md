# SIMD Operations Example

Comprehensive testing and benchmarking of SIMD (AVX2) operations across all numeric types with extensive edge case coverage.

## Overview

This example demonstrates:
- SIMD-optimized array operations for all numeric types (i32, i64, u32, u64, f32, f64)
- Comparison between SIMD and scalar implementations
- Proper handling of unaligned array sizes
- Float edge case handling (NaN, Infinity)
- Performance benchmarking and verification

## Features

### Supported Operations

For all integer types (i32, i64, u32, u64):
- Sum with wraparound
- Min/Max detection
- Average calculation

For floating-point types (f32, f64):
- Sum with NaN detection
- Min/Max with NaN handling
- Infinity detection
- Edge case validation

### SIMD Implementation

- **AVX2 instructions** for x86_64 architecture
- **8-element batches** for i32/u32/f32 (256-bit vectors)
- **4-element batches** for i64/u64/f64 (256-bit vectors)
- **Remainder handling** for unaligned array sizes
- **Scalar fallback** for non-AVX2 systems

## Array Sizes Tested

| Size | Elements | Purpose |
|------|----------|---------|
| Small | 8 | SIMD-aligned testing |
| Unaligned Small | 7, 13 | Remainder handling |
| Medium | 1,000 | Typical workload |
| Unaligned Medium | 1,001 | Remainder at scale |
| Large | 1,000,000 | Performance testing |
| Huge | 16,000,000 | Maximum capacity |

## Structure

```
08_simd_operations/
├── proto/
│   └── simd.proto              # Message definitions
├── rust/
│   ├── src/
│   │   ├── lib.rs              # ~1000 lines SIMD implementation
│   │   └── generated.rs        # Generated bindings
│   └── Cargo.toml
└── flutter/
    ├── lib/
    │   └── generated.dart      # Generated Dart bindings
    ├── test/
    │   └── simd_operations_test.dart  # 25+ tests
    └── pubspec.yaml
```

## Building

```bash
cd rust
cargo build --release

# Copy library to expected location (if using custom CARGO_TARGET_DIR)
mkdir -p target/release
cp $CARGO_TARGET_DIR/release/libsimd_operations_ffi.dylib target/release/
```

## Running Tests

```bash
cd flutter
dart pub get
dart test
```

### Expected Output

```
00:00 +25: All tests passed!

Large array (1M elements) sum: 1000000, time: 92μs
Large f32 array (1M elements) sum: 1000000.0, time: 790μs

=== i32 Sum Benchmark (100K elements, 100 iterations) ===
SIMD average: 4.00μs
Scalar average: 4.00μs
Speedup: 1.00x

f32 sum (8 elements): 0.014μs
f32 sum (100 elements): 0.053μs
f32 sum (1000 elements): 0.733μs
f32 sum (10000 elements): 7.767μs
```

## Test Coverage

### Integer Operations (i32, i64, u32, u64)

1. **Sum Operations**
   - Small aligned arrays (8 elements)
   - Unaligned arrays (7, 13 elements)
   - Medium arrays (1000, 1001 elements)
   - Large arrays (1M elements)
   - Wraparound handling

2. **Min/Max Operations**
   - Positive and negative values
   - Edge values (INT_MIN, INT_MAX)
   - Large value ranges

3. **Average Calculation**
   - Integer division precision
   - Floating-point conversion

4. **SIMD vs Scalar Verification**
   - Results must match exactly
   - Performance comparison

### Float Operations (f32, f64)

1. **Sum Operations**
   - Normal values
   - NaN detection
   - Infinity detection (positive and negative)
   - Mixed edge cases

2. **Min/Max Operations**
   - NaN handling (ignored in min/max)
   - Infinity handling
   - Precision validation
   - Edge case propagation

3. **Large Array Performance**
   - 1M element processing
   - Time measurement
   - Throughput calculation

### Performance Benchmarks

1. **SIMD vs Scalar Comparison**
   - 100K elements
   - 100 iterations
   - Average time calculation
   - Speedup factor

2. **Size Scaling Tests**
   - 8, 100, 1000, 10000 elements
   - 1000 iterations each
   - Time per size

## SIMD Implementation Details

### i32/u32 Sum (AVX2)

```rust
unsafe fn i32_sum_avx2(data: &[i32]) -> i32 {
    use std::arch::x86_64::*;

    let mut sum = _mm256_setzero_si256();
    let mut i = 0;

    // Process 8 elements at a time
    while i + 8 <= data.len() {
        let vec = _mm256_loadu_si256(data.as_ptr().add(i) as *const __m256i);
        sum = _mm256_add_epi32(sum, vec);
        i += 8;
    }

    // Horizontal sum
    let mut result_array = [0i32; 8];
    _mm256_storeu_si256(result_array.as_mut_ptr() as *mut __m256i, sum);
    let mut total = result_array.iter().sum::<i32>();

    // Handle remainder
    while i < data.len() {
        total = total.wrapping_add(data[i]);
        i += 1;
    }

    total
}
```

### i32/u32 Min/Max (AVX2)

```rust
unsafe fn i32_min_max_avx2(data: &[i32]) -> (i32, i32) {
    use std::arch::x86_64::*;

    let mut min_vec = _mm256_set1_epi32(i32::MAX);
    let mut max_vec = _mm256_set1_epi32(i32::MIN);
    let mut i = 0;

    // Process 8 elements at a time
    while i + 8 <= data.len() {
        let vec = _mm256_loadu_si256(data.as_ptr().add(i) as *const __m256i);
        min_vec = _mm256_min_epi32(min_vec, vec);
        max_vec = _mm256_max_epi32(max_vec, vec);
        i += 8;
    }

    // Extract results and find global min/max
    let mut min_array = [0i32; 8];
    let mut max_array = [0i32; 8];
    _mm256_storeu_si256(min_array.as_mut_ptr() as *mut __m256i, min_vec);
    _mm256_storeu_si256(max_array.as_mut_ptr() as *mut __m256i, max_vec);

    let mut min_val = *min_array.iter().min().unwrap();
    let mut max_val = *max_array.iter().max().unwrap();

    // Handle remainder
    while i < data.len() {
        min_val = min_val.min(data[i]);
        max_val = max_val.max(data[i]);
        i += 1;
    }

    (min_val, max_val)
}
```

### f32 Operations with NaN/Infinity Handling

```rust
unsafe fn f32_sum_avx2(data: &[f32]) -> (f32, bool, bool) {
    use std::arch::x86_64::*;

    let mut sum = _mm256_setzero_ps();
    let mut has_nan = false;
    let mut has_inf = false;
    let mut i = 0;

    // Process 8 elements at a time
    while i + 8 <= data.len() {
        let vec = _mm256_loadu_ps(data.as_ptr().add(i));
        sum = _mm256_add_ps(sum, vec);
        i += 8;
    }

    // Extract and check for edge cases
    let mut result_array = [0.0f32; 8];
    _mm256_storeu_ps(result_array.as_mut_ptr(), sum);
    let mut total = result_array.iter().sum::<f32>();

    // Check vector results for edge cases
    for &val in &result_array {
        if val.is_nan() { has_nan = true; }
        if val.is_infinite() { has_inf = true; }
    }

    // Handle remainder
    while i < data.len() {
        let val = data[i];
        if val.is_nan() { has_nan = true; }
        if val.is_infinite() { has_inf = true; }
        total += val;
        i += 1;
    }

    (total, has_nan, has_inf)
}
```

## Edge Cases Handled

### Integer Edge Cases

1. **Overflow/Wraparound**
   - i32: Wrapping addition for overflow
   - u32: Wrapping addition for overflow
   - Consistent behavior between SIMD and scalar

2. **Min/Max Edge Values**
   - INT_MIN and INT_MAX
   - UINT_MAX
   - Zero values

3. **Empty Arrays**
   - Return defaults (0 sum, MAX min, MIN max)
   - No crashes

### Float Edge Cases

1. **NaN Propagation**
   - Detected and flagged
   - Not used in min/max calculations
   - Does not cause incorrect results

2. **Infinity Handling**
   - Positive and negative infinity detected
   - Included in sum operations
   - Handled in min/max

3. **Precision**
   - f32: Single precision validation
   - f64: Double precision validation
   - Accumulation accuracy

## Performance Characteristics

### SIMD Benefits

- **Throughput**: 8-16x more data per instruction
- **Latency**: Reduced for large arrays
- **Efficiency**: Better cache utilization

### When SIMD Helps Most

1. **Large arrays** (1000+ elements)
2. **Aligned data** (multiples of vector width)
3. **Simple operations** (add, min, max)
4. **Repeated operations** (amortized setup cost)

### When SIMD Helps Less

1. **Small arrays** (< 64 elements)
2. **Complex operations** (divisions, transcendentals)
3. **Unaligned data** (extra handling overhead)
4. **Branch-heavy code** (conditional logic)

## Bugs Found and Fixed

This example helped identify several important issues:

1. **Bool Type Mismatch**
   - Issue: has_nan/has_infinity fields were u32, should be u8
   - Fix: Changed cast from `as u32` to `as u8`
   - Impact: Correct proto type representation

2. **Array Pointer Types**
   - Issue: Generated Dart code used `@ffi.Pointer<type>` annotations
   - Fix: Changed to `external ffi.Pointer<ffi.Type>` fields
   - Impact: Proper FFI struct layout

3. **Remainder Handling**
   - Issue: Arrays not divisible by vector width
   - Fix: Process remainder elements with scalar code
   - Impact: Correct results for all array sizes

4. **NaN Handling in Min/Max**
   - Issue: NaN could corrupt min/max results
   - Fix: Skip NaN values in comparisons
   - Impact: Robust float operations

## Best Practices Demonstrated

1. **Always provide scalar fallback** for non-SIMD systems
2. **Handle remainders** for unaligned array sizes
3. **Validate results** by comparing SIMD vs scalar
4. **Test edge cases** (NaN, Infinity, overflow)
5. **Benchmark realistically** with various sizes
6. **Use wrapping arithmetic** for predictable overflow
7. **Document assumptions** about alignment and sizes

## Further Optimizations

Potential improvements for production use:

1. **Aligned allocation** for better SIMD performance
2. **AVX-512 support** for 16-element vectors
3. **Auto-vectorization** comparison with rustc flags
4. **Cache prefetching** for very large arrays
5. **Multi-threading** for huge datasets
6. **NEON support** for ARM processors
7. **Compile-time dispatch** based on CPU features

## References

- [Intel AVX2 Intrinsics Guide](https://www.intel.com/content/www/us/en/docs/intrinsics-guide/index.html)
- [Rust std::arch documentation](https://doc.rust-lang.org/std/arch/index.html)
- [Dart FFI documentation](https://dart.dev/guides/libraries/c-interop)

## License

This example is part of the proto2ffi project.
