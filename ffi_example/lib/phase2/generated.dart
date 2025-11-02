// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: constant_identifier_names

import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'dart:typed_data';
import 'dart:io';
import 'dart:convert';

const int VEC3_SIZE = 24;
const int VEC3_ALIGNMENT = 8;

final class Vec3 extends ffi.Struct {
  @ffi.Double()
  external double x;

  @ffi.Double()
  external double y;

  @ffi.Double()
  external double z;

  static ffi.Pointer<Vec3> allocate() {
    return calloc<Vec3>();
  }
}

const int COLOR_SIZE = 16;
const int COLOR_ALIGNMENT = 8;

final class Color extends ffi.Struct {
  @ffi.Uint32()
  external int r;

  @ffi.Uint32()
  external int g;

  @ffi.Uint32()
  external int b;

  @ffi.Uint32()
  external int a;

  static ffi.Pointer<Color> allocate() {
    return calloc<Color>();
  }
}

const int VERTEX_SIZE = 64;
const int VERTEX_ALIGNMENT = 8;

final class Vertex extends ffi.Struct {
  external Vec3 position;

  external Vec3 normal;

  external Color color;

  static ffi.Pointer<Vertex> allocate() {
    return calloc<Vertex>();
  }
}

const int TRIANGLE_SIZE = 224;
const int TRIANGLE_ALIGNMENT = 8;

final class Triangle extends ffi.Struct {
  @ffi.Uint32()
  external int vertices_count;

  @ffi.Array<Vertex>(3)
  external ffi.Array<Vertex> _vertices;

  external Vec3 normal;

  List<Vertex> get vertices {
    return List.generate(
      vertices_count,
      (i) => _vertices[i],
      growable: false,
    );
  }

  Vertex get_next_vertice() {
    if (vertices_count >= 3) {
      throw Exception('vertices array full');
    }
    final idx = vertices_count;
    vertices_count++;
    return _vertices[idx];
  }

  static ffi.Pointer<Triangle> allocate() {
    return calloc<Triangle>();
  }
}

const int MESH_SIZE = 22472;
const int MESH_ALIGNMENT = 8;

final class Mesh extends ffi.Struct {
  @ffi.Uint32()
  external int triangles_count;

  @ffi.Array<Triangle>(100)
  external ffi.Array<Triangle> _triangles;

  @ffi.Uint32()
  external int triangle_count;

  @ffi.Array<ffi.Uint8>(64)
  external ffi.Array<ffi.Uint8> _name;

  List<Triangle> get triangles {
    return List.generate(
      triangles_count,
      (i) => _triangles[i],
      growable: false,
    );
  }

  Triangle get_next_triangle() {
    if (triangles_count >= 100) {
      throw Exception('triangles array full');
    }
    final idx = triangles_count;
    triangles_count++;
    return _triangles[idx];
  }

  String get name {
    final bytes = <int>[];
    for (int i = 0; i < 64; i++) {
      if (_name[i] == 0) break;
      bytes.add(_name[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set name(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 63 ? bytes.length : 63;
    for (int i = 0; i < len; i++) {
      _name[i] = bytes[i];
    }
    if (len < 64) {
      _name[len] = 0;
    }
  }

  static ffi.Pointer<Mesh> allocate() {
    return calloc<Mesh>();
  }
}

const int BOUNDINGBOX_SIZE = 48;
const int BOUNDINGBOX_ALIGNMENT = 8;

final class BoundingBox extends ffi.Struct {
  external Vec3 min;

  external Vec3 max;

  static ffi.Pointer<BoundingBox> allocate() {
    return calloc<BoundingBox>();
  }
}

const int MODEL_SIZE = 22528;
const int MODEL_ALIGNMENT = 8;

final class Model extends ffi.Struct {
  external Mesh mesh;

  external BoundingBox bounds;

  @ffi.Uint64()
  external int id;

  static ffi.Pointer<Model> allocate() {
    return calloc<Model>();
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

  late final vec3_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('vec3_size');

  late final vec3_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('vec3_alignment');

  late final color_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('color_size');

  late final color_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('color_alignment');

  late final vertex_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('vertex_size');

  late final vertex_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('vertex_alignment');

  late final triangle_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('triangle_size');

  late final triangle_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('triangle_alignment');

  late final mesh_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('mesh_size');

  late final mesh_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('mesh_alignment');

  late final boundingbox_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('boundingbox_size');

  late final boundingbox_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('boundingbox_alignment');

  late final model_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('model_size');

  late final model_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('model_alignment');
}
