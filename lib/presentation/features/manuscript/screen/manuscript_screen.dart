import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:fictionist/domain/manuscript/manuscript_chapter.dart';
import 'package:fictionist/presentation/common/widget/confirm_dialog.dart';
import 'package:fictionist/presentation/common/widget/loading_indicator.dart';
import 'package:fictionist/presentation/common/widget/page_header.dart';
import 'package:fictionist/presentation/features/manuscript/provider/manuscript_provider.dart';
import 'package:fictionist/presentation/features/manuscript/widget/dashboard_view.dart';
import 'package:fictionist/presentation/features/manuscript/widget/template_picker.dart';

/// Manuscript home — shows the chapter list with status, word count & progress.
///
/// Tapping a chapter navigates to [ChapterEditorScreen] via `/manuscript/write/:id`
/// which lives outside the AppScaffold shell (no bottom nav bar).
class ManuscriptScreen extends ConsumerStatefulWidget {
  const ManuscriptScreen({super.key});

  @override
  ConsumerState<ManuscriptScreen> createState() => _ManuscriptScreenState();
}

class _ManuscriptScreenState extends ConsumerState<ManuscriptScreen> {
  Future<void> _createChapter() async {
    final titles = await showTemplatePicker(context);
    if (titles == null || !mounted) return;

    final notifier = ref.read(manuscriptNotifierProvider.notifier);
    final originalCount = ref.read(manuscriptNotifierProvider).chapters.length;

    for (final title in titles) {
      if (title.trim().isEmpty) continue;
      await notifier.createChapter(title.trim());
    }

    // Navigate directly to the first new chapter
    if (!mounted) return;
    final state = ref.read(manuscriptNotifierProvider);
    if (originalCount < state.chapters.length) {
      final firstNew = state.chapters[originalCount];
      context.push('/manuscript/write/${firstNew.id}');
    }
  }

  Future<void> _deleteChapter(String id, String title) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => ConfirmDialog(
        title: 'Delete Chapter',
        content: 'Delete "$title"? This cannot be undone.',
        confirmLabel: 'Delete',
        isDestructive: true,
      ),
    );
    if (confirm == true) {
      await ref.read(manuscriptNotifierProvider.notifier).deleteChapter(id);
    }
  }

  Future<void> _reorderChapters(int oldIndex, int newIndex) async {
    HapticFeedback.selectionClick();
    await ref.read(manuscriptNotifierProvider.notifier)
        .reorderChapters(oldIndex, newIndex > oldIndex ? newIndex - 1 : newIndex);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(manuscriptNotifierProvider);

    if (state.isLoading) {
      return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: const Center(child: LoadingIndicator()),
      );
    }

    if (state.errorMessage != null) {
      return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48,
                  color: theme.colorScheme.error.withOpacity(0.6)),
              const SizedBox(height: 12),
              Text(state.errorMessage!,
                  style: theme.textTheme.bodyMedium!
                      .copyWith(color: theme.colorScheme.error)),
              const SizedBox(height: 16),
              FilledButton(
                  onPressed: () => ref
                      .read(manuscriptNotifierProvider.notifier)
                      .refreshChapters(),
                  child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    final chapters = state.chapters;

    // Summary stats
    final totalWords = chapters.fold<int>(0, (sum, c) =>
        sum + c.content.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length);
    final doneCount = chapters.where((c) => c.status == ChapterStatus.done).length;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: chapters.isEmpty
          ? _EmptyManuscript(onCreate: _createChapter)
          : Column(
              children: [
                // ── Page header ─────────────────────────────────────────────
                PageHeader(
                  title: 'Manuscript',
                  subtitle: 'Write and organize your story',
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.dashboard_outlined, color: theme.colorScheme.onSurface, size: 20),
                        tooltip: 'Dashboard',
                        onPressed: () => showDashboardSheet(context, ref),
                      ),
                      IconButton(
                        icon: Icon(Icons.add_circle_outline, color: theme.colorScheme.primary, size: 20),
                        tooltip: 'New Chapter',
                        onPressed: _createChapter,
                      ),
                    ],
                  ),
                ),
                // ── Summary strip ───────────────────────────────────────────
                _SummaryStrip(
                  totalChapters: chapters.length,
                  totalWords: totalWords,
                  doneCount: doneCount,
                  theme: theme,
                ),
                Divider(height: 1,
                    color: theme.colorScheme.outline.withOpacity(0.08)),

                // ── Chapter list ────────────────────────────────────────────
                Expanded(
                  child: ReorderableListView.builder(
                    padding: const EdgeInsets.only(bottom: 100),
                    buildDefaultDragHandles: false,
                    itemCount: chapters.length,
                    onReorder: _reorderChapters,
                    itemBuilder: (context, index) {
                      final chapter = chapters[index];
                      return _ChapterCard(
                        key: ValueKey(chapter.id),
                        chapter: chapter,
                        index: index,
                        onTap: () {
                          HapticFeedback.lightImpact();
                          context.push('/manuscript/write/${chapter.id}');
                        },
                        onDelete: () =>
                            _deleteChapter(chapter.id, chapter.title),
                      );
                    },
                  ),
                ),
              ],
            ),
      // FAB
      floatingActionButton: chapters.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _createChapter,
              icon: const Icon(Icons.add),
              label: const Text('New Chapter'),
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
            )
          : null,
    );
  }
}

// ─── Empty state ─────────────────────────────────────────────────────────────

class _EmptyManuscript extends StatelessWidget {
  final VoidCallback onCreate;
  const _EmptyManuscript({required this.onCreate});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_stories_outlined,
              size: 72,
              color: theme.colorScheme.primary.withOpacity(0.4)),
          const SizedBox(height: 20),
          Text('Your story starts here',
              style: theme.textTheme.headlineSmall!.copyWith(
                fontFamily: theme.textTheme.displayLarge?.fontFamily,
                color: theme.colorScheme.onSurface,
              )),
          const SizedBox(height: 10),
          Text('Create your first chapter to begin writing.',
              style: theme.textTheme.bodyMedium!.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              )),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: onCreate,
            icon: const Icon(Icons.add),
            label: const Text('Create First Chapter'),
          ),
        ],
      ),
    );
  }
}

// ─── Summary strip ────────────────────────────────────────────────────────────

class _SummaryStrip extends StatelessWidget {
  final int totalChapters;
  final int totalWords;
  final int doneCount;
  final ThemeData theme;

  const _SummaryStrip({
    required this.totalChapters,
    required this.totalWords,
    required this.doneCount,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final pct = totalChapters > 0 ? doneCount / totalChapters : 0.0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Chip(
                icon: Icons.format_list_numbered,
                label: '$totalChapters ${totalChapters == 1 ? 'chapter' : 'chapters'}',
                theme: theme,
              ),
              const SizedBox(width: 10),
              _Chip(
                icon: Icons.text_fields,
                label: _fmt(totalWords),
                theme: theme,
              ),
              const SizedBox(width: 10),
              _Chip(
                icon: Icons.check_circle_outline,
                label: '$doneCount done',
                theme: theme,
                active: doneCount > 0,
              ),
            ],
          ),
          if (totalChapters > 0) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: pct,
                minHeight: 4,
                backgroundColor:
                    theme.colorScheme.primary.withOpacity(0.12),
                valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.primary),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _fmt(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k words';
    return '$n words';
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  final ThemeData theme;
  final bool active;

  const _Chip({
    required this.icon,
    required this.label,
    required this.theme,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: active
            ? theme.colorScheme.primary.withOpacity(0.12)
            : theme.colorScheme.surfaceVariant.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 12,
              color: active
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 5),
          Text(
            label,
            style: theme.textTheme.labelSmall!.copyWith(
              color: active
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
              fontWeight:
                  active ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Chapter card ─────────────────────────────────────────────────────────────

class _ChapterCard extends StatelessWidget {
  final ManuscriptChapter chapter;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ChapterCard({
    super.key,
    required this.chapter,
    required this.index,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wordCount = chapter.content
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .length;
    final statusColor = _statusColor(chapter.status, theme);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.25),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Drag handle
                ReorderableDragStartListener(
                  index: index,
                  child: Icon(
                    Icons.drag_handle,
                    size: 20,
                    color:
                        theme.colorScheme.onSurfaceVariant.withOpacity(0.4),
                  ),
                ),
                const SizedBox(width: 14),

                // Chapter number badge
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: theme.textTheme.labelMedium!.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Title + synopsis + meta
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chapter.title,
                        style: theme.textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.w600,
                          fontFamily: Theme.of(context).textTheme.displayLarge?.fontFamily,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (chapter.synopsis != null &&
                          chapter.synopsis!.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Text(
                          chapter.synopsis!,
                          style: theme.textTheme.bodySmall!.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontStyle: FontStyle.italic,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          // Status chip
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: statusColor.withOpacity(0.3)),
                            ),
                            child: Text(
                              chapter.status.label,
                              style: theme.textTheme.labelSmall!.copyWith(
                                color: statusColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Word count
                          Text(
                            wordCount == 0
                                ? 'Empty'
                                : '$wordCount words',
                            style: theme.textTheme.labelSmall!.copyWith(
                              color: theme.colorScheme.onSurfaceVariant
                                  .withOpacity(0.7),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Delete action
                IconButton(
                  icon: Icon(Icons.delete_outline,
                      size: 18,
                      color: theme.colorScheme.onSurfaceVariant
                          .withOpacity(0.4)),
                  onPressed: onDelete,
                  visualDensity: VisualDensity.compact,
                  tooltip: 'Delete chapter',
                ),

                // Arrow
                Icon(Icons.chevron_right,
                    size: 18,
                    color: theme.colorScheme.onSurfaceVariant.withOpacity(0.4)),
              ],
            ),
          ),
        ),
      ),
    ).animate()
     .fade(duration: 250.ms, curve: Curves.easeOut)
     .slideY(begin: 0.08, end: 0, duration: 250.ms, curve: Curves.easeOut);
  }

  Color _statusColor(ChapterStatus status, ThemeData theme) {
    switch (status) {
      case ChapterStatus.draft:
        return theme.colorScheme.onSurfaceVariant;
      case ChapterStatus.revising:
        return const Color(0xFFFBBF24);
      case ChapterStatus.done:
        return const Color(0xFF34D399);
    }
  }
}
