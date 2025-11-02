import 'dart:ffi' as ffi;
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'generated.dart';

class ImageProcessingFFI {
  static final ffi.DynamicLibrary _dylib = _loadLibrary();

  static ffi.DynamicLibrary _loadLibrary() {
    if (Platform.isMacOS) {
      return ffi.DynamicLibrary.open(
          '../rust/target/release/libimage_processing_ffi.dylib');
    } else if (Platform.isLinux) {
      return ffi.DynamicLibrary.open(
          '../rust/target/release/libimage_processing_ffi.so');
    } else if (Platform.isWindows) {
      return ffi.DynamicLibrary.open(
          '../rust/target/release/image_processing_ffi.dll');
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  // Initialize image pool
  static final _initImagePool = _dylib.lookupFunction<
      ffi.Void Function(ffi.Size),
      void Function(int)>('init_image_pool');

  static void initImagePool(int capacity) {
    _initImagePool(capacity);
  }

  // Grayscale conversion
  static final _convertToGrayscale = _dylib.lookupFunction<
      ffi.Bool Function(ffi.Pointer<ImageBuffer>, ffi.Pointer<ImageBuffer>),
      bool Function(ffi.Pointer<ImageBuffer>,
          ffi.Pointer<ImageBuffer>)>('convert_to_grayscale');

  static bool convertToGrayscale(
      ffi.Pointer<ImageBuffer> src, ffi.Pointer<ImageBuffer> dst) {
    return _convertToGrayscale(src, dst);
  }

  // Box blur
  static final _applyBoxBlur = _dylib.lookupFunction<
      ffi.Bool Function(
          ffi.Pointer<ImageBuffer>, ffi.Pointer<ImageBuffer>, ffi.Uint32),
      bool Function(ffi.Pointer<ImageBuffer>, ffi.Pointer<ImageBuffer>,
          int)>('apply_box_blur');

  static bool applyBoxBlur(
      ffi.Pointer<ImageBuffer> src, ffi.Pointer<ImageBuffer> dst, int radius) {
    return _applyBoxBlur(src, dst, radius);
  }

  // Brightness adjustment
  static final _adjustBrightness = _dylib.lookupFunction<
      ffi.Bool Function(
          ffi.Pointer<ImageBuffer>, ffi.Pointer<ImageBuffer>, ffi.Float),
      bool Function(ffi.Pointer<ImageBuffer>, ffi.Pointer<ImageBuffer>,
          double)>('adjust_brightness');

  static bool adjustBrightness(
      ffi.Pointer<ImageBuffer> src, ffi.Pointer<ImageBuffer> dst, double adjustment) {
    return _adjustBrightness(src, dst, adjustment);
  }

  // Calculate histogram
  static final _calculateHistogram = _dylib.lookupFunction<
      ffi.Bool Function(ffi.Pointer<ImageBuffer>, ffi.Pointer<Histogram>,
          ffi.Uint32),
      bool Function(ffi.Pointer<ImageBuffer>, ffi.Pointer<Histogram>,
          int)>('calculate_histogram');

  static bool calculateHistogram(
      ffi.Pointer<ImageBuffer> buffer, ffi.Pointer<Histogram> histogram, int channel) {
    return _calculateHistogram(buffer, histogram, channel);
  }

  // Calculate color stats
  static final _calculateColorStats = _dylib.lookupFunction<
      ffi.Bool Function(
          ffi.Pointer<ImageBuffer>, ffi.Pointer<ColorStats>),
      bool Function(ffi.Pointer<ImageBuffer>,
          ffi.Pointer<ColorStats>)>('calculate_color_stats');

  static bool calculateColorStats(
      ffi.Pointer<ImageBuffer> buffer, ffi.Pointer<ColorStats> stats) {
    return _calculateColorStats(buffer, stats);
  }

  // Performance metrics
  static final _getPerformanceMetrics = _dylib.lookupFunction<
      ffi.Bool Function(ffi.Pointer<PerformanceMetrics>),
      bool Function(
          ffi.Pointer<PerformanceMetrics>)>('get_performance_metrics');

  static bool getPerformanceMetrics(ffi.Pointer<PerformanceMetrics> metrics) {
    return _getPerformanceMetrics(metrics);
  }

  static final _resetPerformanceMetrics = _dylib
      .lookupFunction<ffi.Void Function(), void Function()>(
          'reset_performance_metrics');

  static void resetPerformanceMetrics() {
    _resetPerformanceMetrics();
  }
}

// Helper functions for creating test images
class ImageHelper {
  static ffi.Pointer<ImageBuffer> createTestImage(
      int width, int height, int color) {
    final buffer = calloc<ImageBuffer>();
    buffer.ref.width = width;
    buffer.ref.height = height;
    buffer.ref.stride = width;
    buffer.ref.color_space = 1; // RGBA
    buffer.ref.data_count = width * height;

    for (int i = 0; i < width * height; i++) {
      buffer.ref.data[i] = color;
    }

    return buffer;
  }

  static void freeImage(ffi.Pointer<ImageBuffer> buffer) {
    calloc.free(buffer);
  }

  static ffi.Pointer<Histogram> createHistogram() {
    return calloc<Histogram>();
  }

  static void freeHistogram(ffi.Pointer<Histogram> histogram) {
    calloc.free(histogram);
  }

  static ffi.Pointer<ColorStats> createColorStats() {
    return calloc<ColorStats>();
  }

  static void freeColorStats(ffi.Pointer<ColorStats> stats) {
    calloc.free(stats);
  }

  static ffi.Pointer<PerformanceMetrics> createPerformanceMetrics() {
    return calloc<PerformanceMetrics>();
  }

  static void freePerformanceMetrics(ffi.Pointer<PerformanceMetrics> metrics) {
    calloc.free(metrics);
  }
}
