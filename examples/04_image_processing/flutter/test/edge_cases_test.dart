import 'dart:ffi' as ffi;
import 'package:test/test.dart';
import 'package:ffi/ffi.dart';
import '../lib/image_processing.dart';
import '../lib/generated.dart';

void main() {
  group('Edge Case Tests', () {
    setUpAll(() {
      ImageProcessingFFI.initImagePool(1000);
    });

    test('Null Pointer Handling - Source', () {
      final dst = ImageHelper.createTestImage(100, 100, 0);
      final success = ImageProcessingFFI.convertToGrayscale(ffi.nullptr, dst);
      expect(success, isFalse);
      ImageHelper.freeImage(dst);
    });

    test('Null Pointer Handling - Destination', () {
      final src = ImageHelper.createTestImage(100, 100, 0xFF0000FF);
      final success = ImageProcessingFFI.convertToGrayscale(src, ffi.nullptr);
      expect(success, isFalse);
      ImageHelper.freeImage(src);
    });

    test('Null Pointer Handling - Both', () {
      final success =
          ImageProcessingFFI.convertToGrayscale(ffi.nullptr, ffi.nullptr);
      expect(success, isFalse);
    });

    test('Zero Size Image - Width', () {
      final src = calloc<ImageBuffer>();
      src.ref.width = 0;
      src.ref.height = 100;
      src.ref.data_count = 0;

      final dst = ImageHelper.createTestImage(100, 100, 0);
      final success = ImageProcessingFFI.convertToGrayscale(src, dst);
      expect(success, isFalse);

      calloc.free(src);
      ImageHelper.freeImage(dst);
    });

    test('Zero Size Image - Height', () {
      final src = calloc<ImageBuffer>();
      src.ref.width = 100;
      src.ref.height = 0;
      src.ref.data_count = 0;

      final dst = ImageHelper.createTestImage(100, 100, 0);
      final success = ImageProcessingFFI.convertToGrayscale(src, dst);
      expect(success, isFalse);

      calloc.free(src);
      ImageHelper.freeImage(dst);
    });

    test('Box Blur - Zero Radius', () {
      final src = ImageHelper.createTestImage(100, 100, 0xFF0000FF);
      final dst = ImageHelper.createTestImage(100, 100, 0);

      final success = ImageProcessingFFI.applyBoxBlur(src, dst, 0);
      expect(success, isFalse);

      ImageHelper.freeImage(src);
      ImageHelper.freeImage(dst);
    });

    test('Histogram - Null Buffer', () {
      final histogram = ImageHelper.createHistogram();
      final success =
          ImageProcessingFFI.calculateHistogram(ffi.nullptr, histogram, 0);
      expect(success, isFalse);
      ImageHelper.freeHistogram(histogram);
    });

    test('Histogram - Null Histogram', () {
      final buffer = ImageHelper.createTestImage(100, 100, 0xFF0000FF);
      final success =
          ImageProcessingFFI.calculateHistogram(buffer, ffi.nullptr, 0);
      expect(success, isFalse);
      ImageHelper.freeImage(buffer);
    });

    test('Color Stats - Null Buffer', () {
      final stats = ImageHelper.createColorStats();
      final success =
          ImageProcessingFFI.calculateColorStats(ffi.nullptr, stats);
      expect(success, isFalse);
      ImageHelper.freeColorStats(stats);
    });

    test('Color Stats - Zero Pixels', () {
      final buffer = calloc<ImageBuffer>();
      buffer.ref.width = 0;
      buffer.ref.height = 0;
      buffer.ref.data_count = 0;

      final stats = ImageHelper.createColorStats();
      final success = ImageProcessingFFI.calculateColorStats(buffer, stats);
      expect(success, isFalse);

      calloc.free(buffer);
      ImageHelper.freeColorStats(stats);
    });

    test('Very Small Image - 1x1', () {
      final src = ImageHelper.createTestImage(1, 1, 0xFF0000FF);
      final dst = ImageHelper.createTestImage(1, 1, 0);

      final success = ImageProcessingFFI.convertToGrayscale(src, dst);
      expect(success, isTrue);

      ImageHelper.freeImage(src);
      ImageHelper.freeImage(dst);
    });

    test('Rectangular Image - Wide', () {
      final src = ImageHelper.createTestImage(1000, 1, 0xFF0000FF);
      final dst = ImageHelper.createTestImage(1000, 1, 0);

      final success = ImageProcessingFFI.convertToGrayscale(src, dst);
      expect(success, isTrue);

      ImageHelper.freeImage(src);
      ImageHelper.freeImage(dst);
    });

    test('Rectangular Image - Tall', () {
      final src = ImageHelper.createTestImage(1, 1000, 0xFF0000FF);
      final dst = ImageHelper.createTestImage(1, 1000, 0);

      final success = ImageProcessingFFI.convertToGrayscale(src, dst);
      expect(success, isTrue);

      ImageHelper.freeImage(src);
      ImageHelper.freeImage(dst);
    });

    test('Full HD Image - 1920x1080', () {
      print('\n=== Testing Full HD (1920x1080) ===');
      final src = ImageHelper.createTestImage(1920, 1080, 0x7F7F7FFF);
      final dst = ImageHelper.createTestImage(1920, 1080, 0);

      final stopwatch = Stopwatch()..start();
      final success = ImageProcessingFFI.convertToGrayscale(src, dst);
      stopwatch.stop();

      print('Pixels: ${1920 * 1080} (${(1920 * 1080 / 1000000).toStringAsFixed(2)} MP)');
      print('Time: ${stopwatch.elapsedMicroseconds}μs');
      print('Throughput: ${((1920 * 1080 / 1000000) / (stopwatch.elapsedMicroseconds / 1000000)).toStringAsFixed(2)} Mpx/sec');

      expect(success, isTrue);
      ImageHelper.freeImage(src);
      ImageHelper.freeImage(dst);
    });

    test('4K Image - 3840x2160', () {
      print('\n=== Testing 4K (3840x2160) ===');
      final src = ImageHelper.createTestImage(3840, 2160, 0x7F7F7FFF);
      final dst = ImageHelper.createTestImage(3840, 2160, 0);

      final stopwatch = Stopwatch()..start();
      final success = ImageProcessingFFI.convertToGrayscale(src, dst);
      stopwatch.stop();

      print('Pixels: ${3840 * 2160} (${(3840 * 2160 / 1000000).toStringAsFixed(2)} MP)');
      print('Time: ${stopwatch.elapsedMicroseconds}μs');
      print('Throughput: ${((3840 * 2160 / 1000000) / (stopwatch.elapsedMicroseconds / 1000000)).toStringAsFixed(2)} Mpx/sec');

      expect(success, isTrue);
      ImageHelper.freeImage(src);
      ImageHelper.freeImage(dst);
    });

    test('4K Brightness Adjustment', () {
      print('\n=== Testing 4K Brightness Adjustment ===');
      final src = ImageHelper.createTestImage(3840, 2160, 0x808080FF);
      final dst = ImageHelper.createTestImage(3840, 2160, 0);

      final stopwatch = Stopwatch()..start();
      final success = ImageProcessingFFI.adjustBrightness(src, dst, 0.2);
      stopwatch.stop();

      print('Time: ${stopwatch.elapsedMicroseconds}μs');
      print('Throughput: ${((3840 * 2160 / 1000000) / (stopwatch.elapsedMicroseconds / 1000000)).toStringAsFixed(2)} Mpx/sec');

      expect(success, isTrue);
      ImageHelper.freeImage(src);
      ImageHelper.freeImage(dst);
    });

    test('4K Box Blur - Small Radius', () {
      print('\n=== Testing 4K Box Blur (radius=2) ===');
      final src = ImageHelper.createTestImage(1920, 1080, 0xFF0000FF);
      final dst = ImageHelper.createTestImage(1920, 1080, 0);

      final stopwatch = Stopwatch()..start();
      final success = ImageProcessingFFI.applyBoxBlur(src, dst, 2);
      stopwatch.stop();

      print('Time: ${stopwatch.elapsedMicroseconds}μs (${stopwatch.elapsedMilliseconds}ms)');

      expect(success, isTrue);
      ImageHelper.freeImage(src);
      ImageHelper.freeImage(dst);
    });

    test('Brightness - Extreme Values', () {
      final src = ImageHelper.createTestImage(100, 100, 0x808080FF);
      final dst = ImageHelper.createTestImage(100, 100, 0);

      final success = ImageProcessingFFI.adjustBrightness(src, dst, 2.0);
      expect(success, isTrue);

      final dstPixel = dst.ref.data[0];
      final dstR = (dstPixel >> 24) & 0xFF;
      expect(dstR, equals(255));

      ImageHelper.freeImage(src);
      ImageHelper.freeImage(dst);
    });

    test('Brightness - Negative Extreme', () {
      final src = ImageHelper.createTestImage(100, 100, 0x808080FF);
      final dst = ImageHelper.createTestImage(100, 100, 0);

      final success = ImageProcessingFFI.adjustBrightness(src, dst, -2.0);
      expect(success, isTrue);

      final dstPixel = dst.ref.data[0];
      final dstR = (dstPixel >> 24) & 0xFF;
      expect(dstR, equals(0));

      ImageHelper.freeImage(src);
      ImageHelper.freeImage(dst);
    });

    test('Histogram - All Channels', () {
      final buffer = ImageHelper.createTestImage(100, 100, 0x7F7F7FFF);
      final histogram = ImageHelper.createHistogram();

      for (int channel = 0; channel < 4; channel++) {
        final success =
            ImageProcessingFFI.calculateHistogram(buffer, histogram, channel);
        expect(success, isTrue);
      }

      ImageHelper.freeImage(buffer);
      ImageHelper.freeHistogram(histogram);
    });

    test('Sequential Operations Pipeline', () {
      final src = ImageHelper.createTestImage(500, 500, 0xFF0000FF);
      final temp = ImageHelper.createTestImage(500, 500, 0);
      final dst = ImageHelper.createTestImage(500, 500, 0);

      var success = ImageProcessingFFI.convertToGrayscale(src, temp);
      expect(success, isTrue);

      success = ImageProcessingFFI.adjustBrightness(temp, dst, 0.2);
      expect(success, isTrue);

      ImageHelper.freeImage(src);
      ImageHelper.freeImage(temp);
      ImageHelper.freeImage(dst);
    });

    test('Memory Stress - Multiple Large Allocations', () {
      final buffers = <ffi.Pointer<ImageBuffer>>[];

      for (int i = 0; i < 10; i++) {
        buffers.add(ImageHelper.createTestImage(1000, 1000, 0xFF0000FF));
      }

      for (final buffer in buffers) {
        ImageHelper.freeImage(buffer);
      }

      expect(buffers.length, equals(10));
    });

    test('Performance - Repeated Operations', () {
      final src = ImageHelper.createTestImage(500, 500, 0xFF0000FF);
      final dst = ImageHelper.createTestImage(500, 500, 0);

      for (int i = 0; i < 100; i++) {
        final success = ImageProcessingFFI.convertToGrayscale(src, dst);
        expect(success, isTrue);
      }

      ImageHelper.freeImage(src);
      ImageHelper.freeImage(dst);
    });

    test('Color Stats - Varied Image', () {
      final buffer = calloc<ImageBuffer>();
      buffer.ref.width = 256;
      buffer.ref.height = 256;
      buffer.ref.stride = 256;
      buffer.ref.color_space = 1;
      buffer.ref.data_count = 256 * 256;

      for (int y = 0; y < 256; y++) {
        for (int x = 0; x < 256; x++) {
          final r = x;
          final g = y;
          final b = (x + y) ~/ 2;
          buffer.ref.data[y * 256 + x] =
              (r << 24) | (g << 16) | (b << 8) | 0xFF;
        }
      }

      final stats = ImageHelper.createColorStats();
      final success = ImageProcessingFFI.calculateColorStats(buffer, stats);

      expect(success, isTrue);
      expect(stats.ref.mean_r, greaterThan(0.0));
      expect(stats.ref.mean_g, greaterThan(0.0));
      expect(stats.ref.mean_b, greaterThan(0.0));
      expect(stats.ref.stddev_r, greaterThan(0.0));
      expect(stats.ref.stddev_g, greaterThan(0.0));
      expect(stats.ref.stddev_b, greaterThan(0.0));

      calloc.free(buffer);
      ImageHelper.freeColorStats(stats);
    });
  });
}
