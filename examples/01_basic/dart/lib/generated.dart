// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: constant_identifier_names

import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'dart:typed_data';
import 'dart:io';
import 'dart:convert';

const int POINT_SIZE = 16;
const int POINT_ALIGNMENT = 8;

final class Point extends ffi.Struct {
  @ffi.Double()
  external double x;

  @ffi.Double()
  external double y;

  static ffi.Pointer<Point> allocate() {
    return calloc<Point>();
  }
}

const int COUNTER_SIZE = 16;
const int COUNTER_ALIGNMENT = 8;

final class Counter extends ffi.Struct {
  @ffi.Int64()
  external int value;

  @ffi.Int64()
  external int timestamp;

  static ffi.Pointer<Counter> allocate() {
    return calloc<Counter>();
  }
}

const int STATS_SIZE = 40;
const int STATS_ALIGNMENT = 8;

final class Stats extends ffi.Struct {
  @ffi.Int64()
  external int count;

  @ffi.Double()
  external double sum;

  @ffi.Double()
  external double min;

  @ffi.Double()
  external double max;

  @ffi.Double()
  external double avg;

  static ffi.Pointer<Stats> allocate() {
    return calloc<Stats>();
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

  late final point_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('point_size');

  late final point_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('point_alignment');

  late final counter_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('counter_size');

  late final counter_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('counter_alignment');

  late final stats_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('stats_size');

  late final stats_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('stats_alignment');
}
