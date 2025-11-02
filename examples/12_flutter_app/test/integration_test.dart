import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager/services/ffi_service.dart';

void main() {
  late FFIService ffi;

  setUp(() {
    ffi = FFIService();
    ffi.clearAllTasks();
  });

  group('Integration Tests', () {
    test('complete workflow: create, update, complete, delete', () {
      final id = ffi.createTask('Buy groceries', 'Milk, eggs, bread', 5);
      expect(id, greaterThan(0));

      var task = ffi.getTask(id);
      expect(task, isNotNull);
      expect(task!.completed, isFalse);

      ffi.updateTask(id, 'Buy groceries', 'Milk, eggs, bread, cheese', 6, false);

      task = ffi.getTask(id);
      expect(task!.description, contains('cheese'));
      expect(task.priority, equals(6));

      ffi.updateTask(id, task.title, task.description, task.priority, true);

      task = ffi.getTask(id);
      expect(task!.completed, isTrue);

      final deleted = ffi.deleteTask(id);
      expect(deleted, isTrue);
      expect(ffi.getTask(id), isNull);
    });

    test('priority-based workflow', () {
      ffi.createTask('Low priority', 'Can wait', 2);
      ffi.createTask('Medium priority', 'Should do soon', 5);
      ffi.createTask('High priority', 'Urgent!', 9);

      final highPriority = ffi.listTasks(minPriority: 7);
      expect(highPriority.length, equals(1));
      expect(highPriority[0].priority, equals(9));

      final mediumPriority = ffi.listTasks(minPriority: 4, maxPriority: 6);
      expect(mediumPriority.length, equals(1));
      expect(mediumPriority[0].priority, equals(5));
    });

    test('batch operations with statistics tracking', () {
      final initialStats = ffi.getStatistics();
      expect(initialStats.totalTasks, equals(0));

      final ids = <int>[];
      for (var i = 0; i < 10; i++) {
        ids.add(ffi.createTask('Task $i', 'Batch task $i', 5 + (i % 5)));
      }

      var stats = ffi.getStatistics();
      expect(stats.totalTasks, equals(10));
      expect(stats.pendingTasks, equals(10));
      expect(stats.completionRate, equals(0.0));

      for (var i = 0; i < 5; i++) {
        final task = ffi.getTask(ids[i])!;
        ffi.updateTask(task.id, task.title, task.description, task.priority, true);
      }

      stats = ffi.getStatistics();
      expect(stats.completedTasks, equals(5));
      expect(stats.pendingTasks, equals(5));
      expect(stats.completionRate, closeTo(50.0, 0.1));

      for (final id in ids.skip(5)) {
        ffi.deleteTask(id);
      }

      stats = ffi.getStatistics();
      expect(stats.totalTasks, equals(5));
      expect(stats.completedTasks, equals(5));
      expect(stats.completionRate, equals(100.0));
    });

    test('memory management workflow', () {
      final initialPerf = ffi.getPerformanceMetrics();

      final ids = <int>[];
      for (var i = 0; i < 100; i++) {
        ids.add(ffi.createTask('Task $i', 'A' * 100, 5));
      }

      final afterCreate = ffi.getPerformanceMetrics();
      expect(afterCreate.memoryAllocatedBytes, greaterThan(initialPerf.memoryAllocatedBytes));

      for (final id in ids.take(50)) {
        ffi.deleteTask(id);
      }

      final beforeCompact = ffi.getPerformanceMetrics();

      final freed = ffi.compactMemory();

      final afterCompact = ffi.getPerformanceMetrics();
      expect(afterCompact.memoryAllocatedBytes, lessThanOrEqualTo(beforeCompact.memoryAllocatedBytes));

      final stats = ffi.getStatistics();
      expect(stats.totalTasks, equals(50));
    });

    test('realistic daily workflow simulation', () {
      ffi.createTask('Morning meeting', 'Standup at 9am', 7);
      ffi.createTask('Code review', 'Review PR #123', 6);
      ffi.createTask('Fix bug', 'Critical production issue', 10);
      ffi.createTask('Lunch break', 'Team lunch', 3);
      ffi.createTask('Write docs', 'Update README', 4);

      var stats = ffi.getStatistics();
      expect(stats.totalTasks, equals(5));
      expect(stats.highPriorityTasks, greaterThanOrEqualTo(2));

      final urgent = ffi.listTasks(minPriority: 7);
      expect(urgent.length, greaterThanOrEqualTo(2));

      for (final task in urgent) {
        ffi.updateTask(task.id, task.title, task.description, task.priority, true);
      }

      final completed = ffi.listTasks(completed: true);
      expect(completed.length, equals(urgent.length));

      final pending = ffi.listTasks(completed: false);
      expect(pending.length, equals(5 - urgent.length));

      stats = ffi.getStatistics();
      expect(stats.completedTasks, equals(urgent.length));
      expect(stats.pendingTasks, equals(5 - urgent.length));
    });

    test('concurrent-like operations', () {
      final batchSize = 50;
      final ids = <int>[];

      for (var i = 0; i < batchSize; i++) {
        ids.add(ffi.createTask('Batch Task $i', 'Description', i % 10));
      }

      final initialStats = ffi.getStatistics();
      expect(initialStats.totalTasks, equals(batchSize));

      for (var i = 0; i < batchSize; i += 2) {
        final task = ffi.getTask(ids[i])!;
        ffi.updateTask(task.id, task.title, task.description, task.priority, true);
      }

      for (var i = 1; i < batchSize; i += 2) {
        if (i % 4 == 1) {
          ffi.deleteTask(ids[i]);
        }
      }

      final finalStats = ffi.getStatistics();
      expect(finalStats.completedTasks, equals(batchSize ~/ 2));
      expect(finalStats.totalTasks, lessThan(batchSize));
    });
  });

  group('Memory Leak Detection', () {
    test('repeated create and delete cycles', () {
      final initialPerf = ffi.getPerformanceMetrics();

      for (var cycle = 0; cycle < 10; cycle++) {
        final ids = <int>[];
        for (var i = 0; i < 100; i++) {
          ids.add(ffi.createTask('Temp $i', 'Temporary task', 5));
        }

        for (final id in ids) {
          ffi.deleteTask(id);
        }

        ffi.compactMemory();
      }

      final finalPerf = ffi.getPerformanceMetrics();

      final memoryGrowth = finalPerf.memoryAllocatedBytes - initialPerf.memoryAllocatedBytes;
      expect(memoryGrowth, lessThan(100000));
    });

    test('repeated list operations do not leak', () {
      for (var i = 0; i < 10; i++) {
        ffi.createTask('Task $i', 'Description', 5);
      }

      final initialPerf = ffi.getPerformanceMetrics();

      for (var i = 0; i < 100; i++) {
        final tasks = ffi.listTasks();
        expect(tasks.length, equals(10));
      }

      final finalPerf = ffi.getPerformanceMetrics();

      expect(finalPerf.memoryAllocatedBytes, equals(initialPerf.memoryAllocatedBytes));
    });
  });
}
