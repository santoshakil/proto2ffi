import 'dart:ffi' as ffi;
import 'dart:io';
import 'package:ffi/ffi.dart';
import '../generated.dart';

class FFIService {
  static FFIService? _instance;
  late final ffi.DynamicLibrary _lib;
  late final FFIBindings bindings;

  FFIService._() {
    _lib = _loadLibrary();
    bindings = FFIBindings(_lib);
  }

  factory FFIService() {
    _instance ??= FFIService._();
    return _instance!;
  }

  ffi.DynamicLibrary _loadLibrary() {
    const base = 'task_manager';
    if (Platform.isMacOS || Platform.isIOS) {
      return ffi.DynamicLibrary.open('rust/target/release/lib$base.dylib');
    } else if (Platform.isAndroid || Platform.isLinux) {
      return ffi.DynamicLibrary.open('rust/target/release/lib$base.so');
    } else if (Platform.isWindows) {
      return ffi.DynamicLibrary.open('rust/target/release/$base.dll');
    }
    throw UnsupportedError('Platform not supported');
  }

  int createTask(String title, String desc, int priority) {
    final task = Task.allocate();
    task.ref.title_str = title;
    task.ref.description_str = desc;
    task.ref.priority = priority;
    task.ref.completed = 0;
    task.ref.id = 0;
    task.ref.created_at = 0;
    task.ref.updated_at = 0;
    task.ref.tags = ffi.nullptr;

    final id = bindings.create_task(task);
    calloc.free(task);
    return id;
  }

  TaskData? getTask(int id) {
    final task = Task.allocate();
    final found = bindings.get_task(id, task);
    if (found == 0) {
      calloc.free(task);
      return null;
    }
    final data = TaskData.fromFFI(task.ref);
    calloc.free(task);
    return data;
  }

  bool updateTask(int id, String title, String desc, int priority, bool completed) {
    final task = Task.allocate();
    task.ref.id = id;
    task.ref.title_str = title;
    task.ref.description_str = desc;
    task.ref.priority = priority;
    task.ref.completed = completed ? 1 : 0;
    task.ref.tags = ffi.nullptr;

    final result = bindings.update_task(task);
    calloc.free(task);
    return result != 0;
  }

  bool deleteTask(int id) {
    return bindings.delete_task(id) != 0;
  }

  List<TaskData> listTasks({bool? completed, int? minPriority, int? maxPriority}) {
    final filter = TaskFilter.allocate();
    filter.ref.filter_by_completed = completed != null ? 1 : 0;
    filter.ref.completed_value = completed == true ? 1 : 0;
    filter.ref.filter_by_priority = (minPriority != null || maxPriority != null) ? 1 : 0;
    filter.ref.min_priority = minPriority ?? 0;
    filter.ref.max_priority = maxPriority ?? 10;
    filter.ref.tags = ffi.nullptr;

    final outPtr = calloc<ffi.Pointer<Task>>();
    final outLen = calloc<ffi.Size>();

    bindings.list_tasks(filter, outPtr, outLen);

    final len = outLen.value;
    final tasks = <TaskData>[];

    if (len > 0 && outPtr.value != ffi.nullptr) {
      for (var i = 0; i < len; i++) {
        final taskPtr = outPtr.value + i;
        tasks.add(TaskData.fromFFI(taskPtr.ref));
      }
      bindings.free_task_list(outPtr.value, len);
    }

    calloc.free(filter);
    calloc.free(outPtr);
    calloc.free(outLen);

    return tasks;
  }

  StatsData getStatistics() {
    final stats = TaskStats.allocate();
    bindings.get_statistics(stats);
    final data = StatsData.fromFFI(stats.ref);
    calloc.free(stats);
    return data;
  }

  PerformanceData getPerformanceMetrics() {
    final metrics = PerformanceMetrics.allocate();
    bindings.get_performance_metrics(metrics);
    final data = PerformanceData.fromFFI(metrics.ref);
    calloc.free(metrics);
    return data;
  }

  int clearAllTasks() {
    return bindings.clear_all_tasks();
  }

  int compactMemory() {
    return bindings.compact_memory();
  }
}

class FFIBindings {
  final ffi.DynamicLibrary _lib;

  FFIBindings(this._lib);

  late final create_task = _lib.lookupFunction<
      ffi.Uint64 Function(ffi.Pointer<Task>),
      int Function(ffi.Pointer<Task>)>('create_task');

  late final get_task = _lib.lookupFunction<
      ffi.Uint8 Function(ffi.Uint64, ffi.Pointer<Task>),
      int Function(int, ffi.Pointer<Task>)>('get_task');

  late final update_task = _lib.lookupFunction<
      ffi.Uint8 Function(ffi.Pointer<Task>),
      int Function(ffi.Pointer<Task>)>('update_task');

  late final delete_task = _lib.lookupFunction<
      ffi.Uint8 Function(ffi.Uint64),
      int Function(int)>('delete_task');

  late final list_tasks = _lib.lookupFunction<
      ffi.Void Function(ffi.Pointer<TaskFilter>, ffi.Pointer<ffi.Pointer<Task>>, ffi.Pointer<ffi.Size>),
      void Function(ffi.Pointer<TaskFilter>, ffi.Pointer<ffi.Pointer<Task>>, ffi.Pointer<ffi.Size>)>('list_tasks');

  late final get_statistics = _lib.lookupFunction<
      ffi.Void Function(ffi.Pointer<TaskStats>),
      void Function(ffi.Pointer<TaskStats>)>('get_statistics');

  late final get_performance_metrics = _lib.lookupFunction<
      ffi.Void Function(ffi.Pointer<PerformanceMetrics>),
      void Function(ffi.Pointer<PerformanceMetrics>)>('get_performance_metrics');

  late final clear_all_tasks = _lib.lookupFunction<
      ffi.Uint64 Function(),
      int Function()>('clear_all_tasks');

  late final compact_memory = _lib.lookupFunction<
      ffi.Uint64 Function(),
      int Function()>('compact_memory');

  late final free_task_list = _lib.lookupFunction<
      ffi.Void Function(ffi.Pointer<Task>, ffi.Size),
      void Function(ffi.Pointer<Task>, int)>('free_task_list');
}

class TaskData {
  final int id;
  final String title;
  final String description;
  final int priority;
  final bool completed;
  final int createdAt;
  final int updatedAt;

  TaskData({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.completed,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TaskData.fromFFI(Task task) {
    return TaskData(
      id: task.id,
      title: task.title_str,
      description: task.description_str,
      priority: task.priority,
      completed: task.completed != 0,
      createdAt: task.created_at,
      updatedAt: task.updated_at,
    );
  }
}

class StatsData {
  final int totalTasks;
  final int completedTasks;
  final int pendingTasks;
  final int highPriorityTasks;
  final double completionRate;
  final int avgCompletionTimeMs;
  final int totalMemoryUsed;
  final int poolAllocations;

  StatsData({
    required this.totalTasks,
    required this.completedTasks,
    required this.pendingTasks,
    required this.highPriorityTasks,
    required this.completionRate,
    required this.avgCompletionTimeMs,
    required this.totalMemoryUsed,
    required this.poolAllocations,
  });

  factory StatsData.fromFFI(TaskStats stats) {
    return StatsData(
      totalTasks: stats.total_tasks,
      completedTasks: stats.completed_tasks,
      pendingTasks: stats.pending_tasks,
      highPriorityTasks: stats.high_priority_tasks,
      completionRate: stats.completion_rate,
      avgCompletionTimeMs: stats.avg_completion_time_ms,
      totalMemoryUsed: stats.total_memory_used,
      poolAllocations: stats.pool_allocations,
    );
  }
}

class PerformanceData {
  final int memoryAllocatedBytes;
  final int poolHits;
  final int poolMisses;

  PerformanceData({
    required this.memoryAllocatedBytes,
    required this.poolHits,
    required this.poolMisses,
  });

  factory PerformanceData.fromFFI(PerformanceMetrics metrics) {
    return PerformanceData(
      memoryAllocatedBytes: metrics.memory_allocated_bytes,
      poolHits: metrics.pool_hits,
      poolMisses: metrics.pool_misses,
    );
  }

  double get hitRate {
    final total = poolHits + poolMisses;
    if (total == 0) return 0.0;
    return (poolHits / total) * 100.0;
  }
}
