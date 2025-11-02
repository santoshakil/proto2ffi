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
typedef I32ArraySumScalarFFI = ffi.Bool Function(ffi.Pointer<I32ArrayOps>, ffi.Pointer<I32ArrayOps>);
typedef I32ArraySumScalarDart = bool Function(ffi.Pointer<I32ArrayOps>, ffi.Pointer<I32ArrayOps>);
typedef I32ArrayMinMaxSimdFFI = ffi.Bool Function(ffi.Pointer<I32ArrayOps>, ffi.Pointer<I32ArrayOps>);
typedef I32ArrayMinMaxSimdDart = bool Function(ffi.Pointer<I32ArrayOps>, ffi.Pointer<I32ArrayOps>);

typedef I64ArraySumSimdFFI = ffi.Bool Function(ffi.Pointer<I64ArrayOps>, ffi.Pointer<I64ArrayOps>);
typedef I64ArraySumSimdDart = bool Function(ffi.Pointer<I64ArrayOps>, ffi.Pointer<I64ArrayOps>);

typedef U32ArraySumSimdFFI = ffi.Bool Function(ffi.Pointer<U32ArrayOps>, ffi.Pointer<U32ArrayOps>);
typedef U32ArraySumSimdDart = bool Function(ffi.Pointer<U32ArrayOps>, ffi.Pointer<U32ArrayOps>);
typedef U32ArraySumScalarFFI = ffi.Bool Function(ffi.Pointer<U32ArrayOps>, ffi.Pointer<U32ArrayOps>);
typedef U32ArraySumScalarDart = bool Function(ffi.Pointer<U32ArrayOps>, ffi.Pointer<U32ArrayOps>);

typedef U64ArraySumSimdFFI = ffi.Bool Function(ffi.Pointer<U64ArrayOps>, ffi.Pointer<U64ArrayOps>);
typedef U64ArraySumSimdDart = bool Function(ffi.Pointer<U64ArrayOps>, ffi.Pointer<U64ArrayOps>);

typedef F32ArraySumSimdFFI = ffi.Bool Function(ffi.Pointer<F32ArrayOps>, ffi.Pointer<F32ArrayOps>);
typedef F32ArraySumSimdDart = bool Function(ffi.Pointer<F32ArrayOps>, ffi.Pointer<F32ArrayOps>);

typedef F64ArraySumSimdFFI = ffi.Bool Function(ffi.Pointer<F64ArrayOps>, ffi.Pointer<F64ArrayOps>);
typedef F64ArraySumSimdDart = bool Function(ffi.Pointer<F64ArrayOps>, ffi.Pointer<F64ArrayOps>);

class BenchmarkResults {
  final String type;
  final String operation;
  final int size;
  final double simdTime;
  final double scalarTime;
  final double speedup;
  final int throughput;

  BenchmarkResults(this.type, this.operation, this.size, this.simdTime, this.scalarTime)
      : speedup = scalarTime / simdTime,
        throughput = simdTime > 0 ? (size / simdTime * 1000000).round() : 0;
}

void main() {
  late ffi.DynamicLibrary dylib;
  late I32ArraySumSimdDart i32ArraySumSimd;
  late I32ArraySumScalarDart i32ArraySumScalar;
  late I32ArrayMinMaxSimdDart i32ArrayMinMaxSimd;
  late I64ArraySumSimdDart i64ArraySumSimd;
  late U32ArraySumSimdDart u32ArraySumSimd;
  late U32ArraySumScalarDart u32ArraySumScalar;
  late U64ArraySumSimdDart u64ArraySumSimd;
  late F32ArraySumSimdDart f32ArraySumSimd;
  late F64ArraySumSimdDart f64ArraySumSimd;

  final allResults = <BenchmarkResults>[];

  setUpAll(() {
    dylib = loadLibrary();
    i32ArraySumSimd = dylib.lookup<ffi.NativeFunction<I32ArraySumSimdFFI>>('i32_array_sum_simd').asFunction();
    i32ArraySumScalar = dylib.lookup<ffi.NativeFunction<I32ArraySumScalarFFI>>('i32_array_sum_scalar').asFunction();
    i32ArrayMinMaxSimd = dylib.lookup<ffi.NativeFunction<I32ArrayMinMaxSimdFFI>>('i32_array_min_max_simd').asFunction();
    i64ArraySumSimd = dylib.lookup<ffi.NativeFunction<I64ArraySumSimdFFI>>('i64_array_sum_simd').asFunction();
    u32ArraySumSimd = dylib.lookup<ffi.NativeFunction<U32ArraySumSimdFFI>>('u32_array_sum_simd').asFunction();
    u32ArraySumScalar = dylib.lookup<ffi.NativeFunction<U32ArraySumScalarFFI>>('i32_array_sum_scalar').asFunction();
    u64ArraySumSimd = dylib.lookup<ffi.NativeFunction<U64ArraySumSimdFFI>>('u64_array_sum_simd').asFunction();
    f32ArraySumSimd = dylib.lookup<ffi.NativeFunction<F32ArraySumSimdFFI>>('f32_array_sum_simd').asFunction();
    f64ArraySumSimd = dylib.lookup<ffi.NativeFunction<F64ArraySumSimdFFI>>('f64_array_sum_simd').asFunction();
  });

  group('Comprehensive Benchmarks - All Types, All Sizes', () {
    final sizes = [8, 64, 1000, 10000, 100000, 1000000, 10000000];

    int getIterations(int size) {
      if (size <= 100) return 1000;
      if (size <= 10000) return 500;
      if (size <= 100000) return 100;
      return 50;
    }

    test('i32 Sum Benchmark', () {
      print('\n=== i32 Sum Benchmarks ===');

      for (var size in sizes) {
        final iterations = getIterations(size);
        final data = calloc<ffi.Int32>(size);
        for (var i = 0; i < size; i++) {
          data[i] = i % 100;
        }

        final input = calloc<I32ArrayOps>();
        input.ref.data = data;
        input.ref.count = size;

        final simdResult = calloc<I32ArrayOps>();
        final scalarResult = calloc<I32ArrayOps>();

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
        final throughput = simdAvg > 0 ? (size / simdAvg * 1000000).round() : 0;

        print('Size: ${size.toString().padLeft(10)} | SIMD: ${simdAvg.toStringAsFixed(3).padLeft(10)}μs | Scalar: ${scalarAvg.toStringAsFixed(3).padLeft(10)}μs | Speedup: ${speedup.toStringAsFixed(2)}x | Throughput: ${throughput} elem/s');

        allResults.add(BenchmarkResults('i32', 'sum', size, simdAvg, scalarAvg));

        expect(simdResult.ref.sum, scalarResult.ref.sum);

        calloc.free(data);
        calloc.free(input);
        calloc.free(simdResult);
        calloc.free(scalarResult);
      }
    });

    test('i64 Sum Benchmark', () {
      print('\n=== i64 Sum Benchmarks ===');

      for (var size in sizes) {
        final iterations = getIterations(size);
        final data = calloc<ffi.Int64>(size);
        for (var i = 0; i < size; i++) {
          data[i] = i % 100;
        }

        final input = calloc<I64ArrayOps>();
        input.ref.data = data;
        input.ref.count = size;

        final result = calloc<I64ArrayOps>();

        var totalTime = 0;
        for (var i = 0; i < iterations; i++) {
          final sw = Stopwatch()..start();
          i64ArraySumSimd(input, result);
          sw.stop();
          totalTime += sw.elapsedMicroseconds;
        }

        final avg = totalTime / iterations;
        final throughput = avg > 0 ? (size / avg * 1000000).round() : 0;

        print('Size: ${size.toString().padLeft(10)} | SIMD: ${avg.toStringAsFixed(3).padLeft(10)}μs | Throughput: ${throughput} elem/s');

        calloc.free(data);
        calloc.free(input);
        calloc.free(result);
      }
    });

    test('u32 Sum Benchmark', () {
      print('\n=== u32 Sum Benchmarks ===');

      for (var size in sizes) {
        final iterations = getIterations(size);
        final data = calloc<ffi.Uint32>(size);
        for (var i = 0; i < size; i++) {
          data[i] = i % 100;
        }

        final input = calloc<U32ArrayOps>();
        input.ref.data = data;
        input.ref.count = size;

        final simdResult = calloc<U32ArrayOps>();
        final scalarResult = calloc<U32ArrayOps>();

        var simdTime = 0;
        for (var i = 0; i < iterations; i++) {
          final sw = Stopwatch()..start();
          u32ArraySumSimd(input, simdResult);
          sw.stop();
          simdTime += sw.elapsedMicroseconds;
        }

        var scalarTime = 0;
        for (var i = 0; i < iterations; i++) {
          final sw = Stopwatch()..start();
          u32ArraySumScalar(input, scalarResult);
          sw.stop();
          scalarTime += sw.elapsedMicroseconds;
        }

        final simdAvg = simdTime / iterations;
        final scalarAvg = scalarTime / iterations;
        final speedup = scalarAvg / simdAvg;
        final throughput = simdAvg > 0 ? (size / simdAvg * 1000000).round() : 0;

        print('Size: ${size.toString().padLeft(10)} | SIMD: ${simdAvg.toStringAsFixed(3).padLeft(10)}μs | Scalar: ${scalarAvg.toStringAsFixed(3).padLeft(10)}μs | Speedup: ${speedup.toStringAsFixed(2)}x | Throughput: ${throughput} elem/s');

        allResults.add(BenchmarkResults('u32', 'sum', size, simdAvg, scalarAvg));

        expect(simdResult.ref.sum, scalarResult.ref.sum);

        calloc.free(data);
        calloc.free(input);
        calloc.free(simdResult);
        calloc.free(scalarResult);
      }
    });

    test('u64 Sum Benchmark', () {
      print('\n=== u64 Sum Benchmarks ===');

      for (var size in sizes) {
        final iterations = getIterations(size);
        final data = calloc<ffi.Uint64>(size);
        for (var i = 0; i < size; i++) {
          data[i] = i % 100;
        }

        final input = calloc<U64ArrayOps>();
        input.ref.data = data;
        input.ref.count = size;

        final result = calloc<U64ArrayOps>();

        var totalTime = 0;
        for (var i = 0; i < iterations; i++) {
          final sw = Stopwatch()..start();
          u64ArraySumSimd(input, result);
          sw.stop();
          totalTime += sw.elapsedMicroseconds;
        }

        final avg = totalTime / iterations;
        final throughput = avg > 0 ? (size / avg * 1000000).round() : 0;

        print('Size: ${size.toString().padLeft(10)} | SIMD: ${avg.toStringAsFixed(3).padLeft(10)}μs | Throughput: ${throughput} elem/s');

        calloc.free(data);
        calloc.free(input);
        calloc.free(result);
      }
    });

    test('f32 Sum Benchmark', () {
      print('\n=== f32 Sum Benchmarks ===');

      for (var size in sizes) {
        final iterations = getIterations(size);
        final data = calloc<ffi.Float>(size);
        for (var i = 0; i < size; i++) {
          data[i] = (i % 100).toDouble();
        }

        final input = calloc<F32ArrayOps>();
        input.ref.data = data;
        input.ref.count = size;

        final result = calloc<F32ArrayOps>();

        var totalTime = 0;
        for (var i = 0; i < iterations; i++) {
          final sw = Stopwatch()..start();
          f32ArraySumSimd(input, result);
          sw.stop();
          totalTime += sw.elapsedMicroseconds;
        }

        final avg = totalTime / iterations;
        final throughput = avg > 0 ? (size / avg * 1000000).round() : 0;

        print('Size: ${size.toString().padLeft(10)} | SIMD: ${avg.toStringAsFixed(3).padLeft(10)}μs | Throughput: ${throughput} elem/s');

        calloc.free(data);
        calloc.free(input);
        calloc.free(result);
      }
    });

    test('f64 Sum Benchmark', () {
      print('\n=== f64 Sum Benchmarks ===');

      for (var size in sizes) {
        final iterations = getIterations(size);
        final data = calloc<ffi.Double>(size);
        for (var i = 0; i < size; i++) {
          data[i] = (i % 100).toDouble();
        }

        final input = calloc<F64ArrayOps>();
        input.ref.data = data;
        input.ref.count = size;

        final result = calloc<F64ArrayOps>();

        var totalTime = 0;
        for (var i = 0; i < iterations; i++) {
          final sw = Stopwatch()..start();
          f64ArraySumSimd(input, result);
          sw.stop();
          totalTime += sw.elapsedMicroseconds;
        }

        final avg = totalTime / iterations;
        final throughput = avg > 0 ? (size / avg * 1000000).round() : 0;

        print('Size: ${size.toString().padLeft(10)} | SIMD: ${avg.toStringAsFixed(3).padLeft(10)}μs | Throughput: ${throughput} elem/s');

        calloc.free(data);
        calloc.free(input);
        calloc.free(result);
      }
    });

    test('i32 Min/Max Benchmark', () {
      print('\n=== i32 Min/Max Benchmarks ===');

      for (var size in sizes) {
        final iterations = getIterations(size);
        final data = calloc<ffi.Int32>(size);
        for (var i = 0; i < size; i++) {
          data[i] = (i % 1000) - 500;
        }

        final input = calloc<I32ArrayOps>();
        input.ref.data = data;
        input.ref.count = size;

        final result = calloc<I32ArrayOps>();

        var totalTime = 0;
        for (var i = 0; i < iterations; i++) {
          final sw = Stopwatch()..start();
          i32ArrayMinMaxSimd(input, result);
          sw.stop();
          totalTime += sw.elapsedMicroseconds;
        }

        final avg = totalTime / iterations;
        final throughput = avg > 0 ? (size / avg * 1000000).round() : 0;

        print('Size: ${size.toString().padLeft(10)} | SIMD: ${avg.toStringAsFixed(3).padLeft(10)}μs | Throughput: ${throughput} elem/s');

        calloc.free(data);
        calloc.free(input);
        calloc.free(result);
      }
    });
  });

  tearDownAll(() {
    print('\n=== Summary of Results ===');
    if (allResults.isNotEmpty) {
      final avgSpeedup = allResults.fold(0.0, (sum, r) => sum + r.speedup) / allResults.length;
      print('Average SIMD speedup: ${avgSpeedup.toStringAsFixed(2)}x');

      final bestResult = allResults.reduce((a, b) => a.speedup > b.speedup ? a : b);
      print('Best speedup: ${bestResult.speedup.toStringAsFixed(2)}x (${bestResult.type} ${bestResult.operation}, ${bestResult.size} elements)');

      final worstResult = allResults.reduce((a, b) => a.speedup < b.speedup ? a : b);
      print('Worst speedup: ${worstResult.speedup.toStringAsFixed(2)}x (${worstResult.type} ${worstResult.operation}, ${worstResult.size} elements)');
    }
  });
}
