import 'dart:ffi';
import 'package:fixnum/fixnum.dart' as fixnum;
import 'buffer_pool.dart';
import 'calculator.dart';
import 'generated_bindings.dart';
import 'native_loader.dart';
import '../generated/proto/calculator.pb.dart';
import '../generated/proto/complex_data.pb.dart';

class CalculatorOptimized implements Calculator {
  late final RustLibBindings _bindings;
  final BufferPool _pool = BufferPool(maxPoolSize: 30);
  bool _disposed = false;

  CalculatorOptimized() {
    final lib = NativeLoader.load('rust_lib');
    _bindings = RustLibBindings(lib);
  }

  void _checkDisposed() {
    if (_disposed) {
      throw StateError('Calculator already disposed');
    }
  }

  ComplexCalculationResponse _processRequestPooled(ComplexCalculationRequest request) {
    _checkDisposed();

    final requestBytes = request.writeToBuffer();
    final requestBuffer = _pool.acquire(requestBytes.length);

    try {
      final nativeBytes = requestBuffer.asTypedList(requestBytes.length);
      nativeBytes.setAll(0, requestBytes);

      final responseBuffer = _bindings.calculator_process(
        requestBuffer.ptr,
        requestBytes.length,
      );

      try {
        final responseBytes = responseBuffer.ptr.asTypedList(responseBuffer.len);
        return ComplexCalculationResponse.fromBuffer(responseBytes);
      } finally {
        _bindings.calculator_free_buffer(responseBuffer);
      }
    } finally {
      requestBuffer.release();
    }
  }

  @override
  int add(int a, int b) {
    final request = ComplexCalculationRequest(
      add: BinaryOp()
        ..a = fixnum.Int64(a)
        ..b = fixnum.Int64(b),
    );
    final response = _processRequestPooled(request);

    return switch (response.whichResult()) {
      ComplexCalculationResponse_Result.value => response.value.toInt(),
      ComplexCalculationResponse_Result.error => throw Exception(response.error.message),
      _ => throw StateError('No result in response'),
    };
  }

  @override
  int subtract(int a, int b) {
    final request = ComplexCalculationRequest(
      subtract: BinaryOp()
        ..a = fixnum.Int64(a)
        ..b = fixnum.Int64(b),
    );
    final response = _processRequestPooled(request);

    return switch (response.whichResult()) {
      ComplexCalculationResponse_Result.value => response.value.toInt(),
      ComplexCalculationResponse_Result.error => throw Exception(response.error.message),
      _ => throw StateError('No result in response'),
    };
  }

  @override
  int multiply(int a, int b) {
    final request = ComplexCalculationRequest(
      multiply: BinaryOp()
        ..a = fixnum.Int64(a)
        ..b = fixnum.Int64(b),
    );
    final response = _processRequestPooled(request);

    return switch (response.whichResult()) {
      ComplexCalculationResponse_Result.value => response.value.toInt(),
      ComplexCalculationResponse_Result.error => throw Exception(response.error.message),
      _ => throw StateError('No result in response'),
    };
  }

  @override
  int? divide(int a, int b) {
    final request = ComplexCalculationRequest(
      divide: BinaryOp()
        ..a = fixnum.Int64(a)
        ..b = fixnum.Int64(b),
    );

    try {
      final response = _processRequestPooled(request);
      return switch (response.whichResult()) {
        ComplexCalculationResponse_Result.value => response.value.toInt(),
        ComplexCalculationResponse_Result.error => throw Exception(response.error.message),
        _ => throw StateError('No result in response'),
      };
    } on Exception catch (e) {
      if (e.toString().contains('Division by zero')) {
        return null;
      }
      rethrow;
    }
  }

  List<int> batchAdd(List<(int, int)> operations) {
    _checkDisposed();

    final batchOps = operations
        .map((op) => BinaryOp(a: fixnum.Int64(op.$1), b: fixnum.Int64(op.$2)))
        .toList();

    final request = ComplexCalculationRequest(
      batch: BatchOperation(operations: batchOps),
    );

    final response = _processRequestPooled(request);

    return switch (response.whichResult()) {
      ComplexCalculationResponse_Result.batchResult =>
        response.batchResult.values.map((v) => v.toInt()).toList(),
      ComplexCalculationResponse_Result.error =>
        throw Exception(response.error.message),
      _ => throw StateError('Expected batch result'),
    };
  }

  @override
  void dispose() {
    if (!_disposed) {
      _pool.clear();
      _disposed = true;
    }
  }

  int get poolSize => _pool.poolSize;
  int get totalAllocated => _pool.totalAllocated;
}
