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

typedef I32ArraySumSimdFFI = ffi.Bool Function(
    ffi.Pointer<I32ArrayOps>, ffi.Pointer<I32ArrayOps>);
typedef I32ArraySumSimdDart = bool Function(
    ffi.Pointer<I32ArrayOps>, ffi.Pointer<I32ArrayOps>);

typedef I32ArraySumScalarFFI = ffi.Bool Function(
    ffi.Pointer<I32ArrayOps>, ffi.Pointer<I32ArrayOps>);
typedef I32ArraySumScalarDart = bool Function(
    ffi.Pointer<I32ArrayOps>, ffi.Pointer<I32ArrayOps>);

typedef I32ArrayMinMaxSimdFFI = ffi.Bool Function(
    ffi.Pointer<I32ArrayOps>, ffi.Pointer<I32ArrayOps>);
typedef I32ArrayMinMaxSimdDart = bool Function(
    ffi.Pointer<I32ArrayOps>, ffi.Pointer<I32ArrayOps>);

typedef I32ArrayAverageSimdFFI = ffi.Bool Function(
    ffi.Pointer<I32ArrayOps>, ffi.Pointer<I32ArrayOps>);
typedef I32ArrayAverageSimdDart = bool Function(
    ffi.Pointer<I32ArrayOps>, ffi.Pointer<I32ArrayOps>);

typedef U32ArraySumSimdFFI = ffi.Bool Function(
    ffi.Pointer<U32ArrayOps>, ffi.Pointer<U32ArrayOps>);
typedef U32ArraySumSimdDart = bool Function(
    ffi.Pointer<U32ArrayOps>, ffi.Pointer<U32ArrayOps>);

typedef U32ArrayMinMaxSimdFFI = ffi.Bool Function(
    ffi.Pointer<U32ArrayOps>, ffi.Pointer<U32ArrayOps>);
typedef U32ArrayMinMaxSimdDart = bool Function(
    ffi.Pointer<U32ArrayOps>, ffi.Pointer<U32ArrayOps>);

typedef I64ArraySumSimdFFI = ffi.Bool Function(
    ffi.Pointer<I64ArrayOps>, ffi.Pointer<I64ArrayOps>);
typedef I64ArraySumSimdDart = bool Function(
    ffi.Pointer<I64ArrayOps>, ffi.Pointer<I64ArrayOps>);

typedef I64ArrayMinMaxSimdFFI = ffi.Bool Function(
    ffi.Pointer<I64ArrayOps>, ffi.Pointer<I64ArrayOps>);
typedef I64ArrayMinMaxSimdDart = bool Function(
    ffi.Pointer<I64ArrayOps>, ffi.Pointer<I64ArrayOps>);

typedef U64ArraySumSimdFFI = ffi.Bool Function(
    ffi.Pointer<U64ArrayOps>, ffi.Pointer<U64ArrayOps>);
typedef U64ArraySumSimdDart = bool Function(
    ffi.Pointer<U64ArrayOps>, ffi.Pointer<U64ArrayOps>);

typedef F32ArraySumSimdFFI = ffi.Bool Function(
    ffi.Pointer<F32ArrayOps>, ffi.Pointer<F32ArrayOps>);
typedef F32ArraySumSimdDart = bool Function(
    ffi.Pointer<F32ArrayOps>, ffi.Pointer<F32ArrayOps>);

typedef F32ArrayMinMaxSimdFFI = ffi.Bool Function(
    ffi.Pointer<F32ArrayOps>, ffi.Pointer<F32ArrayOps>);
typedef F32ArrayMinMaxSimdDart = bool Function(
    ffi.Pointer<F32ArrayOps>, ffi.Pointer<F32ArrayOps>);

typedef F64ArraySumSimdFFI = ffi.Bool Function(
    ffi.Pointer<F64ArrayOps>, ffi.Pointer<F64ArrayOps>);
typedef F64ArraySumSimdDart = bool Function(
    ffi.Pointer<F64ArrayOps>, ffi.Pointer<F64ArrayOps>);

typedef F64ArrayMinMaxSimdFFI = ffi.Bool Function(
    ffi.Pointer<F64ArrayOps>, ffi.Pointer<F64ArrayOps>);
typedef F64ArrayMinMaxSimdDart = bool Function(
    ffi.Pointer<F64ArrayOps>, ffi.Pointer<F64ArrayOps>);

void main() {
  late ffi.DynamicLibrary dylib;
  late I32ArraySumSimdDart i32ArraySumSimd;
  late I32ArraySumScalarDart i32ArraySumScalar;
  late I32ArrayMinMaxSimdDart i32ArrayMinMaxSimd;
  late I32ArrayAverageSimdDart i32ArrayAverageSimd;
  late U32ArraySumSimdDart u32ArraySumSimd;
  late U32ArrayMinMaxSimdDart u32ArrayMinMaxSimd;
  late I64ArraySumSimdDart i64ArraySumSimd;
  late I64ArrayMinMaxSimdDart i64ArrayMinMaxSimd;
  late U64ArraySumSimdDart u64ArraySumSimd;
  late F32ArraySumSimdDart f32ArraySumSimd;
  late F32ArrayMinMaxSimdDart f32ArrayMinMaxSimd;
  late F64ArraySumSimdDart f64ArraySumSimd;
  late F64ArrayMinMaxSimdDart f64ArrayMinMaxSimd;

  setUpAll(() {
    dylib = loadLibrary();
    i32ArraySumSimd = dylib
        .lookup<ffi.NativeFunction<I32ArraySumSimdFFI>>('i32_array_sum_simd')
        .asFunction();
    i32ArraySumScalar = dylib
        .lookup<ffi.NativeFunction<I32ArraySumScalarFFI>>(
            'i32_array_sum_scalar')
        .asFunction();
    i32ArrayMinMaxSimd = dylib
        .lookup<ffi.NativeFunction<I32ArrayMinMaxSimdFFI>>(
            'i32_array_min_max_simd')
        .asFunction();
    i32ArrayAverageSimd = dylib
        .lookup<ffi.NativeFunction<I32ArrayAverageSimdFFI>>(
            'i32_array_average_simd')
        .asFunction();
    u32ArraySumSimd = dylib
        .lookup<ffi.NativeFunction<U32ArraySumSimdFFI>>('u32_array_sum_simd')
        .asFunction();
    u32ArrayMinMaxSimd = dylib
        .lookup<ffi.NativeFunction<U32ArrayMinMaxSimdFFI>>(
            'u32_array_min_max_simd')
        .asFunction();
    i64ArraySumSimd = dylib
        .lookup<ffi.NativeFunction<I64ArraySumSimdFFI>>('i64_array_sum_simd')
        .asFunction();
    i64ArrayMinMaxSimd = dylib
        .lookup<ffi.NativeFunction<I64ArrayMinMaxSimdFFI>>(
            'i64_array_min_max_simd')
        .asFunction();
    u64ArraySumSimd = dylib
        .lookup<ffi.NativeFunction<U64ArraySumSimdFFI>>('u64_array_sum_simd')
        .asFunction();
    f32ArraySumSimd = dylib
        .lookup<ffi.NativeFunction<F32ArraySumSimdFFI>>('f32_array_sum_simd')
        .asFunction();
    f32ArrayMinMaxSimd = dylib
        .lookup<ffi.NativeFunction<F32ArrayMinMaxSimdFFI>>(
            'f32_array_min_max_simd')
        .asFunction();
    f64ArraySumSimd = dylib
        .lookup<ffi.NativeFunction<F64ArraySumSimdFFI>>('f64_array_sum_simd')
        .asFunction();
    f64ArrayMinMaxSimd = dylib
        .lookup<ffi.NativeFunction<F64ArrayMinMaxSimdFFI>>(
            'f64_array_min_max_simd')
        .asFunction();
  });

  group('i32 SIMD Operations', () {
    test('Sum small array (8 elements)', () {
      final data = calloc<ffi.Int32>(8);
      for (var i = 0; i < 8; i++) {
        data[i] = i + 1;
      }

      final input = calloc<I32ArrayOps>();
      input.ref.data = data;
      input.ref.count = 8;

      final result = calloc<I32ArrayOps>();

      expect(i32ArraySumSimd(input, result), true);
      expect(result.ref.sum, 36);

      calloc.free(data);
      calloc.free(input);
      calloc.free(result);
    });

    test('Sum unaligned array (7 elements)', () {
      final data = calloc<ffi.Int32>(7);
      for (var i = 0; i < 7; i++) {
        data[i] = 10;
      }

      final input = calloc<I32ArrayOps>();
      input.ref.data = data;
      input.ref.count = 7;

      final result = calloc<I32ArrayOps>();

      expect(i32ArraySumSimd(input, result), true);
      expect(result.ref.sum, 70);

      calloc.free(data);
      calloc.free(input);
      calloc.free(result);
    });

    test('Sum unaligned array (13 elements)', () {
      final data = calloc<ffi.Int32>(13);
      for (var i = 0; i < 13; i++) {
        data[i] = 5;
      }

      final input = calloc<I32ArrayOps>();
      input.ref.data = data;
      input.ref.count = 13;

      final result = calloc<I32ArrayOps>();

      expect(i32ArraySumSimd(input, result), true);
      expect(result.ref.sum, 65);

      calloc.free(data);
      calloc.free(input);
      calloc.free(result);
    });

    test('Sum medium array (1000 elements)', () {
      final data = calloc<ffi.Int32>(1000);
      for (var i = 0; i < 1000; i++) {
        data[i] = 1;
      }

      final input = calloc<I32ArrayOps>();
      input.ref.data = data;
      input.ref.count = 1000;

      final result = calloc<I32ArrayOps>();

      expect(i32ArraySumSimd(input, result), true);
      expect(result.ref.sum, 1000);

      calloc.free(data);
      calloc.free(input);
      calloc.free(result);
    });

    test('Sum unaligned medium array (1001 elements)', () {
      final data = calloc<ffi.Int32>(1001);
      for (var i = 0; i < 1001; i++) {
        data[i] = 2;
      }

      final input = calloc<I32ArrayOps>();
      input.ref.data = data;
      input.ref.count = 1001;

      final result = calloc<I32ArrayOps>();

      expect(i32ArraySumSimd(input, result), true);
      expect(result.ref.sum, 2002);

      calloc.free(data);
      calloc.free(input);
      calloc.free(result);
    });

    test('Min/Max operations', () {
      final data = calloc<ffi.Int32>(10);
      data[0] = 5;
      data[1] = -10;
      data[2] = 100;
      data[3] = 0;
      data[4] = 50;
      data[5] = -5;
      data[6] = 75;
      data[7] = 25;
      data[8] = -100;
      data[9] = 200;

      final input = calloc<I32ArrayOps>();
      input.ref.data = data;
      input.ref.count = 10;

      final result = calloc<I32ArrayOps>();

      expect(i32ArrayMinMaxSimd(input, result), true);
      expect(result.ref.min, -100);
      expect(result.ref.max, 200);

      calloc.free(data);
      calloc.free(input);
      calloc.free(result);
    });

    test('Average calculation', () {
      final data = calloc<ffi.Int32>(4);
      data[0] = 10;
      data[1] = 20;
      data[2] = 30;
      data[3] = 40;

      final input = calloc<I32ArrayOps>();
      input.ref.data = data;
      input.ref.count = 4;

      final result = calloc<I32ArrayOps>();

      expect(i32ArrayAverageSimd(input, result), true);
      expect(result.ref.sum, 100);
      expect(result.ref.average, closeTo(25.0, 0.01));

      calloc.free(data);
      calloc.free(input);
      calloc.free(result);
    });

    test('SIMD vs Scalar comparison', () {
      final data = calloc<ffi.Int32>(1000);
      for (var i = 0; i < 1000; i++) {
        data[i] = i;
      }

      final input = calloc<I32ArrayOps>();
      input.ref.data = data;
      input.ref.count = 1000;

      final simdResult = calloc<I32ArrayOps>();
      final scalarResult = calloc<I32ArrayOps>();

      expect(i32ArraySumSimd(input, simdResult), true);
      expect(i32ArraySumScalar(input, scalarResult), true);

      expect(simdResult.ref.sum, scalarResult.ref.sum);

      calloc.free(data);
      calloc.free(input);
      calloc.free(simdResult);
      calloc.free(scalarResult);
    });
  });

  group('u32 SIMD Operations', () {
    test('Sum small array', () {
      final data = calloc<ffi.Uint32>(8);
      for (var i = 0; i < 8; i++) {
        data[i] = i + 1;
      }

      final input = calloc<U32ArrayOps>();
      input.ref.data = data;
      input.ref.count = 8;

      final result = calloc<U32ArrayOps>();

      expect(u32ArraySumSimd(input, result), true);
      expect(result.ref.sum, 36);

      calloc.free(data);
      calloc.free(input);
      calloc.free(result);
    });

    test('Min/Max with large values', () {
      final data = calloc<ffi.Uint32>(5);
      data[0] = 1000000;
      data[1] = 5000000;
      data[2] = 100;
      data[3] = 4294967295;
      data[4] = 50;

      final input = calloc<U32ArrayOps>();
      input.ref.data = data;
      input.ref.count = 5;

      final result = calloc<U32ArrayOps>();

      expect(u32ArrayMinMaxSimd(input, result), true);
      expect(result.ref.min, 50);
      expect(result.ref.max, 4294967295);

      calloc.free(data);
      calloc.free(input);
      calloc.free(result);
    });
  });

  group('i64 SIMD Operations', () {
    test('Sum small array', () {
      final data = calloc<ffi.Int64>(8);
      for (var i = 0; i < 8; i++) {
        data[i] = i + 1;
      }

      final input = calloc<I64ArrayOps>();
      input.ref.data = data;
      input.ref.count = 8;

      final result = calloc<I64ArrayOps>();

      expect(i64ArraySumSimd(input, result), true);
      expect(result.ref.sum, 36);

      calloc.free(data);
      calloc.free(input);
      calloc.free(result);
    });

    test('Min/Max operations', () {
      final data = calloc<ffi.Int64>(5);
      data[0] = 1000000000000;
      data[1] = -1000000000000;
      data[2] = 0;
      data[3] = 5000000000000;
      data[4] = -5000000000000;

      final input = calloc<I64ArrayOps>();
      input.ref.data = data;
      input.ref.count = 5;

      final result = calloc<I64ArrayOps>();

      expect(i64ArrayMinMaxSimd(input, result), true);
      expect(result.ref.min, -5000000000000);
      expect(result.ref.max, 5000000000000);

      calloc.free(data);
      calloc.free(input);
      calloc.free(result);
    });
  });

  group('u64 SIMD Operations', () {
    test('Sum small array', () {
      final data = calloc<ffi.Uint64>(8);
      for (var i = 0; i < 8; i++) {
        data[i] = i + 1;
      }

      final input = calloc<U64ArrayOps>();
      input.ref.data = data;
      input.ref.count = 8;

      final result = calloc<U64ArrayOps>();

      expect(u64ArraySumSimd(input, result), true);
      expect(result.ref.sum, 36);

      calloc.free(data);
      calloc.free(input);
      calloc.free(result);
    });
  });

  group('f32 SIMD Operations with Edge Cases', () {
    test('Sum normal values', () {
      final data = calloc<ffi.Float>(8);
      for (var i = 0; i < 8; i++) {
        data[i] = (i + 1).toDouble();
      }

      final input = calloc<F32ArrayOps>();
      input.ref.data = data;
      input.ref.count = 8;

      final result = calloc<F32ArrayOps>();

      expect(f32ArraySumSimd(input, result), true);
      expect(result.ref.sum, closeTo(36.0, 0.01));
      expect(result.ref.has_nan, 0);
      expect(result.ref.has_infinity, 0);

      calloc.free(data);
      calloc.free(input);
      calloc.free(result);
    });

    test('Detect NaN values', () {
      final data = calloc<ffi.Float>(5);
      data[0] = 1.0;
      data[1] = 2.0;
      data[2] = double.nan;
      data[3] = 4.0;
      data[4] = 5.0;

      final input = calloc<F32ArrayOps>();
      input.ref.data = data;
      input.ref.count = 5;

      final result = calloc<F32ArrayOps>();

      expect(f32ArraySumSimd(input, result), true);
      expect(result.ref.has_nan, 1);

      calloc.free(data);
      calloc.free(input);
      calloc.free(result);
    });

    test('Detect Infinity values', () {
      final data = calloc<ffi.Float>(5);
      data[0] = 1.0;
      data[1] = double.infinity;
      data[2] = 3.0;
      data[3] = double.negativeInfinity;
      data[4] = 5.0;

      final input = calloc<F32ArrayOps>();
      input.ref.data = data;
      input.ref.count = 5;

      final result = calloc<F32ArrayOps>();

      expect(f32ArraySumSimd(input, result), true);
      expect(result.ref.has_infinity, 1);

      calloc.free(data);
      calloc.free(input);
      calloc.free(result);
    });

    test('Min/Max with NaN handling', () {
      final data = calloc<ffi.Float>(10);
      data[0] = 5.0;
      data[1] = -10.5;
      data[2] = 100.25;
      data[3] = 0.0;
      data[4] = double.nan;
      data[5] = -5.5;
      data[6] = 75.0;
      data[7] = 25.5;
      data[8] = -100.75;
      data[9] = 200.0;

      final input = calloc<F32ArrayOps>();
      input.ref.data = data;
      input.ref.count = 10;

      final result = calloc<F32ArrayOps>();

      expect(f32ArrayMinMaxSimd(input, result), true);
      expect(result.ref.min, closeTo(-100.75, 0.01));
      expect(result.ref.max, closeTo(200.0, 0.01));
      expect(result.ref.has_nan, 1);

      calloc.free(data);
      calloc.free(input);
      calloc.free(result);
    });
  });

  group('f64 SIMD Operations with Edge Cases', () {
    test('Sum normal values', () {
      final data = calloc<ffi.Double>(8);
      for (var i = 0; i < 8; i++) {
        data[i] = (i + 1).toDouble();
      }

      final input = calloc<F64ArrayOps>();
      input.ref.data = data;
      input.ref.count = 8;

      final result = calloc<F64ArrayOps>();

      expect(f64ArraySumSimd(input, result), true);
      expect(result.ref.sum, closeTo(36.0, 0.001));
      expect(result.ref.has_nan, 0);
      expect(result.ref.has_infinity, 0);

      calloc.free(data);
      calloc.free(input);
      calloc.free(result);
    });

    test('Detect NaN values', () {
      final data = calloc<ffi.Double>(5);
      data[0] = 1.0;
      data[1] = 2.0;
      data[2] = double.nan;
      data[3] = 4.0;
      data[4] = 5.0;

      final input = calloc<F64ArrayOps>();
      input.ref.data = data;
      input.ref.count = 5;

      final result = calloc<F64ArrayOps>();

      expect(f64ArraySumSimd(input, result), true);
      expect(result.ref.has_nan, 1);

      calloc.free(data);
      calloc.free(input);
      calloc.free(result);
    });

    test('Detect Infinity values', () {
      final data = calloc<ffi.Double>(5);
      data[0] = 1.0;
      data[1] = double.infinity;
      data[2] = 3.0;
      data[3] = double.negativeInfinity;
      data[4] = 5.0;

      final input = calloc<F64ArrayOps>();
      input.ref.data = data;
      input.ref.count = 5;

      final result = calloc<F64ArrayOps>();

      expect(f64ArraySumSimd(input, result), true);
      expect(result.ref.has_infinity, 1);

      calloc.free(data);
      calloc.free(input);
      calloc.free(result);
    });

    test('Min/Max operations', () {
      final data = calloc<ffi.Double>(5);
      data[0] = 1.123456789;
      data[1] = -1.987654321;
      data[2] = 0.0;
      data[3] = 5.555555555;
      data[4] = -5.999999999;

      final input = calloc<F64ArrayOps>();
      input.ref.data = data;
      input.ref.count = 5;

      final result = calloc<F64ArrayOps>();

      expect(f64ArrayMinMaxSimd(input, result), true);
      expect(result.ref.min, closeTo(-5.999999999, 0.0000001));
      expect(result.ref.max, closeTo(5.555555555, 0.0000001));

      calloc.free(data);
      calloc.free(input);
      calloc.free(result);
    });
  });

  group('Large Array Tests', () {
    test('i32 large array (1,000,000 elements)', () {
      final size = 1000000;
      final data = calloc<ffi.Int32>(size);
      for (var i = 0; i < size; i++) {
        data[i] = 1;
      }

      final input = calloc<I32ArrayOps>();
      input.ref.data = data;
      input.ref.count = size;

      final result = calloc<I32ArrayOps>();

      final sw = Stopwatch()..start();
      expect(i32ArraySumSimd(input, result), true);
      sw.stop();

      print('Large array (1M elements) sum: ${result.ref.sum}, time: ${sw.elapsedMicroseconds}μs');
      expect(result.ref.sum, size);

      calloc.free(data);
      calloc.free(input);
      calloc.free(result);
    });

    test('f32 large array (1,000,000 elements)', () {
      final size = 1000000;
      final data = calloc<ffi.Float>(size);
      for (var i = 0; i < size; i++) {
        data[i] = 1.0;
      }

      final input = calloc<F32ArrayOps>();
      input.ref.data = data;
      input.ref.count = size;

      final result = calloc<F32ArrayOps>();

      final sw = Stopwatch()..start();
      expect(f32ArraySumSimd(input, result), true);
      sw.stop();

      print('Large f32 array (1M elements) sum: ${result.ref.sum}, time: ${sw.elapsedMicroseconds}μs');
      expect(result.ref.sum, closeTo(size.toDouble(), 1.0));

      calloc.free(data);
      calloc.free(input);
      calloc.free(result);
    });
  });

  group('Performance Benchmarks', () {
    test('Benchmark i32 sum: SIMD vs Scalar', () {
      final size = 100000;
      final data = calloc<ffi.Int32>(size);
      for (var i = 0; i < size; i++) {
        data[i] = i % 1000;
      }

      final input = calloc<I32ArrayOps>();
      input.ref.data = data;
      input.ref.count = size;

      final simdResult = calloc<I32ArrayOps>();
      final scalarResult = calloc<I32ArrayOps>();

      final iterations = 100;

      var simdTime = 0;
      for (var i = 0; i < iterations; i++) {
        final sw = Stopwatch()..start();
        i32ArraySumSimd(input, simdResult);
        sw.stop();
        simdTime += sw.elapsedMicroseconds;
      }

      var scalarTime = 0;
      for (var i = 0; i < iterations; i++) {
        final sw = Stopwatch()..start();
        i32ArraySumScalar(input, scalarResult);
        sw.stop();
        scalarTime += sw.elapsedMicroseconds;
      }

      final simdAvg = simdTime / iterations;
      final scalarAvg = scalarTime / iterations;
      final speedup = scalarAvg / simdAvg;

      print('\n=== i32 Sum Benchmark (100K elements, $iterations iterations) ===');
      print('SIMD average: ${simdAvg.toStringAsFixed(2)}μs');
      print('Scalar average: ${scalarAvg.toStringAsFixed(2)}μs');
      print('Speedup: ${speedup.toStringAsFixed(2)}x');

      expect(simdResult.ref.sum, scalarResult.ref.sum);

      calloc.free(data);
      calloc.free(input);
      calloc.free(simdResult);
      calloc.free(scalarResult);
    });

    test('Benchmark f32 operations with different sizes', () {
      final sizes = [8, 100, 1000, 10000];

      for (var size in sizes) {
        final data = calloc<ffi.Float>(size);
        for (var i = 0; i < size; i++) {
          data[i] = i.toDouble();
        }

        final input = calloc<F32ArrayOps>();
        input.ref.data = data;
        input.ref.count = size;

        final result = calloc<F32ArrayOps>();

        final iterations = 1000;
        final sw = Stopwatch()..start();

        for (var i = 0; i < iterations; i++) {
          f32ArraySumSimd(input, result);
        }

        sw.stop();
        final avg = sw.elapsedMicroseconds / iterations;

        print('f32 sum ($size elements): ${avg.toStringAsFixed(3)}μs');

        calloc.free(data);
        calloc.free(input);
        calloc.free(result);
      }
    });
  });
}
