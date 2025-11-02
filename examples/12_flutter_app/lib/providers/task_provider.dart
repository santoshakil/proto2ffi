import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/ffi_service.dart';

final ffiServiceProvider = Provider<FFIService>((ref) => FFIService());

final tasksProvider = StateNotifierProvider<TasksNotifier, List<TaskData>>((ref) {
  return TasksNotifier(ref.watch(ffiServiceProvider));
});

final statsProvider = StateNotifierProvider<StatsNotifier, StatsData>((ref) {
  return StatsNotifier(ref.watch(ffiServiceProvider));
});

final performanceProvider = StateNotifierProvider<PerformanceNotifier, PerformanceData>((ref) {
  return PerformanceNotifier(ref.watch(ffiServiceProvider));
});

final filterCompletedProvider = StateProvider<bool?>((ref) => null);
final filterPriorityProvider = StateProvider<int?>((ref) => null);

class TasksNotifier extends StateNotifier<List<TaskData>> {
  final FFIService _ffi;

  TasksNotifier(this._ffi) : super([]) {
    loadTasks();
  }

  void loadTasks({bool? completed, int? minPriority, int? maxPriority}) {
    state = _ffi.listTasks(
      completed: completed,
      minPriority: minPriority,
      maxPriority: maxPriority,
    );
  }

  Future<void> createTask(String title, String desc, int priority) async {
    _ffi.createTask(title, desc, priority);
    loadTasks();
  }

  Future<void> updateTask(int id, String title, String desc, int priority, bool completed) async {
    _ffi.updateTask(id, title, desc, priority, completed);
    loadTasks();
  }

  Future<void> deleteTask(int id) async {
    _ffi.deleteTask(id);
    loadTasks();
  }

  Future<void> toggleCompleted(int id) async {
    final task = _ffi.getTask(id);
    if (task != null) {
      _ffi.updateTask(id, task.title, task.description, task.priority, !task.completed);
      loadTasks();
    }
  }

  Future<void> clearAll() async {
    _ffi.clearAllTasks();
    loadTasks();
  }
}

class StatsNotifier extends StateNotifier<StatsData> {
  final FFIService _ffi;

  StatsNotifier(this._ffi)
      : super(StatsData(
          totalTasks: 0,
          completedTasks: 0,
          pendingTasks: 0,
          highPriorityTasks: 0,
          completionRate: 0.0,
          avgCompletionTimeMs: 0,
          totalMemoryUsed: 0,
          poolAllocations: 0,
        )) {
    refresh();
  }

  void refresh() {
    state = _ffi.getStatistics();
  }
}

class PerformanceNotifier extends StateNotifier<PerformanceData> {
  final FFIService _ffi;

  PerformanceNotifier(this._ffi)
      : super(PerformanceData(
          memoryAllocatedBytes: 0,
          poolHits: 0,
          poolMisses: 0,
        )) {
    refresh();
  }

  void refresh() {
    state = _ffi.getPerformanceMetrics();
  }

  int compactMemory() {
    final freed = _ffi.compactMemory();
    refresh();
    return freed;
  }
}
