import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/task_provider.dart';
import '../widgets/task_list.dart';
import '../widgets/stats_panel.dart';
import '../widgets/performance_panel.dart';
import 'add_task_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  var _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(tasksProvider.notifier).loadTasks();
      ref.read(statsProvider.notifier).refresh();
      ref.read(performanceProvider.notifier).refresh();
    });
  }

  void _refreshAll() {
    ref.read(tasksProvider.notifier).loadTasks();
    ref.read(statsProvider.notifier).refresh();
    ref.read(performanceProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshAll,
            tooltip: 'Refresh',
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Clear All Tasks'),
                onTap: () {
                  Future.delayed(Duration.zero, () => _showClearDialog());
                },
              ),
              PopupMenuItem(
                child: const Text('Compact Memory'),
                onTap: () {
                  Future.delayed(Duration.zero, () => _compactMemory());
                },
              ),
            ],
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          TaskList(),
          StatsPanel(),
          PerformancePanel(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (idx) => setState(() => _selectedIndex = idx),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.task_outlined),
            selectedIcon: Icon(Icons.task),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics),
            label: 'Statistics',
          ),
          NavigationDestination(
            icon: Icon(Icons.speed_outlined),
            selectedIcon: Icon(Icons.speed),
            label: 'Performance',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () => _showAddTask(),
              icon: const Icon(Icons.add),
              label: const Text('Add Task'),
            )
          : null,
    );
  }

  void _showAddTask() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddTaskScreen()),
    ).then((_) => _refreshAll());
  }

  void _showClearDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Tasks'),
        content: const Text('Are you sure you want to delete all tasks?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(tasksProvider.notifier).clearAll();
              _refreshAll();
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _compactMemory() {
    final freed = ref.read(performanceProvider.notifier).compactMemory();
    _refreshAll();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Freed ${(freed / 1024).toStringAsFixed(2)} KB')),
    );
  }
}
