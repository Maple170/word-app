import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/word_provider.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('学習進捗', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Consumer<WordProvider>(
        builder: (context, provider, _) {
          final total = provider.totalCount;
          final memorized = provider.memorizedCount;
          final progress = total == 0 ? 0.0 : memorized / total;
          final words = provider.allWords;

          final recentWords = words
              .where((w) => w.lastReviewedAt != null)
              .toList()
            ..sort((a, b) =>
                b.lastReviewedAt!.compareTo(a.lastReviewedAt!));
          final recent = recentWords.take(5).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProgressCard(context, total, memorized, progress),
                const SizedBox(height: 16),
                _buildStatsRow(context, total, memorized),
                const SizedBox(height: 24),
                Text(
                  '最近学習した単語',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (recent.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'フラッシュカードで学習を始めましょう！',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.outline),
                      ),
                    ),
                  )
                else
                  ...recent.map((word) => Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(word.english,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text(word.japanese),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('${word.reviewCount}回',
                                  style: const TextStyle(fontSize: 12)),
                              Icon(
                                word.isMemorized
                                    ? Icons.star
                                    : Icons.star_border,
                                color: word.isMemorized ? Colors.amber : null,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      )),
                const SizedBox(height: 24),
                _buildTopWords(context, words),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgressCard(
      BuildContext context, int total, int memorized, double progress) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '暗記率',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${(progress * 100).toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    '$memorized / $total 単語',
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimaryContainer
                          .withOpacity(0.7),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 12,
                backgroundColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, int total, int memorized) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: '総単語数',
            value: '$total',
            icon: Icons.library_books,
            color: Theme.of(context).colorScheme.secondaryContainer,
            onColor: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: '暗記済み',
            value: '$memorized',
            icon: Icons.check_circle,
            color: Theme.of(context).colorScheme.tertiaryContainer,
            onColor: Theme.of(context).colorScheme.onTertiaryContainer,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: '未暗記',
            value: '${total - memorized}',
            icon: Icons.pending,
            color: Theme.of(context).colorScheme.errorContainer,
            onColor: Theme.of(context).colorScheme.onErrorContainer,
          ),
        ),
      ],
    );
  }

  Widget _buildTopWords(BuildContext context, List words) {
    final topWords = List.from(words)
      ..sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
    final top = topWords.take(5).where((w) => w.reviewCount > 0).toList();

    if (top.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'よく学習した単語 TOP 5',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...top.asMap().entries.map((e) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  child: Text(
                    '${e.key + 1}',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(e.value.english,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(e.value.japanese),
                trailing: Text('${e.value.reviewCount}回',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            )),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final Color onColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.onColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: onColor, size: 28),
            const SizedBox(height: 8),
            Text(value,
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold, color: onColor)),
            Text(label, style: TextStyle(fontSize: 12, color: onColor)),
          ],
        ),
      ),
    );
  }
}
