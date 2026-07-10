import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fictionist/presentation/features/manuscript/provider/writing_preferences_provider.dart';

class EditorStatusBar extends ConsumerWidget {
  final int wordCount;
  final int charCount;
  final String? chapterTitle;

  const EditorStatusBar({
    super.key,
    required this.wordCount,
    required this.charCount,
    this.chapterTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(writingPreferencesProvider);
    final theme = Theme.of(context);
    final readingTime = (wordCount / 200).ceil();

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
