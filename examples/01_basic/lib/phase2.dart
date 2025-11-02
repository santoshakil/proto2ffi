import 'dart:ffi' as ffi;
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'phase2/generated.dart';

class Phase2FFI {
  static final ffi.DynamicLibrary _dylib = _loadLibrary();

  static ffi.DynamicLibrary _loadLibrary() {
    if (Platform.isMacOS) {
      return ffi.DynamicLibrary.open('/Volumes/Projects/DevCaches/project-targets/release/libffi_example.dylib');
    } else if (Platform.isLinux) {
      return ffi.DynamicLibrary.open('/Volumes/Projects/DevCaches/project-targets/release/libffi_example.so');
    } else if (Platform.isWindows) {
      return ffi.DynamicLibrary.open('/Volumes/Projects/DevCaches/project-targets/release/ffi_example.dll');
    }
    throw UnsupportedError('Unsupported platform');
  }

  static final _meshCreateCube = _dylib.lookupFunction<
    ffi.Void Function(ffi.Pointer<Mesh>, ffi.Double),
    void Function(ffi.Pointer<Mesh>, double)
  >('mesh_create_cube');

  static final _meshCalculateBounds = _dylib.lookupFunction<
    ffi.Void Function(ffi.Pointer<Mesh>, ffi.Pointer<BoundingBox>),
    void Function(ffi.Pointer<Mesh>, ffi.Pointer<BoundingBox>)
  >('mesh_calculate_bounds');

  static final _meshVertexCount = _dylib.lookupFunction<
    ffi.Uint32 Function(ffi.Pointer<Mesh>),
    int Function(ffi.Pointer<Mesh>)
  >('mesh_vertex_count');

  static final _meshTransform = _dylib.lookupFunction<
    ffi.Void Function(ffi.Pointer<Mesh>, ffi.Double, ffi.Pointer<Vec3>),
    void Function(ffi.Pointer<Mesh>, double, ffi.Pointer<Vec3>)
  >('mesh_transform');

  static final _modelCreate = _dylib.lookupFunction<
    ffi.Void Function(ffi.Pointer<Model>, ffi.Pointer<ffi.Uint8>, ffi.Size),
    void Function(ffi.Pointer<Model>, ffi.Pointer<ffi.Uint8>, int)
  >('model_create');

  static void meshCreateCube(ffi.Pointer<Mesh> mesh, double size) {
    _meshCreateCube(mesh, size);
  }

  static void meshCalculateBounds(ffi.Pointer<Mesh> mesh, ffi.Pointer<BoundingBox> bounds) {
    _meshCalculateBounds(mesh, bounds);
  }

  static int meshVertexCount(ffi.Pointer<Mesh> mesh) {
    return _meshVertexCount(mesh);
  }

  static void meshTransform(ffi.Pointer<Mesh> mesh, double scale, ffi.Pointer<Vec3> offset) {
    _meshTransform(mesh, scale, offset);
  }

  static void modelCreate(ffi.Pointer<Model> model, String name) {
    final namePtr = name.toNativeUtf8();
    _modelCreate(model, namePtr.cast<ffi.Uint8>(), name.length);
    calloc.free(namePtr);
  }
}
