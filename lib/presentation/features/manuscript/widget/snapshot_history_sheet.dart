import 'package:flutter/material.dart';

import 'package:fictionist/domain/manuscript/chapter_snapshot.dart';
import 'package:fictionist/core/utils/word_diff.dart';

/// Formats a DateTime to a human-readable string like "Jul 10, 2026 – 2:30 PM".
String _formatDateTime(DateTime dt) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
  final minute = dt.minute.toString().padLeft(2, '0');
  final period = dt.hour >= 12 ? 'PM' : 'AM';
  return '${months[dt.month - 1]} ${dt.day}, ${dt.year} – $hour:$minute $period';
}

/// A bottom sheet that displays a chapter's version history.
/// Each snapshot shows the timestamp, word count, and a preview.
/// Tapping a snapshot reveals its full content; the "Restore" button
/// replaces the editor content with the snapshot's content.
class SnapshotHistorySheet extends StatelessWidget {
  final List<ChapterSnapshot> snapshots;
  final void Function(ChapterSnapshot snapshot) onRestore;
  final String? currentContent;

  const SnapshotHistorySheet({
    super.key,
    required this.snapshots,
    required this.onRestore,
    this.currentContent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Version History',
                  style: theme.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${snapshots.length} snapshot${snapshots.length == 1 ? '' : 's'}',
                  style: theme.textTheme.labelMedium!.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          if (snapshots.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Icon(
                    Icons.history,
                    size: 48,
                    color: colorScheme.onSurfaceVariant.withOpacity(0.4),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No snapshots yet',
                    style: theme.textTheme.bodyLarge!.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Snapshots are automatically saved as you write.',
                    style: theme.textTheme.bodySmall!.copyWith(
                      color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            )
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: snapshots.length,
                separatorBuilder: (_, __) => const Divider(indent: 72),
                itemBuilder: (context, index) {
                  final snapshot = snapshots[index];
                  final wordCount = snapshot.content
                      .split(RegExp(r'\s+'))
                      .where((w) => w.isNotEmpty)
                      .length;
                  final preview = snapshot.content.length > 100
                      ? '${snapshot.content.substring(0, 100)}…'
                      : snapshot.content;

                  final formattedDate = _formatDateTime(snapshot.createdAt);

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 4,
                    ),
                    leading: CircleAvatar(
                      backgroundColor:
                          colorScheme.primary.withOpacity(0.1),
                      child: Icon(
                        Icons.history,
                        color: colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      formattedDate,
                      style: theme.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          '$wordCount words',
                          style: theme.textTheme.labelSmall!.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          preview,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall!.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.visibility_outlined,
                              size: 20),
                          tooltip: 'Preview',
                          onPressed: () =>
                              _showPreviewDialog(context, snapshot),
                        ),
                        IconButton(
                          icon: Icon(Icons.restore, size: 20,
                              color: colorScheme.secondary),
                          tooltip: 'Restore',
                          onPressed: () {
                            onRestore(snapshot);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    onTap: () => _showPreviewDialog(context, snapshot),
                  );
                },
              ),
            ),
          // Bottom spacing for safe area
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }

  Widget _buildDiffView(BuildContext context, String oldText, String newText) {
    final diffs = computeWordDiff(oldText, newText);
    final theme = Theme.of(context);
    final spans = <TextSpan>[];

    for (final diff in diffs) {
      switch (diff.type) {
        case DiffType.equal:
          spans.add(TextSpan(
            text: diff.text,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
            ),
          ));
          break;
        case DiffType.deletion:
          spans.add(TextSpan(
            text: diff.text,
            style: TextStyle(
              color: theme.colorScheme.error,
              backgroundColor: theme.colorScheme.errorContainer.withOpacity(0.3),
              decoration: TextDecoration.lineThrough,
            ),
          ));
          break;
        case DiffType.insertion:
          spans.add(TextSpan(
            text: diff.text,
            style: TextStyle(
              color: theme.colorScheme.primary,
              backgroundColor: theme.colorScheme.primaryContainer.withOpacity(0.3),
              fontWeight: FontWeight.bold,
            ),
          ));
          break;
      }
    }

    return SelectableText.rich(
      TextSpan(children: spans),
      style: theme.textTheme.bodyMedium!.copyWith(height: 1.6),
    );
  }

  void _showPreviewDialog(BuildContext context, ChapterSnapshot snapshot) {
    final theme = Theme.of(context);
    final formattedDate = _formatDateTime(snapshot.createdAt);
    final wordCount = snapshot.content
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .length;

    showDialog(
      context: context,
      builder: (ctx) {
        bool showDiff = currentContent != null;
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: theme.colorScheme.surface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Row(
                children: [
                  Icon(Icons.history,
                      size: 20, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      formattedDate,
                      style: theme.textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$wordCount words · ${snapshot.content.length} chars',
                          style: theme.textTheme.labelMedium!.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        if (currentContent != null)
                          Row(
                            children: [
                              ChoiceChip(
                                label: const Text('Diff', style: TextStyle(fontSize: 11)),
                                selected: showDiff,
                                visualDensity: VisualDensity.compact,
                                onSelected: (val) {
                                  setStateDialog(() => showDiff = val);
                                },
                              ),
                              const SizedBox(width: 6),
                              ChoiceChip(
                                label: const Text('Raw', style: TextStyle(fontSize: 11)),
                                selected: !showDiff,
                                visualDensity: VisualDensity.compact,
                                onSelected: (val) {
                                  setStateDialog(() => showDiff = !val);
                                },
                              ),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 400),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest
                              .withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SingleChildScrollView(
                          child: showDiff && currentContent != null
                              ? _buildDiffView(context, snapshot.content, currentContent!)
                              : SelectableText(
                                  snapshot.content,
                                  style: theme.textTheme.bodyMedium!.copyWith(
                                    height: 1.6,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Close'),
                ),
                FilledButton.icon(
                  icon: const Icon(Icons.restore, size: 18),
                  label: const Text('Restore'),
                  onPressed: () {
                    Navigator.pop(ctx); // Close dialog
                    onRestore(snapshot);
                    Navigator.pop(context); // Close sheet
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Convenience method to show the sheet from anywhere.
  static Future<void> show(
    BuildContext context, {
    required List<ChapterSnapshot> snapshots,
    required void Function(ChapterSnapshot snapshot) onRestore,
    String? currentContent,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.55,
        minChildSize: 0.3,
        maxChildSize: 0.85,
        expand: false,
        builder: (_, scrollController) {
          return SnapshotHistorySheet(
            snapshots: snapshots,
            onRestore: onRestore,
            currentContent: currentContent,
          );
        },
      ),
    );
  }
}
