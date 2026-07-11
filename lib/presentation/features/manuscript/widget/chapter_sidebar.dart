// File: lib/presentation/features/manuscript/widget/chapter_sidebar.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fictionist/domain/manuscript/manuscript_chapter.dart';
import 'package:fictionist/presentation/features/manuscript/provider/writing_preferences_provider.dart';
import 'package:fictionist/presentation/features/manuscript/widget/corkboard_view.dart';

class ChapterSidebar extends ConsumerWidget {
  final List<ManuscriptChapter> chapters;
  final String? selectedChapterId;
  final void Function(String id) onChapterSelected;
  final void Function(String id, String title) onChapterDeleted;
  final void Function(int oldIndex, int newIndex) onReorder;

  const ChapterSidebar({
    super.key,
    required this.chapters,
    required this.selectedChapterId,
    required this.onChapterSelected,
    required this.onChapterDeleted,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(writingPreferencesProvider);
    final collapsed = prefs.sidebarCollapsed;
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: collapsed ? 60 : 240,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(
            right: BorderSide(
              color: theme.colorScheme.outline.withOpacity(0.15),
              width: 1,
            ),
          ),
        ),
        child: Column(
          children: [
            // Header with collapse toggle
            _SidebarHeader(collapsed: collapsed),
            // Chapter list or corkboard (animated transition)
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                child: collapsed
                    ? _CollapsedChapterList(
                        chapters: chapters,
                        selectedChapterId: selectedChapterId,
                        onChapterSelected: onChapterSelected,
                      )
                    : prefs.corkboardView
                        ? CorkboardView(
                            chapters: chapters,
                            selectedChapterId: selectedChapterId,
                            onChapterSelected: onChapterSelected,
                            onReorder: onReorder,
                          )
                        : _ExpandedChapterList(
                            chapters: chapters,
                            selectedChapterId: selectedChapterId,
                            onChapterSelected: onChapterSelected,
                            onChapterDeleted: onChapterDeleted,
                            onReorder: onReorder,
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SidebarHeader extends StatelessWidget {
  final bool collapsed;
  const _SidebarHeader({required this.collapsed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final toggleButton = Consumer(
      builder: (context, ref, _) {
        final prefsCollapsed =
            ref.watch(writingPreferencesProvider).sidebarCollapsed;
        return IconButton(
          icon: Icon(
            prefsCollapsed
                ? Icons.chevron_right
                : Icons.chevron_left,
            size: 20,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          tooltip: prefsCollapsed
              ? 'Expand sidebar'
              : 'Collapse sidebar',
          onPressed: () {
            ref.read(writingPreferencesProvider.notifier).update(
              (p) => p.copyWith(
                  sidebarCollapsed: !p.sidebarCollapsed),
            );
          },
          visualDensity: VisualDensity.compact,
        );
      },
    );

    if (collapsed) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
        child: Center(
          child: toggleButton,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 8, 8),
      child: Row(
        children: [
          Text('Chapters', style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          )),
          const Spacer(),
          // List / Grid toggle button
          Consumer(
            builder: (context, ref, _) {
              final corkboard = ref.watch(writingPreferencesProvider).corkboardView;
              return IconButton(
                icon: Icon(
                  corkboard ? Icons.list : Icons.grid_view_rounded,
                  size: 20,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                tooltip: corkboard ? 'List view' : 'Corkboard view',
                onPressed: () {
                  ref.read(writingPreferencesProvider.notifier).update(
                    (p) => p.copyWith(corkboardView: !p.corkboardView),
                  );
                },
                visualDensity: VisualDensity.compact,
              );
            },
          ),
          toggleButton,
        ],
      ),
    );
  }
}

/// Returns a color for the given chapter status.
Color _statusColor(ChapterStatus status) {
  switch (status) {
    case ChapterStatus.draft:
      return Colors.grey;
    case ChapterStatus.revising:
      return Colors.amber;
    case ChapterStatus.done:
      return Colors.green;
  }
}

class _CollapsedChapterList extends StatelessWidget {
  final List<ManuscriptChapter> chapters;
  final String? selectedChapterId;
  final void Function(String) onChapterSelected;

  const _CollapsedChapterList({
    required this.chapters,
    required this.selectedChapterId,
    required this.onChapterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.builder(
      itemCount: chapters.length,
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemBuilder: (context, index) {
        final ch = chapters[index];
        final isSelected = ch.id == selectedChapterId;
        return Tooltip(
          message: ch.title,
          preferBelow: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: Material(
              color: isSelected
                  ? theme.colorScheme.primary.withOpacity(0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => onChapterSelected(ch.id),
                child: SizedBox(
                  height: 44,
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ExpandedChapterList extends StatelessWidget {
  final List<ManuscriptChapter> chapters;
  final String? selectedChapterId;
  final void Function(String) onChapterSelected;
  final void Function(String, String) onChapterDeleted;
  final void Function(int, int) onReorder;

  const _ExpandedChapterList({
    required this.chapters,
    required this.selectedChapterId,
    required this.onChapterSelected,
    required this.onChapterDeleted,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ReorderableListView.builder(
      itemCount: chapters.length,
      padding: const EdgeInsets.only(bottom: 16),
      onReorder: onReorder,
      proxyDecorator: (child, index, animation) => Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(8),
        color: theme.colorScheme.surface,
        child: child,
      ),
      itemBuilder: (context, index) {
        final ch = chapters[index];
        final isSelected = ch.id == selectedChapterId;
        final wordCount = ch.content
            .split(RegExp(r'\s+'))
            .where((w) => w.isNotEmpty)
            .length;

        return Padding(
          key: ValueKey(ch.id),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          child: Material(
            color: isSelected
                ? theme.colorScheme.primary.withOpacity(0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => onChapterSelected(ch.id),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  children: [
                    // Chapter number
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: isSelected
                          ? theme.colorScheme.primary.withOpacity(0.18)
                          : theme.colorScheme.surfaceContainerHighest,
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: 11,
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Title + word count
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Status dot
                              Container(
                                width: 8,
                                height: 8,
                                margin: const EdgeInsets.only(right: 6),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _statusColor(ch.status),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  ch.title,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                    color: isSelected
                                        ? theme.colorScheme.onSurface
                                        : theme.colorScheme.onSurfaceVariant,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '$wordCount words',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
                              fontSize: 10,
                            ),
                          ),
                          if (ch.synopsis != null && ch.synopsis!.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              ch.synopsis!,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                                fontSize: 10,
                                fontStyle: FontStyle.italic,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    // Delete + drag handle
                    IconButton(
                      icon: Icon(Icons.delete_outline, size: 16,
                          color: theme.colorScheme.error.withOpacity(0.6)),
                      onPressed: () => onChapterDeleted(ch.id, ch.title),
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    ),
                    Icon(Icons.drag_handle, size: 14,
                        color: theme.colorScheme.onSurfaceVariant.withOpacity(0.3)),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
