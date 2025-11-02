import 'dart:ffi' as ffi;
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'phase4/generated.dart';

class Phase4FFI {
  static final ffi.DynamicLibrary _dylib = _loadLibrary();

  static ffi.DynamicLibrary _loadLibrary() {
    if (Platform.isMacOS) {
      return ffi.DynamicLibrary.open('/Volumes/Projects/DevCaches/project-targets/release/libffi_example.dylib');
    } else if (Platform.isLinux) {
      return ffi.DynamicLibrary.open('/Volumes/Projects/DevCaches/project-targets/release/libffi_example.so');
    } else if (Platform.isWindows) {
      return ffi.DynamicLibrary.open('/Volumes/Projects/DevCaches/project-targets/release/ffi_example.dll');
    }
    throw UnsupportedError('Unsupported platform');
  }

  static final _vector4Add = _dylib.lookupFunction<
    ffi.Void Function(ffi.Pointer<Vector4>, ffi.Pointer<Vector4>, ffi.Pointer<Vector4>),
    void Function(ffi.Pointer<Vector4>, ffi.Pointer<Vector4>, ffi.Pointer<Vector4>)
  >('vector4_add');

  static final _vector4Dot = _dylib.lookupFunction<
    ffi.Float Function(ffi.Pointer<Vector4>, ffi.Pointer<Vector4>),
    double Function(ffi.Pointer<Vector4>, ffi.Pointer<Vector4>)
  >('vector4_dot');

  static final _vector4Scale = _dylib.lookupFunction<
    ffi.Void Function(ffi.Pointer<Vector4>, ffi.Float, ffi.Pointer<Vector4>),
    void Function(ffi.Pointer<Vector4>, double, ffi.Pointer<Vector4>)
  >('vector4_scale');

  static final _vector4BatchAdd = _dylib.lookupFunction<
    ffi.Void Function(ffi.Pointer<Vector4>, ffi.Pointer<Vector4>, ffi.Pointer<Vector4>, ffi.Size),
    void Function(ffi.Pointer<Vector4>, ffi.Pointer<Vector4>, ffi.Pointer<Vector4>, int)
  >('vector4_batch_add');

  static final _vector4BatchScale = _dylib.lookupFunction<
    ffi.Void Function(ffi.Pointer<Vector4>, ffi.Float, ffi.Pointer<Vector4>, ffi.Size),
    void Function(ffi.Pointer<Vector4>, double, ffi.Pointer<Vector4>, int)
  >('vector4_batch_scale');

  static final _vector4BatchDot = _dylib.lookupFunction<
    ffi.Void Function(ffi.Pointer<Vector4>, ffi.Pointer<Vector4>, ffi.Pointer<ffi.Float>, ffi.Size),
    void Function(ffi.Pointer<Vector4>, ffi.Pointer<Vector4>, ffi.Pointer<ffi.Float>, int)
  >('vector4_batch_dot');

  static final _batchGetStats = _dylib.lookupFunction<
    ffi.Void Function(ffi.Pointer<BatchStats>),
    void Function(ffi.Pointer<BatchStats>)
  >('batch_get_stats');

  static final _batchResetStats = _dylib.lookupFunction<
    ffi.Void Function(),
    void Function()
  >('batch_reset_stats');

  static void vector4Add(ffi.Pointer<Vector4> a, ffi.Pointer<Vector4> b, ffi.Pointer<Vector4> result) {
    _vector4Add(a, b, result);
  }

  static double vector4Dot(ffi.Pointer<Vector4> a, ffi.Pointer<Vector4> b) {
    return _vector4Dot(a, b);
  }

  static void vector4Scale(ffi.Pointer<Vector4> v, double s, ffi.Pointer<Vector4> result) {
    _vector4Scale(v, s, result);
  }

  static void vector4BatchAdd(ffi.Pointer<Vector4> a, ffi.Pointer<Vector4> b, ffi.Pointer<Vector4> result, int count) {
    _vector4BatchAdd(a, b, result, count);
  }

  static void vector4BatchScale(ffi.Pointer<Vector4> v, double s, ffi.Pointer<Vector4> result, int count) {
    _vector4BatchScale(v, s, result, count);
  }

  static void vector4BatchDot(ffi.Pointer<Vector4> a, ffi.Pointer<Vector4> b, ffi.Pointer<ffi.Float> results, int count) {
    _vector4BatchDot(a, b, results, count);
  }

  static void batchGetStats(ffi.Pointer<BatchStats> stats) {
    _batchGetStats(stats);
  }

  static void batchResetStats() {
    _batchResetStats();
  }
}
