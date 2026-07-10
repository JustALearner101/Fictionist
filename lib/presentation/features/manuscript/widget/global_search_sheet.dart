import 'package:flutter/material.dart';
import 'package:fictionist/domain/manuscript/manuscript_chapter.dart';

/// Global search & replace across all manuscript chapters.
/// Shows matching snippets with context, chapter name, and replace functionality.
class GlobalSearchSheet extends StatefulWidget {
  final List<ManuscriptChapter> chapters;
  final void Function(String chapterId) onChapterSelected;
  final Future<void> Function(String query, String replacement) onReplaceAll;

  const GlobalSearchSheet({
    super.key,
    required this.chapters,
    required this.onChapterSelected,
    required this.onReplaceAll,
  });

  static void show(
    BuildContext context, {
    required List<ManuscriptChapter> chapters,
    required void Function(String) onChapterSelected,
    required Future<void> Function(String, String) onReplaceAll,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        expand: false,
        builder: (_, scrollController) => GlobalSearchSheet(
          chapters: chapters,
          onChapterSelected: onChapterSelected,
          onReplaceAll: onReplaceAll,
        ),
      ),
    );
  }

  @override
  State<GlobalSearchSheet> createState() => _GlobalSearchSheetState();
}

class _MatchResult {
  final ManuscriptChapter chapter;
  final int matchIndex;
  final int matchStart;
  final int matchEnd;
  final String contextBefore;
  final String contextAfter;

  _MatchResult({
    required this.chapter,
    required this.matchIndex,
    required this.matchStart,
    required this.matchEnd,
    required this.contextBefore,
    required this.contextAfter,
  });
}

class _GlobalSearchSheetState extends State<GlobalSearchSheet> {
  final _searchController = TextEditingController();
  final _replaceController = TextEditingController();
  List<_MatchResult> _results = [];
  bool _showReplace = false;
  bool _replacing = false;

  @override
  void dispose() {
    _searchController.dispose();
    _replaceController.dispose();
    super.dispose();
  }

  void _search(String query) {
    if (query.isEmpty) {
      setState(() => _results = []);
      return;
    }

    final lower = query.toLowerCase();
    final results = <_MatchResult>[];
    final contextLen = 30;

    for (final chapter in widget.chapters) {
      final content = chapter.content;
      int searchFrom = 0;
      while (true) {
        final idx = content.toLowerCase().indexOf(lower, searchFrom);
        if (idx == -1) break;

        final start = (idx - contextLen).clamp(0, content.length);
        final end = (idx + query.length + contextLen).clamp(0, content.length);

        results.add(_MatchResult(
          chapter: chapter,
          matchIndex: results.length,
          matchStart: idx,
          matchEnd: idx + query.length,
          contextBefore: content.substring(start, idx),
          contextAfter: content.substring(idx + query.length, end),
        ));

        searchFrom = idx + query.length;
        if (results.length > 100) break; // Cap at 100 results
      }
    }

    setState(() => _results = results);
  }

  Future<void> _replaceAll() async {
    final query = _searchController.text;
    final replacement = _replaceController.text;
    if (query.isEmpty) return;

    setState(() => _replacing = true);
    try {
      await widget.onReplaceAll(query, replacement);
      if (mounted) {
        _searchController.clear();
        setState(() {
          _results = [];
          _replacing = false;
          _showReplace = false;
        });
        Navigator.pop(context);
      }
    } catch (_) {
      if (mounted) setState(() => _replacing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.surface,
      child: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    style: theme.textTheme.bodyLarge,
                    decoration: InputDecoration(
                      hintText: 'Search all chapters...',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                _search('');
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      isDense: true,
                    ),
                    onChanged: _search,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    _showReplace ? Icons.find_replace : Icons.find_replace_outlined,
                    color: _showReplace
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                  tooltip: 'Replace',
                  onPressed: () => setState(() => _showReplace = !_showReplace),
                ),
              ],
            ),
          ),

          // Result count
          if (_searchController.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${_results.length} match${_results.length == 1 ? '' : 'es'}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),

          // Results list
          Expanded(
            child: _results.isEmpty && _searchController.text.isNotEmpty
                ? Center(
                    child: Text(
                      'No matches found.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _results.length,
                    itemBuilder: (context, index) {
                      final r = _results[index];
                      return _ResultTile(
                        result: r,
                        query: _searchController.text,
                        theme: theme,
                        onTap: () {
                          Navigator.pop(context);
                          widget.onChapterSelected(r.chapter.id);
                        },
                      );
                    },
                  ),
          ),

          // Replace bar
          if (_showReplace) ...[
            Divider(height: 1, color: theme.colorScheme.outline.withOpacity(0.1)),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _replaceController,
                      style: theme.textTheme.bodyMedium,
                      decoration: InputDecoration(
                        hintText: 'Replace with...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _replacing || _results.isEmpty ? null : _replaceAll,
                    child: _replacing
                        ? const SizedBox(
                            width: 16, height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Replace All'),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ResultTile extends StatelessWidget {
  final _MatchResult result;
  final String query;
  final ThemeData theme;
  final VoidCallback onTap;

  const _ResultTile({
    required this.result,
    required this.query,
    required this.theme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chapter name
            Row(
              children: [
                Icon(Icons.article_outlined, size: 14,
                    color: theme.colorScheme.primary.withOpacity(0.6)),
                const SizedBox(width: 6),
                Text(
                  result.chapter.title,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // Context snippet with highlighted match
            RichText(
              text: TextSpan(
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 12,
                  fontFamily: 'monospace',
                ),
                children: [
                  TextSpan(text: _truncateLeft(result.contextBefore)),
                  TextSpan(
                    text: query,
                    style: TextStyle(
                      backgroundColor: Colors.amber.withOpacity(0.4),
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: _truncateRight(result.contextAfter)),
                ],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  String _truncateLeft(String text) {
    if (text.length <= 30) return text;
    return '…${text.substring(text.length - 30)}';
  }

  String _truncateRight(String text) {
    if (text.length <= 30) return text;
    return '${text.substring(0, 30)}…';
  }
}
