import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/task_provider.dart';

class StatsPanel extends ConsumerWidget {
  const StatsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(statsProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(statsProvider.notifier).refresh();
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _StatCard(
            title: 'Total Tasks',
            value: stats.totalTasks.toString(),
            icon: Icons.task_alt,
            color: Colors.blue,
          ),
          _StatCard(
            title: 'Completed Tasks',
            value: stats.completedTasks.toString(),
            icon: Icons.check_circle,
            color: Colors.green,
          ),
          _StatCard(
            title: 'Pending Tasks',
            value: stats.pendingTasks.toString(),
            icon: Icons.pending_actions,
            color: Colors.orange,
          ),
          _StatCard(
            title: 'High Priority Tasks',
            value: stats.highPriorityTasks.toString(),
            icon: Icons.priority_high,
            color: Colors.red,
          ),
          _ProgressCard(
            title: 'Completion Rate',
            value: stats.completionRate,
            icon: Icons.percent,
          ),
          _StatCard(
            title: 'Avg Completion Time',
            value: '${(stats.avgCompletionTimeMs / 1000).toStringAsFixed(1)}s',
            icon: Icons.timer,
            color: Colors.purple,
          ),
          _StatCard(
            title: 'Memory Used',
            value: '${(stats.totalMemoryUsed / 1024).toStringAsFixed(2)} KB',
            icon: Icons.memory,
            color: Colors.teal,
          ),
          _StatCard(
            title: 'Pool Allocations',
            value: stats.poolAllocations.toString(),
            icon: Icons.storage,
            color: Colors.indigo,
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final String title;
  final double value;
  final IconData icon;

  const _ProgressCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final color = value >= 75 ? Colors.green : value >= 50 ? Colors.orange : Colors.red;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(title, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: value / 100,
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
              backgroundColor: color.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation(color),
            ),
            const SizedBox(height: 8),
            Text(
              '${value.toStringAsFixed(1)}%',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
