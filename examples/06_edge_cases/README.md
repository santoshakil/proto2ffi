# Edge Cases Example

This example demonstrates comprehensive edge case testing for the proto2ffi system, testing boundary conditions and extreme scenarios.

## Test Coverage

### 1. Integer Limits
- **int32**: Min (-2,147,483,648) and Max (2,147,483,647)
- **uint32**: Min (0) and Max (4,294,967,295)
- **int64**: Min (-9,223,372,036,854,775,808) and Max (9,223,372,036,854,775,807)
- **uint64**: Min (0) and Max (18,446,744,073,709,551,615)
- **sint32, sint64**: Zigzag encoded signed integers
- **fixed32, fixed64**: Fixed-width unsigned integers
- **sfixed32, sfixed64**: Fixed-width signed integers

### 2. Float Edge Cases
- Zero and negative zero
- Positive and negative infinity
- NaN (Not a Number)
- Minimum positive values (denormalized numbers)
- Maximum and minimum representable values
- Both float32 and float64 (double) precision

### 3. String Sizes
- Empty strings
- 255 character strings (edge of small string)
- 1,024 character strings (medium)
- 4,096 character strings (large)
- Tests truncation to 256-byte limit in proto2ffi

### 4. Array Sizes
- Empty arrays (0 elements)
- Small arrays (100 elements)
- Medium arrays (1,000 elements)
- Large arrays (10,000 elements)
- Tests pointer-based array handling

### 5. Deeply Nested Messages
- 10 levels of nesting (Level1 -> Level2 -> ... -> Level10)
- Tests stack depth and memory layout
- Verifies correct field access at deepest level

### 6. Message with Many Fields
- 55 fields in a single message
- Tests struct layout and alignment
- Verifies field ordering and padding

### 7. Boolean Fields
- Message with 8 boolean fields
- Tests boolean storage as u8
- Verifies true/false handling

### 8. Enum Fields
- Small enum (2 values)
- Large enum (111 values)
- Tests enum storage as u32
- Verifies value preservation

### 9. Edge Message Types
- Empty message (no fields)
- Single field message
- All types combined in one message

## Structure

```
06_edge_cases/
├── proto/
│   └── edge_cases.proto     # Comprehensive proto definitions
├── rust/
│   ├── Cargo.toml          # Rust library configuration
│   └── src/
│       ├── lib.rs          # FFI exports and edge case handlers
│       └── generated.rs    # Generated Rust FFI code
└── dart/
    ├── pubspec.yaml        # Dart dependencies
    ├── lib/
    │   └── generated.dart  # Generated Dart FFI bindings
    └── test/
        └── edge_cases_test.dart  # Comprehensive test suite
```

## Known Issues

### Dart Code Generation Bug

The current version of proto2ffi has a bug in the Dart code generator when handling repeated fields (arrays). The generated code produces invalid Dart annotations:

```dart
@ffi.Pointer<i32>  // Invalid: should be external ffi.Pointer<ffi.Int32>
external List<int> empty_array;
```

**Expected output:**
```dart
external ffi.Pointer<ffi.Int32> empty_array;
```

This affects the `ArraySizes` struct and similar repeated field types. The proto file is correct, and the Rust code handles these properly as `*const i32` pointers.

### String Truncation

All strings are currently limited to 256 bytes in the generated code (using `[u8; 256]` in Rust). This is a design decision in proto2ffi for fixed-size FFI compatibility. The test cases verify that strings longer than 256 characters are properly truncated.

## Building

```bash
# Build Rust library
cd rust
cargo build

# The library will be output to:
# macOS: target/debug/libedge_cases.dylib
# Linux: target/debug/libedge_cases.so
# Windows: target/debug/edge_cases.dll
```

## Testing

Due to the Dart code generation bug, the tests cannot currently run. Once fixed:

```bash
cd dart
dart pub get
dart test
```

## Test Cases

### Integer Limits Tests
- Verifies all integer types can store their maximum and minimum values
- Tests signed vs unsigned handling
- Validates zigzag encoding for sint types

### Float Edge Cases Tests
- Confirms special float values (Infinity, NaN) round-trip correctly
- Tests negative zero handling
- Verifies extreme magnitude values

### String Size Tests
- Creates strings of various sizes
- Verifies truncation at 256 bytes
- Tests roundtrip with `verify_string_roundtrip` function

### Array Size Tests
- Allocates arrays of different sizes
- Tests pointer-based array storage
- Verifies array length tracking

### Deep Nesting Tests
- Creates deeply nested structures
- Uses `get_deeply_nested_value` to verify access
- Tests that value at level 10 is accessible

### Many Fields Tests
- Creates message with 55 integer fields
- Uses `sum_many_fields` to verify all fields stored correctly
- Tests struct layout and memory alignment

### Boolean Tests
- All true, all false, and mixed boolean states
- Uses `count_true_flags` to verify storage
- Tests boolean as u8 conversion

### Enum Tests
- Tests both small and large enums
- Verifies enum values preserved as u32
- Tests boundary enum values (0 and max)

### Memory Safety Tests
- Null pointer handling
- Multiple allocations and frees
- Large memory allocations
- No crashes or memory leaks

## What This Example Tests

This is a **stress test** and **edge case validator** for proto2ffi. It helps catch:

1. **Overflow bugs**: Testing integer min/max values
2. **Special value bugs**: NaN, Infinity in floats
3. **Memory bugs**: Deep nesting, large arrays
4. **Truncation issues**: Large strings
5. **Alignment issues**: Many fields, nested structures
6. **Type conversion bugs**: Booleans, enums
7. **Null handling**: Empty strings, arrays
8. **Memory leaks**: Allocation/free patterns

## Files Created

```
Modified:
- /Volumes/Projects/ssss/proto2ffil/Cargo.toml (added to workspace)

Created:
- /Volumes/Projects/ssss/proto2ffil/examples/06_edge_cases/proto/edge_cases.proto
- /Volumes/Projects/ssss/proto2ffil/examples/06_edge_cases/rust/Cargo.toml
- /Volumes/Projects/ssss/proto2ffil/examples/06_edge_cases/rust/src/lib.rs
- /Volumes/Projects/ssss/proto2ffil/examples/06_edge_cases/rust/src/generated.rs
- /Volumes/Projects/ssss/proto2ffil/examples/06_edge_cases/dart/pubspec.yaml
- /Volumes/Projects/ssss/proto2ffil/examples/06_edge_cases/dart/lib/generated.dart
- /Volumes/Projects/ssss/proto2ffil/examples/06_edge_cases/dart/test/edge_cases_test.dart
- /Volumes/Projects/ssss/proto2ffil/examples/06_edge_cases/README.md
```
