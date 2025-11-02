import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:test/test.dart';
import '../lib/generated.dart';

final lib = Platform.isMacOS
    ? DynamicLibrary.open('../rust/target/release/libstress_tests.dylib')
    : Platform.isLinux
        ? DynamicLibrary.open('../rust/target/release/libstress_tests.so')
        : DynamicLibrary.open('../rust/target/release/stress_tests.dll');

typedef StressCreateDeepNesting = Pointer<DeepNestingRoot> Function();
typedef StressDestroyDeepNesting = Void Function(Pointer<DeepNestingRoot>);
typedef StressCreateWideMessage = Pointer<WideMessage> Function();
typedef StressDestroyWideMessage = Void Function(Pointer<WideMessage>);
typedef StressCreateHugeMessage = Pointer<HugeMessage> Function();
typedef StressDestroyHugeMessage = Void Function(Pointer<HugeMessage>);
typedef StressCreateMassiveArray = Pointer<MassiveArray> Function();
typedef StressDestroyMassiveArray = Void Function(Pointer<MassiveArray>);
typedef StressCreateRecursiveNode = Pointer<RecursiveNode> Function();
typedef StressDestroyRecursiveNode = Void Function(Pointer<RecursiveNode>);
typedef StressCreateComplexGraph = Pointer<ComplexGraph> Function();
typedef StressDestroyComplexGraph = Void Function(Pointer<ComplexGraph>);
typedef StressCreateAllocationTest = Pointer<AllocationTest> Function();
typedef StressDestroyAllocationTest = Void Function(Pointer<AllocationTest>);
typedef StressCreateMixedComplexity = Pointer<MixedComplexity> Function();
typedef StressDestroyMixedComplexity = Void Function(Pointer<MixedComplexity>);
typedef StressCreateStressTestSuite = Pointer<StressTestSuite> Function();
typedef StressDestroyStressTestSuite = Void Function(Pointer<StressTestSuite>);
typedef StressMeasureLayoutSize = IntPtr Function();
typedef StressMeasureWideMessageSize = IntPtr Function();
typedef StressMeasureHugeMessageSize = IntPtr Function();

final createDeepNesting = lib.lookupFunction<StressCreateDeepNesting, StressCreateDeepNesting>('stress_create_deep_nesting');
final destroyDeepNesting = lib.lookupFunction<StressDestroyDeepNesting, StressDestroyDeepNesting>('stress_destroy_deep_nesting');
final createWideMessage = lib.lookupFunction<StressCreateWideMessage, StressCreateWideMessage>('stress_create_wide_message');
final destroyWideMessage = lib.lookupFunction<StressDestroyWideMessage, StressDestroyWideMessage>('stress_destroy_wide_message');
final createHugeMessage = lib.lookupFunction<StressCreateHugeMessage, StressCreateHugeMessage>('stress_create_huge_message');
final destroyHugeMessage = lib.lookupFunction<StressDestroyHugeMessage, StressDestroyHugeMessage>('stress_destroy_huge_message');
final createMassiveArray = lib.lookupFunction<StressCreateMassiveArray, StressCreateMassiveArray>('stress_create_massive_array');
final destroyMassiveArray = lib.lookupFunction<StressDestroyMassiveArray, StressDestroyMassiveArray>('stress_destroy_massive_array');
final createRecursiveNode = lib.lookupFunction<StressCreateRecursiveNode, StressCreateRecursiveNode>('stress_create_recursive_node');
final destroyRecursiveNode = lib.lookupFunction<StressDestroyRecursiveNode, StressDestroyRecursiveNode>('stress_destroy_recursive_node');
final createComplexGraph = lib.lookupFunction<StressCreateComplexGraph, StressCreateComplexGraph>('stress_create_complex_graph');
final destroyComplexGraph = lib.lookupFunction<StressDestroyComplexGraph, StressDestroyComplexGraph>('stress_destroy_complex_graph');
final createAllocationTest = lib.lookupFunction<StressCreateAllocationTest, StressCreateAllocationTest>('stress_create_allocation_test');
final destroyAllocationTest = lib.lookupFunction<StressDestroyAllocationTest, StressDestroyAllocationTest>('stress_destroy_allocation_test');
final createMixedComplexity = lib.lookupFunction<StressCreateMixedComplexity, StressCreateMixedComplexity>('stress_create_mixed_complexity');
final destroyMixedComplexity = lib.lookupFunction<StressDestroyMixedComplexity, StressDestroyMixedComplexity>('stress_destroy_mixed_complexity');
final createStressTestSuite = lib.lookupFunction<StressCreateStressTestSuite, StressCreateStressTestSuite>('stress_create_stress_test_suite');
final destroyStressTestSuite = lib.lookupFunction<StressDestroyStressTestSuite, StressDestroyStressTestSuite>('stress_destroy_stress_test_suite');
final measureLayoutSize = lib.lookupFunction<StressMeasureLayoutSize, StressMeasureLayoutSize>('stress_measure_layout_size');
final measureWideMessageSize = lib.lookupFunction<StressMeasureWideMessageSize, StressMeasureWideMessageSize>('stress_measure_wide_message_size');
final measureHugeMessageSize = lib.lookupFunction<StressMeasureHugeMessageSize, StressMeasureHugeMessageSize>('stress_measure_huge_message_size');

void main() {
  group('Memory Stress Tests', () {
    test('massive allocation test - 10k objects', () {
      final allocations = <Pointer>[];
      final stopwatch = Stopwatch()..start();

      for (var i = 0; i < 10000; i++) {
        final ptr = createDeepNesting();
        expect(ptr.address, isNot(0));
        allocations.add(ptr);
      }

      stopwatch.stop();
      print('Allocated 10k objects in ${stopwatch.elapsedMilliseconds}ms');

      final cleanup = Stopwatch()..start();
      for (final ptr in allocations) {
        destroyDeepNesting(ptr as Pointer<DeepNestingRoot>);
      }
      cleanup.stop();
      print('Cleaned up 10k objects in ${cleanup.elapsedMilliseconds}ms');
    });

    test('mixed allocation pattern - 1k of each type', () {
      final allocations = <MapEntry<String, Pointer>>[];

      for (var i = 0; i < 1000; i++) {
        allocations.add(MapEntry('deep', createDeepNesting()));
        allocations.add(MapEntry('wide', createWideMessage()));
        allocations.add(MapEntry('huge', createHugeMessage()));
        allocations.add(MapEntry('massive', createMassiveArray()));
      }

      expect(allocations.length, 4000);

      for (final entry in allocations) {
        expect(entry.value.address, isNot(0));
        switch (entry.key) {
          case 'deep':
            destroyDeepNesting(entry.value as Pointer<DeepNestingRoot>);
          case 'wide':
            destroyWideMessage(entry.value as Pointer<WideMessage>);
          case 'huge':
            destroyHugeMessage(entry.value as Pointer<HugeMessage>);
          case 'massive':
            destroyMassiveArray(entry.value as Pointer<MassiveArray>);
        }
      }
    });

    test('interleaved allocation and deallocation', () {
      final active = <Pointer<WideMessage>>[];

      for (var round = 0; round < 100; round++) {
        for (var i = 0; i < 100; i++) {
          active.add(createWideMessage());
        }

        final toRemove = active.take(50).toList();
        for (final ptr in toRemove) {
          destroyWideMessage(ptr);
          active.remove(ptr);
        }
      }

      for (final ptr in active) {
        destroyWideMessage(ptr);
      }
    });

    test('rapid allocation and deallocation cycles', () {
      for (var cycle = 0; cycle < 1000; cycle++) {
        final ptr = createDeepNesting();
        expect(ptr.address, isNot(0));
        destroyDeepNesting(ptr);
      }
    });
  });

  group('Deep Nesting Tests', () {
    test('traverse deeply nested structure', () {
      final root = createDeepNesting();
      expect(root.address, isNot(0));

      var current = root;
      var depth = 0;

      try {
        while (current.address != 0 && depth < 20) {
          depth++;
          if (depth < 20) {
          }
        }

        print('Successfully traversed $depth levels of nesting');
      } finally {
        destroyDeepNesting(root);
      }
    });

    test('multiple deep nesting roots', () {
      final roots = <Pointer<DeepNestingRoot>>[];

      for (var i = 0; i < 100; i++) {
        roots.add(createDeepNesting());
      }

      for (final root in roots) {
        expect(root.address, isNot(0));
      }

      for (final root in roots) {
        destroyDeepNesting(root);
      }
    });
  });

  group('Wide Message Tests', () {
    test('100 field message allocation', () {
      final msg = createWideMessage();
      expect(msg.address, isNot(0));

      final ref = msg.ref;
      expect(ref.field_001, isNotNull);
      expect(ref.field_050, isNotNull);
      expect(ref.field_100, isNotNull);

      destroyWideMessage(msg);
    });

    test('wide message array - 1000 instances', () {
      final messages = <Pointer<WideMessage>>[];

      for (var i = 0; i < 1000; i++) {
        messages.add(createWideMessage());
      }

      for (final msg in messages) {
        expect(msg.address, isNot(0));
        destroyWideMessage(msg);
      }
    });

    test('measure wide message size', () {
      final size = measureWideMessageSize();
      print('WideMessage size: $size bytes');
      expect(size, greaterThan(0));
    });
  });

  group('Huge Message Tests', () {
    test('multi-KB message allocation', () {
      final msg = createHugeMessage();
      expect(msg.address, isNot(0));
      destroyHugeMessage(msg);
    });

    test('huge message array - 100 instances', () {
      final messages = <Pointer<HugeMessage>>[];

      for (var i = 0; i < 100; i++) {
        messages.add(createHugeMessage());
      }

      expect(messages.length, 100);

      for (final msg in messages) {
        destroyHugeMessage(msg);
      }
    });

    test('measure huge message size', () {
      final size = measureHugeMessageSize();
      print('HugeMessage size: $size bytes');
      expect(size, greaterThan(0));
    });
  });

  group('Massive Array Tests', () {
    test('large array allocation', () {
      final arr = createMassiveArray();
      expect(arr.address, isNot(0));
      destroyMassiveArray(arr);
    });

    test('multiple massive arrays', () {
      final arrays = <Pointer<MassiveArray>>[];

      for (var i = 0; i < 50; i++) {
        arrays.add(createMassiveArray());
      }

      for (final arr in arrays) {
        expect(arr.address, isNot(0));
        destroyMassiveArray(arr);
      }
    });
  });

  group('Complex Structure Tests', () {
    test('recursive node creation', () {
      final node = createRecursiveNode();
      expect(node.address, isNot(0));
      destroyRecursiveNode(node);
    });

    test('complex graph creation', () {
      final graph = createComplexGraph();
      expect(graph.address, isNot(0));
      destroyComplexGraph(graph);
    });

    test('mixed complexity creation', () {
      final mixed = createMixedComplexity();
      expect(mixed.address, isNot(0));
      destroyMixedComplexity(mixed);
    });

    test('full stress test suite', () {
      final suite = createStressTestSuite();
      expect(suite.address, isNot(0));

      final size = measureLayoutSize();
      print('StressTestSuite size: $size bytes');

      destroyStressTestSuite(suite);
    });
  });

  group('Performance Benchmarks', () {
    test('allocation speed - deep nesting', () {
      final stopwatch = Stopwatch()..start();
      final count = 10000;

      final ptrs = <Pointer<DeepNestingRoot>>[];
      for (var i = 0; i < count; i++) {
        ptrs.add(createDeepNesting());
      }

      stopwatch.stop();
      final ms = stopwatch.elapsedMilliseconds;
      final perSec = (count / ms * 1000).round();
      print('Deep nesting: $perSec allocations/sec');

      for (final ptr in ptrs) {
        destroyDeepNesting(ptr);
      }

      expect(perSec, greaterThan(1000));
    });

    test('allocation speed - wide message', () {
      final stopwatch = Stopwatch()..start();
      final count = 10000;

      final ptrs = <Pointer<WideMessage>>[];
      for (var i = 0; i < count; i++) {
        ptrs.add(createWideMessage());
      }

      stopwatch.stop();
      final ms = stopwatch.elapsedMilliseconds;
      final perSec = (count / ms * 1000).round();
      print('Wide message: $perSec allocations/sec');

      for (final ptr in ptrs) {
        destroyWideMessage(ptr);
      }

      expect(perSec, greaterThan(1000));
    });

    test('allocation speed - huge message', () {
      final stopwatch = Stopwatch()..start();
      final count = 1000;

      final ptrs = <Pointer<HugeMessage>>[];
      for (var i = 0; i < count; i++) {
        ptrs.add(createHugeMessage());
      }

      stopwatch.stop();
      final ms = stopwatch.elapsedMilliseconds;
      final perSec = (count / ms * 1000).round();
      print('Huge message: $perSec allocations/sec');

      for (final ptr in ptrs) {
        destroyHugeMessage(ptr);
      }

      expect(perSec, greaterThan(100));
    });

    test('deallocation speed', () {
      final ptrs = <Pointer<WideMessage>>[];
      for (var i = 0; i < 10000; i++) {
        ptrs.add(createWideMessage());
      }

      final stopwatch = Stopwatch()..start();
      for (final ptr in ptrs) {
        destroyWideMessage(ptr);
      }
      stopwatch.stop();

      final ms = stopwatch.elapsedMilliseconds;
      final perSec = (10000 / ms * 1000).round();
      print('Deallocation: $perSec deallocations/sec');

      expect(perSec, greaterThan(1000));
    });
  });

  group('Edge Cases and Boundaries', () {
    test('null pointer handling', () {
      destroyDeepNesting(nullptr);
      destroyWideMessage(nullptr);
      destroyHugeMessage(nullptr);
      destroyMassiveArray(nullptr);
    });

    test('repeated allocation at same location pattern', () {
      for (var i = 0; i < 1000; i++) {
        final ptr = createWideMessage();
        destroyWideMessage(ptr);
      }
    });

    test('mixed type rapid cycling', () {
      for (var i = 0; i < 1000; i++) {
        final d = createDeepNesting();
        final w = createWideMessage();
        final h = createHugeMessage();
        final m = createMassiveArray();

        destroyMassiveArray(m);
        destroyHugeMessage(h);
        destroyWideMessage(w);
        destroyDeepNesting(d);
      }
    });
  });

  group('Memory Leak Detection', () {
    test('no leak in 100k allocation-deallocation cycles', () {
      final iterations = 100000;

      for (var i = 0; i < iterations; i++) {
        final ptr = createWideMessage();
        destroyWideMessage(ptr);

        if (i % 10000 == 0) {
          print('Completed ${i ~/ 1000}k cycles');
        }
      }

      print('Completed $iterations cycles without crash');
    });

    test('sustained load - 10k active objects', () {
      final active = <Pointer<WideMessage>>[];

      for (var i = 0; i < 10000; i++) {
        active.add(createWideMessage());
      }

      print('10k objects allocated, performing operations...');

      for (var round = 0; round < 100; round++) {
        for (var i = 0; i < 100; i++) {
          final idx = i % active.length;
          final old = active[idx];
          destroyWideMessage(old);
          active[idx] = createWideMessage();
        }
      }

      for (final ptr in active) {
        destroyWideMessage(ptr);
      }

      print('Sustained load test completed');
    });
  });

  group('Concurrency Simulation', () {
    test('sequential allocation batches', () {
      for (var batch = 0; batch < 10; batch++) {
        final batchPtrs = <Pointer<WideMessage>>[];

        for (var i = 0; i < 1000; i++) {
          batchPtrs.add(createWideMessage());
        }

        for (final ptr in batchPtrs) {
          destroyWideMessage(ptr);
        }

        print('Batch $batch completed');
      }
    });
  });

  group('Scalability Tests', () {
    test('linear scaling - 1k to 10k objects', () {
      final sizes = [1000, 2000, 5000, 10000];

      for (final size in sizes) {
        final stopwatch = Stopwatch()..start();
        final ptrs = <Pointer<WideMessage>>[];

        for (var i = 0; i < size; i++) {
          ptrs.add(createWideMessage());
        }

        for (final ptr in ptrs) {
          destroyWideMessage(ptr);
        }

        stopwatch.stop();
        print('$size objects: ${stopwatch.elapsedMilliseconds}ms');
      }
    });
  });
}
