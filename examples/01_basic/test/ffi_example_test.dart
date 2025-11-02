import 'dart:ffi' as ffi;
import 'package:test/test.dart';
import 'package:ffi/ffi.dart';
import 'package:ffi_example/ffi_example.dart';
import 'package:ffi_example/generated/generated.dart';

void main() {
  group('Point operations', () {
    test('distance calculation', () {
      final p1 = Point.allocate();
      final p2 = Point.allocate();

      p1.ref.x = 0.0;
      p1.ref.y = 0.0;

      p2.ref.x = 3.0;
      p2.ref.y = 4.0;

      final distance = FFIExample.pointDistance(p1, p2);
      expect(distance, equals(5.0));

      calloc.free(p1);
      calloc.free(p2);
    });

    test('midpoint calculation', () {
      final p1 = Point.allocate();
      final p2 = Point.allocate();

      p1.ref.x = 0.0;
      p1.ref.y = 0.0;

      p2.ref.x = 10.0;
      p2.ref.y = 20.0;

      final midpoint = FFIExample.pointMidpoint(p1, p2);
      expect(midpoint.ref.x, equals(5.0));
      expect(midpoint.ref.y, equals(10.0));

      calloc.free(p1);
      calloc.free(p2);
      calloc.free(midpoint);
    });

    test('zero-copy verification - same memory', () {
      final p1 = Point.allocate();
      p1.ref.x = 42.0;
      p1.ref.y = 24.0;

      // Get the raw pointer
      final ptr = p1.cast<ffi.Uint8>();
      final bytes = ptr.asTypedList(POINT_SIZE);

      // Modify through Dart
      p1.ref.x = 100.0;

      // Verify bytes changed (zero-copy - same memory)
      final newBytes = ptr.asTypedList(POINT_SIZE);
      expect(newBytes, isNot(equals([0, 0, 0, 0, 0, 0, 69, 64, 0, 0, 0, 0, 0, 0, 56, 64])));

      calloc.free(p1);
    });
  });

  group('Counter operations', () {
    test('increment', () {
      final counter = Counter.allocate();
      counter.ref.value = 0;
      counter.ref.timestamp = 0;

      final newValue = FFIExample.counterIncrement(counter);
      expect(newValue, equals(1));
      expect(counter.ref.value, equals(1));
      expect(counter.ref.timestamp, greaterThan(0));

      calloc.free(counter);
    });

    test('add amount', () {
      final counter = Counter.allocate();
      counter.ref.value = 10;
      counter.ref.timestamp = 0;

      final newValue = FFIExample.counterAdd(counter, 5);
      expect(newValue, equals(15));
      expect(counter.ref.value, equals(15));

      calloc.free(counter);
    });

    test('memory layout verification', () {
      final counter = Counter.allocate();

      // Both fields are i64 (8 bytes each)
      expect(COUNTER_SIZE, equals(16));
      expect(COUNTER_ALIGNMENT, equals(8));

      calloc.free(counter);
    });
  });

  group('Stats operations', () {
    test('update statistics', () {
      final stats = Stats.allocate();
      stats.ref.count = 0;
      stats.ref.sum = 0;
      stats.ref.min = 0;
      stats.ref.max = 0;
      stats.ref.avg = 0;

      FFIExample.statsUpdate(stats, 10.0);
      expect(stats.ref.count, equals(1));
      expect(stats.ref.sum, equals(10.0));
      expect(stats.ref.min, equals(10.0));
      expect(stats.ref.max, equals(10.0));
      expect(stats.ref.avg, equals(10.0));

      FFIExample.statsUpdate(stats, 20.0);
      expect(stats.ref.count, equals(2));
      expect(stats.ref.sum, equals(30.0));
      expect(stats.ref.min, equals(10.0));
      expect(stats.ref.max, equals(20.0));
      expect(stats.ref.avg, equals(15.0));

      FFIExample.statsUpdate(stats, 30.0);
      expect(stats.ref.count, equals(3));
      expect(stats.ref.sum, equals(60.0));
      expect(stats.ref.min, equals(10.0));
      expect(stats.ref.max, equals(30.0));
      expect(stats.ref.avg, equals(20.0));

      calloc.free(stats);
    });

    test('reset', () {
      final stats = Stats.allocate();
      FFIExample.statsUpdate(stats, 10.0);
      FFIExample.statsUpdate(stats, 20.0);

      FFIExample.statsReset(stats);
      expect(stats.ref.count, equals(0));
      expect(stats.ref.sum, equals(0.0));

      calloc.free(stats);
    });

    test('performance - 1M operations', () {
      final stats = Stats.allocate();
      final stopwatch = Stopwatch()..start();

      for (int i = 0; i < 1000000; i++) {
        FFIExample.statsUpdate(stats, i.toDouble());
      }

      stopwatch.stop();
      print('1M stats updates: ${stopwatch.elapsedMicroseconds}μs');
      print('Per operation: ${stopwatch.elapsedMicroseconds / 1000000}μs');

      expect(stats.ref.count, equals(1000000));

      calloc.free(stats);
    });
  });
}
