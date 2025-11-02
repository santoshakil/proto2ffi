// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: constant_identifier_names

import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'dart:typed_data';
import 'dart:io';
import 'dart:convert';

const int TASK_SIZE = 560;
const int TASK_ALIGNMENT = 8;

final class Task extends ffi.Struct {
  @ffi.Uint64()
  external int id;

  @ffi.Uint64()
  external int created_at;

  @ffi.Uint64()
  external int updated_at;

  external ffi.Pointer<ffi.Uint8> tags;

  @ffi.Uint32()
  external int priority;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> title;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> description;

  @ffi.Uint8()
  external int completed;

  String get title_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (title[i] == 0) break;
      bytes.add(title[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set title_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      title[i] = bytes[i];
    }
    if (len < 256) {
      title[len] = 0;
    }
  }

  String get description_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (description[i] == 0) break;
      bytes.add(description[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set description_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      description[i] = bytes[i];
    }
    if (len < 256) {
      description[len] = 0;
    }
  }

  static ffi.Pointer<Task> allocate() {
    return calloc<Task>();
  }
}

const int TASKFILTER_SIZE = 32;
const int TASKFILTER_ALIGNMENT = 8;

final class TaskFilter extends ffi.Struct {
  external ffi.Pointer<ffi.Uint8> tags;

  @ffi.Uint32()
  external int min_priority;

  @ffi.Uint32()
  external int max_priority;

  @ffi.Uint8()
  external int filter_by_completed;

  @ffi.Uint8()
  external int completed_value;

  @ffi.Uint8()
  external int filter_by_priority;

  static ffi.Pointer<TaskFilter> allocate() {
    return calloc<TaskFilter>();
  }
}

const int TASKSTATS_SIZE = 64;
const int TASKSTATS_ALIGNMENT = 8;

final class TaskStats extends ffi.Struct {
  @ffi.Uint64()
  external int total_tasks;

  @ffi.Uint64()
  external int completed_tasks;

  @ffi.Uint64()
  external int pending_tasks;

  @ffi.Uint64()
  external int high_priority_tasks;

  @ffi.Double()
  external double completion_rate;

  @ffi.Uint64()
  external int avg_completion_time_ms;

  @ffi.Uint64()
  external int total_memory_used;

  @ffi.Uint64()
  external int pool_allocations;

  static ffi.Pointer<TaskStats> allocate() {
    return calloc<TaskStats>();
  }
}

const int BATCHTASKREQUEST_SIZE = 16;
const int BATCHTASKREQUEST_ALIGNMENT = 8;

final class BatchTaskRequest extends ffi.Struct {
  external ffi.Pointer<Task> tasks;

  static ffi.Pointer<BatchTaskRequest> allocate() {
    return calloc<BatchTaskRequest>();
  }
}

const int BATCHTASKRESPONSE_SIZE = 32;
const int BATCHTASKRESPONSE_ALIGNMENT = 8;

final class BatchTaskResponse extends ffi.Struct {
  external ffi.Pointer<ffi.Uint64> task_ids;

  @ffi.Uint64()
  external int success_count;

  @ffi.Uint64()
  external int error_count;

  static ffi.Pointer<BatchTaskResponse> allocate() {
    return calloc<BatchTaskResponse>();
  }
}

const int PERFORMANCEMETRICS_SIZE = 40;
const int PERFORMANCEMETRICS_ALIGNMENT = 8;

final class PerformanceMetrics extends ffi.Struct {
  @ffi.Uint64()
  external int operation_duration_ns;

  @ffi.Uint64()
  external int memory_allocated_bytes;

  @ffi.Uint64()
  external int pool_hits;

  @ffi.Uint64()
  external int pool_misses;

  @ffi.Double()
  external double cpu_usage_percent;

  static ffi.Pointer<PerformanceMetrics> allocate() {
    return calloc<PerformanceMetrics>();
  }
}

const int TASKSEARCHREQUEST_SIZE = 264;
const int TASKSEARCHREQUEST_ALIGNMENT = 8;

final class TaskSearchRequest extends ffi.Struct {
  @ffi.Uint32()
  external int limit;

  @ffi.Uint32()
  external int offset;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> query;

  String get query_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (query[i] == 0) break;
      bytes.add(query[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set query_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      query[i] = bytes[i];
    }
    if (len < 256) {
      query[len] = 0;
    }
  }

  static ffi.Pointer<TaskSearchRequest> allocate() {
    return calloc<TaskSearchRequest>();
  }
}

const int TASKSEARCHRESPONSE_SIZE = 32;
const int TASKSEARCHRESPONSE_ALIGNMENT = 8;

final class TaskSearchResponse extends ffi.Struct {
  external ffi.Pointer<Task> tasks;

  @ffi.Uint64()
  external int total_matches;

  @ffi.Uint64()
  external int search_time_us;

  static ffi.Pointer<TaskSearchResponse> allocate() {
    return calloc<TaskSearchResponse>();
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

  late final task_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('task_size');

  late final task_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('task_alignment');

  late final taskfilter_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('taskfilter_size');

  late final taskfilter_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('taskfilter_alignment');

  late final taskstats_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('taskstats_size');

  late final taskstats_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('taskstats_alignment');

  late final batchtaskrequest_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('batchtaskrequest_size');

  late final batchtaskrequest_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('batchtaskrequest_alignment');

  late final batchtaskresponse_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('batchtaskresponse_size');

  late final batchtaskresponse_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('batchtaskresponse_alignment');

  late final performancemetrics_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('performancemetrics_size');

  late final performancemetrics_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('performancemetrics_alignment');

  late final tasksearchrequest_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('tasksearchrequest_size');

  late final tasksearchrequest_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('tasksearchrequest_alignment');

  late final tasksearchresponse_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('tasksearchresponse_size');

  late final tasksearchresponse_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('tasksearchresponse_alignment');
}
