// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: constant_identifier_names

import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'dart:typed_data';
import 'dart:io';
import 'dart:convert';

const int VECTOR4_SIZE = 16;
const int VECTOR4_ALIGNMENT = 8;

final class Vector4 extends ffi.Struct {
  @ffi.Float()
  external double x;

  @ffi.Float()
  external double y;

  @ffi.Float()
  external double z;

  @ffi.Float()
  external double w;

  static ffi.Pointer<Vector4> allocate() {
    return calloc<Vector4>();
  }
}

const int TRANSFORM_SIZE = 64;
const int TRANSFORM_ALIGNMENT = 8;

final class Transform extends ffi.Struct {
  @ffi.Float()
  external double m00;

  @ffi.Float()
  external double m01;

  @ffi.Float()
  external double m02;

  @ffi.Float()
  external double m03;

  @ffi.Float()
  external double m10;

  @ffi.Float()
  external double m11;

  @ffi.Float()
  external double m12;

  @ffi.Float()
  external double m13;

  @ffi.Float()
  external double m20;

  @ffi.Float()
  external double m21;

  @ffi.Float()
  external double m22;

  @ffi.Float()
  external double m23;

  @ffi.Float()
  external double m30;

  @ffi.Float()
  external double m31;

  @ffi.Float()
  external double m32;

  @ffi.Float()
  external double m33;

  static ffi.Pointer<Transform> allocate() {
    return calloc<Transform>();
  }
}

const int BATCHSTATS_SIZE = 32;
const int BATCHSTATS_ALIGNMENT = 8;

final class BatchStats extends ffi.Struct {
  @ffi.Uint64()
  external int total_processed;

  @ffi.Uint64()
  external int simd_operations;

  @ffi.Uint64()
  external int scalar_operations;

  @ffi.Double()
  external double avg_batch_size;

  static ffi.Pointer<BatchStats> allocate() {
    return calloc<BatchStats>();
  }
}

class FFIBindings {
  static final _dylib = _loadLibrary();

  static ffi.DynamicLibrary _loadLibrary() {
    if (Platform.isAndroid) {
      return ffi.DynamicLibrary.open('libgenerated.so');
    } else if (Platform.isIOS) {
      return ffi.DynamicLibrary.process();
    } else if (Platform.isMacOS) {
      return ffi.DynamicLibrary.open('libgenerated.dylib');
    } else if (Platform.isWindows) {
      return ffi.DynamicLibrary.open('generated.dll');
    } else {
      return ffi.DynamicLibrary.open('libgenerated.so');
    }
  }

  late final vector4_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('vector4_size');

  late final vector4_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('vector4_alignment');

  late final transform_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('transform_size');

  late final transform_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('transform_alignment');

  late final batchstats_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('batchstats_size');

  late final batchstats_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('batchstats_alignment');
}
