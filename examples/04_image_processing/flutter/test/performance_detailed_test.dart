import 'dart:ffi' as ffi;
import 'package:test/test.dart';
import 'package:ffi/ffi.dart';
import '../lib/image_processing.dart';
import '../lib/generated.dart';

void main() {
  group('Detailed Performance Benchmarks', () {
    setUpAll(() {
      ImageProcessingFFI.initImagePool(1000);
    });

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
      print('Total time: ${stopwatch.elapsedMicroseconds}μs (${stopwatch.elapsedMilliseconds}ms)');
      print('Avg per call: ${avgCallTime.toStringAsFixed(3)}μs');
      print('Calls per second: ${(1000000 / avgCallTime).toStringAsFixed(0)}');

      expect(avgCallTime, lessThan(10.0));

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
      print('Total iterations: 10000');
      print('Avg per call: ${avgCallTime.toStringAsFixed(3)}μs');
      print('Calls per second: ${(1000000 / avgCallTime).toStringAsFixed(0)}');

      ImageHelper.freeImage(src);
      ImageHelper.freeImage(dst);
    });

    test('Memory Allocation Overhead - Small Images', () {
      final stopwatch = Stopwatch()..start();

      for (int i = 0; i < 1000; i++) {
        final buffer = ImageHelper.createTestImage(100, 100, 0xFF0000FF);
        ImageHelper.freeImage(buffer);
      }

      stopwatch.stop();

      final avgAllocTime = stopwatch.elapsedMicroseconds / 1000;

      print('\n=== Memory Allocation Overhead (100x100 image) ===');
      print('Total iterations: 1000');
      print('Total time: ${stopwatch.elapsedMilliseconds}ms');
      print('Avg alloc+free time: ${avgAllocTime.toStringAsFixed(2)}μs');
    });

    test('Memory Allocation - Large Images', () {
      print('\n=== Large Image Memory Allocation ===');

      final sizes = [
        [1920, 1080, 'Full HD'],
        [3840, 2160, '4K UHD'],
      ];

      for (final size in sizes) {
        final stopwatch = Stopwatch()..start();
        final buffer = ImageHelper.createTestImage(size[0] as int, size[1] as int, 0xFF0000FF);
        stopwatch.stop();

        final bytes = (size[0] as int) * (size[1] as int) * 4;

        print('${size[2]}: ${stopwatch.elapsedMicroseconds}μs, '
            '${(bytes / 1024 / 1024).toStringAsFixed(2)} MB');

        ImageHelper.freeImage(buffer);
      }
    });

    test('Grayscale - Size Scaling Performance', () {
      final sizes = [
        [100, 100],
        [256, 256],
        [512, 512],
        [1000, 1000],
        [1920, 1080],
        [2000, 2000],
        [3840, 2160],
      ];

      print('\n=== Grayscale - Size Scaling Performance ===');
      print('Size          | Pixels    | Time      | Throughput');
      print('------------- | --------- | --------- | -----------');

      for (final size in sizes) {
        final src = ImageHelper.createTestImage(size[0], size[1], 0xFF0000FF);
        final dst = ImageHelper.createTestImage(size[0], size[1], 0);

        final stopwatch = Stopwatch()..start();
        ImageProcessingFFI.convertToGrayscale(src, dst);
        stopwatch.stop();

        final pixels = size[0] * size[1];
        final megapixels = pixels / 1000000;
        final throughput = megapixels / (stopwatch.elapsedMicroseconds / 1000000);

        print('${size[0].toString().padRight(4)}x${size[1].toString().padLeft(4)} | '
            '${megapixels.toStringAsFixed(2).padLeft(9)} | '
            '${stopwatch.elapsedMicroseconds.toString().padLeft(7)}μs | '
            '${throughput.toStringAsFixed(2)} Mpx/s');

        ImageHelper.freeImage(src);
        ImageHelper.freeImage(dst);
      }
    });

    test('Brightness - Size Scaling Performance', () {
      final sizes = [
        [100, 100],
        [256, 256],
        [512, 512],
        [1000, 1000],
        [1920, 1080],
        [2000, 2000],
        [3840, 2160],
      ];

      print('\n=== Brightness - Size Scaling Performance ===');
      print('Size          | Pixels    | Time      | Throughput');
      print('------------- | --------- | --------- | -----------');

      for (final size in sizes) {
        final src = ImageHelper.createTestImage(size[0], size[1], 0x808080FF);
        final dst = ImageHelper.createTestImage(size[0], size[1], 0);

        final stopwatch = Stopwatch()..start();
        ImageProcessingFFI.adjustBrightness(src, dst, 0.2);
        stopwatch.stop();

        final pixels = size[0] * size[1];
        final megapixels = pixels / 1000000;
        final throughput = megapixels / (stopwatch.elapsedMicroseconds / 1000000);

        print('${size[0].toString().padRight(4)}x${size[1].toString().padLeft(4)} | '
            '${megapixels.toStringAsFixed(2).padLeft(9)} | '
            '${stopwatch.elapsedMicroseconds.toString().padLeft(7)}μs | '
            '${throughput.toStringAsFixed(2)} Mpx/s');

        ImageHelper.freeImage(src);
        ImageHelper.freeImage(dst);
      }
    });

    test('Box Blur - Radius Scaling', () {
      final radii = [1, 2, 3, 5, 7, 10];

      print('\n=== Box Blur - Radius Scaling (500x500 image) ===');
      print('Radius | Time       | Pixels/sec');
      print('------ | ---------- | ----------');

      for (final radius in radii) {
        final src = ImageHelper.createTestImage(500, 500, 0xFF0000FF);
        final dst = ImageHelper.createTestImage(500, 500, 0);

        final stopwatch = Stopwatch()..start();
        ImageProcessingFFI.applyBoxBlur(src, dst, radius);
        stopwatch.stop();

        final pixelsPerSec = (500 * 500) / (stopwatch.elapsedMicroseconds / 1000000);

        print('${radius.toString().padLeft(6)} | '
            '${stopwatch.elapsedMicroseconds.toString().padLeft(8)}μs | '
            '${pixelsPerSec.toStringAsFixed(0).padLeft(10)}');

        ImageHelper.freeImage(src);
        ImageHelper.freeImage(dst);
      }
    });

    test('Histogram - Size Scaling', () {
      final sizes = [
        [100, 100],
        [500, 500],
        [1000, 1000],
        [2000, 2000],
      ];

      print('\n=== Histogram - Size Scaling ===');
      print('Size          | Pixels    | Time      | Throughput');
      print('------------- | --------- | --------- | -----------');

      for (final size in sizes) {
        final buffer = ImageHelper.createTestImage(size[0], size[1], 0xFF0000FF);
        final histogram = ImageHelper.createHistogram();

        final stopwatch = Stopwatch()..start();
        ImageProcessingFFI.calculateHistogram(buffer, histogram, 0);
        stopwatch.stop();

        final pixels = size[0] * size[1];
        final megapixels = pixels / 1000000;
        final throughput = megapixels / (stopwatch.elapsedMicroseconds / 1000000);

        print('${size[0].toString().padRight(4)}x${size[1].toString().padLeft(4)} | '
            '${megapixels.toStringAsFixed(2).padLeft(9)} | '
            '${stopwatch.elapsedMicroseconds.toString().padLeft(7)}μs | '
            '${throughput.toStringAsFixed(2)} Mpx/s');

        ImageHelper.freeImage(buffer);
        ImageHelper.freeHistogram(histogram);
      }
    });

    test('Color Statistics - Size Scaling', () {
      final sizes = [
        [100, 100],
        [500, 500],
        [1000, 1000],
        [2000, 2000],
      ];

      print('\n=== Color Statistics - Size Scaling ===');
      print('Size          | Pixels    | Time       | Throughput');
      print('------------- | --------- | ---------- | -----------');

      for (final size in sizes) {
        final buffer = ImageHelper.createTestImage(size[0], size[1], 0x7F7F7FFF);
        final stats = ImageHelper.createColorStats();

        final stopwatch = Stopwatch()..start();
        ImageProcessingFFI.calculateColorStats(buffer, stats);
        stopwatch.stop();

        final pixels = size[0] * size[1];
        final megapixels = pixels / 1000000;
        final throughput = megapixels / (stopwatch.elapsedMicroseconds / 1000000);

        print('${size[0].toString().padRight(4)}x${size[1].toString().padLeft(4)} | '
            '${megapixels.toStringAsFixed(2).padLeft(9)} | '
            '${stopwatch.elapsedMicroseconds.toString().padLeft(8)}μs | '
            '${throughput.toStringAsFixed(2)} Mpx/s');

        ImageHelper.freeImage(buffer);
        ImageHelper.freeColorStats(stats);
      }
    });

    test('SIMD Performance Tracking', () {
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

      if (metrics.ref.simd_operations > 0) {
        print('Using SIMD acceleration: YES');
      } else {
        print('Using SIMD acceleration: NO (scalar fallback)');
      }

      ImageHelper.freeImage(src);
      ImageHelper.freeImage(dst);
      ImageHelper.freePerformanceMetrics(metrics);
    });

    test('Pipeline Performance - Sequential Operations', () {
      print('\n=== Pipeline Performance ===');

      final sizes = [
        [500, 500],
        [1000, 1000],
        [1920, 1080],
      ];

      for (final size in sizes) {
        final src = ImageHelper.createTestImage(size[0], size[1], 0xFF0000FF);
        final temp1 = ImageHelper.createTestImage(size[0], size[1], 0);
        final temp2 = ImageHelper.createTestImage(size[0], size[1], 0);
        final dst = ImageHelper.createTestImage(size[0], size[1], 0);

        final stopwatch = Stopwatch()..start();

        ImageProcessingFFI.convertToGrayscale(src, temp1);
        ImageProcessingFFI.adjustBrightness(temp1, temp2, 0.2);
        ImageProcessingFFI.applyBoxBlur(temp2, dst, 2);

        stopwatch.stop();

        print('${size[0]}x${size[1]}: 3 operations in ${stopwatch.elapsedMicroseconds}μs');

        ImageHelper.freeImage(src);
        ImageHelper.freeImage(temp1);
        ImageHelper.freeImage(temp2);
        ImageHelper.freeImage(dst);
      }
    });

    test('Batch Processing - Multiple Images', () {
      print('\n=== Batch Processing - 100 images (100x100 each) ===');

      final images = <ffi.Pointer<ImageBuffer>>[];
      final results = <ffi.Pointer<ImageBuffer>>[];

      for (int i = 0; i < 100; i++) {
        images.add(ImageHelper.createTestImage(100, 100, 0xFF0000FF));
        results.add(ImageHelper.createTestImage(100, 100, 0));
      }

      final stopwatch = Stopwatch()..start();

      for (int i = 0; i < 100; i++) {
        ImageProcessingFFI.convertToGrayscale(images[i], results[i]);
      }

      stopwatch.stop();

      print('Total time: ${stopwatch.elapsedMilliseconds}ms');
      print('Avg per image: ${stopwatch.elapsedMicroseconds ~/ 100}μs');
      print('Images per second: ${(100 / (stopwatch.elapsedMicroseconds / 1000000)).toStringAsFixed(0)}');

      for (final img in images) {
        ImageHelper.freeImage(img);
      }
      for (final img in results) {
        ImageHelper.freeImage(img);
      }
    });
  });
}
