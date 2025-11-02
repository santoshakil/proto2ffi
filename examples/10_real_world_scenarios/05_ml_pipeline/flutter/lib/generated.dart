// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: constant_identifier_names

import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'dart:typed_data';
import 'dart:io';
import 'dart:convert';

enum TensorDataType {
  FLOAT32(0), // Value: 0
  FLOAT64(1), // Value: 1
  INT32(2), // Value: 2
  INT64(3), // Value: 3
  UINT8(4); // Value: 4

  const TensorDataType(this.value);
  final int value;
}

enum ModelStatus {
  UNINITIALIZED(0), // Value: 0
  LOADING(1), // Value: 1
  READY(2), // Value: 2
  INFERRING(3), // Value: 3
  ERROR(4); // Value: 4

  const ModelStatus(this.value);
  final int value;
}

const int TENSORSHAPE_SIZE = 48;
const int TENSORSHAPE_ALIGNMENT = 8;

final class TensorShape extends ffi.Struct {
  @ffi.Uint32()
  external int dimensions_count;

  @ffi.Array<ffi.Uint32>(8)
  external ffi.Array<ffi.Uint32> dimensions;

  @ffi.Uint32()
  external int rank;

  @ffi.Uint32()
  external int total_elements;

  List<int> get dimensions_list {
    return List.generate(
      dimensions_count,
      (i) => dimensions[i],
      growable: false,
    );
  }

  void add_dimension(int item) {
    if (dimensions_count >= 8) {
      throw Exception('dimensions array full');
    }
    dimensions[dimensions_count] = item;
    dimensions_count++;
  }

  static ffi.Pointer<TensorShape> allocate() {
    return calloc<TensorShape>();
  }
}

const int TENSOR_SIZE = 4000128;
const int TENSOR_ALIGNMENT = 8;

final class Tensor extends ffi.Struct {
  external TensorShape shape;

  @ffi.Uint32()
  external int data_f32_count;

  @ffi.Array<ffi.Float>(1000000)
  external ffi.Array<ffi.Float> data_f32;

  @ffi.Uint32()
  external int dtype;

  @ffi.Uint32()
  external int data_count;

  @ffi.Array<ffi.Uint8>(64)
  external ffi.Array<ffi.Uint8> name;

  List<double> get data_f32_list {
    return List.generate(
      data_f32_count,
      (i) => data_f32[i],
      growable: false,
    );
  }

  void add_data_f32(double item) {
    if (data_f32_count >= 1000000) {
      throw Exception('data_f32 array full');
    }
    data_f32[data_f32_count] = item;
    data_f32_count++;
  }

  String get name_str {
    final bytes = <int>[];
    for (int i = 0; i < 64; i++) {
      if (name[i] == 0) break;
      bytes.add(name[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set name_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 63 ? bytes.length : 63;
    for (int i = 0; i < len; i++) {
      name[i] = bytes[i];
    }
    if (len < 64) {
      name[len] = 0;
    }
  }

  static ffi.Pointer<Tensor> allocate() {
    return calloc<Tensor>();
  }
}

const int MODELPARAMETERS_SIZE = 400012944;
const int MODELPARAMETERS_ALIGNMENT = 8;

final class ModelParameters extends ffi.Struct {
  @ffi.Uint32()
  external int layers_count;

  @ffi.Array<Tensor>(100)
  external ffi.Array<Tensor> layers;

  @ffi.Uint32()
  external int parameter_count;

  @ffi.Uint32()
  external int layer_count;

  @ffi.Array<ffi.Uint8>(128)
  external ffi.Array<ffi.Uint8> model_name;

  List<Tensor> get layers_list {
    return List.generate(
      layers_count,
      (i) => layers[i],
      growable: false,
    );
  }

  Tensor get_next_layer() {
    if (layers_count >= 100) {
      throw Exception('layers array full');
    }
    final idx = layers_count;
    layers_count++;
    return layers[idx];
  }

  String get model_name_str {
    final bytes = <int>[];
    for (int i = 0; i < 128; i++) {
      if (model_name[i] == 0) break;
      bytes.add(model_name[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set model_name_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 127 ? bytes.length : 127;
    for (int i = 0; i < len; i++) {
      model_name[i] = bytes[i];
    }
    if (len < 128) {
      model_name[len] = 0;
    }
  }

  static ffi.Pointer<ModelParameters> allocate() {
    return calloc<ModelParameters>();
  }
}

const int INFERENCEREQUEST_SIZE = 4000152;
const int INFERENCEREQUEST_ALIGNMENT = 8;

final class InferenceRequest extends ffi.Struct {
  @ffi.Uint64()
  external int request_id;

  @ffi.Uint64()
  external int timestamp_ns;

  external Tensor input;

  @ffi.Uint32()
  external int batch_size;

  static ffi.Pointer<InferenceRequest> allocate() {
    return calloc<InferenceRequest>();
  }
}

const int INFERENCERESULT_SIZE = 4000152;
const int INFERENCERESULT_ALIGNMENT = 8;

final class InferenceResult extends ffi.Struct {
  @ffi.Uint64()
  external int request_id;

  external Tensor output;

  @ffi.Uint64()
  external int inference_time_ns;

  @ffi.Float()
  external double confidence;

  static ffi.Pointer<InferenceResult> allocate() {
    return calloc<InferenceResult>();
  }
}

const int TRAININGMETRICS_SIZE = 40;
const int TRAININGMETRICS_ALIGNMENT = 8;

final class TrainingMetrics extends ffi.Struct {
  @ffi.Uint64()
  external int epoch;

  @ffi.Uint64()
  external int iteration;

  @ffi.Uint64()
  external int batch_time_ns;

  @ffi.Float()
  external double loss;

  @ffi.Float()
  external double accuracy;

  @ffi.Float()
  external double learning_rate;

  static ffi.Pointer<TrainingMetrics> allocate() {
    return calloc<TrainingMetrics>();
  }
}

const int BATCHDATA_SIZE = 512016400;
const int BATCHDATA_ALIGNMENT = 8;

final class BatchData extends ffi.Struct {
  @ffi.Uint32()
  external int inputs_count;

  @ffi.Array<Tensor>(64)
  external ffi.Array<Tensor> inputs;

  @ffi.Uint32()
  external int labels_count;

  @ffi.Array<Tensor>(64)
  external ffi.Array<Tensor> labels;

  @ffi.Uint32()
  external int batch_size;

  List<Tensor> get inputs_list {
    return List.generate(
      inputs_count,
      (i) => inputs[i],
      growable: false,
    );
  }

  Tensor get_next_input() {
    if (inputs_count >= 64) {
      throw Exception('inputs array full');
    }
    final idx = inputs_count;
    inputs_count++;
    return inputs[idx];
  }

  List<Tensor> get labels_list {
    return List.generate(
      labels_count,
      (i) => labels[i],
      growable: false,
    );
  }

  Tensor get_next_label() {
    if (labels_count >= 64) {
      throw Exception('labels array full');
    }
    final idx = labels_count;
    labels_count++;
    return labels[idx];
  }

  static ffi.Pointer<BatchData> allocate() {
    return calloc<BatchData>();
  }
}

const int PIPELINESTATS_SIZE = 40;
const int PIPELINESTATS_ALIGNMENT = 8;

final class PipelineStats extends ffi.Struct {
  @ffi.Uint64()
  external int total_inferences;

  @ffi.Uint64()
  external int successful_inferences;

  @ffi.Uint64()
  external int failed_inferences;

  @ffi.Uint64()
  external int bytes_processed;

  @ffi.Float()
  external double average_latency_ms;

  @ffi.Float()
  external double throughput_per_second;

  static ffi.Pointer<PipelineStats> allocate() {
    return calloc<PipelineStats>();
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

  late final tensorshape_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('tensorshape_size');

  late final tensorshape_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('tensorshape_alignment');

  late final tensor_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('tensor_size');

  late final tensor_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('tensor_alignment');

  late final modelparameters_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('modelparameters_size');

  late final modelparameters_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('modelparameters_alignment');

  late final inferencerequest_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('inferencerequest_size');

  late final inferencerequest_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('inferencerequest_alignment');

  late final inferenceresult_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('inferenceresult_size');

  late final inferenceresult_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('inferenceresult_alignment');

  late final trainingmetrics_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('trainingmetrics_size');

  late final trainingmetrics_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('trainingmetrics_alignment');

  late final batchdata_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('batchdata_size');

  late final batchdata_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('batchdata_alignment');

  late final pipelinestats_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('pipelinestats_size');

  late final pipelinestats_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('pipelinestats_alignment');
}
