import 'dart:ffi' as ffi;
import 'dart:isolate';
import 'package:test/test.dart';
import 'package:ffi/ffi.dart';
import '../lib/image_processing.dart';
import '../lib/generated.dart';

void isolateWorkerSimple(SendPort sendPort) {
  ImageProcessingFFI.initImagePool(100);

  final src = ImageHelper.createTestImage(100, 100, 0xFF0000FF);
  final dst = ImageHelper.createTestImage(100, 100, 0);

  final stopwatch = Stopwatch()..start();

  for (int i = 0; i < 10; i++) {
    ImageProcessingFFI.convertToGrayscale(src, dst);
  }

  stopwatch.stop();

  ImageHelper.freeImage(src);
  ImageHelper.freeImage(dst);

  sendPort.send({
    'elapsed': stopwatch.elapsedMicroseconds,
    'iterations': 10,
  });
}

void main() {
  group('Simple Concurrent Tests', () {
    test('Main Thread Processing', () {
      ImageProcessingFFI.initImagePool(100);

      final src = ImageHelper.createTestImage(100, 100, 0xFF0000FF);
      final dst = ImageHelper.createTestImage(100, 100, 0);

      final stopwatch = Stopwatch()..start();

      for (int i = 0; i < 10; i++) {
        ImageProcessingFFI.convertToGrayscale(src, dst);
      }

      stopwatch.stop();

      print('\n=== Main Thread ===');
      print('10 operations: ${stopwatch.elapsedMicroseconds}μs');

      ImageHelper.freeImage(src);
      ImageHelper.freeImage(dst);
    });

    test('Single Isolate Processing', () async {
      final receivePort = ReceivePort();
      await Isolate.spawn(isolateWorkerSimple, receivePort.sendPort);

      final result = await receivePort.first as Map<String, dynamic>;

      print('\n=== Single Isolate ===');
      print('10 operations: ${result['elapsed']}μs');

      expect(result['elapsed'], greaterThan(0));
    });

    test('Sequential Isolates', () async {
      print('\n=== Sequential Isolates ===');

      for (int i = 0; i < 3; i++) {
        final receivePort = ReceivePort();
        await Isolate.spawn(isolateWorkerSimple, receivePort.sendPort);
        final result = await receivePort.first as Map<String, dynamic>;
        print('Isolate $i: ${result['elapsed']}μs');
      }
    });

    test('Measure Isolate Startup Overhead', () async {
      final startupStopwatch = Stopwatch()..start();
      final receivePort = ReceivePort();
      await Isolate.spawn(isolateWorkerSimple, receivePort.sendPort);
      startupStopwatch.stop();

      final result = await receivePort.first as Map<String, dynamic>;

      print('\n=== Isolate Overhead ===');
      print('Isolate spawn time: ${startupStopwatch.elapsedMicroseconds}μs');
      print('Work time: ${result['elapsed']}μs');
      print('Overhead: ${startupStopwatch.elapsedMicroseconds - result['elapsed']}μs');
    });
  });
}
