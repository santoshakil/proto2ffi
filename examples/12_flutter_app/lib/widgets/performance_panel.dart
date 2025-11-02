import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/task_provider.dart';

class PerformancePanel extends ConsumerWidget {
  const PerformancePanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perf = ref.watch(performanceProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(performanceProvider.notifier).refresh();
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _PerformanceCard(
            title: 'Memory Allocated',
            value: '${(perf.memoryAllocatedBytes / 1024).toStringAsFixed(2)} KB',
            subtitle: '${perf.memoryAllocatedBytes} bytes',
            icon: Icons.memory,
            color: Colors.blue,
          ),
          _PerformanceCard(
            title: 'Pool Hits',
            value: perf.poolHits.toString(),
            subtitle: 'Successful pool allocations',
            icon: Icons.check_circle,
            color: Colors.green,
          ),
          _PerformanceCard(
            title: 'Pool Misses',
            value: perf.poolMisses.toString(),
            subtitle: 'Failed pool allocations',
            icon: Icons.cancel,
            color: Colors.red,
          ),
          _HitRateCard(hitRate: perf.hitRate),
          const SizedBox(height: 16),
          _MemoryActionsCard(),
        ],
      ),
    );
  }
}

class _PerformanceCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _PerformanceCard({
    required this.title,
    required this.value,
    required this.subtitle,
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
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
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

class _HitRateCard extends StatelessWidget {
  final double hitRate;

  const _HitRateCard({required this.hitRate});

  @override
  Widget build(BuildContext context) {
    final color = hitRate >= 80 ? Colors.green : hitRate >= 50 ? Colors.orange : Colors.red;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.speed, color: color),
                const SizedBox(width: 8),
                Text('Pool Hit Rate', style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: hitRate / 100,
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
              backgroundColor: color.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation(color),
            ),
            const SizedBox(height: 8),
            Text(
              '${hitRate.toStringAsFixed(1)}%',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Higher is better - indicates efficient memory pool usage',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MemoryActionsCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Memory Management',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {
                final freed = ref.read(performanceProvider.notifier).compactMemory();
                ref.read(statsProvider.notifier).refresh();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Compacted: ${(freed / 1024).toStringAsFixed(2)} KB freed'),
                  ),
                );
              },
              icon: const Icon(Icons.compress),
              label: const Text('Compact Memory'),
            ),
            const SizedBox(height: 8),
            Text(
              'Removes unused memory blocks and optimizes pool usage',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
