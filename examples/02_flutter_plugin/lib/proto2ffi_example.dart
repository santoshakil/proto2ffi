import 'dart:ffi' as ffi;
import 'dart:io';

/// Dynamic library loader with platform-specific paths
class NativeLibrary {
  static ffi.DynamicLibrary? _library;

  /// Load the native library
  static ffi.DynamicLibrary load() {
    if (_library != null) return _library!;

    if (Platform.isAndroid) {
      _library = ffi.DynamicLibrary.open('libproto2ffi_example.so');
    } else if (Platform.isIOS) {
      _library = ffi.DynamicLibrary.process();
    } else if (Platform.isMacOS) {
      _library = _tryLoad([
        'libproto2ffi_example.dylib',
        '../rust/target/release/libproto2ffi_example.dylib',
        '../target/release/libproto2ffi_example.dylib',
      ]);
    } else if (Platform.isLinux) {
      _library = _tryLoad([
        'libproto2ffi_example.so',
        '../rust/target/release/libproto2ffi_example.so',
        '../target/release/libproto2ffi_example.so',
      ]);
    } else if (Platform.isWindows) {
      _library = _tryLoad([
        'proto2ffi_example.dll',
        '../rust/target/release/proto2ffi_example.dll',
        '../target/release/proto2ffi_example.dll',
      ]);
    } else {
      throw UnsupportedError('Platform ${Platform.operatingSystem} is not supported');
    }

    return _library!;
  }

  static ffi.DynamicLibrary _tryLoad(List<String> paths) {
    for (final path in paths) {
      try {
        return ffi.DynamicLibrary.open(path);
      } catch (e) {
        // Try next path
      }
    }
    throw UnsupportedError(
      'Could not load native library. Tried paths: ${paths.join(", ")}'
    );
  }
}

/// Base class for FFI bindings
class FFIBindings {
  static final dylib = NativeLibrary.load();
}
