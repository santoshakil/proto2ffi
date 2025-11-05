import 'package:dart_ffi_lib/dart_ffi_lib.dart';

void main() {
  print('=' * 70);
  print('Single Call Latency Benchmark (Cold Start)');
  print('=' * 70);
  print('');

  final calc = CalculatorImpl();

  try {
    print('Measuring individual call latencies...');
    print('');

    final operations = [
      ('ADD(10, 5)', () => calc.add(10, 5)),
      ('SUBTRACT(10, 5)', () => calc.subtract(10, 5)),
      ('MULTIPLY(10, 5)', () => calc.multiply(10, 5)),
      ('DIVIDE(10, 5)', () => calc.divide(10, 5)),
      ('DIVIDE(10, 0) - Error handling', () => calc.divide(10, 0)),
    ];

    for (final (name, op) in operations) {
      final sw = Stopwatch()..start();
      final result = op();
      sw.stop();

      print('$name:');
      print('  Result: $result');
      print('  Time:   ${sw.elapsedMicroseconds}µs (${sw.elapsedMicroseconds * 1000}ns)');
      print('');
    }

    print('─' * 70);
    print('Running 10 consecutive calls to see variation:');
    print('');

    final times = <int>[];
    for (var i = 0; i < 10; i++) {
      final sw = Stopwatch()..start();
      calc.add(10, 5);
      sw.stop();
      times.add(sw.elapsedMicroseconds);
    }

    print('ADD(10, 5) - 10 consecutive calls:');
    for (var i = 0; i < times.length; i++) {
      print('  Call ${i + 1}: ${times[i]}µs');
    }

    times.sort();
    final min = times.first;
    final max = times.last;
    final median = times[times.length ~/ 2];
    final avg = times.reduce((a, b) => a + b) / times.length;

    print('');
    print('Statistics:');
    print('  Min:    ${min}µs');
    print('  Max:    ${max}µs');
    print('  Median: ${median}µs');
    print('  Avg:    ${avg.toStringAsFixed(2)}µs');
    print('  Range:  ${max - min}µs');

    print('');
    print('=' * 70);
  } finally {
    calc.dispose();
  }
}
