import 'dart:ffi' as ffi;
import 'dart:isolate';
import 'package:test/test.dart';
import 'package:ffi/ffi.dart';
import '../lib/image_processing.dart';
import '../lib/generated.dart';

void isolateWorker(SendPort sendPort) {
  ImageProcessingFFI.initImagePool(100);

  final src = ImageHelper.createTestImage(500, 500, 0xFF0000FF);
  final dst = ImageHelper.createTestImage(500, 500, 0);

  final stopwatch = Stopwatch()..start();

  for (int i = 0; i < 50; i++) {
    ImageProcessingFFI.convertToGrayscale(src, dst);
  }

  stopwatch.stop();

  ImageHelper.freeImage(src);
  ImageHelper.freeImage(dst);

  sendPort.send({
    'elapsed': stopwatch.elapsedMicroseconds,
    'iterations': 50,
  });
}

void isolateWorkerBrightness(SendPort sendPort) {
  ImageProcessingFFI.initImagePool(100);

  final src = ImageHelper.createTestImage(500, 500, 0x808080FF);
  final dst = ImageHelper.createTestImage(500, 500, 0);

  final stopwatch = Stopwatch()..start();

  for (int i = 0; i < 50; i++) {
    ImageProcessingFFI.adjustBrightness(src, dst, 0.1 * (i % 10));
  }

  stopwatch.stop();

  ImageHelper.freeImage(src);
  ImageHelper.freeImage(dst);

  sendPort.send({
    'elapsed': stopwatch.elapsedMicroseconds,
    'iterations': 50,
  });
}

void isolateWorkerBlur(SendPort sendPort) {
  ImageProcessingFFI.initImagePool(100);

  final src = ImageHelper.createTestImage(300, 300, 0xFF0000FF);
  final dst = ImageHelper.createTestImage(300, 300, 0);

  final stopwatch = Stopwatch()..start();

  for (int i = 0; i < 20; i++) {
    ImageProcessingFFI.applyBoxBlur(src, dst, 2);
  }

  stopwatch.stop();

  ImageHelper.freeImage(src);
  ImageHelper.freeImage(dst);

  sendPort.send({
    'elapsed': stopwatch.elapsedMicroseconds,
    'iterations': 20,
  });
}

void isolateWorkerHistogram(SendPort sendPort) {
  ImageProcessingFFI.initImagePool(100);

  final buffer = ImageHelper.createTestImage(500, 500, 0xFF0000FF);
  final histogram = ImageHelper.createHistogram();

  final stopwatch = Stopwatch()..start();

  for (int i = 0; i < 100; i++) {
    ImageProcessingFFI.calculateHistogram(buffer, histogram, i % 4);
  }

  stopwatch.stop();

  ImageHelper.freeImage(buffer);
  ImageHelper.freeHistogram(histogram);

  sendPort.send({
    'elapsed': stopwatch.elapsedMicroseconds,
    'iterations': 100,
  });
}

void main() {
  group('Concurrent Access Tests', () {
    setUpAll(() {
      ImageProcessingFFI.initImagePool(1000);
    });

    test('Single Isolate - Grayscale', () async {
      final receivePort = ReceivePort();
      await Isolate.spawn(isolateWorker, receivePort.sendPort);

      final result = await receivePort.first as Map<String, dynamic>;
      print('\n=== Single Isolate - Grayscale ===');
      print('Iterations: ${result['iterations']}');
      print('Total time: ${result['elapsed']}μs');
      print(
          'Avg per operation: ${(result['elapsed'] / result['iterations']).toStringAsFixed(2)}μs');

      expect(result['elapsed'], greaterThan(0));
    });

    test('Dual Isolates - Grayscale', () async {
      final receivePort1 = ReceivePort();
      final receivePort2 = ReceivePort();

      final stopwatch = Stopwatch()..start();

      await Isolate.spawn(isolateWorker, receivePort1.sendPort);
      await Isolate.spawn(isolateWorker, receivePort2.sendPort);

      final results = await Future.wait([
        receivePort1.first,
        receivePort2.first,
      ]);

      stopwatch.stop();

      print('\n=== Dual Isolates - Grayscale ===');
      print('Wall time: ${stopwatch.elapsedMicroseconds}μs');
      print('Isolate 1: ${(results[0] as Map)['elapsed']}μs');
      print('Isolate 2: ${(results[1] as Map)['elapsed']}μs');

      expect(results.length, equals(2));
    });

    test('Quad Isolates - Grayscale', () async {
      final receivePorts = List.generate(4, (_) => ReceivePort());

      final stopwatch = Stopwatch()..start();

      for (int i = 0; i < receivePorts.length; i++) {
        await Isolate.spawn(isolateWorker, receivePorts[i].sendPort);
      }

      final results =
          await Future.wait(receivePorts.map((port) => port.first).toList());

      stopwatch.stop();

      print('\n=== Quad Isolates - Grayscale ===');
      print('Wall time: ${stopwatch.elapsedMicroseconds}μs');
      for (int i = 0; i < results.length; i++) {
        print('Isolate $i: ${(results[i] as Map)['elapsed']}μs');
      }

      expect(results.length, equals(4));
    });

    test('Mixed Operations - 4 Isolates', () async {
      final receivePort1 = ReceivePort();
      final receivePort2 = ReceivePort();
      final receivePort3 = ReceivePort();
      final receivePort4 = ReceivePort();

      final stopwatch = Stopwatch()..start();

      await Future.wait([
        Isolate.spawn(isolateWorker, receivePort1.sendPort),
        Isolate.spawn(isolateWorkerBrightness, receivePort2.sendPort),
        Isolate.spawn(isolateWorkerBlur, receivePort3.sendPort),
        Isolate.spawn(isolateWorkerHistogram, receivePort4.sendPort),
      ]);

      final results = await Future.wait([
        receivePort1.first,
        receivePort2.first,
        receivePort3.first,
        receivePort4.first,
      ]);

      stopwatch.stop();

      print('\n=== Mixed Operations - 4 Isolates ===');
      print('Wall time: ${stopwatch.elapsedMicroseconds}μs');
      print('Grayscale: ${(results[0] as Map)['elapsed']}μs');
      print('Brightness: ${(results[1] as Map)['elapsed']}μs');
      print('Blur: ${(results[2] as Map)['elapsed']}μs');
      print('Histogram: ${(results[3] as Map)['elapsed']}μs');

      expect(results.length, equals(4));
    });

    test('Sequential vs Concurrent Comparison', () async {
      ImageProcessingFFI.resetPerformanceMetrics();

      final seqStopwatch = Stopwatch()..start();
      for (int i = 0; i < 4; i++) {
        final src = ImageHelper.createTestImage(500, 500, 0xFF0000FF);
        final dst = ImageHelper.createTestImage(500, 500, 0);
        for (int j = 0; j < 50; j++) {
          ImageProcessingFFI.convertToGrayscale(src, dst);
        }
        ImageHelper.freeImage(src);
        ImageHelper.freeImage(dst);
      }
      seqStopwatch.stop();

      final receivePorts = List.generate(4, (_) => ReceivePort());
      final concStopwatch = Stopwatch()..start();

      await Future.wait(
        receivePorts
            .map((port) => Isolate.spawn(isolateWorker, port.sendPort))
            .toList(),
      );

      await Future.wait(receivePorts.map((port) => port.first).toList());
      concStopwatch.stop();

      print('\n=== Sequential vs Concurrent ===');
      print('Sequential (4 workers): ${seqStopwatch.elapsedMilliseconds}ms');
      print('Concurrent (4 isolates): ${concStopwatch.elapsedMilliseconds}ms');
      print(
          'Speedup: ${(seqStopwatch.elapsedMicroseconds / concStopwatch.elapsedMicroseconds).toStringAsFixed(2)}x');

      expect(concStopwatch.elapsedMicroseconds,
          lessThan(seqStopwatch.elapsedMicroseconds));
    });

    test('Heavy Contention - 8 Isolates', () async {
      final receivePorts = List.generate(8, (_) => ReceivePort());

      final stopwatch = Stopwatch()..start();

      await Future.wait(
        receivePorts
            .map((port) => Isolate.spawn(isolateWorker, port.sendPort))
            .toList(),
      );

      final results =
          await Future.wait(receivePorts.map((port) => port.first).toList());

      stopwatch.stop();

      print('\n=== Heavy Contention - 8 Isolates ===');
      print('Wall time: ${stopwatch.elapsedMilliseconds}ms');

      var totalOps = 0;
      for (int i = 0; i < results.length; i++) {
        final map = results[i] as Map;
        totalOps += map['iterations'] as int;
      }

      print('Total operations: $totalOps');
      print('Avg throughput: ${(totalOps / (stopwatch.elapsedMicroseconds / 1000000)).toStringAsFixed(2)} ops/sec');

      expect(results.length, equals(8));
    });
  });

  group('FFI Call Overhead Tests', () {
    test('FFI Call Overhead - Minimal Work', () {
      final src = ImageHelper.createTestImage(1, 1, 0xFF0000FF);
      final dst = ImageHelper.createTestImage(1, 1, 0);

      final stopwatch = Stopwatch()..start();

      for (int i = 0; i < 10000; i++) {
        ImageProcessingFFI.convertToGrayscale(src, dst);
      }

      stopwatch.stop();

      final avgCallTime = stopwatch.elapsedMicroseconds / 10000;

      print('\n=== FFI Call Overhead (1x1 image) ===');
      print('Total iterations: 10000');
      print('Total time: ${stopwatch.elapsedMicroseconds}μs');
      print('Avg per call: ${avgCallTime.toStringAsFixed(3)}μs');
      print('Calls per second: ${(1000000 / avgCallTime).toStringAsFixed(0)}');

      ImageHelper.freeImage(src);
      ImageHelper.freeImage(dst);
    });

    test('FFI Call Overhead - Brightness', () {
      final src = ImageHelper.createTestImage(1, 1, 0x808080FF);
      final dst = ImageHelper.createTestImage(1, 1, 0);

      final stopwatch = Stopwatch()..start();

      for (int i = 0; i < 10000; i++) {
        ImageProcessingFFI.adjustBrightness(src, dst, 0.1);
      }

      stopwatch.stop();

      final avgCallTime = stopwatch.elapsedMicroseconds / 10000;

      print('\n=== FFI Call Overhead - Brightness (1x1 image) ===');
      print('Avg per call: ${avgCallTime.toStringAsFixed(3)}μs');

      ImageHelper.freeImage(src);
      ImageHelper.freeImage(dst);
    });

    test('FFI Call Overhead - Histogram', () {
      final buffer = ImageHelper.createTestImage(1, 1, 0xFF0000FF);
      final histogram = ImageHelper.createHistogram();

      final stopwatch = Stopwatch()..start();

      for (int i = 0; i < 10000; i++) {
        ImageProcessingFFI.calculateHistogram(buffer, histogram, 0);
      }

      stopwatch.stop();

      final avgCallTime = stopwatch.elapsedMicroseconds / 10000;

      print('\n=== FFI Call Overhead - Histogram (1x1 image) ===');
      print('Avg per call: ${avgCallTime.toStringAsFixed(3)}μs');

      ImageHelper.freeImage(buffer);
      ImageHelper.freeHistogram(histogram);
    });

    test('Memory Allocation Overhead', () {
      final stopwatch = Stopwatch()..start();

      for (int i = 0; i < 1000; i++) {
        final buffer = ImageHelper.createTestImage(100, 100, 0xFF0000FF);
        ImageHelper.freeImage(buffer);
      }

      stopwatch.stop();

      final avgAllocTime = stopwatch.elapsedMicroseconds / 1000;

      print('\n=== Memory Allocation Overhead (100x100 image) ===');
      print('Total iterations: 1000');
      print('Avg alloc+free time: ${avgAllocTime.toStringAsFixed(2)}μs');
    });

    test('Large Image Allocation', () {
      final stopwatch = Stopwatch()..start();

      final buffer = ImageHelper.createTestImage(3840, 2160, 0xFF0000FF);

      stopwatch.stop();

      print('\n=== Large Image Allocation (4K) ===');
      print('Allocation time: ${stopwatch.elapsedMicroseconds}μs');
      print('Memory size: ${3840 * 2160 * 4} bytes (${(3840 * 2160 * 4 / 1024 / 1024).toStringAsFixed(2)} MB)');

      ImageHelper.freeImage(buffer);
    });
  });

  group('SIMD Performance Validation', () {
    test('Track SIMD vs Scalar Operations', () {
      ImageProcessingFFI.resetPerformanceMetrics();

      final src = ImageHelper.createTestImage(1000, 1000, 0xFF0000FF);
      final dst = ImageHelper.createTestImage(1000, 1000, 0);

      for (int i = 0; i < 100; i++) {
        ImageProcessingFFI.convertToGrayscale(src, dst);
      }

      final metrics = ImageHelper.createPerformanceMetrics();
      ImageProcessingFFI.getPerformanceMetrics(metrics);

      print('\n=== SIMD Performance Tracking ===');
      print('SIMD operations: ${metrics.ref.simd_operations}');
      print('Scalar operations: ${metrics.ref.scalar_operations}');
      print('Total pixels processed: ${metrics.ref.total_pixels_processed}');

      ImageHelper.freeImage(src);
      ImageHelper.freeImage(dst);
      ImageHelper.freePerformanceMetrics(metrics);
    });

    test('Grayscale - Size Scaling Performance', () {
      final sizes = [
        [100, 100],
        [500, 500],
        [1000, 1000],
        [2000, 2000],
      ];

      print('\n=== Grayscale - Size Scaling ===');

      for (final size in sizes) {
        final src = ImageHelper.createTestImage(size[0], size[1], 0xFF0000FF);
        final dst = ImageHelper.createTestImage(size[0], size[1], 0);

        final stopwatch = Stopwatch()..start();
        ImageProcessingFFI.convertToGrayscale(src, dst);
        stopwatch.stop();

        final megapixels = (size[0] * size[1]) / 1000000;
        final throughput = megapixels / (stopwatch.elapsedMicroseconds / 1000000);

        print('${size[0]}x${size[1]} (${megapixels.toStringAsFixed(2)} MP): '
            '${stopwatch.elapsedMicroseconds}μs, '
            '${throughput.toStringAsFixed(2)} Mpx/sec');

        ImageHelper.freeImage(src);
        ImageHelper.freeImage(dst);
      }
    });

    test('Brightness - Size Scaling Performance', () {
      final sizes = [
        [100, 100],
        [500, 500],
        [1000, 1000],
        [2000, 2000],
      ];

      print('\n=== Brightness - Size Scaling ===');

      for (final size in sizes) {
        final src = ImageHelper.createTestImage(size[0], size[1], 0x808080FF);
        final dst = ImageHelper.createTestImage(size[0], size[1], 0);

        final stopwatch = Stopwatch()..start();
        ImageProcessingFFI.adjustBrightness(src, dst, 0.2);
        stopwatch.stop();

        final megapixels = (size[0] * size[1]) / 1000000;
        final throughput = megapixels / (stopwatch.elapsedMicroseconds / 1000000);

        print('${size[0]}x${size[1]} (${megapixels.toStringAsFixed(2)} MP): '
            '${stopwatch.elapsedMicroseconds}μs, '
            '${throughput.toStringAsFixed(2)} Mpx/sec');

        ImageHelper.freeImage(src);
        ImageHelper.freeImage(dst);
      }
    });
  });
}
