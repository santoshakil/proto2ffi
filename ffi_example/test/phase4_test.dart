import 'dart:ffi' as ffi;
import 'package:test/test.dart';
import 'package:ffi/ffi.dart';
import 'package:ffi_example/phase4.dart';
import 'package:ffi_example/phase4/generated.dart';

void main() {
  setUp(() {
    Phase4FFI.batchResetStats();
  });

  group('Vector4 Basic Operations', () {
    test('addition', () {
      final a = Vector4.allocate();
      final b = Vector4.allocate();
      final result = Vector4.allocate();

      a.ref.x = 1.0;
      a.ref.y = 2.0;
      a.ref.z = 3.0;
      a.ref.w = 4.0;

      b.ref.x = 5.0;
      b.ref.y = 6.0;
      b.ref.z = 7.0;
      b.ref.w = 8.0;

      Phase4FFI.vector4Add(a, b, result);

      expect(result.ref.x, closeTo(6.0, 0.001));
      expect(result.ref.y, closeTo(8.0, 0.001));
      expect(result.ref.z, closeTo(10.0, 0.001));
      expect(result.ref.w, closeTo(12.0, 0.001));

      calloc.free(a);
      calloc.free(b);
      calloc.free(result);
    });

    test('dot product', () {
      final a = Vector4.allocate();
      final b = Vector4.allocate();

      a.ref.x = 1.0;
      a.ref.y = 2.0;
      a.ref.z = 3.0;
      a.ref.w = 4.0;

      b.ref.x = 5.0;
      b.ref.y = 6.0;
      b.ref.z = 7.0;
      b.ref.w = 8.0;

      final dot = Phase4FFI.vector4Dot(a, b);

      expect(dot, closeTo(70.0, 0.001));

      calloc.free(a);
      calloc.free(b);
    });

    test('scaling', () {
      final v = Vector4.allocate();
      final result = Vector4.allocate();

      v.ref.x = 2.0;
      v.ref.y = 4.0;
      v.ref.z = 6.0;
      v.ref.w = 8.0;

      Phase4FFI.vector4Scale(v, 2.5, result);

      expect(result.ref.x, closeTo(5.0, 0.001));
      expect(result.ref.y, closeTo(10.0, 0.001));
      expect(result.ref.z, closeTo(15.0, 0.001));
      expect(result.ref.w, closeTo(20.0, 0.001));

      calloc.free(v);
      calloc.free(result);
    });
  });

  group('SIMD Batch Operations', () {
    test('batch add - 10 vectors', () {
      final count = 10;
      final a = calloc<Vector4>(count);
      final b = calloc<Vector4>(count);
      final result = calloc<Vector4>(count);

      for (var i = 0; i < count; i++) {
        a[i].x = i.toDouble();
        a[i].y = i.toDouble() * 2;
        a[i].z = i.toDouble() * 3;
        a[i].w = i.toDouble() * 4;

        b[i].x = 1.0;
        b[i].y = 2.0;
        b[i].z = 3.0;
        b[i].w = 4.0;
      }

      Phase4FFI.vector4BatchAdd(a, b, result, count);

      for (var i = 0; i < count; i++) {
        expect(result[i].x, closeTo(i + 1.0, 0.001));
        expect(result[i].y, closeTo(i * 2 + 2.0, 0.001));
        expect(result[i].z, closeTo(i * 3 + 3.0, 0.001));
        expect(result[i].w, closeTo(i * 4 + 4.0, 0.001));
      }

      calloc.free(a);
      calloc.free(b);
      calloc.free(result);
    });

    test('batch scale - 100 vectors', () {
      final count = 100;
      final v = calloc<Vector4>(count);
      final result = calloc<Vector4>(count);

      for (var i = 0; i < count; i++) {
        v[i].x = i.toDouble();
        v[i].y = i.toDouble();
        v[i].z = i.toDouble();
        v[i].w = i.toDouble();
      }

      Phase4FFI.vector4BatchScale(v, 0.5, result, count);

      for (var i = 0; i < count; i++) {
        expect(result[i].x, closeTo(i * 0.5, 0.001));
      }

      calloc.free(v);
      calloc.free(result);
    });

    test('batch dot - 1000 vectors', () {
      final count = 1000;
      final a = calloc<Vector4>(count);
      final b = calloc<Vector4>(count);
      final results = calloc<ffi.Float>(count);

      for (var i = 0; i < count; i++) {
        a[i].x = 1.0;
        a[i].y = 2.0;
        a[i].z = 3.0;
        a[i].w = 4.0;

        b[i].x = 5.0;
        b[i].y = 6.0;
        b[i].z = 7.0;
        b[i].w = 8.0;
      }

      Phase4FFI.vector4BatchDot(a, b, results, count);

      for (var i = 0; i < count; i++) {
        expect(results[i], closeTo(70.0, 0.01));
      }

      calloc.free(a);
      calloc.free(b);
      calloc.free(results);
    });
  });

  group('Performance Benchmarks', () {
    test('batch add - 10K vectors', () {
      final count = 10000;
      final a = calloc<Vector4>(count);
      final b = calloc<Vector4>(count);
      final result = calloc<Vector4>(count);

      for (var i = 0; i < count; i++) {
        a[i].x = i.toDouble();
        a[i].y = i.toDouble();
        a[i].z = i.toDouble();
        a[i].w = i.toDouble();
        b[i] = a[i];
      }

      final stopwatch = Stopwatch()..start();

      Phase4FFI.vector4BatchAdd(a, b, result, count);

      stopwatch.stop();
      print('10K vector batch add: ${stopwatch.elapsedMicroseconds}μs');

      expect(stopwatch.elapsedMicroseconds, lessThan(1000));

      calloc.free(a);
      calloc.free(b);
      calloc.free(result);
    });

    test('batch scale - 100K vectors', () {
      final count = 100000;
      final v = calloc<Vector4>(count);
      final result = calloc<Vector4>(count);

      for (var i = 0; i < count; i++) {
        v[i].x = i.toDouble();
        v[i].y = i.toDouble();
        v[i].z = i.toDouble();
        v[i].w = i.toDouble();
      }

      final stopwatch = Stopwatch()..start();

      Phase4FFI.vector4BatchScale(v, 2.0, result, count);

      stopwatch.stop();
      print('100K vector batch scale: ${stopwatch.elapsedMicroseconds}μs (${(stopwatch.elapsedMicroseconds / 100000).toStringAsFixed(3)}μs per vector)');

      calloc.free(v);
      calloc.free(result);
    });
  });

  group('SIMD Stats Tracking', () {
    test('stats tracking - SIMD vs scalar', () {
      Phase4FFI.batchResetStats();

      final a = calloc<Vector4>(100);
      final b = calloc<Vector4>(100);
      final result = calloc<Vector4>(100);

      for (var i = 0; i < 100; i++) {
        a[i].x = i.toDouble();
        b[i].x = i.toDouble();
      }

      Phase4FFI.vector4BatchAdd(a, b, result, 100);

      final stats = BatchStats.allocate();
      Phase4FFI.batchGetStats(stats);

      print('SIMD operations: ${stats.ref.simd_operations}');
      print('Scalar operations: ${stats.ref.scalar_operations}');
      print('Total processed: ${stats.ref.total_processed}');

      expect(stats.ref.total_processed, equals(100));

      calloc.free(a);
      calloc.free(b);
      calloc.free(result);
      calloc.free(stats);
    });

    test('stats reset', () {
      final a = calloc<Vector4>(10);
      final b = calloc<Vector4>(10);
      final result = calloc<Vector4>(10);

      Phase4FFI.vector4BatchAdd(a, b, result, 10);

      Phase4FFI.batchResetStats();

      final stats = BatchStats.allocate();
      Phase4FFI.batchGetStats(stats);

      expect(stats.ref.total_processed, equals(0));
      expect(stats.ref.simd_operations, equals(0));
      expect(stats.ref.scalar_operations, equals(0));

      calloc.free(a);
      calloc.free(b);
      calloc.free(result);
      calloc.free(stats);
    });
  });
}
