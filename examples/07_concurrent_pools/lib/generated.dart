// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: constant_identifier_names

import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'dart:typed_data';
import 'dart:io';
import 'dart:convert';

const int SMALLMESSAGE_SIZE = 264;
const int SMALLMESSAGE_ALIGNMENT = 8;

final class SmallMessage extends ffi.Struct {
  @ffi.Int32()
  external int id;

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

  static ffi.Pointer<SmallMessage> allocate() {
    return calloc<SmallMessage>();
  }
}

const int MEDIUMMESSAGE_SIZE = 536;
const int MEDIUMMESSAGE_ALIGNMENT = 8;

final class MediumMessage extends ffi.Struct {
  @ffi.Pointer<i32>
  external List<int> tags;

  @ffi.Int32()
  external int id;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> title;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> description;

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

  static ffi.Pointer<MediumMessage> allocate() {
    return calloc<MediumMessage>();
  }
}

const int LARGEMESSAGE_SIZE = 1592;
const int LARGEMESSAGE_ALIGNMENT = 8;

final class LargeMessage extends ffi.Struct {
  @ffi.Pointer<SmallMessage>
  external List<SmallMessage> children;

  @ffi.Pointer<[u8; 256]>
  external List<String> keywords;

  @ffi.Pointer<i64>
  external List<int> timestamps;

  @ffi.Int32()
  external int id;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> title;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> description;

  @ffi.Array<ffi.Uint8>(1024)
  external ffi.Array<ffi.Uint8> payload;

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

  static ffi.Pointer<LargeMessage> allocate() {
    return calloc<LargeMessage>();
  }
}

const int STRESSTESTMESSAGE_SIZE = 1048;
const int STRESSTESTMESSAGE_ALIGNMENT = 8;

final class StressTestMessage extends ffi.Struct {
  @ffi.Int64()
  external int thread_id;

  @ffi.Int64()
  external int sequence;

  @ffi.Int64()
  external int timestamp;

  @ffi.Array<ffi.Uint8>(1024)
  external ffi.Array<ffi.Uint8> data;

  static ffi.Pointer<StressTestMessage> allocate() {
    return calloc<StressTestMessage>();
  }
}

const int POOLSTATSMESSAGE_SIZE = 40;
const int POOLSTATSMESSAGE_ALIGNMENT = 8;

final class PoolStatsMessage extends ffi.Struct {
  @ffi.Uint64()
  external int total_allocated;

  @ffi.Uint64()
  external int total_freed;

  @ffi.Uint64()
  external int active_count;

  @ffi.Uint64()
  external int pool_size;

  @ffi.Uint64()
  external int growth_count;

  static ffi.Pointer<PoolStatsMessage> allocate() {
    return calloc<PoolStatsMessage>();
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

  late final smallmessage_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('smallmessage_size');

  late final smallmessage_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('smallmessage_alignment');

  late final mediummessage_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('mediummessage_size');

  late final mediummessage_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('mediummessage_alignment');

  late final largemessage_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('largemessage_size');

  late final largemessage_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('largemessage_alignment');

  late final stresstestmessage_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('stresstestmessage_size');

  late final stresstestmessage_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('stresstestmessage_alignment');

  late final poolstatsmessage_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('poolstatsmessage_size');

  late final poolstatsmessage_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('poolstatsmessage_alignment');
}
