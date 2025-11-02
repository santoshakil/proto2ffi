import 'dart:ffi' as ffi;
import 'package:test/test.dart';
import 'package:ffi/ffi.dart';
import '../lib/image_processing.dart';
import '../lib/generated.dart';

void main() {
  group('Image Processing FFI Tests', () {
    setUpAll(() {
      ImageProcessingFFI.initImagePool(1000);
    });

    test('Grayscale Conversion - Red Image', () {
      final src = ImageHelper.createTestImage(100, 100, 0xFF0000FF);
      final dst = ImageHelper.createTestImage(100, 100, 0);

      final success = ImageProcessingFFI.convertToGrayscale(src, dst);

      expect(success, isTrue);
      expect(dst.ref.width, equals(100));
      expect(dst.ref.height, equals(100));
      expect(dst.ref.color_space, equals(2)); // GRAYSCALE

      // Check first pixel is grayscale
      final pixel = dst.ref.data[0];
      final r = (pixel >> 24) & 0xFF;
      final g = (pixel >> 16) & 0xFF;
      final b = (pixel >> 8) & 0xFF;
      expect(r, equals(g));
      expect(g, equals(b));

      ImageHelper.freeImage(src);
      ImageHelper.freeImage(dst);
    });

    test('Grayscale Conversion - Various Sizes', () {
      final sizes = [
        [10, 10],
        [64, 64],
        [128, 128],
        [256, 256],
        [512, 512],
      ];

      for (final size in sizes) {
        final src = ImageHelper.createTestImage(size[0], size[1], 0x7F7F7FFF);
        final dst = ImageHelper.createTestImage(size[0], size[1], 0);

        final success = ImageProcessingFFI.convertToGrayscale(src, dst);

        expect(success, isTrue,
            reason: 'Failed for size ${size[0]}x${size[1]}');

        ImageHelper.freeImage(src);
        ImageHelper.freeImage(dst);
      }
    });

    test('Box Blur - Small Radius', () {
      final src = ImageHelper.createTestImage(100, 100, 0xFF0000FF);
      final dst = ImageHelper.createTestImage(100, 100, 0);

      final success = ImageProcessingFFI.applyBoxBlur(src, dst, 1);

      expect(success, isTrue);
      expect(dst.ref.width, equals(100));
      expect(dst.ref.height, equals(100));

      ImageHelper.freeImage(src);
      ImageHelper.freeImage(dst);
    });

    test('Box Blur - Large Radius', () {
      final src = ImageHelper.createTestImage(100, 100, 0xFF0000FF);
      final dst = ImageHelper.createTestImage(100, 100, 0);

      final success = ImageProcessingFFI.applyBoxBlur(src, dst, 5);

      expect(success, isTrue);

      ImageHelper.freeImage(src);
      ImageHelper.freeImage(dst);
    });

    test('Brightness Adjustment - Increase', () {
      final src = ImageHelper.createTestImage(100, 100, 0x808080FF);
      final dst = ImageHelper.createTestImage(100, 100, 0);

      final success = ImageProcessingFFI.adjustBrightness(src, dst, 0.2);

      expect(success, isTrue);

      // Verify brightness increased
      final srcPixel = src.ref.data[0];
      final dstPixel = dst.ref.data[0];

      final srcR = (srcPixel >> 24) & 0xFF;
      final dstR = (dstPixel >> 24) & 0xFF;

      expect(dstR, greaterThan(srcR));

      ImageHelper.freeImage(src);
      ImageHelper.freeImage(dst);
    });

    test('Brightness Adjustment - Decrease', () {
      final src = ImageHelper.createTestImage(100, 100, 0x808080FF);
      final dst = ImageHelper.createTestImage(100, 100, 0);

      final success = ImageProcessingFFI.adjustBrightness(src, dst, -0.2);

      expect(success, isTrue);

      // Verify brightness decreased
      final srcPixel = src.ref.data[0];
      final dstPixel = dst.ref.data[0];

      final srcR = (srcPixel >> 24) & 0xFF;
      final dstR = (dstPixel >> 24) & 0xFF;

      expect(dstR, lessThan(srcR));

      ImageHelper.freeImage(src);
      ImageHelper.freeImage(dst);
    });

    test('Histogram Calculation - Red Channel', () {
      final buffer = ImageHelper.createTestImage(100, 100, 0xFF0000FF);
      final histogram = ImageHelper.createHistogram();

      final success =
          ImageProcessingFFI.calculateHistogram(buffer, histogram, 0);

      expect(success, isTrue);

      // All red channel values should be 0xFF (255)
      expect(histogram.ref.bins[255], equals(10000)); // 100x100 pixels

      ImageHelper.freeImage(buffer);
      ImageHelper.freeHistogram(histogram);
    });

    test('Histogram Calculation - Gradient', () {
      final buffer = calloc<ImageBuffer>();
      buffer.ref.width = 256;
      buffer.ref.height = 1;
      buffer.ref.stride = 256;
      buffer.ref.color_space = 2; // GRAYSCALE
      buffer.ref.data_count = 256;

      // Create gradient
      for (int i = 0; i < 256; i++) {
        buffer.ref.data[i] = (i << 24) | (i << 16) | (i << 8) | 0xFF;
      }

      final histogram = ImageHelper.createHistogram();
      final success =
          ImageProcessingFFI.calculateHistogram(buffer, histogram, 0);

      expect(success, isTrue);

      // Each bin should have exactly 1 pixel
      for (int i = 0; i < 256; i++) {
        expect(histogram.ref.bins[i], equals(1),
            reason: 'Bin $i should have 1 pixel');
      }

      calloc.free(buffer);
      ImageHelper.freeHistogram(histogram);
    });

    test('Color Statistics Calculation', () {
      final buffer = ImageHelper.createTestImage(100, 100, 0x808080FF);
      final stats = ImageHelper.createColorStats();

      final success = ImageProcessingFFI.calculateColorStats(buffer, stats);

      expect(success, isTrue);
      expect(stats.ref.mean_r, closeTo(128.0, 0.1));
      expect(stats.ref.mean_g, closeTo(128.0, 0.1));
      expect(stats.ref.mean_b, closeTo(128.0, 0.1));
      expect(stats.ref.min_r, equals(128));
      expect(stats.ref.min_g, equals(128));
      expect(stats.ref.min_b, equals(128));
      expect(stats.ref.max_r, equals(128));
      expect(stats.ref.max_g, equals(128));
      expect(stats.ref.max_b, equals(128));
      expect(stats.ref.stddev_r, closeTo(0.0, 0.1));
      expect(stats.ref.stddev_g, closeTo(0.0, 0.1));
      expect(stats.ref.stddev_b, closeTo(0.0, 0.1));

      ImageHelper.freeImage(buffer);
      ImageHelper.freeColorStats(stats);
    });

    test('Performance Metrics Tracking', () {
      ImageProcessingFFI.resetPerformanceMetrics();

      final src = ImageHelper.createTestImage(100, 100, 0xFF0000FF);
      final dst = ImageHelper.createTestImage(100, 100, 0);

      // Perform operations
      ImageProcessingFFI.convertToGrayscale(src, dst);
      ImageProcessingFFI.convertToGrayscale(src, dst);

      final metrics = ImageHelper.createPerformanceMetrics();
      final success = ImageProcessingFFI.getPerformanceMetrics(metrics);

      expect(success, isTrue);
      expect(metrics.ref.total_pixels_processed, equals(20000)); // 2 * 100*100

      ImageHelper.freeImage(src);
      ImageHelper.freeImage(dst);
      ImageHelper.freePerformanceMetrics(metrics);
    });
  });

  group('Performance Benchmarks', () {
    test('Grayscale Conversion - 1K images', () {
      final src = ImageHelper.createTestImage(1000, 1000, 0xFF0000FF);
      final dst = ImageHelper.createTestImage(1000, 1000, 0);

      final stopwatch = Stopwatch()..start();

      for (int i = 0; i < 10; i++) {
        ImageProcessingFFI.convertToGrayscale(src, dst);
      }

      stopwatch.stop();

      final timePerImage = stopwatch.elapsedMicroseconds / 10;
      final megapixelsPerSecond = (1.0 / timePerImage) * 1000000;

      print('\n=== Grayscale Conversion Benchmark ===');
      print('Image size: 1000x1000 (1 megapixel)');
      print('Iterations: 10');
      print('Average time: ${timePerImage.toStringAsFixed(2)}μs');
      print('Throughput: ${megapixelsPerSecond.toStringAsFixed(2)} Mpx/sec');

      expect(timePerImage, lessThan(10000), // Should be faster than 10ms
          reason: 'Grayscale conversion too slow');

      ImageHelper.freeImage(src);
      ImageHelper.freeImage(dst);
    });

    test('Box Blur - Performance', () {
      final src = ImageHelper.createTestImage(500, 500, 0xFF0000FF);
      final dst = ImageHelper.createTestImage(500, 500, 0);

      final stopwatch = Stopwatch()..start();

      for (int i = 0; i < 5; i++) {
        ImageProcessingFFI.applyBoxBlur(src, dst, 3);
      }

      stopwatch.stop();

      final timePerImage = stopwatch.elapsedMicroseconds / 5;

      print('\n=== Box Blur Benchmark ===');
      print('Image size: 500x500');
      print('Radius: 3');
      print('Iterations: 5');
      print('Average time: ${timePerImage.toStringAsFixed(2)}μs');

      ImageHelper.freeImage(src);
      ImageHelper.freeImage(dst);
    });

    test('Brightness Adjustment - Throughput', () {
      final src = ImageHelper.createTestImage(1000, 1000, 0x808080FF);
      final dst = ImageHelper.createTestImage(1000, 1000, 0);

      final stopwatch = Stopwatch()..start();

      for (int i = 0; i < 20; i++) {
        ImageProcessingFFI.adjustBrightness(src, dst, 0.1);
      }

      stopwatch.stop();

      final timePerImage = stopwatch.elapsedMicroseconds / 20;
      final megapixelsPerSecond = (1.0 / timePerImage) * 1000000;

      print('\n=== Brightness Adjustment Benchmark ===');
      print('Image size: 1000x1000');
      print('Iterations: 20');
      print('Average time: ${timePerImage.toStringAsFixed(2)}μs');
      print('Throughput: ${megapixelsPerSecond.toStringAsFixed(2)} Mpx/sec');

      expect(timePerImage, lessThan(5000), // Should be very fast
          reason: 'Brightness adjustment too slow');

      ImageHelper.freeImage(src);
      ImageHelper.freeImage(dst);
    });

    test('Histogram Calculation - Performance', () {
      final buffer = ImageHelper.createTestImage(1000, 1000, 0xFF0000FF);
      final histogram = ImageHelper.createHistogram();

      final stopwatch = Stopwatch()..start();

      for (int i = 0; i < 100; i++) {
        ImageProcessingFFI.calculateHistogram(buffer, histogram, 0);
      }

      stopwatch.stop();

      final timePerCalc = stopwatch.elapsedMicroseconds / 100;

      print('\n=== Histogram Calculation Benchmark ===');
      print('Image size: 1000x1000');
      print('Iterations: 100');
      print('Average time: ${timePerCalc.toStringAsFixed(2)}μs');

      expect(timePerCalc, lessThan(2000), // Should be fast
          reason: 'Histogram calculation too slow');

      ImageHelper.freeImage(buffer);
      ImageHelper.freeHistogram(histogram);
    });

    test('Color Statistics - Performance', () {
      final buffer = ImageHelper.createTestImage(1000, 1000, 0x7F7F7FFF);
      final stats = ImageHelper.createColorStats();

      final stopwatch = Stopwatch()..start();

      for (int i = 0; i < 50; i++) {
        ImageProcessingFFI.calculateColorStats(buffer, stats);
      }

      stopwatch.stop();

      final timePerCalc = stopwatch.elapsedMicroseconds / 50;

      print('\n=== Color Statistics Benchmark ===');
      print('Image size: 1000x1000');
      print('Iterations: 50');
      print('Average time: ${timePerCalc.toStringAsFixed(2)}μs');

      ImageHelper.freeImage(buffer);
      ImageHelper.freeColorStats(stats);
    });
  });
}
