import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager/services/ffi_service.dart';

void main() {
  late FFIService ffi;

  setUp(() {
    ffi = FFIService();
    ffi.clearAllTasks();
  });

  group('Task CRUD Operations', () {
    test('create task returns valid ID', () {
      final id = ffi.createTask('Test Task', 'Description', 5);
      expect(id, greaterThan(0));
    });

    test('get task returns created task', () {
      final id = ffi.createTask('Test Task', 'Test Desc', 7);
      final task = ffi.getTask(id);

      expect(task, isNotNull);
      expect(task!.id, equals(id));
      expect(task.title, equals('Test Task'));
      expect(task.description, equals('Test Desc'));
      expect(task.priority, equals(7));
      expect(task.completed, isFalse);
    });

    test('update task modifies existing task', () {
      final id = ffi.createTask('Original', 'Desc', 5);
      final updated = ffi.updateTask(id, 'Updated', 'New Desc', 8, true);

      expect(updated, isTrue);

      final task = ffi.getTask(id);
      expect(task!.title, equals('Updated'));
      expect(task.description, equals('New Desc'));
      expect(task.priority, equals(8));
      expect(task.completed, isTrue);
    });

    test('delete task removes task', () {
      final id = ffi.createTask('To Delete', 'Desc', 5);
      final deleted = ffi.deleteTask(id);

      expect(deleted, isTrue);
      expect(ffi.getTask(id), isNull);
    });

    test('get non-existent task returns null', () {
      expect(ffi.getTask(99999), isNull);
    });
  });

  group('Task Listing and Filtering', () {
    setUp(() {
      ffi.createTask('Task 1', 'Low priority', 2);
      ffi.createTask('Task 2', 'High priority', 9);
      ffi.createTask('Task 3', 'Medium priority', 5);
    });

    test('list all tasks', () {
      final tasks = ffi.listTasks();
      expect(tasks.length, equals(3));
    });

    test('filter by completed status', () {
      final id = ffi.createTask('Completed Task', 'Done', 5);
      ffi.updateTask(id, 'Completed Task', 'Done', 5, true);

      final completed = ffi.listTasks(completed: true);
      expect(completed.length, equals(1));
      expect(completed[0].completed, isTrue);

      final pending = ffi.listTasks(completed: false);
      expect(pending.length, equals(3));
    });

    test('filter by priority range', () {
      final highPriority = ffi.listTasks(minPriority: 7, maxPriority: 10);
      expect(highPriority.length, equals(1));
      expect(highPriority[0].priority, greaterThanOrEqualTo(7));
    });
  });

  group('Statistics', () {
    test('statistics reflect task state', () {
      ffi.createTask('Task 1', 'Desc', 5);
      ffi.createTask('Task 2', 'Desc', 9);

      final stats = ffi.getStatistics();
      expect(stats.totalTasks, equals(2));
      expect(stats.completedTasks, equals(0));
      expect(stats.pendingTasks, equals(2));
      expect(stats.highPriorityTasks, greaterThanOrEqualTo(1));
    });

    test('completion rate calculation', () {
      final id1 = ffi.createTask('Task 1', 'Desc', 5);
      ffi.createTask('Task 2', 'Desc', 5);

      ffi.updateTask(id1, 'Task 1', 'Desc', 5, true);

      final stats = ffi.getStatistics();
      expect(stats.completionRate, closeTo(50.0, 0.1));
    });
  });

  group('Performance Metrics', () {
    test('memory usage increases with tasks', () {
      final before = ffi.getPerformanceMetrics();

      for (var i = 0; i < 10; i++) {
        ffi.createTask('Task $i', 'Description $i', 5);
      }

      final after = ffi.getPerformanceMetrics();
      expect(after.memoryAllocatedBytes, greaterThan(before.memoryAllocatedBytes));
    });

    test('pool hit rate is calculated', () {
      for (var i = 0; i < 10; i++) {
        ffi.createTask('Task $i', 'Desc', 5);
      }

      final perf = ffi.getPerformanceMetrics();
      expect(perf.poolHits + perf.poolMisses, greaterThan(0));
      expect(perf.hitRate, greaterThanOrEqualTo(0.0));
      expect(perf.hitRate, lessThanOrEqualTo(100.0));
    });
  });

  group('Memory Management', () {
    test('clear all tasks resets store', () {
      ffi.createTask('Task 1', 'Desc', 5);
      ffi.createTask('Task 2', 'Desc', 5);

      final cleared = ffi.clearAllTasks();
      expect(cleared, equals(2));

      final stats = ffi.getStatistics();
      expect(stats.totalTasks, equals(0));
    });

    test('compact memory reduces usage', () {
      for (var i = 0; i < 100; i++) {
        ffi.createTask('Task $i', 'Description', 5);
      }

      ffi.clearAllTasks();

      final before = ffi.getPerformanceMetrics().memoryAllocatedBytes;
      final freed = ffi.compactMemory();
      final after = ffi.getPerformanceMetrics().memoryAllocatedBytes;

      expect(after, lessThanOrEqualTo(before));
    });
  });

  group('Edge Cases', () {
    test('empty title and description', () {
      final id = ffi.createTask('', '', 5);
      final task = ffi.getTask(id);

      expect(task, isNotNull);
      expect(task!.title, isEmpty);
      expect(task.description, isEmpty);
    });

    test('max priority value', () {
      final id = ffi.createTask('Max Priority', 'Desc', 10);
      final task = ffi.getTask(id);

      expect(task!.priority, equals(10));
    });

    test('min priority value', () {
      final id = ffi.createTask('Min Priority', 'Desc', 0);
      final task = ffi.getTask(id);

      expect(task!.priority, equals(0));
    });

    test('very long strings are truncated', () {
      final longTitle = 'A' * 300;
      final longDesc = 'B' * 300;

      final id = ffi.createTask(longTitle, longDesc, 5);
      final task = ffi.getTask(id);

      expect(task!.title.length, lessThanOrEqualTo(255));
      expect(task.description.length, lessThanOrEqualTo(255));
    });
  });

  group('Performance Tests', () {
    test('create 1000 tasks', () {
      final sw = Stopwatch()..start();

      for (var i = 0; i < 1000; i++) {
        ffi.createTask('Task $i', 'Description $i', i % 10);
      }

      sw.stop();
      print('Created 1000 tasks in ${sw.elapsedMilliseconds}ms');

      final stats = ffi.getStatistics();
      expect(stats.totalTasks, equals(1000));
      expect(sw.elapsedMilliseconds, lessThan(1000));
    });

    test('list 1000 tasks', () {
      for (var i = 0; i < 1000; i++) {
        ffi.createTask('Task $i', 'Description $i', i % 10);
      }

      final sw = Stopwatch()..start();
      final tasks = ffi.listTasks();
      sw.stop();

      print('Listed 1000 tasks in ${sw.elapsedMilliseconds}ms');
      expect(tasks.length, equals(1000));
      expect(sw.elapsedMilliseconds, lessThan(100));
    });

    test('update 1000 tasks', () {
      final ids = <int>[];
      for (var i = 0; i < 1000; i++) {
        ids.add(ffi.createTask('Task $i', 'Description $i', 5));
      }

      final sw = Stopwatch()..start();
      for (final id in ids) {
        ffi.updateTask(id, 'Updated', 'New Desc', 7, true);
      }
      sw.stop();

      print('Updated 1000 tasks in ${sw.elapsedMilliseconds}ms');
      expect(sw.elapsedMilliseconds, lessThan(1000));
    });

    test('delete 1000 tasks', () {
      final ids = <int>[];
      for (var i = 0; i < 1000; i++) {
        ids.add(ffi.createTask('Task $i', 'Description $i', 5));
      }

      final sw = Stopwatch()..start();
      for (final id in ids) {
        ffi.deleteTask(id);
      }
      sw.stop();

      print('Deleted 1000 tasks in ${sw.elapsedMilliseconds}ms');
      expect(sw.elapsedMilliseconds, lessThan(1000));
    });
  });
}
