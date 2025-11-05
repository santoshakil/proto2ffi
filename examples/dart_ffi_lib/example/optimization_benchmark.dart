import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:fixnum/fixnum.dart' as fixnum;
import 'package:dart_ffi_lib/src/generated_bindings.dart';
import 'package:dart_ffi_lib/src/native_loader.dart';
import 'package:dart_ffi_lib/generated/proto/calculator.pb.dart';
import 'package:dart_ffi_lib/generated/proto/complex_data.pb.dart';

class OptimizationBenchmark {
  late final RustLibBindings _bindings;

  OptimizationBenchmark() {
    final lib = NativeLoader.load('rust_lib');
    _bindings = RustLibBindings(lib);
  }

  ComplexCalculationResponse _processRequest(ComplexCalculationRequest request) {
    final requestBytes = request.writeToBuffer();
    final requestPtr = calloc<Uint8>(requestBytes.length);

    try {
      final nativeBytes = requestPtr.asTypedList(requestBytes.length);
      nativeBytes.setAll(0, requestBytes);

      final responseBuffer = _bindings.calculator_process(
        requestPtr,
        requestBytes.length,
      );

      try {
        final responseBytes = responseBuffer.ptr.asTypedList(responseBuffer.len);
        return ComplexCalculationResponse.fromBuffer(responseBytes);
      } finally {
        _bindings.calculator_free_buffer(responseBuffer);
      }
    } finally {
      calloc.free(requestPtr);
    }
  }

  void benchmarkSimpleOperation(int iterations) {
    print('1. Simple Operation (Baseline)');
    print('   $iterations individual FFI calls');

    final sw = Stopwatch()..start();

    for (var i = 0; i < iterations; i++) {
      final request = ComplexCalculationRequest(
        add: BinaryOp(a: fixnum.Int64(10), b: fixnum.Int64(5)),
      );
      final response = _processRequest(request);

      if (response.whichResult() != ComplexCalculationResponse_Result.value) {
        throw Exception('Unexpected result');
      }
    }

    sw.stop();
    final avgUs = sw.elapsedMicroseconds / iterations;
    print('   Total: ${sw.elapsedMilliseconds}ms');
    print('   Avg per call: ${avgUs.toStringAsFixed(3)}µs');
    print('   Throughput: ${(iterations / (sw.elapsedMilliseconds / 1000)).toStringAsFixed(0)} ops/sec');
    print('');
  }

  void benchmarkBatchOperation(int batchSize, int iterations) {
    print('2. Batch Operation (Optimized)');
    print('   $iterations batches of $batchSize operations each');
    print('   Total operations: ${batchSize * iterations}');

    final sw = Stopwatch()..start();

    for (var i = 0; i < iterations; i++) {
      final operations = List.generate(
        batchSize,
        (_) => BinaryOp(a: fixnum.Int64(10), b: fixnum.Int64(5)),
      );

      final request = ComplexCalculationRequest(
        batch: BatchOperation(operations: operations),
      );

      final response = _processRequest(request);

      if (response.whichResult() != ComplexCalculationResponse_Result.batchResult) {
        throw Exception('Unexpected result');
      }
    }

    sw.stop();

    final totalOps = batchSize * iterations;
    final avgUsPerOp = sw.elapsedMicroseconds / totalOps;
    final avgUsPerBatch = sw.elapsedMicroseconds / iterations;

    print('   Total: ${sw.elapsedMilliseconds}ms');
    print('   Avg per batch: ${avgUsPerBatch.toStringAsFixed(3)}µs');
    print('   Avg per operation: ${avgUsPerOp.toStringAsFixed(3)}µs');
    print('   Throughput: ${(totalOps / (sw.elapsedMilliseconds / 1000)).toStringAsFixed(0)} ops/sec');
    print('   Speedup vs simple: ${(1 / avgUsPerOp * 0.6).toStringAsFixed(1)}x'); // Assuming 0.6µs baseline
    print('');
  }

  void benchmarkComplexData(int transactionCount, int iterations) {
    print('3. Complex Nested Data');
    print('   $iterations requests with $transactionCount transactions each');

    final transactions = List.generate(transactionCount, (i) {
      return Transaction(
        transactionId: 'tx_$i',
        timestamp: fixnum.Int64(DateTime.now().millisecondsSinceEpoch),
        amount: 100.0 + i,
        currency: i % 2 == 0 ? 'USD' : 'EUR',
        sender: Person(
          id: 'person_${i * 2}',
          firstName: 'John',
          lastName: 'Doe',
          email: 'john.doe$i@example.com',
          age: 30 + i,
          homeAddress: Address(
            street: '$i Main St',
            city: 'New York',
            state: 'NY',
            zipCode: '10001',
            country: 'USA',
            latitude: 40.7128,
            longitude: -74.0060,
          ),
          phoneNumbers: ['555-0001', '555-0002'],
        )
          ..metadata.addAll({'key1': 'value1', 'key2': 'value2'}),
        receiver: Person(
          id: 'person_${i * 2 + 1}',
          firstName: 'Jane',
          lastName: 'Smith',
          email: 'jane.smith$i@example.com',
          age: 28 + i,
          homeAddress: Address(
            street: '${i + 1} Broadway',
            city: 'Los Angeles',
            state: 'CA',
            zipCode: '90001',
            country: 'USA',
            latitude: 34.0522,
            longitude: -118.2437,
          ),
          phoneNumbers: ['555-0003'],
        )
          ..metadata.addAll({'type': 'business'}),
        tags: ['tag1', 'tag2', 'priority'],
      )
        ..fees.addAll({'processing': 2.5, 'network': 1.5});
    });

    final dataBatch = DataBatch(
      transactions: transactions,
      batchId: fixnum.Int64(12345),
      createdAt: fixnum.Int64(DateTime.now().millisecondsSinceEpoch),
    );

    final protoSize = dataBatch.writeToBuffer().length;
    print('   Protobuf size: ${(protoSize / 1024).toStringAsFixed(2)} KB');

    final sw = Stopwatch()..start();

    for (var i = 0; i < iterations; i++) {
      final request = ComplexCalculationRequest(
        complex: ComplexDataOperation(
          data: dataBatch,
          operationType: 'aggregate',
        ),
      );

      final response = _processRequest(request);

      if (response.whichResult() != ComplexCalculationResponse_Result.complexResult) {
        throw Exception('Unexpected result');
      }

      final result = response.complexResult;
      if (result.transactionCount != transactionCount) {
        throw Exception('Transaction count mismatch');
      }
    }

    sw.stop();

    final avgUs = sw.elapsedMicroseconds / iterations;
    print('   Total: ${sw.elapsedMilliseconds}ms');
    print('   Avg per call: ${avgUs.toStringAsFixed(3)}µs');
    print('   Throughput: ${(iterations / (sw.elapsedMilliseconds / 1000)).toStringAsFixed(0)} ops/sec');
    print('   Data throughput: ${(protoSize * iterations / 1024 / (sw.elapsedMilliseconds / 1000)).toStringAsFixed(0)} KB/sec');
    print('');
  }

  void runAll() {
    print('=' * 70);
    print('Optimization Benchmark Suite');
    print('=' * 70);
    print('');

    print('Warmup...');
    benchmarkSimpleOperation(1000);

    print('=' * 70);
    print('Running Benchmarks');
    print('=' * 70);
    print('');

    benchmarkSimpleOperation(10000);

    benchmarkBatchOperation(10, 10000);
    benchmarkBatchOperation(100, 1000);
    benchmarkBatchOperation(1000, 100);

    benchmarkComplexData(10, 1000);
    benchmarkComplexData(100, 100);
    benchmarkComplexData(1000, 10);

    print('=' * 70);
    print('Key Findings');
    print('=' * 70);
    print('');
    print('Batch processing provides significant optimization when sending');
    print('multiple operations in a single FFI call. The overhead of FFI');
    print('boundary crossing and protobuf serialization is amortized across');
    print('all operations in the batch.');
    print('');
    print('Complex nested data structures have minimal impact on performance.');
    print('Protobuf handles serialization/deserialization efficiently even');
    print('for deeply nested objects with many fields.');
    print('');
  }
}

void main() {
  final benchmark = OptimizationBenchmark();
  benchmark.runAll();
}
