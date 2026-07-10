// File: lib/presentation/features/manuscript/widget/corkboard_view.dart
import 'package:flutter/material.dart';
import 'package:fictionist/domain/manuscript/manuscript_chapter.dart';

/// Scrivener-style corkboard grid of chapter cards.
///
/// Displays chapters as cards in a wrap layout with:
/// - Colored top bar cycling through a palette per index
/// - Number badge, title (bold, 2 lines max), word count, synopsis snippet
/// - Selected: blue border + subtle scale
/// - Long-press drag to reorder
/// - Empty state when no chapters
class CorkboardView extends StatelessWidget {
  final List<ManuscriptChapter> chapters;
  final String? selectedChapterId;
  final void Function(String id) onChapterSelected;
  final void Function(int oldIndex, int newIndex) onReorder;

  const CorkboardView({
    super.key,
    required this.chapters,
    required this.selectedChapterId,
    required this.onChapterSelected,
    required this.onReorder,
  });

  /// Cycling color palette for the top accent bar.
  static const _accentColors = [
    Color(0xFFD32F2F), // red
    Color(0xFFE65100), // deep orange
    Color(0xFFF9A825), // amber/gold
    Color(0xFF2E7D32), // green
    Color(0xFF00838F), // teal
    Color(0xFF1565C0), // blue
    Color(0xFF6A1B9A), // purple
    Color(0xFFAD1457), // pink
    Color(0xFF4E342E), // brown
    Color(0xFF37474F), // blue-grey
  ];

  Color _colorForIndex(int index) => _accentColors[index % _accentColors.length];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (chapters.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.dashboard_outlined,
                size: 48,
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.3),
              ),
              const SizedBox(height: 16),
              Text(
                'No chapters yet',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Create a chapter to see it on the corkboard',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.35),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(12),
      child: ReorderableWrap(
        spacing: 12,
        runSpacing: 12,
        onReorder: onReorder,
        children: List.generate(chapters.length, (index) {
          final ch = chapters[index];
          final isSelected = ch.id == selectedChapterId;
          final wordCount = ch.content
              .split(RegExp(r'\s+'))
              .where((w) => w.isNotEmpty)
              .length;

          return AnimatedScale(
            key: ValueKey(ch.id),
            duration: const Duration(milliseconds: 200),
            scale: isSelected ? 1.02 : 1.0,
            child: _CorkboardCard(
              chapter: ch,
              index: index,
              isSelected: isSelected,
              accentColor: _colorForIndex(index),
              wordCount: wordCount,
              onTap: () => onChapterSelected(ch.id),
              onLongPressStart: () {
                // Long-press feedback handled by ReorderableWrap
              },
            ),
          );
        }),
      ),
    );
  }
}

/// Individual card on the corkboard.
class _CorkboardCard extends StatelessWidget {
  final ManuscriptChapter chapter;
  final int index;
  final bool isSelected;
  final Color accentColor;
  final int wordCount;
  final VoidCallback onTap;
  final VoidCallback onLongPressStart;

  const _CorkboardCard({
    required this.chapter,
    required this.index,
    required this.isSelected,
    required this.accentColor,
    required this.wordCount,
    required this.onTap,
    required this.onLongPressStart,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      onLongPressStart: (_) => onLongPressStart(),
      child: Container(
        width: 170,
        height: 130,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.4),
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(
                  color: theme.colorScheme.primary,
                  width: 2,
                )
              : Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.1),
                  width: 1,
                ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
            if (isSelected)
              BoxShadow(
                color: theme.colorScheme.primary.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Colored top bar
            Container(
              height: 3,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
            ),
            // Card body
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Number badge + title line
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Number badge
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: accentColor.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: accentColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        // Title
                        Expanded(
                          child: Text(
                            chapter.title,
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.onSurface,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Word count
                    Text(
                      '$wordCount words',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                        fontSize: 10,
                      ),
                    ),
                    const Spacer(),
                    // Synopsis (1 line italic, truncated)
                    if (chapter.synopsis != null &&
                        chapter.synopsis!.isNotEmpty)
                      Text(
                        chapter.synopsis!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: theme.colorScheme.onSurfaceVariant
                              .withOpacity(0.55),
                          fontSize: 10,
                          height: 1.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A wrap-based reorderable grid.
///
/// Wraps [Wrap] with drag-reorder support. Each child must have a [ValueKey].
/// Long-press a child to enter drag mode, then drag to reorder.
class ReorderableWrap extends StatefulWidget {
  final List<Widget> children;
  final void Function(int oldIndex, int newIndex) onReorder;
  final double spacing;
  final double runSpacing;

  const ReorderableWrap({
    super.key,
    required this.children,
    required this.onReorder,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
  });

  @override
  State<ReorderableWrap> createState() => _ReorderableWrapState();
}

class _ReorderableWrapState extends State<ReorderableWrap> {
  int? _draggingIndex;
  Offset? _dragOffset;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Compute grid layout to find target positions
        // We wrap in a Stack so the dragged child can float
        return Stack(
          clipBehavior: Clip.none,
          children: [
            // The underlying wrap
            Wrap(
              spacing: widget.spacing,
              runSpacing: widget.runSpacing,
              children: List.generate(widget.children.length, (i) {
                final child = widget.children[i];

                // Hide the original while dragging
                if (_draggingIndex == i) {
                  return SizedBox(
                    width: 170,
                    height: 130,
                    child: Opacity(
                      opacity: 0.3,
                      child: child,
                    ),
                  );
                }

                return GestureDetector(
                  onLongPressStart: (details) {
                    setState(() {
                      _draggingIndex = i;
                      _dragOffset = details.localPosition;
                    });
                  },
                  onLongPressMoveUpdate: (details) {
                    setState(() {
                      _dragOffset = Offset(
                        details.globalPosition.dx -
                            (context.findRenderObject() as RenderBox)
                                .localToGlobal(Offset.zero)
                                .dx,
                        details.globalPosition.dy -
                            (context.findRenderObject() as RenderBox)
                                .localToGlobal(Offset.zero)
                                .dy,
                      );
                    });
                  },
                  onLongPressEnd: (details) {
                    if (_draggingIndex != null) {
                      // Calculate target index based on drop position
                      final pos = details.globalPosition;
                      final renderBox =
                          context.findRenderObject() as RenderBox;
                      final local = renderBox.globalToLocal(pos);
                      final targetIndex = _findTargetIndex(local);

                      if (targetIndex >= 0 &&
                          targetIndex < widget.children.length &&
                          targetIndex != _draggingIndex) {
                        widget.onReorder(_draggingIndex!, targetIndex);
                      }
                    }
                    setState(() {
                      _draggingIndex = null;
                      _dragOffset = null;
                    });
                  },
                  child: child,
                );
              }),
            ),
            // Floating dragged child
            if (_draggingIndex != null && _dragOffset != null)
              Positioned(
                left: _dragOffset!.dx - 85, // half card width
                top: _dragOffset!.dy - 20,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(12),
                  shadowColor: Colors.black26,
                  child: widget.children[_draggingIndex!],
                ),
              ),
          ],
        );
      },
    );
  }

  int _findTargetIndex(Offset localPosition) {
    // Simple approach: scan children positions
    // We use the drag position to determine where the card would land
    // This is an approximation; in production, track rendered child positions
    final cardWidth = 170.0 + widget.spacing;
    final cardHeight = 130.0 + widget.runSpacing;
    final maxWidth =
        (context.findRenderObject() as RenderBox).size.width;

    final col = (localPosition.dx / cardWidth).floor();
    final row = (localPosition.dy / cardHeight).floor();
    final colsPerRow = (maxWidth / cardWidth).floor().clamp(1, 99);

    final target = row * colsPerRow + col;
    return target.clamp(0, widget.children.length - 1);
  }
}
