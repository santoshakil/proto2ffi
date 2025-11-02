// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: constant_identifier_names

import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'dart:typed_data';
import 'dart:io';
import 'dart:convert';

typedef i32 = ffi.Int32;
typedef i64 = ffi.Int64;
typedef u32 = ffi.Uint32;
typedef u64 = ffi.Uint64;
typedef f32 = ffi.Float;
typedef f64 = ffi.Double;

const int I32ARRAYOPS_SIZE = 40;
const int I32ARRAYOPS_ALIGNMENT = 8;

final class I32ArrayOps extends ffi.Struct {
  external ffi.Pointer<ffi.Int32> data;

  @ffi.Uint32()
  external int count;

  @ffi.Int32()
  external int sum;

  @ffi.Int32()
  external int min;

  @ffi.Int32()
  external int max;

  @ffi.Float()
  external double average;

  static ffi.Pointer<I32ArrayOps> allocate() {
    return calloc<I32ArrayOps>();
  }
}

const int I64ARRAYOPS_SIZE = 56;
const int I64ARRAYOPS_ALIGNMENT = 8;

final class I64ArrayOps extends ffi.Struct {
  external ffi.Pointer<ffi.Int64> data;

  @ffi.Int64()
  external int sum;

  @ffi.Int64()
  external int min;

  @ffi.Int64()
  external int max;

  @ffi.Double()
  external double average;

  @ffi.Uint32()
  external int count;

  static ffi.Pointer<I64ArrayOps> allocate() {
    return calloc<I64ArrayOps>();
  }
}

const int U32ARRAYOPS_SIZE = 40;
const int U32ARRAYOPS_ALIGNMENT = 8;

final class U32ArrayOps extends ffi.Struct {
  external ffi.Pointer<ffi.Uint32> data;

  @ffi.Uint32()
  external int count;

  @ffi.Uint32()
  external int sum;

  @ffi.Uint32()
  external int min;

  @ffi.Uint32()
  external int max;

  @ffi.Float()
  external double average;

  static ffi.Pointer<U32ArrayOps> allocate() {
    return calloc<U32ArrayOps>();
  }
}

const int U64ARRAYOPS_SIZE = 56;
const int U64ARRAYOPS_ALIGNMENT = 8;

final class U64ArrayOps extends ffi.Struct {
  external ffi.Pointer<ffi.Uint64> data;

  @ffi.Uint64()
  external int sum;

  @ffi.Uint64()
  external int min;

  @ffi.Uint64()
  external int max;

  @ffi.Double()
  external double average;

  @ffi.Uint32()
  external int count;

  static ffi.Pointer<U64ArrayOps> allocate() {
    return calloc<U64ArrayOps>();
  }
}

const int F32ARRAYOPS_SIZE = 40;
const int F32ARRAYOPS_ALIGNMENT = 8;

final class F32ArrayOps extends ffi.Struct {
  external ffi.Pointer<ffi.Float> data;

  @ffi.Uint32()
  external int count;

  @ffi.Float()
  external double sum;

  @ffi.Float()
  external double min;

  @ffi.Float()
  external double max;

  @ffi.Float()
  external double average;

  @ffi.Uint8()
  external int has_nan;

  @ffi.Uint8()
  external int has_infinity;

  static ffi.Pointer<F32ArrayOps> allocate() {
    return calloc<F32ArrayOps>();
  }
}

const int F64ARRAYOPS_SIZE = 56;
const int F64ARRAYOPS_ALIGNMENT = 8;

final class F64ArrayOps extends ffi.Struct {
  external ffi.Pointer<ffi.Double> data;

  @ffi.Double()
  external double sum;

  @ffi.Double()
  external double min;

  @ffi.Double()
  external double max;

  @ffi.Double()
  external double average;

  @ffi.Uint32()
  external int count;

  @ffi.Uint8()
  external int has_nan;

  @ffi.Uint8()
  external int has_infinity;

  static ffi.Pointer<F64ArrayOps> allocate() {
    return calloc<F64ArrayOps>();
  }
}

const int BENCHMARKRESULT_SIZE = 280;
const int BENCHMARKRESULT_ALIGNMENT = 8;

final class BenchmarkResult extends ffi.Struct {
  @ffi.Uint64()
  external int simd_time_ns;

  @ffi.Uint64()
  external int scalar_time_ns;

  @ffi.Float()
  external double speedup_factor;

  @ffi.Uint32()
  external int elements_processed;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> _operation_name;

  String get operation_name {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (_operation_name[i] == 0) break;
      bytes.add(_operation_name[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set operation_name(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      _operation_name[i] = bytes[i];
    }
    if (len < 256) {
      _operation_name[len] = 0;
    }
  }

  static ffi.Pointer<BenchmarkResult> allocate() {
    return calloc<BenchmarkResult>();
  }
}

const int TESTCONFIG_SIZE = 40;
const int TESTCONFIG_ALIGNMENT = 8;

final class TestConfig extends ffi.Struct {
  external ffi.Pointer<ffi.Uint32> unaligned_sizes;

  @ffi.Uint32()
  external int small_size;

  @ffi.Uint32()
  external int medium_size;

  @ffi.Uint32()
  external int large_size;

  @ffi.Uint32()
  external int huge_size;

  @ffi.Uint32()
  external int unaligned_count;

  static ffi.Pointer<TestConfig> allocate() {
    return calloc<TestConfig>();
  }
}

class FFIBindings {
  static final _dylib = _loadLibrary();

  static ffi.DynamicLibrary _loadLibrary() {
    if (Platform.isAndroid) {
      return ffi.DynamicLibrary.open('libsimd_operations_ffi.so');
    } else if (Platform.isIOS) {
      return ffi.DynamicLibrary.process();
    } else if (Platform.isMacOS) {
      return ffi.DynamicLibrary.open('libsimd_operations_ffi.dylib');
    } else if (Platform.isWindows) {
      return ffi.DynamicLibrary.open('simd_operations_ffi.dll');
    } else {
      return ffi.DynamicLibrary.open('libsimd_operations_ffi.so');
    }
  }

  late final i32arrayops_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('i32arrayops_size');

  late final i32arrayops_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('i32arrayops_alignment');

  late final i64arrayops_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('i64arrayops_size');

  late final i64arrayops_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('i64arrayops_alignment');

  late final u32arrayops_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('u32arrayops_size');

  late final u32arrayops_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('u32arrayops_alignment');

  late final u64arrayops_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('u64arrayops_size');

  late final u64arrayops_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('u64arrayops_alignment');

  late final f32arrayops_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('f32arrayops_size');

  late final f32arrayops_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('f32arrayops_alignment');

  late final f64arrayops_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('f64arrayops_size');

  late final f64arrayops_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('f64arrayops_alignment');

  late final benchmarkresult_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('benchmarkresult_size');

  late final benchmarkresult_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('benchmarkresult_alignment');

  late final testconfig_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('testconfig_size');

  late final testconfig_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('testconfig_alignment');
}
