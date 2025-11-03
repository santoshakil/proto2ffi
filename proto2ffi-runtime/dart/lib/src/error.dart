/// Proto2FFI error
class Proto2FfiError implements Exception {
  final String message;
  final Object? cause;

  Proto2FfiError(this.message, [this.cause]);

  @override
  String toString() {
    if (cause != null) {
      return 'Proto2FfiError: $message\nCaused by: $cause';
    }
    return 'Proto2FfiError: $message';
  }
}

/// FFI call error
class FfiCallError extends Proto2FfiError {
  FfiCallError(super.message, [super.cause]);
}

/// Protobuf encoding error
class EncodeError extends Proto2FfiError {
  EncodeError(super.message, [super.cause]);
}

/// Protobuf decoding error
class DecodeError extends Proto2FfiError {
  DecodeError(super.message, [super.cause]);
}
