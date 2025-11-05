import 'package:dart_ffi_lib/src/calculator_impl.dart';
import 'package:dart_ffi_lib/src/calculator_optimized.dart';

void main() {
  print('=' * 70);
  print('Object Pooling Optimization Benchmark');
  print('=' * 70);
  print('');

  final iterations = 100000;

  print('Testing with $iterations iterations...');
  print('');

  print('1. Without Pooling (Original)');
  final calc = CalculatorImpl();
  try {
    final sw = Stopwatch()..start();
    for (var i = 0; i < iterations; i++) {
      calc.add(10, 5);
    }
    sw.stop();

    final avgUs = sw.elapsedMicroseconds / iterations;
    print('   Total: ${sw.elapsedMilliseconds}ms');
    print('   Avg per call: ${avgUs.toStringAsFixed(3)}µs');
    print('   Throughput: ${(iterations / (sw.elapsedMilliseconds / 1000)).toStringAsFixed(0)} ops/sec');
  } finally {
    calc.dispose();
  }

  print('');
  print('2. With Object Pooling (Optimized)');

  final calcOpt = CalculatorOptimized();
  try {
    final sw = Stopwatch()..start();
    for (var i = 0; i < iterations; i++) {
      calcOpt.add(10, 5);
    }
    sw.stop();

    final avgUs = sw.elapsedMicroseconds / iterations;
    print('   Total: ${sw.elapsedMilliseconds}ms');
    print('   Avg per call: ${avgUs.toStringAsFixed(3)}µs');
    print('   Throughput: ${(iterations / (sw.elapsedMilliseconds / 1000)).toStringAsFixed(0)} ops/sec');
    print('   Pool size: ${calcOpt.poolSize}');
    print('   Total allocated: ${calcOpt.totalAllocated}');
  } finally {
    calcOpt.dispose();
  }

  print('');
  print('3. Batch Operations with Pooling');

  final calcBatch = CalculatorOptimized();
  try {
    final operations = List.generate(1000, (i) => (10, 5));

    final sw = Stopwatch()..start();
    for (var i = 0; i < iterations ~/ 1000; i++) {
      calcBatch.batchAdd(operations);
    }
    sw.stop();

    final totalOps = operations.length * (iterations ~/ 1000);
    final avgUs = sw.elapsedMicroseconds / totalOps;

    print('   Total operations: $totalOps');
    print('   Total: ${sw.elapsedMilliseconds}ms');
    print('   Avg per op: ${avgUs.toStringAsFixed(3)}µs');
    print('   Throughput: ${(totalOps / (sw.elapsedMilliseconds / 1000)).toStringAsFixed(0)} ops/sec');
    print('   Pool size: ${calcBatch.poolSize}');
  } finally {
    calcBatch.dispose();
  }

  print('');
  print('=' * 70);
  print('Analysis');
  print('=' * 70);
  print('');
  print('Object pooling reduces GC pressure by reusing allocated buffers.');
  print('Buffers are rounded up to power-of-2 sizes for efficient reuse.');
  print('Pool size is limited to prevent unbounded memory growth.');
  print('');
}
