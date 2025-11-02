# Limitations Found During Stress Test Implementation

## Critical Issues in Proto2FFI Generator

### 1. File Path Handling Bug
**Issue**: The proto2ffi generator creates directories instead of files when generating output.

**Impact**:
- Generated files appear as directories
- Requires manual workaround to extract actual file from nested directory structure

**Workaround**:
```bash
# Generated path: examples/09_stress_tests/rust/src/generated.rs/generated.rs
# Expected path: examples/09_stress_tests/rust/src/generated.rs

mv generated.rs/generated.rs generated.rs.tmp
rm -rf generated.rs
mv generated.rs.tmp generated.rs
```

### 2. Invalid Dart Code Generation for Repeated Fields
**Issue**: Generator produces invalid Dart syntax for repeated fields with non-primitive types.

**Generated (Invalid)**:
```dart
@ffi.Pointer<[u8; 256]>  // Invalid: annotation with array syntax
@ffi.Pointer<i32>        // Invalid: missing field declaration
```

**Expected**:
```dart
external ffi.Pointer<ffi.Uint8> texts;  // or similar valid syntax
external ffi.Pointer<ffi.Int32> numbers;
```

**Impact**:
- Cannot use `repeated string` fields
- Cannot use `repeated bytes` fields
- Complex nested repeated structures fail to compile
- Severely limits practical use cases

### 3. Type Annotation Bug in Dart
**Issue**: Generator emits type annotations (`@ffi.Pointer<T>`) instead of field declarations for repeated fields.

**Manifestation**:
- All repeated fields generate as annotations
- No actual field is declared
- Dart analyzer fails with "annotation must be followed by argument list"

### 4. String and Bytes Handling
**Issue**: String and bytes fields in repeated contexts generate as fixed-size arrays (`[u8; 256]`) in Dart, which is invalid syntax.

**Impact**:
- Any proto with `repeated string` fails
- Any proto with `repeated bytes` fails
- Forces use of integer-only protos for testing

## Tested Workarounds

### Successful Approach
- **Numeric types only**: int32, int64, double, float, bool work correctly
- **Nested messages**: Work when containing only numeric types
- **Primitive arrays**: `repeated int32`, `repeated double` work correctly

### Failed Approaches
- String fields in any context - generates invalid Dart
- Bytes fields - generates invalid array syntax
- Complex nesting with strings - compilation fails
- Map types - not supported (expected, documented limitation)

## What We Can Test With Current Generator

### Working Features
1. Deep nesting (10 levels tested)
2. Wide structures (30 fields tested)
3. Repeated numeric fields
4. Nested message types (numeric fields only)
5. Memory allocation/deallocation
6. Large arrays of primitives

### Cannot Test Due to Bugs
1. String handling at scale
2. Bytes/binary data handling
3. Mixed string+numeric complexity
4. Real-world message structures (which always include strings)
5. Complex data structures typical in actual applications

## Impact on Stress Testing

The generator bugs prevent comprehensive stress testing because:

1. **Real-world patterns blocked**: Most real applications use strings extensively
2. **Limited complexity**: Cannot test realistic message complexity
3. **Artificial constraints**: Tests become "what the generator can handle" vs "what FFI can handle"
4. **Incomplete coverage**: Missing critical data types in stress scenarios

## Recommended Fixes (for proto2ffi-core)

### High Priority
1. **Fix file path handling**: Generate files directly, not as nested directories
2. **Fix Dart repeated field generation**: Generate proper field declarations
3. **Fix string/bytes in arrays**: Generate valid Dart pointer syntax

### Implementation Suggestions
```dart
// Current (broken):
@ffi.Pointer<[u8; 256]>

// Should be:
external ffi.Pointer<ffi.Pointer<ffi.Uint8>> texts;
```

## Testing Methodology Used

Despite limitations, we tested:
- 10-level deep nesting
- 30-field wide messages
- Numeric arrays
- Recursive structures (with caveats)
- Memory allocation patterns
- Performance characteristics

## Files Created

1. `/rust/proto/stress_simple.proto` - Simplified proto avoiding bugs
2. `/rust/src/lib.rs` - Rust FFI functions
3. `/test/stress_test.dart` - Comprehensive Dart tests
4. `/README.md` - Documentation
5. This file - Limitations documentation

## Conclusion

The proto2ffi generator has fundamental code generation bugs that prevent:
- Full stress testing
- Real-world usage patterns
- String/bytes data types in repeated fields
- Proper Dart FFI struct generation

These issues must be fixed in proto2ffi-core before comprehensive stress testing can proceed.
