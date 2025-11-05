import 'package:dart_ffi_lib/src/calculator_impl.dart';
import 'package:dart_ffi_lib/src/calculator_optimized.dart';

void main() {
  print('=' * 70);
  print('Phase 2 Optimization Benchmark');
  print('Thread-Local Buffers (Rust) + Request Pooling (Dart)');
  print('=' * 70);
  print('');

  final iterations = 100000;

  print('Testing with $iterations iterations...');
  print('');

  // Baseline without any pooling
  print('1. Baseline (No Pooling)');
  final calcBaseline = CalculatorImpl();
  try {
    final sw = Stopwatch()..start();
    for (var i = 0; i < iterations; i++) {
      calcBaseline.add(10, 5);
    }
    sw.stop();

    final avgUs = sw.elapsedMicroseconds / iterations;
    print('   Total: ${sw.elapsedMilliseconds}ms');
    print('   Avg per call: ${avgUs.toStringAsFixed(3)}µs');
    print('   Throughput: ${(iterations / (sw.elapsedMilliseconds / 1000)).toStringAsFixed(0)} ops/sec');
  } finally {
    calcBaseline.dispose();
  }

  print('');
  print('2. With All Optimizations (Buffer + Request Pooling)');

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
    print('   Buffer pool size: ${calcOpt.poolSize}');
    print('   Buffer total allocated: ${calcOpt.totalAllocated}');
    print('   Request pool size: ${calcOpt.requestPoolSize}');
    print('   Request reuse rate: ${(calcOpt.requestReuseRate * 100).toStringAsFixed(2)}%');
  } finally {
    calcOpt.dispose();
  }

  print('');
  print('3. Mixed Operations (add, subtract, multiply, divide)');

  final calcMixed = CalculatorOptimized();
  try {
    final sw = Stopwatch()..start();
    for (var i = 0; i < iterations ~/ 4; i++) {
      calcMixed.add(10, 5);
      calcMixed.subtract(10, 5);
      calcMixed.multiply(10, 5);
      calcMixed.divide(10, 5);
    }
    sw.stop();

    final avgUs = sw.elapsedMicroseconds / iterations;
    print('   Total: ${sw.elapsedMilliseconds}ms');
    print('   Avg per call: ${avgUs.toStringAsFixed(3)}µs');
    print('   Throughput: ${(iterations / (sw.elapsedMilliseconds / 1000)).toStringAsFixed(0)} ops/sec');
    print('   Request pool size: ${calcMixed.requestPoolSize}');
    print('   Request reuse rate: ${(calcMixed.requestReuseRate * 100).toStringAsFixed(2)}%');
  } finally {
    calcMixed.dispose();
  }

  print('');
  print('=' * 70);
  print('Analysis');
  print('=' * 70);
  print('');
  print('Phase 2 Optimizations Applied:');
  print('  1. Thread-local response buffer pooling (Rust)');
  print('  2. Request object pooling (Dart)');
  print('  3. BinaryOp object pooling (Dart)');
  print('');
  print('These optimizations eliminate repeated allocations of:');
  print('  - Vec<u8> for protobuf encoding (Rust side)');
  print('  - ComplexCalculationRequest objects (Dart side)');
  print('  - BinaryOp objects (Dart side)');
  print('');
}
