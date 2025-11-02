// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: constant_identifier_names

import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'dart:typed_data';
import 'dart:io';
import 'dart:convert';

enum ColorSpace {
  RGB(0), // Value: 0
  RGBA(1), // Value: 1
  GRAYSCALE(2), // Value: 2
  YUV(3), // Value: 3
  HSV(4); // Value: 4

  const ColorSpace(this.value);
  final int value;
}

enum FilterType {
  BLUR(0), // Value: 0
  SHARPEN(1), // Value: 1
  EDGE_DETECT(2), // Value: 2
  EMBOSS(3), // Value: 3
  GAUSSIAN(4); // Value: 4

  const FilterType(this.value);
  final int value;
}

enum InterpolationMode {
  NEAREST(0), // Value: 0
  BILINEAR(1), // Value: 1
  BICUBIC(2); // Value: 2

  const InterpolationMode(this.value);
  final int value;
}

const int PIXEL_SIZE = 16;
const int PIXEL_ALIGNMENT = 8;

final class Pixel extends ffi.Struct {
  @ffi.Uint32()
  external int r;

  @ffi.Uint32()
  external int g;

  @ffi.Uint32()
  external int b;

  @ffi.Uint32()
  external int a;

  static ffi.Pointer<Pixel> allocate() {
    return calloc<Pixel>();
  }
}

const int PIXELF32_SIZE = 16;
const int PIXELF32_ALIGNMENT = 8;

final class PixelF32 extends ffi.Struct {
  @ffi.Float()
  external double r;

  @ffi.Float()
  external double g;

  @ffi.Float()
  external double b;

  @ffi.Float()
  external double a;

  static ffi.Pointer<PixelF32> allocate() {
    return calloc<PixelF32>();
  }
}

const int IMAGEINFO_SIZE = 24;
const int IMAGEINFO_ALIGNMENT = 8;

final class ImageInfo extends ffi.Struct {
  @ffi.Uint32()
  external int width;

  @ffi.Uint32()
  external int height;

  @ffi.Uint32()
  external int color_space;

  @ffi.Uint32()
  external int channels;

  @ffi.Uint32()
  external int bit_depth;

  static ffi.Pointer<ImageInfo> allocate() {
    return calloc<ImageInfo>();
  }
}

const int IMAGEBUFFER_SIZE = 67108888;
const int IMAGEBUFFER_ALIGNMENT = 8;

final class ImageBuffer extends ffi.Struct {
  @ffi.Uint32()
  external int data_count;

  @ffi.Array<ffi.Uint32>(16777216)
  external ffi.Array<ffi.Uint32> data;

  @ffi.Uint32()
  external int width;

  @ffi.Uint32()
  external int height;

  @ffi.Uint32()
  external int stride;

  @ffi.Uint32()
  external int color_space;

  List<int> get data_list {
    return List.generate(
      data_count,
      (i) => data[i],
      growable: false,
    );
  }

  void add_data(int item) {
    if (data_count >= 16777216) {
      throw Exception('data array full');
    }
    data[data_count] = item;
    data_count++;
  }

  static ffi.Pointer<ImageBuffer> allocate() {
    return calloc<ImageBuffer>();
  }
}

const int CONVOLUTIONKERNEL_SIZE = 120;
const int CONVOLUTIONKERNEL_ALIGNMENT = 8;

final class ConvolutionKernel extends ffi.Struct {
  @ffi.Uint32()
  external int weights_count;

  @ffi.Array<ffi.Float>(25)
  external ffi.Array<ffi.Float> weights;

  @ffi.Uint32()
  external int size;

  @ffi.Float()
  external double divisor;

  @ffi.Float()
  external double bias;

  List<double> get weights_list {
    return List.generate(
      weights_count,
      (i) => weights[i],
      growable: false,
    );
  }

  void add_weight(double item) {
    if (weights_count >= 25) {
      throw Exception('weights array full');
    }
    weights[weights_count] = item;
    weights_count++;
  }

  static ffi.Pointer<ConvolutionKernel> allocate() {
    return calloc<ConvolutionKernel>();
  }
}

const int RECT_SIZE = 16;
const int RECT_ALIGNMENT = 8;

final class Rect extends ffi.Struct {
  @ffi.Uint32()
  external int x;

  @ffi.Uint32()
  external int y;

  @ffi.Uint32()
  external int width;

  @ffi.Uint32()
  external int height;

  static ffi.Pointer<Rect> allocate() {
    return calloc<Rect>();
  }
}

const int TRANSFORM2D_SIZE = 24;
const int TRANSFORM2D_ALIGNMENT = 8;

final class Transform2D extends ffi.Struct {
  @ffi.Float()
  external double m11;

  @ffi.Float()
  external double m12;

  @ffi.Float()
  external double m13;

  @ffi.Float()
  external double m21;

  @ffi.Float()
  external double m22;

  @ffi.Float()
  external double m23;

  static ffi.Pointer<Transform2D> allocate() {
    return calloc<Transform2D>();
  }
}

const int HISTOGRAM_SIZE = 1032;
const int HISTOGRAM_ALIGNMENT = 8;

final class Histogram extends ffi.Struct {
  @ffi.Uint32()
  external int bins_count;

  @ffi.Array<ffi.Uint32>(256)
  external ffi.Array<ffi.Uint32> bins;

  List<int> get bins_list {
    return List.generate(
      bins_count,
      (i) => bins[i],
      growable: false,
    );
  }

  void add_bin(int item) {
    if (bins_count >= 256) {
      throw Exception('bins array full');
    }
    bins[bins_count] = item;
    bins_count++;
  }

  static ffi.Pointer<Histogram> allocate() {
    return calloc<Histogram>();
  }
}

const int COLORSTATS_SIZE = 48;
const int COLORSTATS_ALIGNMENT = 8;

final class ColorStats extends ffi.Struct {
  @ffi.Float()
  external double mean_r;

  @ffi.Float()
  external double mean_g;

  @ffi.Float()
  external double mean_b;

  @ffi.Float()
  external double stddev_r;

  @ffi.Float()
  external double stddev_g;

  @ffi.Float()
  external double stddev_b;

  @ffi.Uint32()
  external int min_r;

  @ffi.Uint32()
  external int min_g;

  @ffi.Uint32()
  external int min_b;

  @ffi.Uint32()
  external int max_r;

  @ffi.Uint32()
  external int max_g;

  @ffi.Uint32()
  external int max_b;

  static ffi.Pointer<ColorStats> allocate() {
    return calloc<ColorStats>();
  }
}

const int PROCESSINGRESULT_SIZE = 272;
const int PROCESSINGRESULT_ALIGNMENT = 8;

final class ProcessingResult extends ffi.Struct {
  @ffi.Uint64()
  external int processing_time_ns;

  @ffi.Uint32()
  external int pixels_processed;

  @ffi.Uint8()
  external int success;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> error_message;

  String get error_message_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (error_message[i] == 0) break;
      bytes.add(error_message[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set error_message_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      error_message[i] = bytes[i];
    }
    if (len < 256) {
      error_message[len] = 0;
    }
  }

  static ffi.Pointer<ProcessingResult> allocate() {
    return calloc<ProcessingResult>();
  }
}

const int BATCHINFO_SIZE = 24;
const int BATCHINFO_ALIGNMENT = 8;

final class BatchInfo extends ffi.Struct {
  @ffi.Uint64()
  external int total_time_ns;

  @ffi.Uint32()
  external int total_images;

  @ffi.Uint32()
  external int processed;

  @ffi.Uint32()
  external int failed;

  static ffi.Pointer<BatchInfo> allocate() {
    return calloc<BatchInfo>();
  }
}

const int FILTERPARAMS_SIZE = 16;
const int FILTERPARAMS_ALIGNMENT = 8;

final class FilterParams extends ffi.Struct {
  @ffi.Uint32()
  external int filter_type;

  @ffi.Float()
  external double strength;

  @ffi.Float()
  external double radius;

  @ffi.Float()
  external double threshold;

  static ffi.Pointer<FilterParams> allocate() {
    return calloc<FilterParams>();
  }
}

const int RESIZEPARAMS_SIZE = 16;
const int RESIZEPARAMS_ALIGNMENT = 8;

final class ResizeParams extends ffi.Struct {
  @ffi.Uint32()
  external int new_width;

  @ffi.Uint32()
  external int new_height;

  @ffi.Uint32()
  external int interpolation;

  @ffi.Uint8()
  external int preserve_aspect;

  static ffi.Pointer<ResizeParams> allocate() {
    return calloc<ResizeParams>();
  }
}

const int COLORADJUSTMENT_SIZE = 24;
const int COLORADJUSTMENT_ALIGNMENT = 8;

final class ColorAdjustment extends ffi.Struct {
  @ffi.Float()
  external double brightness;

  @ffi.Float()
  external double contrast;

  @ffi.Float()
  external double saturation;

  @ffi.Float()
  external double hue_shift;

  @ffi.Float()
  external double gamma;

  static ffi.Pointer<ColorAdjustment> allocate() {
    return calloc<ColorAdjustment>();
  }
}

const int PERFORMANCEMETRICS_SIZE = 40;
const int PERFORMANCEMETRICS_ALIGNMENT = 8;

final class PerformanceMetrics extends ffi.Struct {
  @ffi.Uint64()
  external int total_pixels_processed;

  @ffi.Uint64()
  external int total_time_ns;

  @ffi.Double()
  external double megapixels_per_second;

  @ffi.Uint32()
  external int cache_hits;

  @ffi.Uint32()
  external int cache_misses;

  @ffi.Uint32()
  external int simd_operations;

  @ffi.Uint32()
  external int scalar_operations;

  static ffi.Pointer<PerformanceMetrics> allocate() {
    return calloc<PerformanceMetrics>();
  }
}

const int IMAGEWORKSPACE_SIZE = 67108872;
const int IMAGEWORKSPACE_ALIGNMENT = 8;

final class ImageWorkspace extends ffi.Struct {
  @ffi.Uint32()
  external int temp_buffer_count;

  @ffi.Array<ffi.Float>(16777216)
  external ffi.Array<ffi.Float> temp_buffer;

  @ffi.Uint32()
  external int buffer_size;

  List<double> get temp_buffer_list {
    return List.generate(
      temp_buffer_count,
      (i) => temp_buffer[i],
      growable: false,
    );
  }

  void add_temp_buffer(double item) {
    if (temp_buffer_count >= 16777216) {
      throw Exception('temp_buffer array full');
    }
    temp_buffer[temp_buffer_count] = item;
    temp_buffer_count++;
  }

  static ffi.Pointer<ImageWorkspace> allocate() {
    return calloc<ImageWorkspace>();
  }
}

class FFIBindings {
  static final _dylib = _loadLibrary();

  static ffi.DynamicLibrary _loadLibrary() {
    if (Platform.isAndroid) {
      return ffi.DynamicLibrary.open('libgenerated.so');
    } else if (Platform.isIOS) {
      return ffi.DynamicLibrary.process();
    } else if (Platform.isMacOS) {
      return ffi.DynamicLibrary.open('libgenerated.dylib');
    } else if (Platform.isWindows) {
      return ffi.DynamicLibrary.open('generated.dll');
    } else {
      return ffi.DynamicLibrary.open('libgenerated.so');
    }
  }

  late final pixel_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('pixel_size');

  late final pixel_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('pixel_alignment');

  late final pixelf32_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('pixelf32_size');

  late final pixelf32_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('pixelf32_alignment');

  late final imageinfo_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('imageinfo_size');

  late final imageinfo_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('imageinfo_alignment');

  late final imagebuffer_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('imagebuffer_size');

  late final imagebuffer_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('imagebuffer_alignment');

  late final convolutionkernel_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('convolutionkernel_size');

  late final convolutionkernel_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('convolutionkernel_alignment');

  late final rect_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('rect_size');

  late final rect_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('rect_alignment');

  late final transform2d_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('transform2d_size');

  late final transform2d_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('transform2d_alignment');

  late final histogram_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('histogram_size');

  late final histogram_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('histogram_alignment');

  late final colorstats_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('colorstats_size');

  late final colorstats_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('colorstats_alignment');

  late final processingresult_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('processingresult_size');

  late final processingresult_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('processingresult_alignment');

  late final batchinfo_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('batchinfo_size');

  late final batchinfo_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('batchinfo_alignment');

  late final filterparams_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('filterparams_size');

  late final filterparams_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('filterparams_alignment');

  late final resizeparams_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('resizeparams_size');

  late final resizeparams_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('resizeparams_alignment');

  late final coloradjustment_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('coloradjustment_size');

  late final coloradjustment_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('coloradjustment_alignment');

  late final performancemetrics_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('performancemetrics_size');

  late final performancemetrics_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('performancemetrics_alignment');

  late final imageworkspace_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('imageworkspace_size');

  late final imageworkspace_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('imageworkspace_alignment');
}
