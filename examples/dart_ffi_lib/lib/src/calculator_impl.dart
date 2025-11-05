import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:fixnum/fixnum.dart' as fixnum;
import 'calculator.dart';
import 'generated_bindings.dart';
import 'native_loader.dart';
import '../generated/proto/calculator.pb.dart';

class CalculatorImpl implements Calculator {
  late final RustLibBindings _bindings;
  bool _disposed = false;

  CalculatorImpl() {
    final lib = NativeLoader.load('rust_lib');
    _bindings = RustLibBindings(lib);
  }

  void _checkDisposed() {
    if (_disposed) {
      throw StateError('Calculator already disposed');
    }
  }

  int _processRequest(CalculatorRequest request) {
    _checkDisposed();

    final requestBytes = request.writeToBuffer();
    final requestPtr = calloc<Uint8>(requestBytes.length);

    try {
      final nativeBytes = requestPtr.asTypedList(requestBytes.length);
      nativeBytes.setAll(0, requestBytes);

      final responseBuffer = _bindings.calculator_process(
        requestPtr,
        requestBytes.length,
      );

      if (responseBuffer.ptr.address == 0 || responseBuffer.len == 0) {
        throw StateError('FFI call failed: null response');
      }

      try {
        final responseBytes = responseBuffer.ptr.asTypedList(responseBuffer.len);
        final response = CalculatorResponse.fromBuffer(responseBytes);

        switch (response.whichResult()) {
          case CalculatorResponse_Result.value:
            return response.value.toInt();
          case CalculatorResponse_Result.error:
            throw Exception(response.error.message);
          case CalculatorResponse_Result.notSet:
            throw StateError('No result in response');
        }
      } finally {
        _bindings.calculator_free_buffer(responseBuffer);
      }
    } finally {
      calloc.free(requestPtr);
    }
  }

  @override
  int add(int a, int b) {
    final request = CalculatorRequest(
      add: BinaryOp(a: fixnum.Int64(a), b: fixnum.Int64(b)),
    );
    return _processRequest(request);
  }

  @override
  int subtract(int a, int b) {
    final request = CalculatorRequest(
      subtract: BinaryOp(a: fixnum.Int64(a), b: fixnum.Int64(b)),
    );
    return _processRequest(request);
  }

  @override
  int multiply(int a, int b) {
    final request = CalculatorRequest(
      multiply: BinaryOp(a: fixnum.Int64(a), b: fixnum.Int64(b)),
    );
    return _processRequest(request);
  }

  @override
  int? divide(int a, int b) {
    final request = CalculatorRequest(
      divide: BinaryOp(a: fixnum.Int64(a), b: fixnum.Int64(b)),
    );
    try {
      return _processRequest(request);
    } on Exception catch (e) {
      if (e.toString().contains('Division by zero')) {
        return null;
      }
      rethrow;
    }
  }

  @override
  void dispose() {
    _disposed = true;
  }
}
