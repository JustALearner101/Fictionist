import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fictionist/presentation/features/manuscript/provider/writing_preferences_provider.dart';

/// Whether the editor has unsaved local changes.
enum SaveStatus { saved, editing, saving }

class EditorStatusBar extends ConsumerWidget {
  final int wordCount;
  final int charCount;
  final String? chapterTitle;
  final bool isSaving;
  final bool hasUnsavedChanges;

  const EditorStatusBar({
    super.key,
    required this.wordCount,
    required this.charCount,
    this.chapterTitle,
    this.isSaving = false,
    this.hasUnsavedChanges = false,
  });

  SaveStatus get _status {
    if (isSaving) return SaveStatus.saving;
    if (hasUnsavedChanges) return SaveStatus.editing;
    return SaveStatus.saved;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(writingPreferencesProvider);
    final theme = Theme.of(context);
    final readingTime = (wordCount / 200).ceil();
    final status = _status;

    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.08),
          ),
        ),
      ),
      child: Row(
        children: [
          // Chapter title (truncated)
          if (chapterTitle != null) ...[
            Flexible(
              child: Text(
                chapterTitle!,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                  fontSize: 10,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 1,
              height: 12,
              color: theme.colorScheme.outline.withOpacity(0.15),
            ),
            const SizedBox(width: 12),
          ],
          // Word count (animated)
          Icon(
            Icons.text_fields,
            size: 10,
            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.4),
          ),
          const SizedBox(width: 4),
          TweenAnimationBuilder<int>(
            tween: IntTween(begin: 0, end: wordCount),
            duration: const Duration(milliseconds: 500),
            builder: (context, value, _) => Text(
              '$value words',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                fontSize: 10,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Reading time
          Icon(
            Icons.timer_outlined,
            size: 10,
            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.4),
          ),
          const SizedBox(width: 4),
          Text(
            '${readingTime}m read',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
              fontSize: 10,
            ),
          ),
          const Spacer(),
          // Save status indicator
          _SaveStatusIndicator(status: status),
          const SizedBox(width: 12),
          // Typewriter indicator
          if (prefs.typewriterMode)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.format_align_center,
                  size: 10,
                  color: theme.colorScheme.primary.withOpacity(0.6),
                ),
                const SizedBox(width: 4),
                Text(
                  'Typewriter',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary.withOpacity(0.6),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _SaveStatusIndicator extends StatelessWidget {
  final SaveStatus status;

  const _SaveStatusIndicator({required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    switch (status) {
      case SaveStatus.saving:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 10,
              height: 10,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                color: Colors.amber.shade600,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              'Saving',
              style: theme.textTheme.labelSmall?.copyWith(
                color: Colors.amber.shade600,
                fontSize: 10,
              ),
            ),
          ],
        );
      case SaveStatus.editing:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.circle, size: 8, color: Colors.amber.shade600),
            const SizedBox(width: 4),
            Text(
              '● Editing',
              style: theme.textTheme.labelSmall?.copyWith(
                color: Colors.amber.shade600,
                fontSize: 10,
              ),
            ),
          ],
        );
      case SaveStatus.saved:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, size: 12, color: Colors.green.shade600),
            const SizedBox(width: 4),
            Text(
              '✓ Saved',
              style: theme.textTheme.labelSmall?.copyWith(
                color: Colors.green.shade600,
                fontSize: 10,
              ),
            ),
          ],
        );
    }
  }
}
