import 'dart:async';
import 'dart:isolate';
import 'package:test/test.dart';
import '../lib/bindings.dart';

void isolateWorker(SendPort sendPort) {
  final receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);

  receivePort.listen((msg) {
    if (msg is Map) {
      final type = msg['type'] as String;
      final iterations = msg['iterations'] as int;
      final isolateId = msg['isolateId'] as int;

      var successCount = 0;
      var errorCount = 0;

      for (var i = 0; i < iterations; i++) {
        try {
          switch (type) {
            case 'small':
              final elapsed = concurrentTestSmallPool(1, 10);
              if (elapsed > 0) successCount++;
              break;
            case 'medium':
              final elapsed = concurrentTestMediumPool(1, 10);
              if (elapsed > 0) successCount++;
              break;
            case 'large':
              final elapsed = concurrentTestLargePool(1, 5);
              if (elapsed > 0) successCount++;
              break;
            case 'stress':
              final ops = stressTestRapidAllocFree(1, 100);
              if (ops > 0) successCount++;
              break;
          }
        } catch (e) {
          errorCount++;
        }
      }

      sendPort.send({
        'isolateId': isolateId,
        'successCount': successCount,
        'errorCount': errorCount,
      });
    }
  });
}

Future<List<Map<String, dynamic>>> runIsolateTest(String type, int isolateCount, int iterationsPerIsolate) async {
  final results = <Map<String, dynamic>>[];
  final futures = <Future>[];

  for (var i = 0; i < isolateCount; i++) {
    final completer = Completer<Map<String, dynamic>>();
    futures.add(completer.future);

    final receivePort = ReceivePort();
    final isolate = await Isolate.spawn(isolateWorker, receivePort.sendPort);

    receivePort.listen((msg) {
      if (msg is SendPort) {
        msg.send({
          'type': type,
          'iterations': iterationsPerIsolate,
          'isolateId': i,
        });
      } else if (msg is Map<String, dynamic>) {
        completer.complete(msg);
        receivePort.close();
        isolate.kill();
      }
    });
  }

  results.addAll(await Future.wait(futures.cast<Future<Map<String, dynamic>>>()));
  return results;
}

void main() {
  group('Rust Native Thread Tests', () {
    test('concurrent small pool - 4 threads', () {
      final elapsed = concurrentTestSmallPool(4, 100);
      print('Small pool (4 threads, 100 ops): $elapsed ms');
      expect(elapsed, greaterThan(0));
    });

    test('concurrent medium pool - 4 threads', () {
      final elapsed = concurrentTestMediumPool(4, 100);
      print('Medium pool (4 threads, 100 ops): $elapsed ms');
      expect(elapsed, greaterThan(0));
    });

    test('concurrent large pool - 4 threads', () {
      final elapsed = concurrentTestLargePool(4, 50);
      print('Large pool (4 threads, 50 ops): $elapsed ms');
      expect(elapsed, greaterThan(0));
    });

    test('stress test - 10 threads', () {
      final ops = stressTestRapidAllocFree(10, 1000);
      print('Stress test (10 threads, 1000ms): $ops ops');
      expect(ops, greaterThan(0));
    });

    test('stress test - 20 threads', () {
      final ops = stressTestRapidAllocFree(20, 1000);
      print('Stress test (20 threads, 1000ms): $ops ops');
      expect(ops, greaterThan(0));
    });

    test('extreme concurrency - 50 threads', () {
      final ops = stressTestRapidAllocFree(50, 2000);
      print('Extreme concurrency (50 threads, 2000ms): $ops ops');
      expect(ops, greaterThan(0));
    });

    test('pool exhaustion test', () {
      final exhausted = testPoolExhaustion(100);
      print('Pool exhaustion: growth occurred = $exhausted');
    });

    test('free list integrity - 1000 iterations', () {
      final valid = testFreeListIntegrity(1000);
      print('Free list integrity (1000 iterations): $valid');
      expect(valid, isTrue);
    });

    test('free list integrity - 10000 iterations', () {
      final valid = testFreeListIntegrity(10000);
      print('Free list integrity (10000 iterations): $valid');
      expect(valid, isTrue);
    });

    test('mixed operations - 8 threads', () {
      final elapsed = concurrentTestMixedOperations(8, 500);
      print('Mixed operations (8 threads, 500 ops): $elapsed ms');
      expect(elapsed, greaterThan(0));
    });

    test('contention measurement', () {
      final shared = measureContention(10, true);
      final isolated = measureContention(10, false);
      final ratio = shared / isolated;
      print('Contention - shared: $shared us, isolated: $isolated us');
      print('Contention ratio: ${ratio.toStringAsFixed(2)}x');
      expect(shared, greaterThan(0));
      expect(isolated, greaterThan(0));
    });
  });

  group('Dart Isolate Tests', () {
    test('isolate concurrent small pool - 4 isolates', () async {
      final results = await runIsolateTest('small', 4, 10);
      var totalSuccess = 0;
      var totalErrors = 0;

      for (final result in results) {
        totalSuccess += result['successCount'] as int;
        totalErrors += result['errorCount'] as int;
        print('Isolate ${result['isolateId']}: ${result['successCount']} success, ${result['errorCount']} errors');
      }

      print('Total: $totalSuccess success, $totalErrors errors');
      expect(totalSuccess, greaterThan(0));
    });

    test('isolate concurrent medium pool - 4 isolates', () async {
      final results = await runIsolateTest('medium', 4, 10);
      var totalSuccess = 0;
      var totalErrors = 0;

      for (final result in results) {
        totalSuccess += result['successCount'] as int;
        totalErrors += result['errorCount'] as int;
        print('Isolate ${result['isolateId']}: ${result['successCount']} success, ${result['errorCount']} errors');
      }

      print('Total: $totalSuccess success, $totalErrors errors');
      expect(totalSuccess, greaterThan(0));
    });

    test('isolate concurrent large pool - 4 isolates', () async {
      final results = await runIsolateTest('large', 4, 5);
      var totalSuccess = 0;
      var totalErrors = 0;

      for (final result in results) {
        totalSuccess += result['successCount'] as int;
        totalErrors += result['errorCount'] as int;
        print('Isolate ${result['isolateId']}: ${result['successCount']} success, ${result['errorCount']} errors');
      }

      print('Total: $totalSuccess success, $totalErrors errors');
      expect(totalSuccess, greaterThan(0));
    });

    test('isolate stress test - 8 isolates', () async {
      final results = await runIsolateTest('stress', 8, 5);
      var totalSuccess = 0;
      var totalErrors = 0;

      for (final result in results) {
        totalSuccess += result['successCount'] as int;
        totalErrors += result['errorCount'] as int;
        print('Isolate ${result['isolateId']}: ${result['successCount']} success, ${result['errorCount']} errors');
      }

      print('Total: $totalSuccess success, $totalErrors errors');
      expect(totalSuccess, greaterThan(0));
    });
  });

  group('Rapid Allocation/Deallocation Tests', () {
    test('rapid small pool ops - sequential', () {
      final start = DateTime.now();
      for (var i = 0; i < 100; i++) {
        concurrentTestSmallPool(1, 10);
      }
      final elapsed = DateTime.now().difference(start).inMilliseconds;
      print('Rapid sequential (100 iterations): $elapsed ms');
      expect(elapsed, greaterThan(0));
    });

    test('rapid stress test - bursts', () {
      final totalOps = <int>[];
      for (var i = 0; i < 10; i++) {
        final ops = stressTestRapidAllocFree(5, 200);
        totalOps.add(ops);
      }
      final total = totalOps.reduce((a, b) => a + b);
      final avg = total / totalOps.length;
      print('Burst test (10 bursts, 5 threads, 200ms each): avg $avg ops/burst');
      expect(total, greaterThan(0));
    });
  });

  group('Memory Corruption Detection', () {
    test('verify integrity after heavy load', () {
      stressTestRapidAllocFree(20, 1000);

      final valid = testFreeListIntegrity(1000);
      print('Integrity after heavy load: $valid');
      expect(valid, isTrue);
    });

    test('verify integrity after mixed operations', () {
      concurrentTestMixedOperations(10, 500);

      final valid = testFreeListIntegrity(1000);
      print('Integrity after mixed ops: $valid');
      expect(valid, isTrue);
    });

    test('verify integrity after exhaustion', () {
      testPoolExhaustion(100);

      final valid = testFreeListIntegrity(1000);
      print('Integrity after exhaustion: $valid');
      expect(valid, isTrue);
    });
  });

  group('Pool Statistics Under Load', () {
    test('compare different pool sizes under same load', () {
      final small = concurrentTestSmallPool(8, 100);
      final medium = concurrentTestMediumPool(8, 100);
      final large = concurrentTestLargePool(8, 100);

      print('Performance comparison (8 threads, 100 ops):');
      print('  Small pool: $small ms');
      print('  Medium pool: $medium ms');
      print('  Large pool: $large ms');

      expect(small, greaterThan(0));
      expect(medium, greaterThan(0));
      expect(large, greaterThan(0));
    });

    test('scalability test - increasing thread count', () {
      final results = <int, int>{};

      for (final threads in [1, 2, 4, 8, 16, 32]) {
        final elapsed = concurrentTestSmallPool(threads, 100);
        results[threads] = elapsed;
        print('$threads threads: $elapsed ms');
      }

      expect(results.values.every((v) => v > 0), isTrue);
    });

    test('throughput test - operations per second', () {
      final threads = 10;
      final durationMs = 5000;

      final totalOps = stressTestRapidAllocFree(threads, durationMs);
      final opsPerSec = (totalOps / durationMs * 1000).toInt();

      print('Throughput: $opsPerSec ops/sec ($totalOps ops in ${durationMs}ms)');
      expect(opsPerSec, greaterThan(0));
    });
  });
}
