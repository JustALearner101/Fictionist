// File: lib/presentation/features/manuscript/widget/dashboard_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fictionist/presentation/features/manuscript/provider/manuscript_provider.dart';
import 'package:fictionist/presentation/features/manuscript/provider/session_goals_provider.dart';

/// A stats-overview dashboard shown as a bottom sheet.
///
/// Displays five metric cards in a 2-column grid:
///   📊 Total Words    — sum of word counts across all chapters
///   📖 Total Chapters — number of chapters in the manuscript
///   📏 Avg / Chapter  — mean words per chapter
///   ✅ Completion %   — chapters with non‑empty content / total
///   🔥 Best Streak    — all‑time best writing streak from [SessionGoals]
///
/// Props are passed in directly so the sheet re‑computes from
/// the latest [ManuscriptState] and [SessionGoals] without
/// needing its own providers.
class DashboardView extends StatelessWidget {
  final ManuscriptState manuscriptState;
  final SessionGoals sessionGoals;

  const DashboardView({
    super.key,
    required this.manuscriptState,
    required this.sessionGoals,
  });

  // ── helpers ──────────────────────────────────────────────────────────

  int _wordCount(String text) =>
      text.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;

  // ── build ────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final chapters = manuscriptState.chapters;
    final totalWords = chapters.fold<int>(
      0,
      (sum, ch) => sum + _wordCount(ch.content),
    );
    final totalChapters = chapters.length;
    final avgWords =
        totalChapters > 0 ? (totalWords / totalChapters).round() : 0;
    final completedCount =
        chapters.where((c) => c.content.trim().isNotEmpty).length;
    final completionPct = totalChapters > 0
        ? ((completedCount / totalChapters) * 100).round()
        : 0;
    final bestStreak = sessionGoals.bestStreak;

    final metrics = <_DashboardMetric>[
      _DashboardMetric(
        icon: Icons.text_fields,
        label: 'Total Words',
        value: _formatNumber(totalWords),
      ),
      _DashboardMetric(
        icon: Icons.book,
        label: 'Total Chapters',
        value: '$totalChapters',
      ),
      _DashboardMetric(
        icon: Icons.analytics_outlined,
        label: 'Avg / Chapter',
        value: '$avgWords words',
      ),
      _DashboardMetric(
        icon: Icons.check_circle_outline,
        label: 'Completion',
        value: '$completionPct%',
      ),
      _DashboardMetric(
        icon: Icons.local_fire_department,
        label: 'Best Streak',
        value: bestStreak > 0 ? '$bestStreak days' : '—',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Header ────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
          child: Row(
            children: [
              Text(
                '📊 Manuscript Stats',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontFamily: 'Lora',
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const Spacer(),
              if (totalChapters > 0)
                Text(
                  '${manuscriptState.chapters.length} chapter${totalChapters == 1 ? '' : 's'}',
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color:
                            Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
            ],
          ),
        ),
        const Divider(),
        // ── Grid ──────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.5, // ~150×100
            ),
            itemCount: metrics.length,
            itemBuilder: (context, index) {
              return _StatCard(metric: metrics[index]);
            },
          ),
        ),
      ],
    );
  }

  /// Format large numbers with commas (e.g. 12345 → "12,345").
  static String _formatNumber(int n) {
    if (n < 1000) return '$n';
    final buffer = StringBuffer();
    final str = n.toString();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write(',');
      buffer.write(str[i]);
    }
    return buffer.toString();
  }
}

// ────────────────────────────────────────────────────────────────────────
// Data
// ────────────────────────────────────────────────────────────────────────

class _DashboardMetric {
  final IconData icon;
  final String label;
  final String value;

  const _DashboardMetric({
    required this.icon,
    required this.label,
    required this.value,
  });
}

// ────────────────────────────────────────────────────────────────────────
// Stat Card
// ────────────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final _DashboardMetric metric;

  const _StatCard({required this.metric});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(16),
      color: theme.colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Icon(
              metric.icon,
              size: 22,
              color: theme.colorScheme.primary.withOpacity(0.85),
            ),
            const SizedBox(height: 8),
            // Value
            Text(
              metric.value,
              style: theme.textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
                fontSize: 20,
                height: 1.1,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            // Label
            Text(
              metric.label,
              style: theme.textTheme.labelSmall!.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                fontWeight: FontWeight.w500,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Convenience helper that shows the [DashboardView] in a
/// [showModalBottomSheet] with the current provider state.
void showDashboardSheet(
  BuildContext context,
  WidgetRef ref,
) {
  final manuscriptState = ref.read(manuscriptNotifierProvider);
  final sessionGoals = ref.read(sessionGoalsProvider);

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return DraggableScrollableSheet(
        initialChildSize: 0.55,
        minChildSize: 0.35,
        maxChildSize: 0.85,
        expand: false,
        builder: (ctx, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: ListView(
              controller: scrollController,
              padding: EdgeInsets.zero,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 4),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant
                          .withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                DashboardView(
                  manuscriptState: manuscriptState,
                  sessionGoals: sessionGoals,
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
