import 'dart:ffi' as ffi;
import 'dart:io';
import 'package:test/test.dart';
import 'package:ffi/ffi.dart';
import '../lib/generated.dart';

ffi.DynamicLibrary loadLibrary() {
  var libPath = '';

  if (Platform.isMacOS) {
    libPath = '/Volumes/Projects/ssss/proto2ffil/examples/08_simd_operations/rust/target/release/libsimd_operations_ffi.dylib';
  } else if (Platform.isLinux) {
    libPath = '/Volumes/Projects/ssss/proto2ffil/examples/08_simd_operations/rust/target/release/libsimd_operations_ffi.so';
  } else if (Platform.isWindows) {
    libPath = '/Volumes/Projects/ssss/proto2ffil/examples/08_simd_operations/rust/target/release/simd_operations_ffi.dll';
  }

  return ffi.DynamicLibrary.open(libPath);
}

typedef I32ArraySumSimdFFI = ffi.Bool Function(ffi.Pointer<I32ArrayOps>, ffi.Pointer<I32ArrayOps>);
typedef I32ArraySumSimdDart = bool Function(ffi.Pointer<I32ArrayOps>, ffi.Pointer<I32ArrayOps>);
typedef U32ArraySumSimdFFI = ffi.Bool Function(ffi.Pointer<U32ArrayOps>, ffi.Pointer<U32ArrayOps>);
typedef U32ArraySumSimdDart = bool Function(ffi.Pointer<U32ArrayOps>, ffi.Pointer<U32ArrayOps>);
typedef F32ArraySumSimdFFI = ffi.Bool Function(ffi.Pointer<F32ArrayOps>, ffi.Pointer<F32ArrayOps>);
typedef F32ArraySumSimdDart = bool Function(ffi.Pointer<F32ArrayOps>, ffi.Pointer<F32ArrayOps>);
typedef F32ArrayMinMaxSimdFFI = ffi.Bool Function(ffi.Pointer<F32ArrayOps>, ffi.Pointer<F32ArrayOps>);
typedef F32ArrayMinMaxSimdDart = bool Function(ffi.Pointer<F32ArrayOps>, ffi.Pointer<F32ArrayOps>);
typedef F64ArraySumSimdFFI = ffi.Bool Function(ffi.Pointer<F64ArrayOps>, ffi.Pointer<F64ArrayOps>);
typedef F64ArraySumSimdDart = bool Function(ffi.Pointer<F64ArrayOps>, ffi.Pointer<F64ArrayOps>);
typedef F64ArrayMinMaxSimdFFI = ffi.Bool Function(ffi.Pointer<F64ArrayOps>, ffi.Pointer<F64ArrayOps>);
typedef F64ArrayMinMaxSimdDart = bool Function(ffi.Pointer<F64ArrayOps>, ffi.Pointer<F64ArrayOps>);

void main() {
  late ffi.DynamicLibrary dylib;
  late I32ArraySumSimdDart i32ArraySumSimd;
  late U32ArraySumSimdDart u32ArraySumSimd;
  late F32ArraySumSimdDart f32ArraySumSimd;
  late F32ArrayMinMaxSimdDart f32ArrayMinMaxSimd;
  late F64ArraySumSimdDart f64ArraySumSimd;
  late F64ArrayMinMaxSimdDart f64ArrayMinMaxSimd;

  setUpAll(() {
    dylib = loadLibrary();
    i32ArraySumSimd = dylib.lookup<ffi.NativeFunction<I32ArraySumSimdFFI>>('i32_array_sum_simd').asFunction();
    u32ArraySumSimd = dylib.lookup<ffi.NativeFunction<U32ArraySumSimdFFI>>('u32_array_sum_simd').asFunction();
    f32ArraySumSimd = dylib.lookup<ffi.NativeFunction<F32ArraySumSimdFFI>>('f32_array_sum_simd').asFunction();
    f32ArrayMinMaxSimd = dylib.lookup<ffi.NativeFunction<F32ArrayMinMaxSimdFFI>>('f32_array_min_max_simd').asFunction();
    f64ArraySumSimd = dylib.lookup<ffi.NativeFunction<F64ArraySumSimdFFI>>('f64_array_sum_simd').asFunction();
    f64ArrayMinMaxSimd = dylib.lookup<ffi.NativeFunction<F64ArrayMinMaxSimdFFI>>('f64_array_min_max_simd').asFunction();
  });

  group('Overflow Behavior Tests', () {
    test('i32 overflow with wrapping addition', () {
      final data = calloc<ffi.Int32>(4);
      data[0] = 2147483647;
      data[1] = 1;
      data[2] = 100;
      data[3] = 200;

      final input = calloc<I32ArrayOps>();
      input.ref.data = data;
      input.ref.count = 4;

      final result = calloc<I32ArrayOps>();

      expect(i32ArraySumSimd(input, result), true);

      final expectedSum = (2147483647 + 1 + 100 + 200) & 0xFFFFFFFF;
      print('i32 overflow test: sum = ${result.ref.sum}, expected wrapping sum = $expectedSum');

      calloc.free(data);
      calloc.free(input);
      calloc.free(result);
    });

    test('u32 overflow with wrapping addition', () {
      final data = calloc<ffi.Uint32>(4);
      data[0] = 4294967295;
      data[1] = 1;
      data[2] = 100;
      data[3] = 200;

      final input = calloc<U32ArrayOps>();
      input.ref.data = data;
      input.ref.count = 4;

      final result = calloc<U32ArrayOps>();

      expect(u32ArraySumSimd(input, result), true);

      print('u32 overflow test: sum = ${result.ref.sum}');

      calloc.free(data);
      calloc.free(input);
      calloc.free(result);
    });

    test('i32 multiple overflows in large array', () {
      final size = 1000;
      final data = calloc<ffi.Int32>(size);
      for (var i = 0; i < size; i++) {
        data[i] = 2147483647;
      }

      final input = calloc<I32ArrayOps>();
      input.ref.data = data;
      input.ref.count = size;

      final result = calloc<I32ArrayOps>();

      expect(i32ArraySumSimd(input, result), true);

      print('i32 large array overflow test: sum = ${result.ref.sum}');

      calloc.free(data);
      calloc.free(input);
      calloc.free(result);
    });
  });

  group('Unaligned Array Size Tests', () {
    final unalignedSizes = [1, 3, 5, 7, 9, 11, 13, 15, 17, 23, 31, 63, 127, 255, 257, 511, 1023, 1025];

    test('i32 unaligned sizes correctness', () {
      print('\n=== i32 Unaligned Size Tests ===');

      for (var size in unalignedSizes) {
        final data = calloc<ffi.Int32>(size);
        var expected = 0;
        for (var i = 0; i < size; i++) {
          data[i] = i + 1;
          expected = (expected + i + 1) & 0xFFFFFFFF;
        }

        final input = calloc<I32ArrayOps>();
        input.ref.data = data;
        input.ref.count = size;

        final result = calloc<I32ArrayOps>();

        expect(i32ArraySumSimd(input, result), true);

        print('Size $size: sum = ${result.ref.sum}, expected = $expected');
        expect(result.ref.sum, expected);

        calloc.free(data);
        calloc.free(input);
        calloc.free(result);
      }
    });

    test('u32 unaligned sizes correctness', () {
      print('\n=== u32 Unaligned Size Tests ===');

      for (var size in unalignedSizes) {
        final data = calloc<ffi.Uint32>(size);
        var expected = 0;
        for (var i = 0; i < size; i++) {
          data[i] = i + 1;
          expected = (expected + i + 1) & 0xFFFFFFFF;
        }

        final input = calloc<U32ArrayOps>();
        input.ref.data = data;
        input.ref.count = size;

        final result = calloc<U32ArrayOps>();

        expect(u32ArraySumSimd(input, result), true);

        print('Size $size: sum = ${result.ref.sum}, expected = $expected');
        expect(result.ref.sum, expected);

        calloc.free(data);
        calloc.free(input);
        calloc.free(result);
      }
    });
  });

  group('NaN Propagation Tests', () {
    test('f32 single NaN at start', () {
      final data = calloc<ffi.Float>(8);
      data[0] = double.nan;
      for (var i = 1; i < 8; i++) {
        data[i] = i.toDouble();
      }

      final input = calloc<F32ArrayOps>();
      input.ref.data = data;
      input.ref.count = 8;

      final result = calloc<F32ArrayOps>();

      expect(f32ArraySumSimd(input, result), true);
      expect(result.ref.has_nan, 1);
      print('f32 NaN at start: has_nan = ${result.ref.has_nan}, sum = ${result.ref.sum}');

      calloc.free(data);
      calloc.free(input);
      calloc.free(result);
    });

    test('f32 single NaN at end', () {
      final data = calloc<ffi.Float>(8);
      for (var i = 0; i < 7; i++) {
        data[i] = i.toDouble();
      }
      data[7] = double.nan;

      final input = calloc<F32ArrayOps>();
      input.ref.data = data;
      input.ref.count = 8;

      final result = calloc<F32ArrayOps>();

      expect(f32ArraySumSimd(input, result), true);
      expect(result.ref.has_nan, 1);
      print('f32 NaN at end: has_nan = ${result.ref.has_nan}');

      calloc.free(data);
      calloc.free(input);
      calloc.free(result);
    });

    test('f32 multiple NaN values', () {
      final data = calloc<ffi.Float>(10);
      data[0] = 1.0;
      data[1] = double.nan;
      data[2] = 3.0;
      data[3] = double.nan;
      data[4] = 5.0;
      data[5] = double.nan;
      data[6] = 7.0;
      data[7] = 8.0;
      data[8] = double.nan;
      data[9] = 10.0;

      final input = calloc<F32ArrayOps>();
      input.ref.data = data;
      input.ref.count = 10;

      final result = calloc<F32ArrayOps>();

      expect(f32ArraySumSimd(input, result), true);
      expect(result.ref.has_nan, 1);
      print('f32 multiple NaN: has_nan = ${result.ref.has_nan}');

      calloc.free(data);
      calloc.free(input);
      calloc.free(result);
    });

    test('f64 NaN detection', () {
      final data = calloc<ffi.Double>(8);
      data[0] = 1.0;
      data[1] = 2.0;
      data[2] = double.nan;
      data[3] = 4.0;
      data[4] = 5.0;
      data[5] = 6.0;
      data[6] = 7.0;
      data[7] = 8.0;

      final input = calloc<F64ArrayOps>();
      input.ref.data = data;
      input.ref.count = 8;

      final result = calloc<F64ArrayOps>();

      expect(f64ArraySumSimd(input, result), true);
      expect(result.ref.has_nan, 1);
      print('f64 NaN detection: has_nan = ${result.ref.has_nan}');

      calloc.free(data);
      calloc.free(input);
      calloc.free(result);
    });

    test('f32 min/max with NaN should ignore NaN', () {
      final data = calloc<ffi.Float>(8);
      data[0] = 5.0;
      data[1] = double.nan;
      data[2] = -10.0;
      data[3] = 100.0;
      data[4] = double.nan;
      data[5] = 0.0;
      data[6] = -50.0;
      data[7] = 75.0;

      final input = calloc<F32ArrayOps>();
      input.ref.data = data;
      input.ref.count = 8;

      final result = calloc<F32ArrayOps>();

      expect(f32ArrayMinMaxSimd(input, result), true);
      expect(result.ref.has_nan, 1);
      expect(result.ref.min, closeTo(-50.0, 0.01));
      expect(result.ref.max, closeTo(100.0, 0.01));
      print('f32 min/max with NaN: min = ${result.ref.min}, max = ${result.ref.max}');

      calloc.free(data);
      calloc.free(input);
      calloc.free(result);
    });
  });

  group('Infinity Handling Tests', () {
    test('f32 positive infinity', () {
      final data = calloc<ffi.Float>(8);
      data[0] = 1.0;
      data[1] = double.infinity;
      data[2] = 3.0;
      for (var i = 3; i < 8; i++) {
        data[i] = i.toDouble();
      }

      final input = calloc<F32ArrayOps>();
      input.ref.data = data;
      input.ref.count = 8;

      final result = calloc<F32ArrayOps>();

      expect(f32ArraySumSimd(input, result), true);
      expect(result.ref.has_infinity, 1);
      expect(result.ref.sum.isInfinite, true);
      print('f32 positive infinity: has_infinity = ${result.ref.has_infinity}, sum = ${result.ref.sum}');

      calloc.free(data);
      calloc.free(input);
      calloc.free(result);
    });

    test('f32 negative infinity', () {
      final data = calloc<ffi.Float>(8);
      data[0] = 1.0;
      data[1] = double.negativeInfinity;
      for (var i = 2; i < 8; i++) {
        data[i] = i.toDouble();
      }

      final input = calloc<F32ArrayOps>();
      input.ref.data = data;
      input.ref.count = 8;

      final result = calloc<F32ArrayOps>();

      expect(f32ArraySumSimd(input, result), true);
      expect(result.ref.has_infinity, 1);
      expect(result.ref.sum.isInfinite, true);
      print('f32 negative infinity: has_infinity = ${result.ref.has_infinity}, sum = ${result.ref.sum}');

      calloc.free(data);
      calloc.free(input);
      calloc.free(result);
    });

    test('f32 both positive and negative infinity', () {
      final data = calloc<ffi.Float>(4);
      data[0] = double.infinity;
      data[1] = double.negativeInfinity;
      data[2] = 10.0;
      data[3] = 20.0;

      final input = calloc<F32ArrayOps>();
      input.ref.data = data;
      input.ref.count = 4;

      final result = calloc<F32ArrayOps>();

      expect(f32ArraySumSimd(input, result), true);
      expect(result.ref.has_infinity, 1);
      print('f32 both infinities: has_infinity = ${result.ref.has_infinity}, sum = ${result.ref.sum}, is_nan = ${result.ref.sum.isNaN}');

      calloc.free(data);
      calloc.free(input);
      calloc.free(result);
    });

    test('f64 infinity detection', () {
      final data = calloc<ffi.Double>(8);
      data[0] = 1.0;
      data[1] = 2.0;
      data[2] = 3.0;
      data[3] = double.infinity;
      data[4] = 5.0;
      data[5] = 6.0;
      data[6] = 7.0;
      data[7] = 8.0;

      final input = calloc<F64ArrayOps>();
      input.ref.data = data;
      input.ref.count = 8;

      final result = calloc<F64ArrayOps>();

      expect(f64ArraySumSimd(input, result), true);
      expect(result.ref.has_infinity, 1);
      expect(result.ref.sum.isInfinite, true);
      print('f64 infinity detection: has_infinity = ${result.ref.has_infinity}');

      calloc.free(data);
      calloc.free(input);
      calloc.free(result);
    });

    test('f32 min/max with infinity', () {
      final data = calloc<ffi.Float>(8);
      data[0] = 5.0;
      data[1] = double.infinity;
      data[2] = -10.0;
      data[3] = 100.0;
      data[4] = double.negativeInfinity;
      data[5] = 0.0;
      data[6] = -50.0;
      data[7] = 75.0;

      final input = calloc<F32ArrayOps>();
      input.ref.data = data;
      input.ref.count = 8;

      final result = calloc<F32ArrayOps>();

      expect(f32ArrayMinMaxSimd(input, result), true);
      expect(result.ref.has_infinity, 1);
      expect(result.ref.min, double.negativeInfinity);
      expect(result.ref.max, double.infinity);
      print('f32 min/max with infinity: min = ${result.ref.min}, max = ${result.ref.max}');

      calloc.free(data);
      calloc.free(input);
      calloc.free(result);
    });

    test('f64 min/max with infinity', () {
      final data = calloc<ffi.Double>(5);
      data[0] = 1.0;
      data[1] = double.infinity;
      data[2] = -100.0;
      data[3] = 50.0;
      data[4] = double.negativeInfinity;

      final input = calloc<F64ArrayOps>();
      input.ref.data = data;
      input.ref.count = 5;

      final result = calloc<F64ArrayOps>();

      expect(f64ArrayMinMaxSimd(input, result), true);
      expect(result.ref.has_infinity, 1);
      expect(result.ref.min, double.negativeInfinity);
      expect(result.ref.max, double.infinity);
      print('f64 min/max with infinity: min = ${result.ref.min}, max = ${result.ref.max}');

      calloc.free(data);
      calloc.free(input);
      calloc.free(result);
    });
  });

  group('Combined Edge Cases', () {
    test('f32 with NaN, Infinity, and normal values', () {
      final data = calloc<ffi.Float>(10);
      data[0] = 1.0;
      data[1] = double.nan;
      data[2] = double.infinity;
      data[3] = -10.0;
      data[4] = 100.0;
      data[5] = double.negativeInfinity;
      data[6] = 0.0;
      data[7] = double.nan;
      data[8] = -50.0;
      data[9] = 75.0;

      final input = calloc<F32ArrayOps>();
      input.ref.data = data;
      input.ref.count = 10;

      final result = calloc<F32ArrayOps>();

      expect(f32ArraySumSimd(input, result), true);
      expect(result.ref.has_nan, 1);
      expect(result.ref.has_infinity, 1);
      print('f32 combined edge cases: has_nan = ${result.ref.has_nan}, has_infinity = ${result.ref.has_infinity}');

      calloc.free(data);
      calloc.free(input);
      calloc.free(result);
    });

    test('f64 with NaN, Infinity, and normal values', () {
      final data = calloc<ffi.Double>(8);
      data[0] = double.nan;
      data[1] = 2.0;
      data[2] = double.infinity;
      data[3] = 4.0;
      data[4] = 5.0;
      data[5] = double.negativeInfinity;
      data[6] = 7.0;
      data[7] = double.nan;

      final input = calloc<F64ArrayOps>();
      input.ref.data = data;
      input.ref.count = 8;

      final result = calloc<F64ArrayOps>();

      expect(f64ArraySumSimd(input, result), true);
      expect(result.ref.has_nan, 1);
      expect(result.ref.has_infinity, 1);
      print('f64 combined edge cases: has_nan = ${result.ref.has_nan}, has_infinity = ${result.ref.has_infinity}');

      calloc.free(data);
      calloc.free(input);
      calloc.free(result);
    });
  });

  group('Zero and Empty Array Tests', () {
    test('i32 all zeros', () {
      final data = calloc<ffi.Int32>(100);
      for (var i = 0; i < 100; i++) {
        data[i] = 0;
      }

      final input = calloc<I32ArrayOps>();
      input.ref.data = data;
      input.ref.count = 100;

      final result = calloc<I32ArrayOps>();

      expect(i32ArraySumSimd(input, result), true);
      expect(result.ref.sum, 0);

      calloc.free(data);
      calloc.free(input);
      calloc.free(result);
    });

    test('f32 all zeros', () {
      final data = calloc<ffi.Float>(100);
      for (var i = 0; i < 100; i++) {
        data[i] = 0.0;
      }

      final input = calloc<F32ArrayOps>();
      input.ref.data = data;
      input.ref.count = 100;

      final result = calloc<F32ArrayOps>();

      expect(f32ArraySumSimd(input, result), true);
      expect(result.ref.sum, 0.0);
      expect(result.ref.has_nan, 0);
      expect(result.ref.has_infinity, 0);

      calloc.free(data);
      calloc.free(input);
      calloc.free(result);
    });
  });
}
