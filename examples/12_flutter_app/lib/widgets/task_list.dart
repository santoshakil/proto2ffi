import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/task_provider.dart';
import '../services/ffi_service.dart';

class TaskList extends ConsumerWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksProvider);

    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.task_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('No tasks yet', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Tap + to create one', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      );
    }

    return Column(
      children: [
        _FilterBar(),
        Expanded(
          child: ListView.builder(
            itemCount: tasks.length,
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, idx) => _TaskCard(task: tasks[idx]),
          ),
        ),
      ],
    );
  }
}

class _FilterBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterCompleted = ref.watch(filterCompletedProvider);

    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Wrap(
          spacing: 8,
          children: [
            FilterChip(
              label: const Text('All'),
              selected: filterCompleted == null,
              onSelected: (selected) {
                ref.read(filterCompletedProvider.notifier).state = null;
                ref.read(tasksProvider.notifier).loadTasks();
              },
            ),
            FilterChip(
              label: const Text('Active'),
              selected: filterCompleted == false,
              onSelected: (selected) {
                ref.read(filterCompletedProvider.notifier).state = false;
                ref.read(tasksProvider.notifier).loadTasks(completed: false);
              },
            ),
            FilterChip(
              label: const Text('Completed'),
              selected: filterCompleted == true,
              onSelected: (selected) {
                ref.read(filterCompletedProvider.notifier).state = true;
                ref.read(tasksProvider.notifier).loadTasks(completed: true);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskCard extends ConsumerWidget {
  final TaskData task;

  const _TaskCard({required this.task});

  Color _priorityColor(int priority) {
    if (priority >= 8) return Colors.red;
    if (priority >= 5) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        leading: Checkbox(
          value: task.completed,
          onChanged: (_) => ref.read(tasksProvider.notifier).toggleCompleted(task.id),
        ),
        title: Text(
          task.title,
          style: task.completed
              ? const TextStyle(decoration: TextDecoration.lineThrough)
              : null,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.description),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _priorityColor(task.priority),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'P${task.priority}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () => _showDeleteDialog(context, ref),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(tasksProvider.notifier).deleteTask(task.id);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
