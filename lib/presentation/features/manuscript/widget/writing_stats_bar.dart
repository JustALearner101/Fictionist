// File: lib/presentation/features/manuscript/widget/writing_stats_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fictionist/presentation/features/manuscript/provider/writing_preferences_provider.dart';

class WritingStatsBar extends ConsumerWidget {
  final int wordCount;
  final int charCount;
  final DateTime? lastEdited;

  const WritingStatsBar({
    super.key,
    required this.wordCount,
    required this.charCount,
    this.lastEdited,
  });

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(writingPreferencesProvider);
    final theme = Theme.of(context);
    final hasGoal = prefs.wordCountGoal > 0;
    final progress = hasGoal ? (wordCount / prefs.wordCountGoal).clamp(0.0, 1.0) : 0.0;
    final readingTime = (wordCount / 200).ceil(); // 200 wpm

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress bar
        if (hasGoal) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 3,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation(
                progress >= 1.0
                    ? theme.colorScheme.tertiary
                    : theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 6),
        ],
        // Stats row
        Row(
          children: [
            _StatChip(label: '$wordCount words', icon: Icons.text_fields),
            const SizedBox(width: 12),
            _StatChip(label: '$charCount chars', icon: Icons.abc),
            const SizedBox(width: 12),
            _StatChip(label: '${readingTime}m read', icon: Icons.timer_outlined),
            if (lastEdited != null) ...[
              const Spacer(),
              Text(
                'Edited ${_formatTime(lastEdited!)}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                  fontSize: 10,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final IconData icon;
  const _StatChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5)),
        const SizedBox(width: 4),
        Text(label, style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
          fontSize: 11,
        )),
      ],
    );
  }
}
