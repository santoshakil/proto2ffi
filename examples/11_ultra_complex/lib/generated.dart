// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: constant_identifier_names

import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'dart:typed_data';
import 'dart:io';
import 'dart:convert';

enum PriorityLevel {
  PRIORITY_UNSPECIFIED(0), // Value: 0
  PRIORITY_CRITICAL(1), // Value: 1
  PRIORITY_HIGH(2), // Value: 2
  PRIORITY_MEDIUM(3), // Value: 3
  PRIORITY_LOW(4), // Value: 4
  PRIORITY_TRIVIAL(5); // Value: 5

  const PriorityLevel(this.value);
  final int value;
}

enum ProcessingState {
  STATE_UNSPECIFIED(0), // Value: 0
  STATE_PENDING(1), // Value: 1
  STATE_IN_PROGRESS(2), // Value: 2
  STATE_PAUSED(3), // Value: 3
  STATE_COMPLETED(4), // Value: 4
  STATE_FAILED(5), // Value: 5
  STATE_CANCELLED(6), // Value: 6
  STATE_RETRYING(7), // Value: 7
  STATE_VALIDATING(8), // Value: 8
  STATE_APPROVED(9), // Value: 9
  STATE_REJECTED(10); // Value: 10

  const ProcessingState(this.value);
  final int value;
}

enum DataType {
  DATA_TYPE_UNSPECIFIED(0), // Value: 0
  DATA_TYPE_INTEGER(1), // Value: 1
  DATA_TYPE_FLOAT(2), // Value: 2
  DATA_TYPE_DOUBLE(3), // Value: 3
  DATA_TYPE_STRING(4), // Value: 4
  DATA_TYPE_BOOLEAN(5), // Value: 5
  DATA_TYPE_BYTES(6), // Value: 6
  DATA_TYPE_TIMESTAMP(7), // Value: 7
  DATA_TYPE_UUID(8), // Value: 8
  DATA_TYPE_JSON(9), // Value: 9
  DATA_TYPE_XML(10), // Value: 10
  DATA_TYPE_BINARY(11), // Value: 11
  DATA_TYPE_COMPRESSED(12), // Value: 12
  DATA_TYPE_ENCRYPTED(13), // Value: 13
  DATA_TYPE_SIGNED(14), // Value: 14
  DATA_TYPE_HASH(15); // Value: 15

  const DataType(this.value);
  final int value;
}

enum ErrorCode {
  ERROR_NONE(0), // Value: 0
  ERROR_UNKNOWN(1), // Value: 1
  ERROR_INVALID_INPUT(2), // Value: 2
  ERROR_INVALID_STATE(3), // Value: 3
  ERROR_TIMEOUT(4), // Value: 4
  ERROR_NETWORK(5), // Value: 5
  ERROR_IO(6), // Value: 6
  ERROR_PERMISSION_DENIED(7), // Value: 7
  ERROR_NOT_FOUND(8), // Value: 8
  ERROR_ALREADY_EXISTS(9), // Value: 9
  ERROR_RESOURCE_EXHAUSTED(10), // Value: 10
  ERROR_OUT_OF_MEMORY(11), // Value: 11
  ERROR_INVALID_ARGUMENT(12), // Value: 12
  ERROR_UNIMPLEMENTED(13), // Value: 13
  ERROR_INTERNAL(14), // Value: 14
  ERROR_UNAVAILABLE(15), // Value: 15
  ERROR_DATA_LOSS(16), // Value: 16
  ERROR_UNAUTHENTICATED(17), // Value: 17
  ERROR_RATE_LIMIT(18), // Value: 18
  ERROR_QUOTA_EXCEEDED(19), // Value: 19
  ERROR_DEPENDENCY_FAILED(20), // Value: 20
  ERROR_VALIDATION_FAILED(21), // Value: 21
  ERROR_SERIALIZATION_FAILED(22), // Value: 22
  ERROR_DESERIALIZATION_FAILED(23), // Value: 23
  ERROR_CORRUPTION(24), // Value: 24
  ERROR_VERSION_MISMATCH(25), // Value: 25
  ERROR_DEADLOCK(26), // Value: 26
  ERROR_RACE_CONDITION(27), // Value: 27
  ERROR_INVARIANT_VIOLATION(28), // Value: 28
  ERROR_ASSERTION_FAILED(29), // Value: 29
  ERROR_OVERFLOW(30), // Value: 30
  ERROR_UNDERFLOW(31), // Value: 31
  ERROR_DIVISION_BY_ZERO(32), // Value: 32
  ERROR_PARSE_ERROR(33), // Value: 33
  ERROR_COMPILATION_ERROR(34), // Value: 34
  ERROR_RUNTIME_ERROR(35), // Value: 35
  ERROR_LOGIC_ERROR(36), // Value: 36
  ERROR_CONFIGURATION_ERROR(37), // Value: 37
  ERROR_COMPATIBILITY_ERROR(38), // Value: 38
  ERROR_SECURITY_ERROR(39), // Value: 39
  ERROR_CHECKSUM_MISMATCH(40); // Value: 40

  const ErrorCode(this.value);
  final int value;
}

enum NetworkProtocol {
  PROTOCOL_UNSPECIFIED(0), // Value: 0
  PROTOCOL_TCP(1), // Value: 1
  PROTOCOL_UDP(2), // Value: 2
  PROTOCOL_HTTP(3), // Value: 3
  PROTOCOL_HTTPS(4), // Value: 4
  PROTOCOL_WEBSOCKET(5), // Value: 5
  PROTOCOL_GRPC(6), // Value: 6
  PROTOCOL_MQTT(7), // Value: 7
  PROTOCOL_AMQP(8), // Value: 8
  PROTOCOL_KAFKA(9), // Value: 9
  PROTOCOL_REDIS(10), // Value: 10
  PROTOCOL_MEMCACHED(11), // Value: 11
  PROTOCOL_POSTGRESQL(12), // Value: 12
  PROTOCOL_MYSQL(13), // Value: 13
  PROTOCOL_MONGODB(14), // Value: 14
  PROTOCOL_CASSANDRA(15), // Value: 15
  PROTOCOL_ELASTICSEARCH(16), // Value: 16
  PROTOCOL_S3(17), // Value: 17
  PROTOCOL_FTP(18), // Value: 18
  PROTOCOL_SFTP(19), // Value: 19
  PROTOCOL_SSH(20); // Value: 20

  const NetworkProtocol(this.value);
  final int value;
}

enum CompressionAlgorithm {
  COMPRESSION_NONE(0), // Value: 0
  COMPRESSION_GZIP(1), // Value: 1
  COMPRESSION_ZLIB(2), // Value: 2
  COMPRESSION_BROTLI(3), // Value: 3
  COMPRESSION_LZ4(4), // Value: 4
  COMPRESSION_ZSTD(5), // Value: 5
  COMPRESSION_SNAPPY(6), // Value: 6
  COMPRESSION_DEFLATE(7), // Value: 7
  COMPRESSION_BZ2(8), // Value: 8
  COMPRESSION_XZ(9), // Value: 9
  COMPRESSION_LZMA(10); // Value: 10

  const CompressionAlgorithm(this.value);
  final int value;
}

enum EncryptionAlgorithm {
  ENCRYPTION_NONE(0), // Value: 0
  ENCRYPTION_AES_128(1), // Value: 1
  ENCRYPTION_AES_192(2), // Value: 2
  ENCRYPTION_AES_256(3), // Value: 3
  ENCRYPTION_RSA_1024(4), // Value: 4
  ENCRYPTION_RSA_2048(5), // Value: 5
  ENCRYPTION_RSA_4096(6), // Value: 6
  ENCRYPTION_CHACHA20(7), // Value: 7
  ENCRYPTION_SALSA20(8), // Value: 8
  ENCRYPTION_TWOFISH(9), // Value: 9
  ENCRYPTION_BLOWFISH(10), // Value: 10
  ENCRYPTION_3DES(11), // Value: 11
  ENCRYPTION_CAMELLIA(12); // Value: 12

  const EncryptionAlgorithm(this.value);
  final int value;
}

enum HashAlgorithm {
  HASH_NONE(0), // Value: 0
  HASH_MD5(1), // Value: 1
  HASH_SHA1(2), // Value: 2
  HASH_SHA224(3), // Value: 3
  HASH_SHA256(4), // Value: 4
  HASH_SHA384(5), // Value: 5
  HASH_SHA512(6), // Value: 6
  HASH_SHA3_224(7), // Value: 7
  HASH_SHA3_256(8), // Value: 8
  HASH_SHA3_384(9), // Value: 9
  HASH_SHA3_512(10), // Value: 10
  HASH_BLAKE2B(11), // Value: 11
  HASH_BLAKE2S(12), // Value: 12
  HASH_BLAKE3(13), // Value: 13
  HASH_WHIRLPOOL(14), // Value: 14
  HASH_RIPEMD160(15), // Value: 15
  HASH_CRC32(16), // Value: 16
  HASH_CRC64(17), // Value: 17
  HASH_XXHASH(18), // Value: 18
  HASH_MURMUR3(19), // Value: 19
  HASH_CITYHASH(20); // Value: 20

  const HashAlgorithm(this.value);
  final int value;
}

enum CachePolicy {
  CACHE_NONE(0), // Value: 0
  CACHE_READ_THROUGH(1), // Value: 1
  CACHE_WRITE_THROUGH(2), // Value: 2
  CACHE_WRITE_BEHIND(3), // Value: 3
  CACHE_WRITE_AROUND(4), // Value: 4
  CACHE_REFRESH_AHEAD(5), // Value: 5
  CACHE_LRU(6), // Value: 6
  CACHE_LFU(7), // Value: 7
  CACHE_FIFO(8), // Value: 8
  CACHE_RANDOM(9), // Value: 9
  CACHE_TTL(10), // Value: 10
  CACHE_TTI(11), // Value: 11
  CACHE_ADAPTIVE(12); // Value: 12

  const CachePolicy(this.value);
  final int value;
}

enum ConsistencyLevel {
  CONSISTENCY_EVENTUAL(0), // Value: 0
  CONSISTENCY_STRONG(1), // Value: 1
  CONSISTENCY_CAUSAL(2), // Value: 2
  CONSISTENCY_SEQUENTIAL(3), // Value: 3
  CONSISTENCY_LINEARIZABLE(4), // Value: 4
  CONSISTENCY_QUORUM(5), // Value: 5
  CONSISTENCY_ONE(6), // Value: 6
  CONSISTENCY_TWO(7), // Value: 7
  CONSISTENCY_THREE(8), // Value: 8
  CONSISTENCY_ALL(9), // Value: 9
  CONSISTENCY_LOCAL_QUORUM(10), // Value: 10
  CONSISTENCY_EACH_QUORUM(11); // Value: 11

  const ConsistencyLevel(this.value);
  final int value;
}

enum OperationType {
  OPERATION_UNSPECIFIED(0), // Value: 0
  OPERATION_INSERT(1), // Value: 1
  OPERATION_UPDATE(2), // Value: 2
  OPERATION_DELETE(3), // Value: 3
  OPERATION_SELECT(4), // Value: 4
  OPERATION_CREATE(5), // Value: 5
  OPERATION_DROP(6), // Value: 6
  OPERATION_ALTER(7), // Value: 7
  OPERATION_TRUNCATE(8); // Value: 8

  const OperationType(this.value);
  final int value;
}

enum LogLevel {
  LOG_LEVEL_TRACE(0), // Value: 0
  LOG_LEVEL_DEBUG(1), // Value: 1
  LOG_LEVEL_INFO(2), // Value: 2
  LOG_LEVEL_WARN(3), // Value: 3
  LOG_LEVEL_ERROR(4), // Value: 4
  LOG_LEVEL_FATAL(5); // Value: 5

  const LogLevel(this.value);
  final int value;
}

const int TIMESTAMP_SIZE = 16;
const int TIMESTAMP_ALIGNMENT = 8;

final class Timestamp extends ffi.Struct {
  @ffi.Int64()
  external int seconds;

  @ffi.Int32()
  external int nanos;

  static ffi.Pointer<Timestamp> allocate() {
    return calloc<Timestamp>();
  }
}

const int UUID_SIZE = 16;
const int UUID_ALIGNMENT = 8;

final class UUID extends ffi.Struct {
  @ffi.Uint64()
  external int high;

  @ffi.Uint64()
  external int low;

  static ffi.Pointer<UUID> allocate() {
    return calloc<UUID>();
  }
}

const int VERSION_SIZE = 528;
const int VERSION_ALIGNMENT = 8;

final class Version extends ffi.Struct {
  @ffi.Uint32()
  external int major;

  @ffi.Uint32()
  external int minor;

  @ffi.Uint32()
  external int patch;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> pre_release;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> build_metadata;

  String get pre_release_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (pre_release[i] == 0) break;
      bytes.add(pre_release[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set pre_release_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      pre_release[i] = bytes[i];
    }
    if (len < 256) {
      pre_release[len] = 0;
    }
  }

  String get build_metadata_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (build_metadata[i] == 0) break;
      bytes.add(build_metadata[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set build_metadata_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      build_metadata[i] = bytes[i];
    }
    if (len < 256) {
      build_metadata[len] = 0;
    }
  }

  static ffi.Pointer<Version> allocate() {
    return calloc<Version>();
  }
}

const int POINT2D_SIZE = 16;
const int POINT2D_ALIGNMENT = 8;

final class Point2D extends ffi.Struct {
  @ffi.Double()
  external double x;

  @ffi.Double()
  external double y;

  static ffi.Pointer<Point2D> allocate() {
    return calloc<Point2D>();
  }
}

const int POINT3D_SIZE = 24;
const int POINT3D_ALIGNMENT = 8;

final class Point3D extends ffi.Struct {
  @ffi.Double()
  external double x;

  @ffi.Double()
  external double y;

  @ffi.Double()
  external double z;

  static ffi.Pointer<Point3D> allocate() {
    return calloc<Point3D>();
  }
}

const int POINT4D_SIZE = 32;
const int POINT4D_ALIGNMENT = 8;

final class Point4D extends ffi.Struct {
  @ffi.Double()
  external double x;

  @ffi.Double()
  external double y;

  @ffi.Double()
  external double z;

  @ffi.Double()
  external double w;

  static ffi.Pointer<Point4D> allocate() {
    return calloc<Point4D>();
  }
}

const int VECTOR2_SIZE = 8;
const int VECTOR2_ALIGNMENT = 8;

final class Vector2 extends ffi.Struct {
  @ffi.Float()
  external double x;

  @ffi.Float()
  external double y;

  static ffi.Pointer<Vector2> allocate() {
    return calloc<Vector2>();
  }
}

const int VECTOR3_SIZE = 16;
const int VECTOR3_ALIGNMENT = 8;

final class Vector3 extends ffi.Struct {
  @ffi.Float()
  external double x;

  @ffi.Float()
  external double y;

  @ffi.Float()
  external double z;

  static ffi.Pointer<Vector3> allocate() {
    return calloc<Vector3>();
  }
}

const int VECTOR4_SIZE = 16;
const int VECTOR4_ALIGNMENT = 8;

final class Vector4 extends ffi.Struct {
  @ffi.Float()
  external double x;

  @ffi.Float()
  external double y;

  @ffi.Float()
  external double z;

  @ffi.Float()
  external double w;

  static ffi.Pointer<Vector4> allocate() {
    return calloc<Vector4>();
  }
}

const int MATRIX2X2_SIZE = 16;
const int MATRIX2X2_ALIGNMENT = 8;

final class Matrix2x2 extends ffi.Struct {
  @ffi.Float()
  external double m00;

  @ffi.Float()
  external double m01;

  @ffi.Float()
  external double m10;

  @ffi.Float()
  external double m11;

  static ffi.Pointer<Matrix2x2> allocate() {
    return calloc<Matrix2x2>();
  }
}

const int MATRIX3X3_SIZE = 40;
const int MATRIX3X3_ALIGNMENT = 8;

final class Matrix3x3 extends ffi.Struct {
  @ffi.Float()
  external double m00;

  @ffi.Float()
  external double m01;

  @ffi.Float()
  external double m02;

  @ffi.Float()
  external double m10;

  @ffi.Float()
  external double m11;

  @ffi.Float()
  external double m12;

  @ffi.Float()
  external double m20;

  @ffi.Float()
  external double m21;

  @ffi.Float()
  external double m22;

  static ffi.Pointer<Matrix3x3> allocate() {
    return calloc<Matrix3x3>();
  }
}

const int MATRIX4X4_SIZE = 64;
const int MATRIX4X4_ALIGNMENT = 8;

final class Matrix4x4 extends ffi.Struct {
  @ffi.Float()
  external double m00;

  @ffi.Float()
  external double m01;

  @ffi.Float()
  external double m02;

  @ffi.Float()
  external double m03;

  @ffi.Float()
  external double m10;

  @ffi.Float()
  external double m11;

  @ffi.Float()
  external double m12;

  @ffi.Float()
  external double m13;

  @ffi.Float()
  external double m20;

  @ffi.Float()
  external double m21;

  @ffi.Float()
  external double m22;

  @ffi.Float()
  external double m23;

  @ffi.Float()
  external double m30;

  @ffi.Float()
  external double m31;

  @ffi.Float()
  external double m32;

  @ffi.Float()
  external double m33;

  static ffi.Pointer<Matrix4x4> allocate() {
    return calloc<Matrix4x4>();
  }
}

const int QUATERNION_SIZE = 16;
const int QUATERNION_ALIGNMENT = 8;

final class Quaternion extends ffi.Struct {
  @ffi.Float()
  external double x;

  @ffi.Float()
  external double y;

  @ffi.Float()
  external double z;

  @ffi.Float()
  external double w;

  static ffi.Pointer<Quaternion> allocate() {
    return calloc<Quaternion>();
  }
}

const int COLOR_SIZE = 16;
const int COLOR_ALIGNMENT = 8;

final class Color extends ffi.Struct {
  @ffi.Float()
  external double r;

  @ffi.Float()
  external double g;

  @ffi.Float()
  external double b;

  @ffi.Float()
  external double a;

  static ffi.Pointer<Color> allocate() {
    return calloc<Color>();
  }
}

const int BOUNDINGBOX_SIZE = 48;
const int BOUNDINGBOX_ALIGNMENT = 8;

final class BoundingBox extends ffi.Struct {
  external Point3D min;

  external Point3D max;

  static ffi.Pointer<BoundingBox> allocate() {
    return calloc<BoundingBox>();
  }
}

const int SPHERE_SIZE = 32;
const int SPHERE_ALIGNMENT = 8;

final class Sphere extends ffi.Struct {
  external Point3D center;

  @ffi.Double()
  external double radius;

  static ffi.Pointer<Sphere> allocate() {
    return calloc<Sphere>();
  }
}

const int PLANE_SIZE = 24;
const int PLANE_ALIGNMENT = 8;

final class Plane extends ffi.Struct {
  external Vector3 normal;

  @ffi.Float()
  external double distance;

  static ffi.Pointer<Plane> allocate() {
    return calloc<Plane>();
  }
}

const int RAY_SIZE = 40;
const int RAY_ALIGNMENT = 8;

final class Ray extends ffi.Struct {
  external Point3D origin;

  external Vector3 direction;

  static ffi.Pointer<Ray> allocate() {
    return calloc<Ray>();
  }
}

const int TRANSFORM_SIZE = 48;
const int TRANSFORM_ALIGNMENT = 8;

final class Transform extends ffi.Struct {
  external Vector3 position;

  external Quaternion rotation;

  external Vector3 scale;

  static ffi.Pointer<Transform> allocate() {
    return calloc<Transform>();
  }
}

const int STATISTICS_SIZE = 104;
const int STATISTICS_ALIGNMENT = 8;

final class Statistics extends ffi.Struct {
  @ffi.Uint64()
  external int count;

  @ffi.Double()
  external double sum;

  @ffi.Double()
  external double min;

  @ffi.Double()
  external double max;

  @ffi.Double()
  external double mean;

  @ffi.Double()
  external double variance;

  @ffi.Double()
  external double std_dev;

  @ffi.Double()
  external double median;

  @ffi.Double()
  external double q1;

  @ffi.Double()
  external double q3;

  @ffi.Double()
  external double iqr;

  @ffi.Double()
  external double skewness;

  @ffi.Double()
  external double kurtosis;

  static ffi.Pointer<Statistics> allocate() {
    return calloc<Statistics>();
  }
}

const int HISTOGRAM_SIZE = 56;
const int HISTOGRAM_ALIGNMENT = 8;

final class Histogram extends ffi.Struct {
  external ffi.Pointer<ffi.Double> bins;

  external ffi.Pointer<ffi.Uint64> counts;

  @ffi.Double()
  external double min;

  @ffi.Double()
  external double max;

  @ffi.Uint32()
  external int num_bins;

  static ffi.Pointer<Histogram> allocate() {
    return calloc<Histogram>();
  }
}

const int TIMESERIES_SIZE = 544;
const int TIMESERIES_ALIGNMENT = 8;

final class TimeSeries extends ffi.Struct {
  external ffi.Pointer<Timestamp> timestamps;

  external ffi.Pointer<ffi.Double> values;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> name;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> unit;

  String get name_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (name[i] == 0) break;
      bytes.add(name[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set name_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      name[i] = bytes[i];
    }
    if (len < 256) {
      name[len] = 0;
    }
  }

  String get unit_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (unit[i] == 0) break;
      bytes.add(unit[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set unit_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      unit[i] = bytes[i];
    }
    if (len < 256) {
      unit[len] = 0;
    }
  }

  static ffi.Pointer<TimeSeries> allocate() {
    return calloc<TimeSeries>();
  }
}

const int GRAPHNODE_SIZE = 1352;
const int GRAPHNODE_ALIGNMENT = 8;

final class GraphNode extends ffi.Struct {
  @ffi.Uint64()
  external int id;

  external ffi.Pointer<ffi.Uint64> outgoing_edges;

  external ffi.Pointer<ffi.Uint64> incoming_edges;

  @ffi.Double()
  external double weight;

  @ffi.Uint64()
  external int parent;

  @ffi.Int32()
  external int color;

  @ffi.Int32()
  external int distance;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> label;

  @ffi.Array<ffi.Uint8>(1024)
  external ffi.Array<ffi.Uint8> metadata;

  @ffi.Uint8()
  external int visited;

  String get label_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (label[i] == 0) break;
      bytes.add(label[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set label_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      label[i] = bytes[i];
    }
    if (len < 256) {
      label[len] = 0;
    }
  }

  static ffi.Pointer<GraphNode> allocate() {
    return calloc<GraphNode>();
  }
}

const int GRAPHEDGE_SIZE = 1320;
const int GRAPHEDGE_ALIGNMENT = 8;

final class GraphEdge extends ffi.Struct {
  @ffi.Uint64()
  external int id;

  @ffi.Uint64()
  external int source;

  @ffi.Uint64()
  external int target;

  @ffi.Double()
  external double weight;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> label;

  @ffi.Uint8()
  external int directed;

  @ffi.Array<ffi.Uint8>(1024)
  external ffi.Array<ffi.Uint8> metadata;

  String get label_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (label[i] == 0) break;
      bytes.add(label[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set label_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      label[i] = bytes[i];
    }
    if (len < 256) {
      label[len] = 0;
    }
  }

  static ffi.Pointer<GraphEdge> allocate() {
    return calloc<GraphEdge>();
  }
}

const int GRAPH_SIZE = 304;
const int GRAPH_ALIGNMENT = 8;

final class Graph extends ffi.Struct {
  external ffi.Pointer<GraphNode> nodes;

  external ffi.Pointer<GraphEdge> edges;

  @ffi.Uint32()
  external int num_nodes;

  @ffi.Uint32()
  external int num_edges;

  @ffi.Uint8()
  external int directed;

  @ffi.Uint8()
  external int weighted;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> name;

  String get name_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (name[i] == 0) break;
      bytes.add(name[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set name_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      name[i] = bytes[i];
    }
    if (len < 256) {
      name[len] = 0;
    }
  }

  static ffi.Pointer<Graph> allocate() {
    return calloc<Graph>();
  }
}

const int TREENODE_SIZE = 1336;
const int TREENODE_ALIGNMENT = 8;

final class TreeNode extends ffi.Struct {
  @ffi.Uint64()
  external int id;

  @ffi.Uint64()
  external int parent_id;

  external ffi.Pointer<ffi.Uint64> child_ids;

  @ffi.Double()
  external double value;

  @ffi.Int32()
  external int depth;

  @ffi.Int32()
  external int height;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> label;

  @ffi.Array<ffi.Uint8>(1024)
  external ffi.Array<ffi.Uint8> data;

  @ffi.Uint8()
  external int is_leaf;

  String get label_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (label[i] == 0) break;
      bytes.add(label[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set label_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      label[i] = bytes[i];
    }
    if (len < 256) {
      label[len] = 0;
    }
  }

  static ffi.Pointer<TreeNode> allocate() {
    return calloc<TreeNode>();
  }
}

const int BINARYTREENODE_SIZE = 64;
const int BINARYTREENODE_ALIGNMENT = 8;

final class BinaryTreeNode extends ffi.Struct {
  @ffi.Uint64()
  external int id;

  @ffi.Int64()
  external int value;

  @ffi.Uint64()
  external int left_id;

  @ffi.Uint64()
  external int right_id;

  @ffi.Uint64()
  external int parent_id;

  external Color color_rb;

  @ffi.Int32()
  external int height;

  @ffi.Int32()
  external int balance_factor;

  static ffi.Pointer<BinaryTreeNode> allocate() {
    return calloc<BinaryTreeNode>();
  }
}

const int HEAPNODE_SIZE = 1064;
const int HEAPNODE_ALIGNMENT = 8;

final class HeapNode extends ffi.Struct {
  @ffi.Uint64()
  external int id;

  @ffi.Double()
  external double priority;

  @ffi.Uint64()
  external int parent_index;

  @ffi.Uint64()
  external int left_child_index;

  @ffi.Uint64()
  external int right_child_index;

  @ffi.Array<ffi.Uint8>(1024)
  external ffi.Array<ffi.Uint8> data;

  static ffi.Pointer<HeapNode> allocate() {
    return calloc<HeapNode>();
  }
}

const int HASHTABLEENTRY_SIZE = 1304;
const int HASHTABLEENTRY_ALIGNMENT = 8;

final class HashTableEntry extends ffi.Struct {
  @ffi.Uint64()
  external int hash;

  @ffi.Uint64()
  external int next_id;

  @ffi.Uint32()
  external int probe_count;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> key;

  @ffi.Array<ffi.Uint8>(1024)
  external ffi.Array<ffi.Uint8> value;

  @ffi.Uint8()
  external int occupied;

  String get key_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (key[i] == 0) break;
      bytes.add(key[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set key_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      key[i] = bytes[i];
    }
    if (len < 256) {
      key[len] = 0;
    }
  }

  static ffi.Pointer<HashTableEntry> allocate() {
    return calloc<HashTableEntry>();
  }
}

const int HASHTABLE_SIZE = 40;
const int HASHTABLE_ALIGNMENT = 8;

final class HashTable extends ffi.Struct {
  external ffi.Pointer<HashTableEntry> buckets;

  @ffi.Double()
  external double load_factor;

  @ffi.Uint32()
  external int size;

  @ffi.Uint32()
  external int capacity;

  @ffi.Uint32()
  external int hash_algorithm;

  @ffi.Uint32()
  external int collision_count;

  static ffi.Pointer<HashTable> allocate() {
    return calloc<HashTable>();
  }
}

const int TRIENODE_SIZE = 1312;
const int TRIENODE_ALIGNMENT = 8;

final class TrieNode extends ffi.Struct {
  @ffi.Uint64()
  external int id;

  external ffi.Pointer<ffi.Uint64> child_ids;

  @ffi.Uint32()
  external int frequency;

  @ffi.Array<ffi.Uint8>(1024)
  external ffi.Array<ffi.Uint8> character;

  @ffi.Uint8()
  external int is_end_of_word;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> word;

  String get word_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (word[i] == 0) break;
      bytes.add(word[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set word_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      word[i] = bytes[i];
    }
    if (len < 256) {
      word[len] = 0;
    }
  }

  static ffi.Pointer<TrieNode> allocate() {
    return calloc<TrieNode>();
  }
}

const int BLOOMFILTER_SIZE = 1048;
const int BLOOMFILTER_ALIGNMENT = 8;

final class BloomFilter extends ffi.Struct {
  @ffi.Uint64()
  external int num_items;

  @ffi.Double()
  external double false_positive_rate;

  @ffi.Uint32()
  external int size;

  @ffi.Uint32()
  external int num_hash_functions;

  @ffi.Array<ffi.Uint8>(1024)
  external ffi.Array<ffi.Uint8> bit_array;

  static ffi.Pointer<BloomFilter> allocate() {
    return calloc<BloomFilter>();
  }
}

const int SKIPLISTNODE_SIZE = 1064;
const int SKIPLISTNODE_ALIGNMENT = 8;

final class SkipListNode extends ffi.Struct {
  @ffi.Uint64()
  external int id;

  @ffi.Int64()
  external int key;

  external ffi.Pointer<ffi.Uint64> forward_ids;

  @ffi.Uint32()
  external int level;

  @ffi.Array<ffi.Uint8>(1024)
  external ffi.Array<ffi.Uint8> value;

  static ffi.Pointer<SkipListNode> allocate() {
    return calloc<SkipListNode>();
  }
}

const int KDTREENODE_SIZE = 1080;
const int KDTREENODE_ALIGNMENT = 8;

final class KdTreeNode extends ffi.Struct {
  @ffi.Uint64()
  external int id;

  external Point3D point;

  @ffi.Uint64()
  external int left_id;

  @ffi.Uint64()
  external int right_id;

  @ffi.Uint32()
  external int split_axis;

  @ffi.Array<ffi.Uint8>(1024)
  external ffi.Array<ffi.Uint8> data;

  static ffi.Pointer<KdTreeNode> allocate() {
    return calloc<KdTreeNode>();
  }
}

const int OCTREENODE_SIZE = 96;
const int OCTREENODE_ALIGNMENT = 8;

final class OctreeNode extends ffi.Struct {
  @ffi.Uint64()
  external int id;

  external BoundingBox bounds;

  external ffi.Pointer<ffi.Uint64> child_ids;

  external ffi.Pointer<ffi.Uint64> object_ids;

  @ffi.Uint32()
  external int depth;

  @ffi.Uint8()
  external int is_leaf;

  static ffi.Pointer<OctreeNode> allocate() {
    return calloc<OctreeNode>();
  }
}

const int QUADTREENODE_SIZE = 80;
const int QUADTREENODE_ALIGNMENT = 8;

final class QuadTreeNode extends ffi.Struct {
  @ffi.Uint64()
  external int id;

  external Point2D min;

  external Point2D max;

  external ffi.Pointer<ffi.Uint64> child_ids;

  external ffi.Pointer<ffi.Uint64> object_ids;

  @ffi.Uint32()
  external int depth;

  @ffi.Uint8()
  external int is_leaf;

  static ffi.Pointer<QuadTreeNode> allocate() {
    return calloc<QuadTreeNode>();
  }
}

const int RTREEENTRY_SIZE = 1096;
const int RTREEENTRY_ALIGNMENT = 8;

final class RTreeEntry extends ffi.Struct {
  @ffi.Uint64()
  external int id;

  external BoundingBox mbr;

  @ffi.Uint64()
  external int child_id;

  @ffi.Array<ffi.Uint8>(1024)
  external ffi.Array<ffi.Uint8> data;

  @ffi.Uint8()
  external int is_leaf;

  static ffi.Pointer<RTreeEntry> allocate() {
    return calloc<RTreeEntry>();
  }
}

const int SPATIALINDEX_SIZE = 32;
const int SPATIALINDEX_ALIGNMENT = 8;

final class SpatialIndex extends ffi.Struct {
  external ffi.Pointer<RTreeEntry> entries;

  @ffi.Uint32()
  external int max_entries;

  @ffi.Uint32()
  external int min_entries;

  @ffi.Uint32()
  external int height;

  static ffi.Pointer<SpatialIndex> allocate() {
    return calloc<SpatialIndex>();
  }
}

const int CACHE_SIZE = 56;
const int CACHE_ALIGNMENT = 8;

final class Cache extends ffi.Struct {
  external ffi.Pointer<HashTableEntry> entries;

  @ffi.Uint64()
  external int hit_count;

  @ffi.Uint64()
  external int miss_count;

  @ffi.Uint64()
  external int eviction_count;

  @ffi.Uint32()
  external int capacity;

  @ffi.Uint32()
  external int size;

  @ffi.Uint32()
  external int policy;

  static ffi.Pointer<Cache> allocate() {
    return calloc<Cache>();
  }
}

const int DATABASE_SIZE = 840;
const int DATABASE_ALIGNMENT = 8;

final class Database extends ffi.Struct {
  external ffi.Pointer<Table> tables;

  external ffi.Pointer<Index> indices;

  external Version version;

  @ffi.Uint64()
  external int total_rows;

  @ffi.Uint64()
  external int total_size_bytes;

  @ffi.Uint32()
  external int consistency;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> name;

  String get name_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (name[i] == 0) break;
      bytes.add(name[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set name_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      name[i] = bytes[i];
    }
    if (len < 256) {
      name[len] = 0;
    }
  }

  static ffi.Pointer<Database> allocate() {
    return calloc<Database>();
  }
}

const int TABLE_SIZE = 320;
const int TABLE_ALIGNMENT = 8;

final class Table extends ffi.Struct {
  external ffi.Pointer<Column> columns;

  external ffi.Pointer<Row> rows;

  external ffi.Pointer<Index> indices;

  @ffi.Uint64()
  external int num_rows;

  @ffi.Uint64()
  external int size_bytes;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> name;

  String get name_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (name[i] == 0) break;
      bytes.add(name[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set name_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      name[i] = bytes[i];
    }
    if (len < 256) {
      name[len] = 0;
    }
  }

  static ffi.Pointer<Table> allocate() {
    return calloc<Table>();
  }
}

const int COLUMN_SIZE = 520;
const int COLUMN_ALIGNMENT = 8;

final class Column extends ffi.Struct {
  @ffi.Uint32()
  external int data_type;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> name;

  @ffi.Uint8()
  external int nullable;

  @ffi.Uint8()
  external int unique;

  @ffi.Uint8()
  external int indexed;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> default_value;

  String get name_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (name[i] == 0) break;
      bytes.add(name[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set name_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      name[i] = bytes[i];
    }
    if (len < 256) {
      name[len] = 0;
    }
  }

  String get default_value_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (default_value[i] == 0) break;
      bytes.add(default_value[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set default_value_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      default_value[i] = bytes[i];
    }
    if (len < 256) {
      default_value[len] = 0;
    }
  }

  static ffi.Pointer<Column> allocate() {
    return calloc<Column>();
  }
}

const int ROW_SIZE = 584;
const int ROW_ALIGNMENT = 8;

final class Row extends ffi.Struct {
  @ffi.Uint64()
  external int id;

  external ffi.Pointer<Cell> cells;

  external Timestamp created_at;

  external Timestamp updated_at;

  external Version version;

  static ffi.Pointer<Row> allocate() {
    return calloc<Row>();
  }
}

const int CELL_SIZE = 1288;
const int CELL_ALIGNMENT = 8;

final class Cell extends ffi.Struct {
  @ffi.Uint32()
  external int data_type;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> column_name;

  @ffi.Array<ffi.Uint8>(1024)
  external ffi.Array<ffi.Uint8> value;

  @ffi.Uint8()
  external int is_null;

  String get column_name_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (column_name[i] == 0) break;
      bytes.add(column_name[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set column_name_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      column_name[i] = bytes[i];
    }
    if (len < 256) {
      column_name[len] = 0;
    }
  }

  static ffi.Pointer<Cell> allocate() {
    return calloc<Cell>();
  }
}

const int INDEX_SIZE = 304;
const int INDEX_ALIGNMENT = 8;

final class Index extends ffi.Struct {
  external ffi.Pointer<ffi.Uint8> column_names;

  external ffi.Pointer<IndexEntry> entries;

  @ffi.Uint64()
  external int size_bytes;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> name;

  @ffi.Uint8()
  external int unique;

  String get name_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (name[i] == 0) break;
      bytes.add(name[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set name_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      name[i] = bytes[i];
    }
    if (len < 256) {
      name[len] = 0;
    }
  }

  static ffi.Pointer<Index> allocate() {
    return calloc<Index>();
  }
}

const int INDEXENTRY_SIZE = 1040;
const int INDEXENTRY_ALIGNMENT = 8;

final class IndexEntry extends ffi.Struct {
  external ffi.Pointer<ffi.Uint64> row_ids;

  @ffi.Array<ffi.Uint8>(1024)
  external ffi.Array<ffi.Uint8> key;

  static ffi.Pointer<IndexEntry> allocate() {
    return calloc<IndexEntry>();
  }
}

const int TRANSACTION_SIZE = 80;
const int TRANSACTION_ALIGNMENT = 8;

final class Transaction extends ffi.Struct {
  external UUID id;

  external ffi.Pointer<Operation> operations;

  external Timestamp started_at;

  external Timestamp committed_at;

  @ffi.Uint32()
  external int state;

  @ffi.Uint32()
  external int consistency;

  @ffi.Int32()
  external int retry_count;

  static ffi.Pointer<Transaction> allocate() {
    return calloc<Transaction>();
  }
}

const int OPERATION_SIZE = 1320;
const int OPERATION_ALIGNMENT = 8;

final class Operation extends ffi.Struct {
  external UUID id;

  external Timestamp timestamp;

  @ffi.Uint32()
  external int type;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> table_name;

  @ffi.Array<ffi.Uint8>(1024)
  external ffi.Array<ffi.Uint8> data;

  String get table_name_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (table_name[i] == 0) break;
      bytes.add(table_name[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set table_name_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      table_name[i] = bytes[i];
    }
    if (len < 256) {
      table_name[len] = 0;
    }
  }

  static ffi.Pointer<Operation> allocate() {
    return calloc<Operation>();
  }
}

const int NETWORKPACKET_SIZE = 4152;
const int NETWORKPACKET_ALIGNMENT = 8;

final class NetworkPacket extends ffi.Struct {
  external UUID id;

  external Timestamp timestamp;

  @ffi.Uint32()
  external int source_port;

  @ffi.Uint32()
  external int destination_port;

  @ffi.Uint32()
  external int protocol;

  @ffi.Uint32()
  external int sequence_number;

  @ffi.Uint32()
  external int acknowledgment_number;

  @ffi.Uint32()
  external int ttl;

  @ffi.Array<ffi.Uint8>(1024)
  external ffi.Array<ffi.Uint8> source_address;

  @ffi.Array<ffi.Uint8>(1024)
  external ffi.Array<ffi.Uint8> destination_address;

  @ffi.Array<ffi.Uint8>(1024)
  external ffi.Array<ffi.Uint8> payload;

  @ffi.Array<ffi.Uint8>(1024)
  external ffi.Array<ffi.Uint8> checksum;

  static ffi.Pointer<NetworkPacket> allocate() {
    return calloc<NetworkPacket>();
  }
}

const int NETWORKCONNECTION_SIZE = 2128;
const int NETWORKCONNECTION_ALIGNMENT = 8;

final class NetworkConnection extends ffi.Struct {
  external UUID id;

  @ffi.Uint64()
  external int bytes_sent;

  @ffi.Uint64()
  external int bytes_received;

  external Timestamp established_at;

  external Timestamp last_activity;

  @ffi.Uint32()
  external int local_port;

  @ffi.Uint32()
  external int remote_port;

  @ffi.Uint32()
  external int protocol;

  @ffi.Uint32()
  external int state;

  @ffi.Array<ffi.Uint8>(1024)
  external ffi.Array<ffi.Uint8> local_address;

  @ffi.Array<ffi.Uint8>(1024)
  external ffi.Array<ffi.Uint8> remote_address;

  static ffi.Pointer<NetworkConnection> allocate() {
    return calloc<NetworkConnection>();
  }
}

const int HTTPREQUEST_SIZE = 2112;
const int HTTPREQUEST_ALIGNMENT = 8;

final class HttpRequest extends ffi.Struct {
  external UUID id;

  external ffi.Pointer<Header> headers;

  external Version version;

  external Timestamp timestamp;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> method;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> url;

  @ffi.Array<ffi.Uint8>(1024)
  external ffi.Array<ffi.Uint8> body;

  String get method_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (method[i] == 0) break;
      bytes.add(method[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set method_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      method[i] = bytes[i];
    }
    if (len < 256) {
      method[len] = 0;
    }
  }

  String get url_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (url[i] == 0) break;
      bytes.add(url[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set url_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      url[i] = bytes[i];
    }
    if (len < 256) {
      url[len] = 0;
    }
  }

  static ffi.Pointer<HttpRequest> allocate() {
    return calloc<HttpRequest>();
  }
}

const int HTTPRESPONSE_SIZE = 1864;
const int HTTPRESPONSE_ALIGNMENT = 8;

final class HttpResponse extends ffi.Struct {
  external UUID id;

  external ffi.Pointer<Header> headers;

  external Version version;

  external Timestamp timestamp;

  @ffi.Uint32()
  external int status_code;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> status_message;

  @ffi.Array<ffi.Uint8>(1024)
  external ffi.Array<ffi.Uint8> body;

  String get status_message_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (status_message[i] == 0) break;
      bytes.add(status_message[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set status_message_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      status_message[i] = bytes[i];
    }
    if (len < 256) {
      status_message[len] = 0;
    }
  }

  static ffi.Pointer<HttpResponse> allocate() {
    return calloc<HttpResponse>();
  }
}

const int HEADER_SIZE = 512;
const int HEADER_ALIGNMENT = 8;

final class Header extends ffi.Struct {
  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> name;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> value;

  String get name_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (name[i] == 0) break;
      bytes.add(name[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set name_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      name[i] = bytes[i];
    }
    if (len < 256) {
      name[len] = 0;
    }
  }

  String get value_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (value[i] == 0) break;
      bytes.add(value[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set value_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      value[i] = bytes[i];
    }
    if (len < 256) {
      value[len] = 0;
    }
  }

  static ffi.Pointer<Header> allocate() {
    return calloc<Header>();
  }
}

const int FILEMETADATA_SIZE = 2376;
const int FILEMETADATA_ALIGNMENT = 8;

final class FileMetadata extends ffi.Struct {
  @ffi.Uint64()
  external int size_bytes;

  external Timestamp created_at;

  external Timestamp modified_at;

  external Timestamp accessed_at;

  @ffi.Uint32()
  external int permissions;

  @ffi.Uint32()
  external int checksum_algorithm;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> path;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> name;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> extension;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> owner;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> group;

  @ffi.Uint8()
  external int is_directory;

  @ffi.Uint8()
  external int is_symlink;

  @ffi.Array<ffi.Uint8>(1024)
  external ffi.Array<ffi.Uint8> checksum;

  String get path_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (path[i] == 0) break;
      bytes.add(path[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set path_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      path[i] = bytes[i];
    }
    if (len < 256) {
      path[len] = 0;
    }
  }

  String get name_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (name[i] == 0) break;
      bytes.add(name[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set name_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      name[i] = bytes[i];
    }
    if (len < 256) {
      name[len] = 0;
    }
  }

  String get extension_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (extension[i] == 0) break;
      bytes.add(extension[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set extension_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      extension[i] = bytes[i];
    }
    if (len < 256) {
      extension[len] = 0;
    }
  }

  String get owner_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (owner[i] == 0) break;
      bytes.add(owner[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set owner_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      owner[i] = bytes[i];
    }
    if (len < 256) {
      owner[len] = 0;
    }
  }

  String get group_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (group[i] == 0) break;
      bytes.add(group[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set group_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      group[i] = bytes[i];
    }
    if (len < 256) {
      group[len] = 0;
    }
  }

  static ffi.Pointer<FileMetadata> allocate() {
    return calloc<FileMetadata>();
  }
}

const int FILECHUNK_SIZE = 2096;
const int FILECHUNK_ALIGNMENT = 8;

final class FileChunk extends ffi.Struct {
  external UUID file_id;

  @ffi.Uint64()
  external int chunk_index;

  @ffi.Uint64()
  external int offset;

  @ffi.Uint32()
  external int size;

  @ffi.Uint32()
  external int compression;

  @ffi.Uint32()
  external int encryption;

  @ffi.Array<ffi.Uint8>(1024)
  external ffi.Array<ffi.Uint8> data;

  @ffi.Array<ffi.Uint8>(1024)
  external ffi.Array<ffi.Uint8> checksum;

  static ffi.Pointer<FileChunk> allocate() {
    return calloc<FileChunk>();
  }
}

const int IMAGEMETADATA_SIZE = 544;
const int IMAGEMETADATA_ALIGNMENT = 8;

final class ImageMetadata extends ffi.Struct {
  @ffi.Uint64()
  external int size_bytes;

  @ffi.Uint32()
  external int width;

  @ffi.Uint32()
  external int height;

  @ffi.Uint32()
  external int channels;

  @ffi.Uint32()
  external int bits_per_channel;

  @ffi.Uint32()
  external int compression;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> format;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> color_space;

  @ffi.Uint8()
  external int has_alpha;

  String get format_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (format[i] == 0) break;
      bytes.add(format[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set format_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      format[i] = bytes[i];
    }
    if (len < 256) {
      format[len] = 0;
    }
  }

  String get color_space_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (color_space[i] == 0) break;
      bytes.add(color_space[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set color_space_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      color_space[i] = bytes[i];
    }
    if (len < 256) {
      color_space[len] = 0;
    }
  }

  static ffi.Pointer<ImageMetadata> allocate() {
    return calloc<ImageMetadata>();
  }
}

const int IMAGE_SIZE = 1640;
const int IMAGE_ALIGNMENT = 8;

final class Image extends ffi.Struct {
  external ImageMetadata metadata;

  external ffi.Pointer<ImageLayer> layers;

  external Histogram histogram;

  @ffi.Array<ffi.Uint8>(1024)
  external ffi.Array<ffi.Uint8> data;

  static ffi.Pointer<Image> allocate() {
    return calloc<Image>();
  }
}

const int IMAGELAYER_SIZE = 1552;
const int IMAGELAYER_ALIGNMENT = 8;

final class ImageLayer extends ffi.Struct {
  @ffi.Double()
  external double opacity;

  @ffi.Uint32()
  external int width;

  @ffi.Uint32()
  external int height;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> name;

  @ffi.Array<ffi.Uint8>(1024)
  external ffi.Array<ffi.Uint8> data;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> blend_mode;

  String get name_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (name[i] == 0) break;
      bytes.add(name[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set name_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      name[i] = bytes[i];
    }
    if (len < 256) {
      name[len] = 0;
    }
  }

  String get blend_mode_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (blend_mode[i] == 0) break;
      bytes.add(blend_mode[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set blend_mode_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      blend_mode[i] = bytes[i];
    }
    if (len < 256) {
      blend_mode[len] = 0;
    }
  }

  static ffi.Pointer<ImageLayer> allocate() {
    return calloc<ImageLayer>();
  }
}

const int AUDIOMETADATA_SIZE = 288;
const int AUDIOMETADATA_ALIGNMENT = 8;

final class AudioMetadata extends ffi.Struct {
  @ffi.Uint64()
  external int num_samples;

  @ffi.Double()
  external double duration_seconds;

  @ffi.Uint32()
  external int sample_rate;

  @ffi.Uint32()
  external int channels;

  @ffi.Uint32()
  external int bits_per_sample;

  @ffi.Uint32()
  external int compression;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> format;

  String get format_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (format[i] == 0) break;
      bytes.add(format[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set format_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      format[i] = bytes[i];
    }
    if (len < 256) {
      format[len] = 0;
    }
  }

  static ffi.Pointer<AudioMetadata> allocate() {
    return calloc<AudioMetadata>();
  }
}

const int AUDIOSAMPLE_SIZE = 1344;
const int AUDIOSAMPLE_ALIGNMENT = 8;

final class AudioSample extends ffi.Struct {
  external AudioMetadata metadata;

  external ffi.Pointer<ffi.Double> amplitudes;

  external ffi.Pointer<ffi.Double> frequencies;

  @ffi.Array<ffi.Uint8>(1024)
  external ffi.Array<ffi.Uint8> data;

  static ffi.Pointer<AudioSample> allocate() {
    return calloc<AudioSample>();
  }
}

const int VIDEOMETADATA_SIZE = 304;
const int VIDEOMETADATA_ALIGNMENT = 8;

final class VideoMetadata extends ffi.Struct {
  @ffi.Double()
  external double fps;

  @ffi.Uint64()
  external int num_frames;

  @ffi.Double()
  external double duration_seconds;

  @ffi.Uint64()
  external int bitrate;

  @ffi.Uint32()
  external int width;

  @ffi.Uint32()
  external int height;

  @ffi.Uint32()
  external int compression;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> codec;

  String get codec_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (codec[i] == 0) break;
      bytes.add(codec[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set codec_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      codec[i] = bytes[i];
    }
    if (len < 256) {
      codec[len] = 0;
    }
  }

  static ffi.Pointer<VideoMetadata> allocate() {
    return calloc<VideoMetadata>();
  }
}

const int VIDEOFRAME_SIZE = 2696;
const int VIDEOFRAME_ALIGNMENT = 8;

final class VideoFrame extends ffi.Struct {
  @ffi.Uint64()
  external int frame_number;

  external Timestamp timestamp;

  external Image image;

  @ffi.Array<ffi.Uint8>(1024)
  external ffi.Array<ffi.Uint8> compressed_data;

  @ffi.Uint8()
  external int is_keyframe;

  static ffi.Pointer<VideoFrame> allocate() {
    return calloc<VideoFrame>();
  }
}

const int MLMODEL_SIZE = 2096;
const int MLMODEL_ALIGNMENT = 8;

final class MLModel extends ffi.Struct {
  external Version version;

  external ffi.Pointer<MLLayer> layers;

  external ffi.Pointer<MLParameter> parameters;

  external MLMetrics metrics;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> name;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> architecture;

  @ffi.Array<ffi.Uint8>(1024)
  external ffi.Array<ffi.Uint8> model_data;

  String get name_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (name[i] == 0) break;
      bytes.add(name[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set name_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      name[i] = bytes[i];
    }
    if (len < 256) {
      name[len] = 0;
    }
  }

  String get architecture_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (architecture[i] == 0) break;
      bytes.add(architecture[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set architecture_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      architecture[i] = bytes[i];
    }
    if (len < 256) {
      architecture[len] = 0;
    }
  }

  static ffi.Pointer<MLModel> allocate() {
    return calloc<MLModel>();
  }
}

const int MLLAYER_SIZE = 824;
const int MLLAYER_ALIGNMENT = 8;

final class MLLayer extends ffi.Struct {
  external ffi.Pointer<ffi.Uint32> shape;

  external ffi.Pointer<ffi.Double> weights;

  external ffi.Pointer<ffi.Double> biases;

  @ffi.Uint32()
  external int num_parameters;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> name;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> type;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> activation;

  String get name_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (name[i] == 0) break;
      bytes.add(name[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set name_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      name[i] = bytes[i];
    }
    if (len < 256) {
      name[len] = 0;
    }
  }

  String get type_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (type[i] == 0) break;
      bytes.add(type[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set type_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      type[i] = bytes[i];
    }
    if (len < 256) {
      type[len] = 0;
    }
  }

  String get activation_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (activation[i] == 0) break;
      bytes.add(activation[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set activation_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      activation[i] = bytes[i];
    }
    if (len < 256) {
      activation[len] = 0;
    }
  }

  static ffi.Pointer<MLLayer> allocate() {
    return calloc<MLLayer>();
  }
}

const int MLPARAMETER_SIZE = 296;
const int MLPARAMETER_ALIGNMENT = 8;

final class MLParameter extends ffi.Struct {
  external ffi.Pointer<ffi.Double> values;

  external ffi.Pointer<ffi.Uint32> shape;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> name;

  @ffi.Uint8()
  external int trainable;

  String get name_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (name[i] == 0) break;
      bytes.add(name[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set name_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      name[i] = bytes[i];
    }
    if (len < 256) {
      name[len] = 0;
    }
  }

  static ffi.Pointer<MLParameter> allocate() {
    return calloc<MLParameter>();
  }
}

const int MLMETRICS_SIZE = 56;
const int MLMETRICS_ALIGNMENT = 8;

final class MLMetrics extends ffi.Struct {
  @ffi.Double()
  external double accuracy;

  @ffi.Double()
  external double precision;

  @ffi.Double()
  external double recall;

  @ffi.Double()
  external double f1_score;

  @ffi.Double()
  external double loss;

  external ffi.Pointer<ffi.Double> confusion_matrix;

  static ffi.Pointer<MLMetrics> allocate() {
    return calloc<MLMetrics>();
  }
}

const int TENSOR_SIZE = 296;
const int TENSOR_ALIGNMENT = 8;

final class Tensor extends ffi.Struct {
  external ffi.Pointer<ffi.Uint32> shape;

  external ffi.Pointer<ffi.Double> data;

  @ffi.Uint32()
  external int dtype;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> device;

  @ffi.Uint8()
  external int requires_grad;

  String get device_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (device[i] == 0) break;
      bytes.add(device[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set device_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      device[i] = bytes[i];
    }
    if (len < 256) {
      device[len] = 0;
    }
  }

  static ffi.Pointer<Tensor> allocate() {
    return calloc<Tensor>();
  }
}

const int COMPUTETASK_SIZE = 2664;
const int COMPUTETASK_ALIGNMENT = 8;

final class ComputeTask extends ffi.Struct {
  external UUID id;

  external ffi.Pointer<ComputeTask> dependencies;

  external Timestamp created_at;

  external Timestamp started_at;

  external Timestamp completed_at;

  @ffi.Double()
  external double progress;

  @ffi.Uint32()
  external int priority;

  @ffi.Uint32()
  external int state;

  @ffi.Uint32()
  external int error_code;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> name;

  @ffi.Array<ffi.Uint8>(1024)
  external ffi.Array<ffi.Uint8> input_data;

  @ffi.Array<ffi.Uint8>(1024)
  external ffi.Array<ffi.Uint8> output_data;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> error_message;

  String get name_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (name[i] == 0) break;
      bytes.add(name[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set name_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      name[i] = bytes[i];
    }
    if (len < 256) {
      name[len] = 0;
    }
  }

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

  static ffi.Pointer<ComputeTask> allocate() {
    return calloc<ComputeTask>();
  }
}

const int WORKERNODE_SIZE = 1360;
const int WORKERNODE_ALIGNMENT = 8;

final class WorkerNode extends ffi.Struct {
  external UUID id;

  @ffi.Uint64()
  external int memory_bytes;

  @ffi.Uint64()
  external int available_memory_bytes;

  @ffi.Double()
  external double cpu_usage;

  @ffi.Double()
  external double memory_usage;

  external ffi.Pointer<ComputeTask> tasks;

  @ffi.Uint32()
  external int port;

  @ffi.Uint32()
  external int state;

  @ffi.Uint32()
  external int num_cores;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> hostname;

  @ffi.Array<ffi.Uint8>(1024)
  external ffi.Array<ffi.Uint8> ip_address;

  String get hostname_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (hostname[i] == 0) break;
      bytes.add(hostname[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set hostname_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      hostname[i] = bytes[i];
    }
    if (len < 256) {
      hostname[len] = 0;
    }
  }

  static ffi.Pointer<WorkerNode> allocate() {
    return calloc<WorkerNode>();
  }
}

const int CLUSTER_SIZE = 416;
const int CLUSTER_ALIGNMENT = 8;

final class Cluster extends ffi.Struct {
  external UUID id;

  external ffi.Pointer<WorkerNode> nodes;

  external ffi.Pointer<ComputeTask> tasks;

  external Statistics load_stats;

  @ffi.Uint32()
  external int state;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> name;

  String get name_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (name[i] == 0) break;
      bytes.add(name[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set name_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      name[i] = bytes[i];
    }
    if (len < 256) {
      name[len] = 0;
    }
  }

  static ffi.Pointer<Cluster> allocate() {
    return calloc<Cluster>();
  }
}

const int MESSAGEQUEUE_SIZE = 304;
const int MESSAGEQUEUE_ALIGNMENT = 8;

final class MessageQueue extends ffi.Struct {
  external ffi.Pointer<QueueMessage> messages;

  @ffi.Uint64()
  external int total_enqueued;

  @ffi.Uint64()
  external int total_dequeued;

  @ffi.Uint32()
  external int max_size;

  @ffi.Uint32()
  external int current_size;

  @ffi.Uint32()
  external int min_priority;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> name;

  String get name_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (name[i] == 0) break;
      bytes.add(name[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set name_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      name[i] = bytes[i];
    }
    if (len < 256) {
      name[len] = 0;
    }
  }

  static ffi.Pointer<MessageQueue> allocate() {
    return calloc<MessageQueue>();
  }
}

const int QUEUEMESSAGE_SIZE = 1080;
const int QUEUEMESSAGE_ALIGNMENT = 8;

final class QueueMessage extends ffi.Struct {
  external UUID id;

  external Timestamp timestamp;

  external Timestamp expiry;

  @ffi.Uint32()
  external int priority;

  @ffi.Uint32()
  external int retry_count;

  @ffi.Array<ffi.Uint8>(1024)
  external ffi.Array<ffi.Uint8> payload;

  static ffi.Pointer<QueueMessage> allocate() {
    return calloc<QueueMessage>();
  }
}

const int EVENTLOG_SIZE = 56;
const int EVENTLOG_ALIGNMENT = 8;

final class EventLog extends ffi.Struct {
  external ffi.Pointer<LogEntry> entries;

  @ffi.Uint64()
  external int total_entries;

  external Timestamp first_entry;

  external Timestamp last_entry;

  static ffi.Pointer<EventLog> allocate() {
    return calloc<EventLog>();
  }
}

const int LOGENTRY_SIZE = 1576;
const int LOGENTRY_ALIGNMENT = 8;

final class LogEntry extends ffi.Struct {
  external UUID id;

  external Timestamp timestamp;

  @ffi.Uint32()
  external int level;

  @ffi.Uint32()
  external int error_code;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> source;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> message;

  @ffi.Array<ffi.Uint8>(1024)
  external ffi.Array<ffi.Uint8> context;

  String get source_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (source[i] == 0) break;
      bytes.add(source[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set source_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      source[i] = bytes[i];
    }
    if (len < 256) {
      source[len] = 0;
    }
  }

  String get message_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (message[i] == 0) break;
      bytes.add(message[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set message_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      message[i] = bytes[i];
    }
    if (len < 256) {
      message[len] = 0;
    }
  }

  static ffi.Pointer<LogEntry> allocate() {
    return calloc<LogEntry>();
  }
}

const int PERFORMANCEMETRICS_SIZE = 104;
const int PERFORMANCEMETRICS_ALIGNMENT = 8;

final class PerformanceMetrics extends ffi.Struct {
  external Timestamp timestamp;

  @ffi.Double()
  external double cpu_usage_percent;

  @ffi.Uint64()
  external int memory_used_bytes;

  @ffi.Uint64()
  external int memory_total_bytes;

  @ffi.Double()
  external double disk_read_mbps;

  @ffi.Double()
  external double disk_write_mbps;

  @ffi.Double()
  external double network_in_mbps;

  @ffi.Double()
  external double network_out_mbps;

  @ffi.Double()
  external double load_average_1m;

  @ffi.Double()
  external double load_average_5m;

  @ffi.Double()
  external double load_average_15m;

  @ffi.Uint32()
  external int num_threads;

  @ffi.Uint32()
  external int num_processes;

  static ffi.Pointer<PerformanceMetrics> allocate() {
    return calloc<PerformanceMetrics>();
  }
}

const int BENCHMARK_SIZE = 592;
const int BENCHMARK_ALIGNMENT = 8;

final class Benchmark extends ffi.Struct {
  external Statistics duration_stats;

  external Statistics throughput_stats;

  external Statistics memory_stats;

  external ffi.Pointer<PerformanceMetrics> samples;

  @ffi.Uint32()
  external int num_iterations;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> name;

  String get name_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (name[i] == 0) break;
      bytes.add(name[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set name_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      name[i] = bytes[i];
    }
    if (len < 256) {
      name[len] = 0;
    }
  }

  static ffi.Pointer<Benchmark> allocate() {
    return calloc<Benchmark>();
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

  late final timestamp_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('timestamp_size');

  late final timestamp_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('timestamp_alignment');

  late final uuid_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('uuid_size');

  late final uuid_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('uuid_alignment');

  late final version_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('version_size');

  late final version_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('version_alignment');

  late final point2d_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('point2d_size');

  late final point2d_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('point2d_alignment');

  late final point3d_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('point3d_size');

  late final point3d_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('point3d_alignment');

  late final point4d_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('point4d_size');

  late final point4d_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('point4d_alignment');

  late final vector2_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('vector2_size');

  late final vector2_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('vector2_alignment');

  late final vector3_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('vector3_size');

  late final vector3_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('vector3_alignment');

  late final vector4_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('vector4_size');

  late final vector4_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('vector4_alignment');

  late final matrix2x2_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('matrix2x2_size');

  late final matrix2x2_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('matrix2x2_alignment');

  late final matrix3x3_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('matrix3x3_size');

  late final matrix3x3_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('matrix3x3_alignment');

  late final matrix4x4_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('matrix4x4_size');

  late final matrix4x4_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('matrix4x4_alignment');

  late final quaternion_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('quaternion_size');

  late final quaternion_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('quaternion_alignment');

  late final color_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('color_size');

  late final color_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('color_alignment');

  late final boundingbox_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('boundingbox_size');

  late final boundingbox_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('boundingbox_alignment');

  late final sphere_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('sphere_size');

  late final sphere_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('sphere_alignment');

  late final plane_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('plane_size');

  late final plane_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('plane_alignment');

  late final ray_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('ray_size');

  late final ray_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('ray_alignment');

  late final transform_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('transform_size');

  late final transform_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('transform_alignment');

  late final statistics_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('statistics_size');

  late final statistics_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('statistics_alignment');

  late final histogram_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('histogram_size');

  late final histogram_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('histogram_alignment');

  late final timeseries_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('timeseries_size');

  late final timeseries_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('timeseries_alignment');

  late final graphnode_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('graphnode_size');

  late final graphnode_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('graphnode_alignment');

  late final graphedge_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('graphedge_size');

  late final graphedge_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('graphedge_alignment');

  late final graph_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('graph_size');

  late final graph_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('graph_alignment');

  late final treenode_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('treenode_size');

  late final treenode_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('treenode_alignment');

  late final binarytreenode_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('binarytreenode_size');

  late final binarytreenode_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('binarytreenode_alignment');

  late final heapnode_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('heapnode_size');

  late final heapnode_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('heapnode_alignment');

  late final hashtableentry_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('hashtableentry_size');

  late final hashtableentry_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('hashtableentry_alignment');

  late final hashtable_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('hashtable_size');

  late final hashtable_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('hashtable_alignment');

  late final trienode_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('trienode_size');

  late final trienode_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('trienode_alignment');

  late final bloomfilter_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('bloomfilter_size');

  late final bloomfilter_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('bloomfilter_alignment');

  late final skiplistnode_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('skiplistnode_size');

  late final skiplistnode_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('skiplistnode_alignment');

  late final kdtreenode_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('kdtreenode_size');

  late final kdtreenode_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('kdtreenode_alignment');

  late final octreenode_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('octreenode_size');

  late final octreenode_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('octreenode_alignment');

  late final quadtreenode_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('quadtreenode_size');

  late final quadtreenode_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('quadtreenode_alignment');

  late final rtreeentry_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('rtreeentry_size');

  late final rtreeentry_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('rtreeentry_alignment');

  late final spatialindex_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('spatialindex_size');

  late final spatialindex_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('spatialindex_alignment');

  late final cache_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('cache_size');

  late final cache_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('cache_alignment');

  late final database_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('database_size');

  late final database_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('database_alignment');

  late final table_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('table_size');

  late final table_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('table_alignment');

  late final column_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('column_size');

  late final column_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('column_alignment');

  late final row_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('row_size');

  late final row_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('row_alignment');

  late final cell_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('cell_size');

  late final cell_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('cell_alignment');

  late final index_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('index_size');

  late final index_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('index_alignment');

  late final indexentry_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('indexentry_size');

  late final indexentry_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('indexentry_alignment');

  late final transaction_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('transaction_size');

  late final transaction_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('transaction_alignment');

  late final operation_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('operation_size');

  late final operation_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('operation_alignment');

  late final networkpacket_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('networkpacket_size');

  late final networkpacket_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('networkpacket_alignment');

  late final networkconnection_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('networkconnection_size');

  late final networkconnection_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('networkconnection_alignment');

  late final httprequest_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('httprequest_size');

  late final httprequest_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('httprequest_alignment');

  late final httpresponse_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('httpresponse_size');

  late final httpresponse_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('httpresponse_alignment');

  late final header_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('header_size');

  late final header_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('header_alignment');

  late final filemetadata_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('filemetadata_size');

  late final filemetadata_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('filemetadata_alignment');

  late final filechunk_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('filechunk_size');

  late final filechunk_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('filechunk_alignment');

  late final imagemetadata_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('imagemetadata_size');

  late final imagemetadata_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('imagemetadata_alignment');

  late final image_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('image_size');

  late final image_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('image_alignment');

  late final imagelayer_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('imagelayer_size');

  late final imagelayer_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('imagelayer_alignment');

  late final audiometadata_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('audiometadata_size');

  late final audiometadata_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('audiometadata_alignment');

  late final audiosample_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('audiosample_size');

  late final audiosample_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('audiosample_alignment');

  late final videometadata_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('videometadata_size');

  late final videometadata_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('videometadata_alignment');

  late final videoframe_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('videoframe_size');

  late final videoframe_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('videoframe_alignment');

  late final mlmodel_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('mlmodel_size');

  late final mlmodel_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('mlmodel_alignment');

  late final mllayer_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('mllayer_size');

  late final mllayer_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('mllayer_alignment');

  late final mlparameter_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('mlparameter_size');

  late final mlparameter_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('mlparameter_alignment');

  late final mlmetrics_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('mlmetrics_size');

  late final mlmetrics_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('mlmetrics_alignment');

  late final tensor_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('tensor_size');

  late final tensor_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('tensor_alignment');

  late final computetask_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('computetask_size');

  late final computetask_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('computetask_alignment');

  late final workernode_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('workernode_size');

  late final workernode_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('workernode_alignment');

  late final cluster_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('cluster_size');

  late final cluster_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('cluster_alignment');

  late final messagequeue_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('messagequeue_size');

  late final messagequeue_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('messagequeue_alignment');

  late final queuemessage_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('queuemessage_size');

  late final queuemessage_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('queuemessage_alignment');

  late final eventlog_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('eventlog_size');

  late final eventlog_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('eventlog_alignment');

  late final logentry_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('logentry_size');

  late final logentry_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('logentry_alignment');

  late final performancemetrics_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('performancemetrics_size');

  late final performancemetrics_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('performancemetrics_alignment');

  late final benchmark_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('benchmark_size');

  late final benchmark_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('benchmark_alignment');
}
