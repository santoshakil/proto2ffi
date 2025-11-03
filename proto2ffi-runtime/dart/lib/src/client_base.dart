import 'dart:ffi' as ffi;
import 'byte_buffer.dart';
import 'error.dart';

/// Base class for proto2ffi generated clients
abstract class Proto2FfiClientBase {
  final ffi.DynamicLibrary dylib;
  late final FreeByteBufferDart freeByteBuffer;

  Proto2FfiClientBase(this.dylib) {
    freeByteBuffer = dylib.lookupFunction<
      FreeByteBufferNative,
      FreeByteBufferDart
    >('proto2ffi_free_byte_buffer');
  }

  /// Get service name
  String get serviceName;
}
