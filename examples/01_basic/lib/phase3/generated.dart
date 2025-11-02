// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: constant_identifier_names

import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'dart:typed_data';
import 'dart:io';
import 'dart:convert';

const int PARTICLE_SIZE = 64;
const int PARTICLE_ALIGNMENT = 8;

final class Particle extends ffi.Struct {
  @ffi.Double()
  external double x;

  @ffi.Double()
  external double y;

  @ffi.Double()
  external double z;

  @ffi.Double()
  external double vx;

  @ffi.Double()
  external double vy;

  @ffi.Double()
  external double vz;

  @ffi.Double()
  external double mass;

  @ffi.Uint32()
  external int color;

  @ffi.Uint8()
  external int active;

  static ffi.Pointer<Particle> allocate() {
    return calloc<Particle>();
  }
}

const int RIGIDBODY_SIZE = 120;
const int RIGIDBODY_ALIGNMENT = 8;

final class RigidBody extends ffi.Struct {
  @ffi.Double()
  external double px;

  @ffi.Double()
  external double py;

  @ffi.Double()
  external double pz;

  @ffi.Double()
  external double qx;

  @ffi.Double()
  external double qy;

  @ffi.Double()
  external double qz;

  @ffi.Double()
  external double qw;

  @ffi.Double()
  external double vx;

  @ffi.Double()
  external double vy;

  @ffi.Double()
  external double vz;

  @ffi.Double()
  external double ax;

  @ffi.Double()
  external double ay;

  @ffi.Double()
  external double az;

  @ffi.Double()
  external double mass;

  @ffi.Uint64()
  external int id;

  static ffi.Pointer<RigidBody> allocate() {
    return calloc<RigidBody>();
  }
}

const int POOLSTATS_SIZE = 40;
const int POOLSTATS_ALIGNMENT = 8;

final class PoolStats extends ffi.Struct {
  @ffi.Uint64()
  external int total_allocations;

  @ffi.Uint64()
  external int total_frees;

  @ffi.Uint64()
  external int active_objects;

  @ffi.Uint64()
  external int pool_hits;

  @ffi.Uint64()
  external int pool_misses;

  static ffi.Pointer<PoolStats> allocate() {
    return calloc<PoolStats>();
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

  late final particle_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('particle_size');

  late final particle_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('particle_alignment');

  late final rigidbody_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('rigidbody_size');

  late final rigidbody_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('rigidbody_alignment');

  late final poolstats_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('poolstats_size');

  late final poolstats_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('poolstats_alignment');
}
