// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: constant_identifier_names

import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'dart:typed_data';
import 'dart:io';
import 'dart:convert';

enum CodecType {
  H264(0), // Value: 0
  H265(1), // Value: 1
  VP8(2), // Value: 2
  VP9(3), // Value: 3
  AV1(4); // Value: 4

  const CodecType(this.value);
  final int value;
}

enum FrameType {
  I_FRAME(0), // Value: 0
  P_FRAME(1), // Value: 1
  B_FRAME(2); // Value: 2

  const FrameType(this.value);
  final int value;
}

enum ChromaSubsampling {
  YUV420(0), // Value: 0
  YUV422(1), // Value: 1
  YUV444(2); // Value: 2

  const ChromaSubsampling(this.value);
  final int value;
}

enum BufferState {
  EMPTY(0), // Value: 0
  FILLING(1), // Value: 1
  FULL(2), // Value: 2
  DRAINING(3); // Value: 3

  const BufferState(this.value);
  final int value;
}

const int FRAMEMETADATA_SIZE = 56;
const int FRAMEMETADATA_ALIGNMENT = 8;

final class FrameMetadata extends ffi.Struct {
  @ffi.Uint64()
  external int timestamp_us;

  @ffi.Uint64()
  external int pts;

  @ffi.Uint64()
  external int dts;

  @ffi.Uint32()
  external int frame_type;

  @ffi.Uint32()
  external int frame_number;

  @ffi.Uint32()
  external int width;

  @ffi.Uint32()
  external int height;

  @ffi.Uint32()
  external int bitrate;

  @ffi.Float()
  external double quality_score;

  @ffi.Uint8()
  external int keyframe;

  static ffi.Pointer<FrameMetadata> allocate() {
    return calloc<FrameMetadata>();
  }
}

const int CODECPARAMETERS_SIZE = 40;
const int CODECPARAMETERS_ALIGNMENT = 8;

final class CodecParameters extends ffi.Struct {
  @ffi.Uint32()
  external int codec;

  @ffi.Uint32()
  external int width;

  @ffi.Uint32()
  external int height;

  @ffi.Uint32()
  external int bitrate;

  @ffi.Uint32()
  external int framerate;

  @ffi.Uint32()
  external int gop_size;

  @ffi.Uint32()
  external int chroma;

  @ffi.Uint32()
  external int bit_depth;

  @ffi.Uint32()
  external int profile;

  @ffi.Uint32()
  external int level;

  static ffi.Pointer<CodecParameters> allocate() {
    return calloc<CodecParameters>();
  }
}

const int VIDEOFRAME_SIZE = 49766480;
const int VIDEOFRAME_ALIGNMENT = 8;

final class VideoFrame extends ffi.Struct {
  external FrameMetadata metadata;

  @ffi.Uint32()
  external int y_plane_count;

  @ffi.Array<ffi.Uint32>(8294400)
  external ffi.Array<ffi.Uint32> y_plane;

  @ffi.Uint32()
  external int u_plane_count;

  @ffi.Array<ffi.Uint32>(2073600)
  external ffi.Array<ffi.Uint32> u_plane;

  @ffi.Uint32()
  external int v_plane_count;

  @ffi.Array<ffi.Uint32>(2073600)
  external ffi.Array<ffi.Uint32> v_plane;

  @ffi.Uint32()
  external int y_stride;

  @ffi.Uint32()
  external int u_stride;

  @ffi.Uint32()
  external int v_stride;

  List<int> get y_plane_list {
    return List.generate(
      y_plane_count,
      (i) => y_plane[i],
      growable: false,
    );
  }

  void add_y_plane(int item) {
    if (y_plane_count >= 8294400) {
      throw Exception('y_plane array full');
    }
    y_plane[y_plane_count] = item;
    y_plane_count++;
  }

  List<int> get u_plane_list {
    return List.generate(
      u_plane_count,
      (i) => u_plane[i],
      growable: false,
    );
  }

  void add_u_plane(int item) {
    if (u_plane_count >= 2073600) {
      throw Exception('u_plane array full');
    }
    u_plane[u_plane_count] = item;
    u_plane_count++;
  }

  List<int> get v_plane_list {
    return List.generate(
      v_plane_count,
      (i) => v_plane[i],
      growable: false,
    );
  }

  void add_v_plane(int item) {
    if (v_plane_count >= 2073600) {
      throw Exception('v_plane array full');
    }
    v_plane[v_plane_count] = item;
    v_plane_count++;
  }

  static ffi.Pointer<VideoFrame> allocate() {
    return calloc<VideoFrame>();
  }
}

const int COMPRESSEDFRAME_SIZE = 4194376;
const int COMPRESSEDFRAME_ALIGNMENT = 8;

final class CompressedFrame extends ffi.Struct {
  external FrameMetadata metadata;

  @ffi.Uint32()
  external int data_count;

  @ffi.Array<ffi.Uint32>(1048576)
  external ffi.Array<ffi.Uint32> data;

  @ffi.Uint32()
  external int data_size;

  @ffi.Uint8()
  external int encrypted;

  List<int> get data_list {
    return List.generate(
      data_count,
      (i) => data[i],
      growable: false,
    );
  }

  void add_data(int item) {
    if (data_count >= 1048576) {
      throw Exception('data array full');
    }
    data[data_count] = item;
    data_count++;
  }

  static ffi.Pointer<CompressedFrame> allocate() {
    return calloc<CompressedFrame>();
  }
}

const int TIMESTAMPSYNC_SIZE = 48;
const int TIMESTAMPSYNC_ALIGNMENT = 8;

final class TimestampSync extends ffi.Struct {
  @ffi.Uint64()
  external int presentation_time;

  @ffi.Uint64()
  external int decode_time;

  @ffi.Uint64()
  external int capture_time;

  @ffi.Uint64()
  external int render_time;

  @ffi.Int64()
  external int av_offset_us;

  @ffi.Int32()
  external int drift_compensation;

  static ffi.Pointer<TimestampSync> allocate() {
    return calloc<TimestampSync>();
  }
}

const int BUFFERPOOL_SIZE = 544;
const int BUFFERPOOL_ALIGNMENT = 8;

final class BufferPool extends ffi.Struct {
  @ffi.Uint32()
  external int buffer_ids_count;

  @ffi.Array<ffi.Uint32>(64)
  external ffi.Array<ffi.Uint32> buffer_ids;

  @ffi.Uint32()
  external int buffer_states_count;

  @ffi.Array<ffi.Uint32>(64)
  external ffi.Array<ffi.Uint32> buffer_states;

  @ffi.Uint64()
  external int total_memory_bytes;

  @ffi.Uint32()
  external int total_buffers;

  @ffi.Uint32()
  external int available_buffers;

  @ffi.Uint32()
  external int used_buffers;

  List<int> get buffer_ids_list {
    return List.generate(
      buffer_ids_count,
      (i) => buffer_ids[i],
      growable: false,
    );
  }

  void add_buffer_id(int item) {
    if (buffer_ids_count >= 64) {
      throw Exception('buffer_ids array full');
    }
    buffer_ids[buffer_ids_count] = item;
    buffer_ids_count++;
  }

  List<int> get buffer_states_list {
    return List.generate(
      buffer_states_count,
      (i) => buffer_states[i],
      growable: false,
    );
  }

  void add_buffer_state(int item) {
    if (buffer_states_count >= 64) {
      throw Exception('buffer_states array full');
    }
    buffer_states[buffer_states_count] = item;
    buffer_states_count++;
  }

  static ffi.Pointer<BufferPool> allocate() {
    return calloc<BufferPool>();
  }
}

const int STREAMSTATISTICS_SIZE = 48;
const int STREAMSTATISTICS_ALIGNMENT = 8;

final class StreamStatistics extends ffi.Struct {
  @ffi.Uint64()
  external int frames_processed;

  @ffi.Uint64()
  external int frames_dropped;

  @ffi.Uint64()
  external int bytes_processed;

  @ffi.Float()
  external double average_bitrate;

  @ffi.Float()
  external double average_framerate;

  @ffi.Uint32()
  external int buffer_underruns;

  @ffi.Uint32()
  external int buffer_overruns;

  @ffi.Float()
  external double average_latency_ms;

  @ffi.Float()
  external double jitter_ms;

  static ffi.Pointer<StreamStatistics> allocate() {
    return calloc<StreamStatistics>();
  }
}

const int ENCODINGCONFIG_SIZE = 72;
const int ENCODINGCONFIG_ALIGNMENT = 8;

final class EncodingConfig extends ffi.Struct {
  external CodecParameters params;

  @ffi.Uint32()
  external int num_threads;

  @ffi.Uint32()
  external int max_b_frames;

  @ffi.Uint32()
  external int ref_frames;

  @ffi.Uint32()
  external int rate_control_mode;

  @ffi.Uint32()
  external int qp_min;

  @ffi.Uint32()
  external int qp_max;

  @ffi.Uint8()
  external int use_hardware_accel;

  @ffi.Uint8()
  external int use_cabac;

  static ffi.Pointer<EncodingConfig> allocate() {
    return calloc<EncodingConfig>();
  }
}

const int DECODINGRESULT_SIZE = 280;
const int DECODINGRESULT_ALIGNMENT = 8;

final class DecodingResult extends ffi.Struct {
  @ffi.Uint64()
  external int decode_time_us;

  @ffi.Uint32()
  external int decoded_frames;

  @ffi.Uint32()
  external int errors;

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

  static ffi.Pointer<DecodingResult> allocate() {
    return calloc<DecodingResult>();
  }
}

const int BITRATECONTROL_SIZE = 32;
const int BITRATECONTROL_ALIGNMENT = 8;

final class BitrateControl extends ffi.Struct {
  @ffi.Uint32()
  external int target_bitrate;

  @ffi.Uint32()
  external int min_bitrate;

  @ffi.Uint32()
  external int max_bitrate;

  @ffi.Uint32()
  external int current_bitrate;

  @ffi.Float()
  external double buffer_fullness;

  @ffi.Uint32()
  external int quantizer;

  @ffi.Uint8()
  external int congestion_detected;

  static ffi.Pointer<BitrateControl> allocate() {
    return calloc<BitrateControl>();
  }
}

const int FRAMEBUFFER_SIZE = 8388632;
const int FRAMEBUFFER_ALIGNMENT = 8;

final class FrameBuffer extends ffi.Struct {
  @ffi.Uint64()
  external int timestamp;

  @ffi.Uint32()
  external int data_count;

  @ffi.Array<ffi.Uint32>(2097152)
  external ffi.Array<ffi.Uint32> data;

  @ffi.Uint32()
  external int buffer_id;

  @ffi.Uint32()
  external int state;

  @ffi.Uint32()
  external int size;

  List<int> get data_list {
    return List.generate(
      data_count,
      (i) => data[i],
      growable: false,
    );
  }

  void add_data(int item) {
    if (data_count >= 2097152) {
      throw Exception('data array full');
    }
    data[data_count] = item;
    data_count++;
  }

  static ffi.Pointer<FrameBuffer> allocate() {
    return calloc<FrameBuffer>();
  }
}

const int NETWORKPACKET_SIZE = 6024;
const int NETWORKPACKET_ALIGNMENT = 8;

final class NetworkPacket extends ffi.Struct {
  @ffi.Uint64()
  external int timestamp;

  @ffi.Uint32()
  external int payload_count;

  @ffi.Array<ffi.Uint32>(1500)
  external ffi.Array<ffi.Uint32> payload;

  @ffi.Uint32()
  external int sequence_number;

  @ffi.Uint32()
  external int payload_size;

  @ffi.Uint8()
  external int marker_bit;

  List<int> get payload_list {
    return List.generate(
      payload_count,
      (i) => payload[i],
      growable: false,
    );
  }

  void add_payload(int item) {
    if (payload_count >= 1500) {
      throw Exception('payload array full');
    }
    payload[payload_count] = item;
    payload_count++;
  }

  static ffi.Pointer<NetworkPacket> allocate() {
    return calloc<NetworkPacket>();
  }
}

const int JITTERBUFFER_SIZE = 3104;
const int JITTERBUFFER_ALIGNMENT = 8;

final class JitterBuffer extends ffi.Struct {
  @ffi.Uint32()
  external int packet_sequence_count;

  @ffi.Array<ffi.Uint32>(256)
  external ffi.Array<ffi.Uint32> packet_sequence;

  @ffi.Uint32()
  external int packet_timestamps_count;

  @ffi.Array<ffi.Uint64>(256)
  external ffi.Array<ffi.Uint64> packet_timestamps;

  @ffi.Uint32()
  external int buffer_size;

  @ffi.Uint32()
  external int head_index;

  @ffi.Uint32()
  external int tail_index;

  @ffi.Uint32()
  external int missing_packets;

  List<int> get packet_sequence_list {
    return List.generate(
      packet_sequence_count,
      (i) => packet_sequence[i],
      growable: false,
    );
  }

  void add_packet_sequence(int item) {
    if (packet_sequence_count >= 256) {
      throw Exception('packet_sequence array full');
    }
    packet_sequence[packet_sequence_count] = item;
    packet_sequence_count++;
  }

  List<int> get packet_timestamps_list {
    return List.generate(
      packet_timestamps_count,
      (i) => packet_timestamps[i],
      growable: false,
    );
  }

  void add_packet_timestamp(int item) {
    if (packet_timestamps_count >= 256) {
      throw Exception('packet_timestamps array full');
    }
    packet_timestamps[packet_timestamps_count] = item;
    packet_timestamps_count++;
  }

  static ffi.Pointer<JitterBuffer> allocate() {
    return calloc<JitterBuffer>();
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

  late final framemetadata_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('framemetadata_size');

  late final framemetadata_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('framemetadata_alignment');

  late final codecparameters_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('codecparameters_size');

  late final codecparameters_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('codecparameters_alignment');

  late final videoframe_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('videoframe_size');

  late final videoframe_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('videoframe_alignment');

  late final compressedframe_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('compressedframe_size');

  late final compressedframe_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('compressedframe_alignment');

  late final timestampsync_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('timestampsync_size');

  late final timestampsync_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('timestampsync_alignment');

  late final bufferpool_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('bufferpool_size');

  late final bufferpool_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('bufferpool_alignment');

  late final streamstatistics_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('streamstatistics_size');

  late final streamstatistics_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('streamstatistics_alignment');

  late final encodingconfig_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('encodingconfig_size');

  late final encodingconfig_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('encodingconfig_alignment');

  late final decodingresult_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('decodingresult_size');

  late final decodingresult_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('decodingresult_alignment');

  late final bitratecontrol_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('bitratecontrol_size');

  late final bitratecontrol_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('bitratecontrol_alignment');

  late final framebuffer_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('framebuffer_size');

  late final framebuffer_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('framebuffer_alignment');

  late final networkpacket_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('networkpacket_size');

  late final networkpacket_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('networkpacket_alignment');

  late final jitterbuffer_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('jitterbuffer_size');

  late final jitterbuffer_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('jitterbuffer_alignment');
}
