// File: lib/presentation/features/manuscript/widget/writing_stats_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fictionist/presentation/features/manuscript/provider/writing_preferences_provider.dart';
import 'package:fictionist/presentation/features/manuscript/provider/session_goals_provider.dart';

/// A compact stats bar shown below the manuscript editor.
///
/// Shows word / char counts, estimated reading time, last-edit timestamp,
/// a circular session-goal progress ring, and the current writing streak.
class WritingStatsBar extends ConsumerWidget {
  final ValueNotifier<int> wordCountNotifier;
  final ValueNotifier<int> charCountNotifier;
  final DateTime? lastEdited;

  const WritingStatsBar({
    super.key,
    required this.wordCountNotifier,
    required this.charCountNotifier,
    this.lastEdited,
  });

  // ── helpers ──────────────────────────────────────────────────────────

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  /// Opens a Material dialog letting the user pick a daily word goal.
  void _showGoalDialog(BuildContext context, WidgetRef ref) {
    final goals = const [250, 500, 1000, 2000];

    showDialog<void>(
      context: context,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        return AlertDialog(
          title: const Text('Set Daily Writing Goal'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: goals.map((goal) {
              return ListTile(
                leading: Icon(Icons.edit_note,
                    color: theme.colorScheme.primary),
                title: Text('$goal words'),
                onTap: () {
                  ref
                      .read(sessionGoalsProvider.notifier)
                      .setDailyGoal(goal);
                  Navigator.pop(ctx);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  // ── build ────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ValueListenableBuilder(
      valueListenable: wordCountNotifier,
      builder: (context, _, __) {
        final wordCount = wordCountNotifier.value;
        final charCount = charCountNotifier.value;
        return _buildContent(context, ref, wordCount, charCount);
      },
    );
  }

  Widget _buildContent(
      BuildContext context, WidgetRef ref, int wordCount, int charCount) {
    final prefs = ref.watch(writingPreferencesProvider);
    final goals = ref.watch(sessionGoalsProvider);
    final theme = Theme.of(context);

    // --- document goal (legacy linear bar) ---
    final hasDocGoal = prefs.wordCountGoal > 0;
    final docProgress =
        hasDocGoal ? (wordCount / prefs.wordCountGoal).clamp(0.0, 1.0) : 0.0;

    // --- session goal (circular ring) ---
    final hasSessionGoal = goals.dailyGoal > 0;
    final sessionProgress = hasSessionGoal
        ? (goals.wordsWrittenToday / goals.dailyGoal).clamp(0.0, 1.0)
        : 0.0;
    final readingTime = (wordCount / 200).ceil(); // 200 wpm

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Row: session ring  ·  streak  ·  goal action ──────────
        Row(
          children: [
            // ── circular progress ring ──────────────────────────
            if (hasSessionGoal) ...[
              _CircularGoalRing(
                progress: sessionProgress,
                label: '${goals.wordsWrittenToday}/${goals.dailyGoal}',
              ),
              const SizedBox(width: 10),
            ],

            // ── streak badge ────────────────────────────────────
            if (goals.currentStreak > 0)
              _StreakBadge(streak: goals.currentStreak),

            if (hasSessionGoal || goals.currentStreak > 0)
              const SizedBox(width: 8),

            // ── set‑goal button (only when no session goal) ─────
            if (!hasSessionGoal)
              _GoalChip(
                label: goals.dailyGoal == 0 ? 'Set Goal' : '${goals.wordsWrittenToday} words',
                onTap: () => _showGoalDialog(context, ref),
              ),

            const Spacer(),

            if (lastEdited != null)
              Text(
                'Edited ${_formatTime(lastEdited!)}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color:
                      theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                  fontSize: 10,
                ),
              ),
          ],
        ),

        const SizedBox(height: 6),

        // ── document goal linear bar (existing behaviour) ────────
        if (hasDocGoal) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: docProgress,
              minHeight: 3,
              backgroundColor:
                  theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation(
                docProgress >= 1.0
                    ? theme.colorScheme.tertiary
                    : theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 6),
        ],

        // ── stats chips ─────────────────────────────────────────
        Row(
          children: [
            _StatChip(
                label: '$wordCount words', icon: Icons.text_fields),
            const SizedBox(width: 12),
            _StatChip(label: '$charCount chars', icon: Icons.abc),
            const SizedBox(width: 12),
            _StatChip(
                label: '${readingTime}m read',
                icon: Icons.timer_outlined),
          ],
        ),
      ],
    );
  }
}

// ────────────────────────────────────────────────────────────────────────
// Private widgets
// ────────────────────────────────────────────────────────────────────────

/// A small circular progress indicator with a centre label.
class _CircularGoalRing extends StatelessWidget {
  final double progress; // 0.0 – 1.0
  final String label;

  const _CircularGoalRing({
    required this.progress,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = progress >= 1.0
        ? theme.colorScheme.tertiary
        : theme.colorScheme.primary;

    return SizedBox(
      width: 36,
      height: 36,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // background ring
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 2.5,
              color: theme.colorScheme.surfaceContainerHighest,
            ),
          ),
          // progress ring
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 2.5,
              color: color,
              backgroundColor: Colors.transparent,
            ),
          ),
          // centre label
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 8,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// A small chip showing the current writing streak.
class _StreakBadge extends StatelessWidget {
  final int streak;

  const _StreakBadge({required this.streak});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryContainer.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('🔥', style: const TextStyle(fontSize: 11)),
          const SizedBox(width: 3),
          Text(
            '$streak ${streak == 1 ? 'day' : 'days'}',
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onTertiaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}

/// A tappable chip used for "Set Goal" / showing current count.
class _GoalChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _GoalChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.3),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

/// Reusable mini stat chip.
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
        Icon(icon,
            size: 12,
            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5)),
        const SizedBox(width: 4),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
