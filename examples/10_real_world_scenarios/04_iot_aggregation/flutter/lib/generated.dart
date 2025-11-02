// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: constant_identifier_names

import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'dart:typed_data';
import 'dart:io';
import 'dart:convert';

enum SensorType {
  TEMPERATURE(0), // Value: 0
  HUMIDITY(1), // Value: 1
  PRESSURE(2), // Value: 2
  LIGHT(3), // Value: 3
  MOTION(4), // Value: 4
  PROXIMITY(5), // Value: 5
  ACCELEROMETER(6), // Value: 6
  GYROSCOPE(7); // Value: 7

  const SensorType(this.value);
  final int value;
}

enum DeviceStatus {
  ONLINE(0), // Value: 0
  OFFLINE(1), // Value: 1
  ERROR(2), // Value: 2
  MAINTENANCE(3); // Value: 3

  const DeviceStatus(this.value);
  final int value;
}

const int SENSORREADING_SIZE = 32;
const int SENSORREADING_ALIGNMENT = 8;

final class SensorReading extends ffi.Struct {
  @ffi.Uint64()
  external int device_id;

  @ffi.Uint64()
  external int timestamp_us;

  @ffi.Uint32()
  external int sensor_type;

  @ffi.Float()
  external double value;

  @ffi.Uint32()
  external int quality;

  static ffi.Pointer<SensorReading> allocate() {
    return calloc<SensorReading>();
  }
}

const int DEVICETELEMETRY_SIZE = 40;
const int DEVICETELEMETRY_ALIGNMENT = 8;

final class DeviceTelemetry extends ffi.Struct {
  @ffi.Uint64()
  external int device_id;

  @ffi.Uint64()
  external int timestamp_us;

  @ffi.Uint32()
  external int battery_level;

  @ffi.Float()
  external double temperature;

  @ffi.Uint32()
  external int signal_strength;

  @ffi.Uint32()
  external int memory_usage;

  @ffi.Uint32()
  external int cpu_usage;

  @ffi.Uint32()
  external int status;

  static ffi.Pointer<DeviceTelemetry> allocate() {
    return calloc<DeviceTelemetry>();
  }
}

const int TIMESERIESDATA_SIZE = 12024;
const int TIMESERIESDATA_ALIGNMENT = 8;

final class TimeSeriesData extends ffi.Struct {
  @ffi.Uint64()
  external int device_id;

  @ffi.Uint32()
  external int timestamps_count;

  @ffi.Array<ffi.Uint64>(1000)
  external ffi.Array<ffi.Uint64> timestamps;

  @ffi.Uint32()
  external int values_count;

  @ffi.Array<ffi.Float>(1000)
  external ffi.Array<ffi.Float> values;

  @ffi.Uint32()
  external int sensor_type;

  @ffi.Uint32()
  external int count;

  List<int> get timestamps_list {
    return List.generate(
      timestamps_count,
      (i) => timestamps[i],
      growable: false,
    );
  }

  void add_timestamp(int item) {
    if (timestamps_count >= 1000) {
      throw Exception('timestamps array full');
    }
    timestamps[timestamps_count] = item;
    timestamps_count++;
  }

  List<double> get values_list {
    return List.generate(
      values_count,
      (i) => values[i],
      growable: false,
    );
  }

  void add_value(double item) {
    if (values_count >= 1000) {
      throw Exception('values array full');
    }
    values[values_count] = item;
    values_count++;
  }

  static ffi.Pointer<TimeSeriesData> allocate() {
    return calloc<TimeSeriesData>();
  }
}

const int AGGREGATEDMETRICS_SIZE = 48;
const int AGGREGATEDMETRICS_ALIGNMENT = 8;

final class AggregatedMetrics extends ffi.Struct {
  @ffi.Uint64()
  external int device_id;

  @ffi.Uint64()
  external int start_time_us;

  @ffi.Uint64()
  external int end_time_us;

  @ffi.Float()
  external double min_value;

  @ffi.Float()
  external double max_value;

  @ffi.Float()
  external double avg_value;

  @ffi.Float()
  external double stddev;

  @ffi.Uint32()
  external int sample_count;

  static ffi.Pointer<AggregatedMetrics> allocate() {
    return calloc<AggregatedMetrics>();
  }
}

const int DEVICEGROUP_SIZE = 2128;
const int DEVICEGROUP_ALIGNMENT = 8;

final class DeviceGroup extends ffi.Struct {
  @ffi.Uint32()
  external int device_ids_count;

  @ffi.Array<ffi.Uint64>(256)
  external ffi.Array<ffi.Uint64> device_ids;

  @ffi.Uint32()
  external int group_id;

  @ffi.Uint32()
  external int device_count;

  @ffi.Array<ffi.Uint8>(64)
  external ffi.Array<ffi.Uint8> group_name;

  List<int> get device_ids_list {
    return List.generate(
      device_ids_count,
      (i) => device_ids[i],
      growable: false,
    );
  }

  void add_device_id(int item) {
    if (device_ids_count >= 256) {
      throw Exception('device_ids array full');
    }
    device_ids[device_ids_count] = item;
    device_ids_count++;
  }

  String get group_name_str {
    final bytes = <int>[];
    for (int i = 0; i < 64; i++) {
      if (group_name[i] == 0) break;
      bytes.add(group_name[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set group_name_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 63 ? bytes.length : 63;
    for (int i = 0; i < len; i++) {
      group_name[i] = bytes[i];
    }
    if (len < 64) {
      group_name[len] = 0;
    }
  }

  static ffi.Pointer<DeviceGroup> allocate() {
    return calloc<DeviceGroup>();
  }
}

const int EVENTSTREAM_SIZE = 288;
const int EVENTSTREAM_ALIGNMENT = 8;

final class EventStream extends ffi.Struct {
  @ffi.Uint64()
  external int event_id;

  @ffi.Uint64()
  external int timestamp_us;

  @ffi.Uint64()
  external int device_id;

  @ffi.Uint32()
  external int event_type;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> payload;

  String get payload_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (payload[i] == 0) break;
      bytes.add(payload[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set payload_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      payload[i] = bytes[i];
    }
    if (len < 256) {
      payload[len] = 0;
    }
  }

  static ffi.Pointer<EventStream> allocate() {
    return calloc<EventStream>();
  }
}

const int SYSTEMSTATS_SIZE = 40;
const int SYSTEMSTATS_ALIGNMENT = 8;

final class SystemStats extends ffi.Struct {
  @ffi.Uint64()
  external int total_devices;

  @ffi.Uint64()
  external int online_devices;

  @ffi.Uint64()
  external int total_readings;

  @ffi.Uint64()
  external int bytes_processed;

  @ffi.Uint32()
  external int readings_per_second;

  @ffi.Float()
  external double average_latency_ms;

  static ffi.Pointer<SystemStats> allocate() {
    return calloc<SystemStats>();
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

  late final sensorreading_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('sensorreading_size');

  late final sensorreading_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('sensorreading_alignment');

  late final devicetelemetry_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('devicetelemetry_size');

  late final devicetelemetry_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('devicetelemetry_alignment');

  late final timeseriesdata_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('timeseriesdata_size');

  late final timeseriesdata_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('timeseriesdata_alignment');

  late final aggregatedmetrics_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('aggregatedmetrics_size');

  late final aggregatedmetrics_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('aggregatedmetrics_alignment');

  late final devicegroup_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('devicegroup_size');

  late final devicegroup_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('devicegroup_alignment');

  late final eventstream_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('eventstream_size');

  late final eventstream_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('eventstream_alignment');

  late final systemstats_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('systemstats_size');

  late final systemstats_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('systemstats_alignment');
}
