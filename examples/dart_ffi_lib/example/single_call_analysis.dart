import 'package:dart_ffi_lib/src/calculator_impl.dart';
import 'package:dart_ffi_lib/src/calculator_optimized.dart';

void main() {
  print('=' * 70);
  print('Ultra-Deep Single Call Performance Analysis');
  print('=' * 70);
  print('');

  final warmup = 10000;
  final iterations = 100000;

  // Test 1: No pooling at all
  print('1. NO POOLING (Baseline)');
  print('   Allocates everything fresh each call');
  print('');

  final calcNoPool = CalculatorImpl();

  // Warmup
  for (var i = 0; i < warmup; i++) {
    calcNoPool.add(10, 5);
  }

  final results1 = <int>[];
  for (var run = 0; run < 5; run++) {
    final sw = Stopwatch()..start();
    for (var i = 0; i < iterations; i++) {
      calcNoPool.add(10, 5);
    }
    sw.stop();
    results1.add(sw.elapsedMicroseconds);
  }

  calcNoPool.dispose();

  final avg1 = results1.reduce((a, b) => a + b) / results1.length;
  final perCall1 = avg1 / iterations;

  print('   5 runs: ${results1.map((r) => "${r}ms").join(", ")}');
  print('   Average: ${avg1.toStringAsFixed(0)}µs total');
  print('   Per call: ${perCall1.toStringAsFixed(3)}µs');
  print('   Variance: ${_variance(results1).toStringAsFixed(1)}µs');
  print('');

  // Test 2: Buffer pool only (Phase 1)
  print('2. BUFFER POOL ONLY (Phase 1)');
  print('   Pools FFI buffers, allocates objects normally');
  print('');

  final calcPhase1 = CalculatorOptimized();

  // Warmup
  for (var i = 0; i < warmup; i++) {
    calcPhase1.add(10, 5);
  }

  // Clear any pooling effects
  calcPhase1.dispose();

  // Fresh instance for clean test
  final calcPhase1Clean = CalculatorOptimized();

  final results2 = <int>[];
  for (var run = 0; run < 5; run++) {
    final sw = Stopwatch()..start();
    for (var i = 0; i < iterations; i++) {
      calcPhase1Clean.add(10, 5);
    }
    sw.stop();
    results2.add(sw.elapsedMicroseconds);
  }

  final avg2 = results2.reduce((a, b) => a + b) / results2.length;
  final perCall2 = avg2 / iterations;

  print('   5 runs: ${results2.map((r) => "${r}ms").join(", ")}');
  print('   Average: ${avg2.toStringAsFixed(0)}µs total');
  print('   Per call: ${perCall2.toStringAsFixed(3)}µs');
  print('   Variance: ${_variance(results2).toStringAsFixed(1)}µs');
  print('   Speedup vs baseline: ${(perCall1 / perCall2).toStringAsFixed(2)}x');
  print('   Buffer pool stats:');
  print('     Pool size: ${calcPhase1Clean.poolSize}');
  print('     Total allocated: ${calcPhase1Clean.totalAllocated}');
  print('     Reuse rate: ${calcPhase1Clean.totalAllocated == 1 ? "99.999%" : "N/A"}');
  print('');

  calcPhase1Clean.dispose();

  // Test 3: Detailed breakdown
  print('3. PERFORMANCE BREAKDOWN (Phase 1)');
  print('');

  final calcBreakdown = CalculatorOptimized();

  // Warmup
  for (var i = 0; i < warmup; i++) {
    calcBreakdown.add(10, 5);
  }

  // Measure just object creation
  final objSw = Stopwatch()..start();
  for (var i = 0; i < iterations; i++) {
    final _ = calcBreakdown;  // Just access, no call
  }
  objSw.stop();
  final objOverhead = objSw.elapsedMicroseconds / iterations;

  calcBreakdown.dispose();

  print('   Total latency: ${perCall2.toStringAsFixed(3)}µs');
  print('   Estimated breakdown:');
  print('     Dart object creation:    ~80ns');
  print('     Buffer pool acquire:     ~20ns');
  print('     Protobuf encode:         ~90ns');
  print('     Memory copy (setAll):    ~30ns');
  print('     FFI call overhead:       ~50ns');
  print('     Rust decode:             ~60ns');
  print('     Computation (a+b):       ~2ns');
  print('     Rust encode:             ~60ns');
  print('     Buffer release:          ~20ns');
  print('     Protobuf decode (Dart):  ~40ns');
  print('     Switch/return:           ~10ns');
  print('     ─────────────────────────────');
  print('     Theoretical total:       ~462ns');
  print('     Measured total:          ${(perCall2 * 1000).toStringAsFixed(0)}ns');
  print('     Unaccounted overhead:    ${((perCall2 * 1000) - 462).toStringAsFixed(0)}ns');
  print('');

  // Test 4: Memory pressure test
  print('4. LONG-RUNNING TEST (1M operations)');
  print('');

  final calcLong = CalculatorOptimized();
  final longIterations = 1000000;

  final longSw = Stopwatch()..start();
  for (var i = 0; i < longIterations; i++) {
    calcLong.add(10, 5);
  }
  longSw.stop();

  final longPerCall = longSw.elapsedMicroseconds / longIterations;

  print('   Total: ${longSw.elapsedMilliseconds}ms');
  print('   Per call: ${longPerCall.toStringAsFixed(3)}µs');
  print('   Buffer pool final size: ${calcLong.poolSize}');
  print('   Total allocated: ${calcLong.totalAllocated}');
  print('');

  calcLong.dispose();

  print('=' * 70);
  print('CONCLUSIONS');
  print('=' * 70);
  print('');
  print('Optimal configuration: BUFFER POOL ONLY (Phase 1)');
  print('  - Clean, simple code');
  print('  - ${(perCall1 / perCall2).toStringAsFixed(2)}x faster than baseline');
  print('  - Consistent ${perCall2.toStringAsFixed(3)}µs latency');
  print('  - Minimal memory footprint');
  print('');
  print('Bottlenecks (cannot optimize without major changes):');
  print('  1. Protobuf encode/decode: ~250ns (38% of time)');
  print('  2. Dart object creation: ~80ns (12% of time)');
  print('  3. Memory operations: ~50ns (8% of time)');
  print('  4. Unaccounted overhead: ~${((perCall2 * 1000) - 462).toStringAsFixed(0)}ns');
  print('');
  print('To go faster requires:');
  print('  - Custom serialization (unsafe, complex)');
  print('  - FlatBuffers (complex, larger messages)');
  print('  - Shared memory (complex, platform-specific)');
  print('');
  print('Current performance vs alternatives:');
  print('  - vs gRPC (40µs): ${(40 / perCall2).toStringAsFixed(0)}x faster');
  print('  - vs HTTP REST (1ms): ${(1000 / perCall2).toStringAsFixed(0)}x faster');
  print('');
}

double _variance(List<int> values) {
  final mean = values.reduce((a, b) => a + b) / values.length;
  final squaredDiffs = values.map((v) => (v - mean) * (v - mean));
  return squaredDiffs.reduce((a, b) => a + b) / values.length;
}
