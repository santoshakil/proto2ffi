import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:fixnum/fixnum.dart' as fixnum;
import 'package:dart_ffi_lib/src/generated_bindings.dart';
import 'package:dart_ffi_lib/src/native_loader.dart';
import 'package:dart_ffi_lib/generated/proto/calculator.pb.dart';

class BenchmarkResult {
  final String operation;
  final int iterations;
  final int totalTimeNs;
  final int serializationNs;
  final int ffiNs;
  final int deserializationNs;

  BenchmarkResult({
    required this.operation,
    required this.iterations,
    required this.totalTimeNs,
    required this.serializationNs,
    required this.ffiNs,
    required this.deserializationNs,
  });

  double get avgSerializationNs => serializationNs / iterations;
  double get avgFfiNs => ffiNs / iterations;
  double get avgDeserializationNs => deserializationNs / iterations;
  double get avgTotalNs => totalTimeNs / iterations;

  @override
  String toString() {
    return '''
Operation: $operation
  Iterations: $iterations
  Total Time: ${(totalTimeNs / 1000).toStringAsFixed(1)}µs (${(totalTimeNs / 1000000).toStringAsFixed(2)}ms)

  Average per call:
    Serialization:     ${avgSerializationNs.toStringAsFixed(1)}ns (${(avgSerializationNs / 1000).toStringAsFixed(2)}µs)
    FFI Call:          ${avgFfiNs.toStringAsFixed(1)}ns (${(avgFfiNs / 1000).toStringAsFixed(2)}µs)
    Deserialization:   ${avgDeserializationNs.toStringAsFixed(1)}ns (${(avgDeserializationNs / 1000).toStringAsFixed(2)}µs)
    ────────────────────────────────────────
    Total Round-trip:  ${avgTotalNs.toStringAsFixed(1)}ns (${(avgTotalNs / 1000).toStringAsFixed(2)}µs)

  Throughput: ${(iterations / (totalTimeNs / 1000000000)).toStringAsFixed(2)} ops/sec
''';
  }
}

class DetailedBenchmark {
  late final RustLibBindings _bindings;

  DetailedBenchmark() {
    final lib = NativeLoader.load('rust_lib');
    _bindings = RustLibBindings(lib);
  }

  BenchmarkResult benchmarkOperation(
    String opName,
    CalculatorRequest Function() createRequest,
    int iterations,
  ) {
    var totalSerializationNs = 0;
    var totalFfiNs = 0;
    var totalDeserializationNs = 0;

    final totalStopwatch = Stopwatch()..start();

    for (var i = 0; i < iterations; i++) {
      final request = createRequest();

      final serializationStopwatch = Stopwatch()..start();
      final requestBytes = request.writeToBuffer();
      final requestPtr = calloc<Uint8>(requestBytes.length);
      final nativeBytes = requestPtr.asTypedList(requestBytes.length);
      nativeBytes.setAll(0, requestBytes);
      serializationStopwatch.stop();
      totalSerializationNs += serializationStopwatch.elapsedMicroseconds * 1000;

      final ffiStopwatch = Stopwatch()..start();
      final responseBuffer = _bindings.calculator_process(
        requestPtr,
        requestBytes.length,
      );
      ffiStopwatch.stop();
      totalFfiNs += ffiStopwatch.elapsedMicroseconds * 1000;

      final deserializationStopwatch = Stopwatch()..start();
      final responseBytes = responseBuffer.ptr.asTypedList(responseBuffer.len);
      final response = CalculatorResponse.fromBuffer(responseBytes);

      switch (response.whichResult()) {
        case CalculatorResponse_Result.value:
          final _ = response.value.toInt();
        case CalculatorResponse_Result.error:
          throw Exception(response.error.message);
        case CalculatorResponse_Result.notSet:
          throw StateError('No result');
      }
      deserializationStopwatch.stop();
      totalDeserializationNs += deserializationStopwatch.elapsedMicroseconds * 1000;

      _bindings.calculator_free_buffer(responseBuffer);
      calloc.free(requestPtr);
    }

    totalStopwatch.stop();

    return BenchmarkResult(
      operation: opName,
      iterations: iterations,
      totalTimeNs: totalStopwatch.elapsedMicroseconds * 1000,
      serializationNs: totalSerializationNs,
      ffiNs: totalFfiNs,
      deserializationNs: totalDeserializationNs,
    );
  }

  void runAllBenchmarks({int iterations = 100000}) {
    print('=' * 70);
    print('FFI + Protobuf Benchmark');
    print('=' * 70);
    print('');

    final results = <BenchmarkResult>[];

    print('Warming up...');
    benchmarkOperation(
      'Warmup',
      () => CalculatorRequest(
        add: BinaryOp(a: fixnum.Int64(10), b: fixnum.Int64(5)),
      ),
      1000,
    );
    print('');

    print('Running benchmarks with $iterations iterations each...');
    print('');

    results.add(benchmarkOperation(
      'ADD',
      () => CalculatorRequest(
        add: BinaryOp(a: fixnum.Int64(10), b: fixnum.Int64(5)),
      ),
      iterations,
    ));

    results.add(benchmarkOperation(
      'SUBTRACT',
      () => CalculatorRequest(
        subtract: BinaryOp(a: fixnum.Int64(10), b: fixnum.Int64(5)),
      ),
      iterations,
    ));

    results.add(benchmarkOperation(
      'MULTIPLY',
      () => CalculatorRequest(
        multiply: BinaryOp(a: fixnum.Int64(10), b: fixnum.Int64(5)),
      ),
      iterations,
    ));

    results.add(benchmarkOperation(
      'DIVIDE',
      () => CalculatorRequest(
        divide: BinaryOp(a: fixnum.Int64(10), b: fixnum.Int64(5)),
      ),
      iterations,
    ));

    for (final result in results) {
      print(result);
    }

    print('=' * 70);
    print('Summary Statistics');
    print('=' * 70);

    final avgSerialization = results
        .map((r) => r.avgSerializationNs)
        .reduce((a, b) => a + b) /
        results.length;

    final avgFfi = results
        .map((r) => r.avgFfiNs)
        .reduce((a, b) => a + b) /
        results.length;

    final avgDeserialization = results
        .map((r) => r.avgDeserializationNs)
        .reduce((a, b) => a + b) /
        results.length;

    final avgTotal = results
        .map((r) => r.avgTotalNs)
        .reduce((a, b) => a + b) /
        results.length;

    print('');
    print('Average across all operations:');
    print('  Serialization:     ${avgSerialization.toStringAsFixed(1)}ns (${(avgSerialization / 1000).toStringAsFixed(2)}µs) - ${(avgSerialization / avgTotal * 100).toStringAsFixed(1)}%');
    print('  FFI Call:          ${avgFfi.toStringAsFixed(1)}ns (${(avgFfi / 1000).toStringAsFixed(2)}µs) - ${(avgFfi / avgTotal * 100).toStringAsFixed(1)}%');
    print('  Deserialization:   ${avgDeserialization.toStringAsFixed(1)}ns (${(avgDeserialization / 1000).toStringAsFixed(2)}µs) - ${(avgDeserialization / avgTotal * 100).toStringAsFixed(1)}%');
    print('  ────────────────────────────────────────');
    print('  Total:             ${avgTotal.toStringAsFixed(1)}ns (${(avgTotal / 1000).toStringAsFixed(2)}µs)');
    print('');
    print('Overhead breakdown:');
    print('  Protobuf (ser+deser): ${(avgSerialization + avgDeserialization).toStringAsFixed(1)}ns (${((avgSerialization + avgDeserialization) / 1000).toStringAsFixed(2)}µs) - ${((avgSerialization + avgDeserialization) / avgTotal * 100).toStringAsFixed(1)}%');
    print('  FFI overhead:         ${avgFfi.toStringAsFixed(1)}ns (${(avgFfi / 1000).toStringAsFixed(2)}µs) - ${(avgFfi / avgTotal * 100).toStringAsFixed(1)}%');
    print('');
  }
}

void main(List<String> args) {
  final iterations = args.isEmpty ? 100000 : int.parse(args[0]);
  final benchmark = DetailedBenchmark();
  benchmark.runAllBenchmarks(iterations: iterations);
}
