import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:fictionist/data/compiler/manuscript_compiler.dart';
import 'package:fictionist/domain/manuscript/compile_format.dart';
import 'package:fictionist/domain/manuscript/manuscript_chapter.dart';
import 'package:fictionist/domain/use_case/entity/list_entities_use_case.dart';
import 'package:fictionist/injection.dart';
import 'package:fictionist/presentation/common/widget/confirm_dialog.dart';
import 'package:fictionist/presentation/features/entity/widget/entity_peek_sheet.dart';
import 'package:fictionist/presentation/features/manuscript/provider/manuscript_provider.dart';
import 'package:fictionist/presentation/features/manuscript/provider/snapshot_provider.dart';
import 'package:fictionist/presentation/features/manuscript/provider/writing_preferences_provider.dart';
import 'package:fictionist/presentation/features/manuscript/widget/dashboard_view.dart';
import 'package:fictionist/presentation/features/manuscript/widget/editor_status_bar.dart';
import 'package:fictionist/presentation/features/manuscript/widget/global_search_sheet.dart';
import 'package:fictionist/presentation/features/manuscript/widget/minimal_toolbar.dart';
import 'package:fictionist/presentation/features/manuscript/widget/quill_editor_widget.dart';
import 'package:fictionist/presentation/features/manuscript/widget/snapshot_history_sheet.dart';
import 'package:fictionist/presentation/features/manuscript/widget/visual_book_preview.dart';
import 'package:fictionist/presentation/features/manuscript/widget/writing_stats_bar.dart';
import 'package:fictionist/domain/entity/entity_type.dart';
import 'package:fictionist/domain/entity/entity.dart';
import 'package:fictionist/presentation/features/entity/provider/entity_list_provider.dart';
import 'package:share_plus/share_plus.dart';



/// Full-screen, distraction-free chapter editor.
///
/// Shown outside the [AppScaffold] shell so the bottom nav bar is hidden.
/// All editing tools remain: formatting toolbar, synopsis, status, undo,
/// snapshot history, preview, global search, codex panel, and compile.
class ChapterEditorScreen extends ConsumerStatefulWidget {
  final String chapterId;

  const ChapterEditorScreen({super.key, required this.chapterId});

  @override
  ConsumerState<ChapterEditorScreen> createState() =>
      _ChapterEditorScreenState();
}

class _ChapterEditorScreenState extends ConsumerState<ChapterEditorScreen> {
  final _titleController = TextEditingController();
  final _synopsisController = TextEditingController();

  String _currentContent = '';
  DateTime? _lastEdited;
  ChapterStatus _currentStatus = ChapterStatus.draft;
  bool _showPreview = false;
  bool _showCodexDrawer = false;
  bool _toolbarExpanded = false;
  bool _isSaving = false;
  bool _hasUnsavedChanges = false;
  bool _initialized = false;
  bool _zenMode = false;

  QuillController? _quillController;

  final ValueNotifier<int> _wordCount = ValueNotifier(0);
  final ValueNotifier<int> _charCount = ValueNotifier(0);

  final List<String> _undoStack = [];
  int _editorVersion = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initChapter());
  }

  void _initChapter() {
    if (_initialized) return;
    final state = ref.read(manuscriptNotifierProvider);
    final chapter = state.chapters.where((c) => c.id == widget.chapterId).firstOrNull;
    if (chapter != null) {
      _titleController.text = chapter.title;
      _synopsisController.text = chapter.synopsis ?? '';
      _currentContent = chapter.content;
      _currentStatus = chapter.status;
      _lastEdited = chapter.updatedAt;
      _initialized = true;
      setState(() {});
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _synopsisController.dispose();
    _wordCount.dispose();
    _charCount.dispose();
    super.dispose();
  }

  // ─── Persistence ──────────────────────────────────────────────────────────

  void _saveContent() {
    _isSaving = true;
    _hasUnsavedChanges = false;
    ref.read(manuscriptNotifierProvider.notifier)
        .updateChapterContent(widget.chapterId, _currentContent);
    ref.read(manuscriptNotifierProvider.notifier)
        .updateChapterTitle(widget.chapterId, _titleController.text);
    _isSaving = false;
  }

  void _saveSynopsis() {
    final synopsis = _synopsisController.text.trim();
    ref.read(manuscriptNotifierProvider.notifier).updateChapterSynopsis(
      widget.chapterId,
      synopsis.isEmpty ? null : synopsis,
    );
  }

  // ─── Status cycle ─────────────────────────────────────────────────────────

  // (tracked locally in _currentStatus)
  void _cycleStatus() {
    final next = ChapterStatus.values[
        (_currentStatus.index + 1) % ChapterStatus.values.length];
    _currentStatus = next;
    ref.read(manuscriptNotifierProvider.notifier)
        .updateChapterStatus(widget.chapterId, next);
    setState(() {});
    HapticFeedback.lightImpact();
  }

  // ─── Undo ─────────────────────────────────────────────────────────────────

  void _pushUndoState() {
    if (_currentContent.isEmpty) return;
    if (_undoStack.isNotEmpty && _undoStack.last == _currentContent) return;
    _undoStack.add(_currentContent);
    if (_undoStack.length > 50) _undoStack.removeAt(0);
  }

  void _performUndo() {
    if (_undoStack.isEmpty) return;
    final prev = _undoStack.removeLast();
    if (_currentContent.isNotEmpty && _currentContent != prev) {
      _undoStack.add(_currentContent);
    }
    _currentContent = prev;
    _editorVersion++;
    _hasUnsavedChanges = true;
    _saveContent();
    setState(() {});
  }

  // ─── Actions ──────────────────────────────────────────────────────────────

  void _showSearch() {
    _saveContent();
    final state = ref.read(manuscriptNotifierProvider);
    GlobalSearchSheet.show(
      context,
      chapters: state.chapters,
      onChapterSelected: (_) {},
      onReplaceAll: (query, replacement) async {
        await ref.read(manuscriptNotifierProvider.notifier)
            .replaceAll(query, replacement);
      },
    );
  }

  Future<void> _showSnapshotHistory() async {
    _saveContent();
    final snapshots = await loadSnapshots(widget.chapterId);
    if (!mounted) return;
    SnapshotHistorySheet.show(
      context,
      snapshots: snapshots,
      currentContent: _currentContent,
      onRestore: (snapshot) {
        _currentContent = snapshot.content;
        ref.read(manuscriptNotifierProvider.notifier).updateChapterContent(
          widget.chapterId,
          snapshot.content,
        );
        setState(() {});
      },
    );
  }

  Future<void> _compileAndExport() async {
    _saveContent();
    final format = await showDialog<CompileFormat>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          'Compile Manuscript',
          style: Theme.of(context).textTheme.titleMedium!
              .copyWith(color: Theme.of(context).colorScheme.primary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: CompileFormat.values.map((fmt) => ListTile(
            leading: Icon(
              fmt == CompileFormat.epub ? Icons.book
                  : fmt == CompileFormat.pdf ? Icons.picture_as_pdf
                  : Icons.text_snippet,
            ),
            title: Text(fmt.label),
            onTap: () => Navigator.pop(ctx, fmt),
          )).toList(),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        ],
      ),
    );
    if (format == null || !mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Row(children: [
        SizedBox(width: 16, height: 16,
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
        SizedBox(width: 12), Text('Compiling...'),
      ]),
      duration: Duration(seconds: 10),
    ));

    final state = ref.read(manuscriptNotifierProvider);
    final compiler = getIt<ManuscriptCompiler>();
    final result = await compiler.compile(CompileManuscriptParams(
      chapterIds: state.chapters.map((c) => c.id).toList(),
      bookTitle: _titleController.text,
      authorName: '',
      format: format,
      includeAppendix: true,
    ));

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    result.fold(
      (f) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Compile failed: ${f.message}'),
        backgroundColor: Theme.of(context).colorScheme.error,
      )),
      (path) async => Share.shareXFiles([XFile(path)], subject: 'Manuscript'),
    );
  }

  Future<void> _deleteChapter() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => ConfirmDialog(
        title: 'Delete Chapter',
        content: 'Delete "${_titleController.text}"? This cannot be undone.',
        confirmLabel: 'Delete',
        isDestructive: true,
      ),
    );
    if (confirm == true && mounted) {
      await ref.read(manuscriptNotifierProvider.notifier)
          .deleteChapter(widget.chapterId);
      if (mounted) context.pop();
    }
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final prefs = ref.watch(writingPreferencesProvider);
    final entities = ref.watch(entityListProvider).valueOrNull ?? [];
    // ponytail: read not watch — provider updates from _saveContent()
    // would rebuild QuillEditor on every keystroke, killing keyboard focus.
    // ceiling: stale entity names if renamed externally. upgrade: watch() with debounce.
    final manuscriptState = ref.read(manuscriptNotifierProvider);

    // Keep title/content in sync if another device/notifier updates
    final chapter = manuscriptState.chapters
        .where((c) => c.id == widget.chapterId)
        .firstOrNull;
    if (chapter != null && !_initialized) {
      _titleController.text = chapter.title;
      _synopsisController.text = chapter.synopsis ?? '';
      _currentContent = chapter.content;
      _currentStatus = chapter.status;
      _lastEdited = chapter.updatedAt;
      _initialized = true;
    }

    final wordCount = _currentContent
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .length;
    final status = _currentStatus;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar ────────────────────────────────────────────────────
            if (!_zenMode)
              _EditorTopBar(
                status: status,
                showPreview: _showPreview,
                showCodex: _showCodexDrawer,
                showZen: _zenMode,
                canUndo: _undoStack.isNotEmpty,
                onBack: () {
                  _saveContent();
                  context.pop();
                },
                onCycleStatus: _cycleStatus,
                onTogglePreview: () => setState(() => _showPreview = !_showPreview),
                onToggleCodex: () => setState(() => _showCodexDrawer = !_showCodexDrawer),
                onToggleZen: () => setState(() => _zenMode = !_zenMode),
                onUndo: _performUndo,
                onSearch: _showSearch,
                onHistory: _showSnapshotHistory,
                onCompile: _compileAndExport,
                onDelete: _deleteChapter,
                onDashboard: () => showDashboardSheet(context, ref),
                onPreferences: _showPreferencesSheet,
              ),

            // ── Title + Synopsis card ────────────────────────────────────
            if (!_zenMode)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 14, 12, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title row + status chip
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _titleController,
                              style: theme.textTheme.headlineMedium!.copyWith(
                                fontFamily: Theme.of(context).textTheme.displayLarge?.fontFamily,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Chapter Title',
                                hintStyle:
                                    theme.textTheme.headlineMedium!.copyWith(
                                  fontFamily: Theme.of(context).textTheme.displayLarge?.fontFamily,
                                  fontSize: 20,
                                  color: theme.colorScheme.onSurfaceVariant
                                      .withOpacity(0.35),
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 4),
                              ),
                              onChanged: (_) => _saveContent(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: _cycleStatus,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: _statusColor(status, theme)
                                    .withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: _statusColor(status, theme)
                                      .withOpacity(0.4),
                                ),
                              ),
                              child: Text(
                                status.label,
                                style: theme.textTheme.labelSmall!.copyWith(
                                  color: _statusColor(status, theme),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Synopsis
                      TextField(
                        controller: _synopsisController,
                        style: theme.textTheme.bodySmall!.copyWith(
                          fontStyle: FontStyle.italic,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Synopsis...',
                          hintStyle: theme.textTheme.bodySmall!.copyWith(
                            fontStyle: FontStyle.italic,
                            color: theme.colorScheme.onSurfaceVariant
                                .withOpacity(0.35),
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 2),
                        ),
                        maxLines: 2,
                        onChanged: (_) => _saveSynopsis(),
                      ),
                      const SizedBox(height: 4),
                      // POV + Location quick picks
                      _PovLocationRow(chapterId: widget.chapterId),
                      const SizedBox(height: 2),
                      WritingStatsBar(
                        wordCountNotifier: _wordCount,
                        charCountNotifier: _charCount,
                        lastEdited: _lastEdited,
                      ),
                    ],
                  ),
                ),
              ),

            // ── Editor + Codex drawer ──────────────────────────────────────
            Expanded(
              child: Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  Positioned.fill(
                    child: _showPreview
                        ? VisualBookPagePreview(
                            title: _titleController.text.isNotEmpty
                                ? _titleController.text
                                : 'Chapter Untitled',
                            content: _currentContent,
                          )
                        : QuillEditorWidget(
                            key: ValueKey(
                                '${widget.chapterId}_v$_editorVersion'),
                            initialContent: _currentContent,
                            typewriterMode: prefs.typewriterMode,
                            layoutMode: prefs.layoutMode,
                            focusHighlight: prefs.focusHighlight,
                            editorFontSize: prefs.editorFontSize,
                            entities: entities,
                            onEntityLinkTapped: (entityId) {
                              showEntityPeekSheet(context, entityId: entityId);
                            },
                            onControllerReady: (c) {
                              _quillController = c;
                            },
                            onContentChanged: (content) {
                              _pushUndoState();
                              _currentContent = content;
                              _hasUnsavedChanges = true;
                              _saveContent();
                              _wordCount.value = content
                                  .split(RegExp(r'\s+'))
                                  .where((w) => w.isNotEmpty)
                                  .length;
                              _charCount.value = content.length;
                            },
                          ),
                  ),
                  // ── Codex overlay (slides in from right) ──────────────
                  if (!_zenMode)
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 280),
                      curve: Curves.easeInOut,
                      right: _showCodexDrawer ? 0 : -300,
                      top: 0,
                      bottom: 0,
                      width: 300,
                      child: _CodexPanel(
                        onClose: () => setState(
                            () => _showCodexDrawer = false),
                      ),
                    ),
                  
                  // ── Zen Mode Overlay Elements ──────────────
                  if (_zenMode) ...[
                    // Floating button to exit Zen Mode
                    Positioned(
                      top: 16,
                      right: 16,
                      child: FloatingActionButton.small(
                        backgroundColor: theme.colorScheme.surface.withOpacity(0.85),
                        foregroundColor: theme.colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: theme.colorScheme.outline.withOpacity(0.2)),
                        ),
                        onPressed: () => setState(() => _zenMode = false),
                        child: const Icon(Icons.close_fullscreen_rounded, size: 18),
                      ),
                    ),
                    
                    // Floating glassmorphic stats / toolbar
                    Positioned(
                      bottom: 24,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: theme.colorScheme.outline.withOpacity(0.25)),
                            boxShadow: [
                              BoxShadow(
                                color: theme.colorScheme.primary.withOpacity(0.08),
                                blurRadius: 16,
                                spreadRadius: 1,
                                offset: const Offset(0, 4),
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.auto_awesome_rounded, size: 14, color: theme.colorScheme.primary),
                              const SizedBox(width: 8),
                              ValueListenableBuilder<int>(
                                valueListenable: _wordCount,
                                builder: (_, count, __) => Text(
                                  '$count words',
                                  style: theme.textTheme.labelMedium!.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(width: 1, height: 14, color: theme.colorScheme.outline.withOpacity(0.3)),
                              const SizedBox(width: 12),
                              Text(
                                'Zen Mode',
                                style: theme.textTheme.labelMedium!.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // ── Bottom toolbar bar ───────────────────────────────────────
            if (_quillController != null && !_zenMode) _BottomToolbarBar(
              controller: _quillController!,
              expanded: _toolbarExpanded,
              onToggle: () =>
                  setState(() => _toolbarExpanded = !_toolbarExpanded),
            ),

            // ── Status Bar ─────────────────────────────────────────────────
            if (!_zenMode)
              EditorStatusBar(
                wordCountNotifier: _wordCount,
                charCountNotifier: _charCount,
                chapterTitle: _titleController.text.isNotEmpty
                    ? _titleController.text
                    : null,
                isSaving: _isSaving,
                hasUnsavedChanges: _hasUnsavedChanges,
              ),
          ],
        ),
      ),
    );
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

  void _showPreferencesSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final theme = Theme.of(ctx);
        return Consumer(
          builder: (context, ref, _) {
            final prefs = ref.watch(writingPreferencesProvider);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Editor Settings',
                        style: theme.textTheme.titleMedium!.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 8),
                  
                  // Typewriter mode
                  SwitchListTile(
                    title: const Text('Typewriter Mode', style: TextStyle(fontSize: 14)),
                    subtitle: const Text('Keep active cursor centered vertically', style: TextStyle(fontSize: 11)),
                    value: prefs.typewriterMode,
                    onChanged: (val) {
                      ref.read(writingPreferencesProvider.notifier).update(
                            (p) => p.copyWith(typewriterMode: val),
                          );
                    },
                  ),
                  
                  // Layout mode
                  const SizedBox(height: 12),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('Layout Comfort Mode', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: 'normal', label: Text('Normal', style: TextStyle(fontSize: 12))),
                        ButtonSegment(value: 'comfort', label: Text('Comfort', style: TextStyle(fontSize: 12))),
                        ButtonSegment(value: 'book', label: Text('Book', style: TextStyle(fontSize: 12))),
                      ],
                      selected: {prefs.layoutMode},
                      onSelectionChanged: (val) {
                        ref.read(writingPreferencesProvider.notifier).update(
                              (p) => p.copyWith(layoutMode: val.first),
                            );
                      },
                    ),
                  ),

                  // ADHD Focus highlighting
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('ADHD Focus Highlight', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: 'none', label: Text('None', style: TextStyle(fontSize: 12))),
                        ButtonSegment(value: 'sentence', label: Text('Sentence', style: TextStyle(fontSize: 12))),
                        ButtonSegment(value: 'paragraph', label: Text('Paragraph', style: TextStyle(fontSize: 12))),
                      ],
                      selected: {prefs.focusHighlight},
                      onSelectionChanged: (val) {
                        ref.read(writingPreferencesProvider.notifier).update(
                              (p) => p.copyWith(focusHighlight: val.first),
                            );
                      },
                    ),
                  ),

                  // Font Size
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('Font Size', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 16),
                      Expanded(
                        child: Slider(
                          value: prefs.editorFontSize,
                          min: 12.0,
                          max: 24.0,
                          divisions: 12,
                          onChanged: (val) {
                            ref.read(writingPreferencesProvider.notifier).update(
                                  (p) => p.copyWith(editorFontSize: val),
                                );
                          },
                        ),
                      ),
                      Text('${prefs.editorFontSize.round()} px', style: const TextStyle(fontSize: 12)),
                      const SizedBox(width: 16),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// ─── Top Bar ────────────────────────────────────────────────────────────────

class _EditorTopBar extends StatelessWidget {
  final ChapterStatus status;
  final bool showPreview;
  final bool showCodex;
  final bool showZen;
  final bool canUndo;
  final VoidCallback onBack;
  final VoidCallback onCycleStatus;
  final VoidCallback onTogglePreview;
  final VoidCallback onToggleCodex;
  final VoidCallback onToggleZen;
  final VoidCallback onUndo;
  final VoidCallback onSearch;
  final VoidCallback onHistory;
  final VoidCallback onCompile;
  final VoidCallback onDelete;
  final VoidCallback onDashboard;
  final VoidCallback onPreferences;

  const _EditorTopBar({
    required this.status,
    required this.showPreview,
    required this.showCodex,
    required this.showZen,
    required this.canUndo,
    required this.onBack,
    required this.onCycleStatus,
    required this.onTogglePreview,
    required this.onToggleCodex,
    required this.onToggleZen,
    required this.onUndo,
    required this.onSearch,
    required this.onHistory,
    required this.onCompile,
    required this.onDelete,
    required this.onDashboard,
    required this.onPreferences,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final primary = theme.colorScheme.primary;

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.08),
          ),
        ),
      ),
      child: Row(
        children: [
          // Back
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new, size: 18, color: onSurface),
            tooltip: 'Back to Manuscript',
            onPressed: onBack,
            visualDensity: VisualDensity.compact,
          ),

          const Spacer(),

          // Undo
          IconButton(
            icon: Icon(Icons.undo, size: 20,
                color: canUndo ? onSurface : onSurface.withOpacity(0.3)),
            tooltip: 'Undo',
            onPressed: canUndo ? onUndo : null,
            visualDensity: VisualDensity.compact,
          ),

          // Search
          IconButton(
            icon: Icon(Icons.search, size: 20, color: onSurface),
            tooltip: 'Find & Replace',
            onPressed: onSearch,
            visualDensity: VisualDensity.compact,
          ),

          // Preview
          IconButton(
            icon: Icon(
              showPreview ? Icons.chrome_reader_mode : Icons.chrome_reader_mode_outlined,
              size: 20, color: showPreview ? primary : onSurface,
            ),
            tooltip: showPreview ? 'Edit Mode' : 'Book Preview',
            onPressed: onTogglePreview,
            visualDensity: VisualDensity.compact,
          ),

          // Codex panel
          IconButton(
            icon: Icon(
              showCodex ? Icons.menu_book : Icons.menu_book_outlined,
              size: 20, color: showCodex ? primary : onSurface,
            ),
            tooltip: showCodex ? 'Hide Codex' : 'Open Codex',
            onPressed: onToggleCodex,
            visualDensity: VisualDensity.compact,
          ),

          // Zen Mode
          IconButton(
            icon: Icon(
              showZen ? Icons.fullscreen_exit_rounded : Icons.fullscreen_rounded,
              size: 22, color: showZen ? primary : onSurface,
            ),
            tooltip: showZen ? 'Normal Mode' : 'Zen Mode',
            onPressed: onToggleZen,
            visualDensity: VisualDensity.compact,
          ),

          // Overflow menu
          PopupMenuButton<String>(
            icon: Icon(Icons.more_horiz, size: 20, color: onSurface),
            tooltip: 'More',
            color: theme.colorScheme.surface,
            onSelected: (val) {
              switch (val) {
                case 'preferences': onPreferences();
                case 'history': onHistory();
                case 'compile': onCompile();
                case 'dashboard': onDashboard();
                case 'delete': onDelete();
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'preferences',
                child: ListTile(dense: true, leading: Icon(Icons.tune), title: Text('Editor Settings'))),
              const PopupMenuItem(value: 'history',
                child: ListTile(dense: true, leading: Icon(Icons.history), title: Text('Snapshot History'))),
              const PopupMenuItem(value: 'compile',
                child: ListTile(dense: true, leading: Icon(Icons.file_download_outlined), title: Text('Compile & Export'))),
              const PopupMenuItem(value: 'dashboard',
                child: ListTile(dense: true, leading: Icon(Icons.bar_chart), title: Text('Dashboard'))),
              const PopupMenuDivider(),
              const PopupMenuItem(value: 'delete',
                child: ListTile(dense: true, leading: Icon(Icons.delete_outline, color: Colors.redAccent), title: Text('Delete Chapter', style: TextStyle(color: Colors.redAccent)))),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Codex side panel ────────────────────────────────────────────────────────

class _CodexPanel extends ConsumerStatefulWidget {
  final VoidCallback onClose;
  const _CodexPanel({required this.onClose});

  @override
  ConsumerState<_CodexPanel> createState() => _CodexPanelState();
}

class _CodexPanelState extends ConsumerState<_CodexPanel> {
  String _filter = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final useCase = getIt<ListEntitiesUseCase>();

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          left: BorderSide(color: theme.colorScheme.outline.withOpacity(0.15)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 8, 6),
            child: Row(
              children: [
                Icon(Icons.menu_book, size: 16, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text('Codex', style: theme.textTheme.titleSmall!.copyWith(
                  fontFamily: theme.textTheme.displayLarge?.fontFamily, fontWeight: FontWeight.bold,
                )),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, size: 16),
                  onPressed: widget.onClose,
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                ),
              ],
            ),
          ),
          // Filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              style: theme.textTheme.bodyMedium!.copyWith(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Filter entities...',
                hintStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5)),
                isDense: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              ),
              onChanged: (v) => setState(() => _filter = v),
            ),
          ),
          const SizedBox(height: 6),
          Divider(height: 1, color: theme.colorScheme.outline.withOpacity(0.1)),
          // Entity list
          Expanded(
            child: FutureBuilder(
              future: useCase(ListEntitiesParams()),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.colorScheme.primary,
                    ),
                  );
                }
                return snapshot.data!.fold(
                  (f) => Center(child: Text('Error: ${f.message}',
                    style: TextStyle(color: theme.colorScheme.error, fontSize: 12))),
                  (entities) {
                    final filtered = _filter.isEmpty ? entities
                        : entities.where((e) => e.name.toLowerCase().contains(_filter.toLowerCase())).toList();
                    if (filtered.isEmpty) {
                      return Center(child: Text('No entities found.',
                        style: theme.textTheme.bodySmall!.copyWith(
                          color: theme.colorScheme.onSurfaceVariant)));
                    }
                    return ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (ctx, i) {
                        final e = filtered[i];
                        return ListTile(
                          dense: true,
                          leading: CircleAvatar(
                            radius: 12,
                            backgroundColor: Color(e.iconColor).withOpacity(0.15),
                            child: Text(e.name.isNotEmpty ? e.name[0].toUpperCase() : '?',
                              style: TextStyle(color: Color(e.iconColor), fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                          title: Text(e.name, style: theme.textTheme.bodyMedium!.copyWith(fontSize: 12)),
                          subtitle: Text(e.type.label, style: theme.textTheme.labelSmall!.copyWith(
                            fontSize: 10, color: theme.colorScheme.onSurfaceVariant)),
                          onTap: () => showEntityPeekSheet(context, entityId: e.id),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Bottom Toolbar (collapsible) ────────────────────────────────────

class _BottomToolbarBar extends StatelessWidget {
  final QuillController controller;
  final bool expanded;
  final VoidCallback onToggle;

  const _BottomToolbarBar({
    required this.controller,
    required this.expanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onToggle,
          child: Container(
            height: 28,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: theme.colorScheme.outline.withOpacity(0.08),
                ),
              ),
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant
                        .withOpacity(0.5),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    expanded ? 'Hide tools' : 'Format',
                    style: theme.textTheme.labelSmall!.copyWith(
                      color: theme.colorScheme.onSurfaceVariant
                          .withOpacity(0.5),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: expanded
              ? MinimalToolbar(controller: controller)
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

/// POV character and Location quick-pick row in the editor header.
class _PovLocationRow extends ConsumerWidget {
  final String chapterId;
  const _PovLocationRow({required this.chapterId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chapter = ref.watch(manuscriptNotifierProvider).chapters
        .where((c) => c.id == chapterId)
        .firstOrNull;
    final entitiesAsync = ref.watch(entityListProvider);
    final theme = Theme.of(context);

    return entitiesAsync.maybeWhen(
      data: (entities) {
        final characters =
            entities.where((e) => e.type == EntityType.character).toList();
        final locations =
            entities.where((e) => e.type == EntityType.location).toList();

        final ch = chapter;
        final povChar = ch?.povCharacterId != null
            ? entities.where((e) => e.id == ch!.povCharacterId).firstOrNull
            : null;
        final loc = ch?.locationId != null
            ? entities.where((e) => e.id == ch!.locationId).firstOrNull
            : null;

        return Row(
          children: [
            _EntityPickChip(
              icon: Icons.person_outline,
              label: povChar?.name ?? 'POV',
              isSet: povChar != null,
              color: povChar != null ? Color(povChar.iconColor) : null,
              entities: characters,
              onSelected: (entity) {
                ref.read(manuscriptNotifierProvider.notifier)
                    .updateChapterPov(chapterId, entity.id);
              },
              onClear: povChar != null
                  ? () => ref.read(manuscriptNotifierProvider.notifier)
                      .updateChapterPov(chapterId, null)
                  : null,
            ),
            const SizedBox(width: 8),
            _EntityPickChip(
              icon: Icons.place_outlined,
              label: loc?.name ?? 'Location',
              isSet: loc != null,
              color: loc != null ? Color(loc.iconColor) : null,
              entities: locations,
              onSelected: (entity) {
                ref.read(manuscriptNotifierProvider.notifier)
                    .updateChapterLocation(chapterId, entity.id);
              },
              onClear: loc != null
                  ? () => ref.read(manuscriptNotifierProvider.notifier)
                      .updateChapterLocation(chapterId, null)
                  : null,
            ),
          ],
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _EntityPickChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSet;
  final Color? color;
  final List<Entity> entities;
  final void Function(Entity) onSelected;
  final VoidCallback? onClear;

  const _EntityPickChip({
    required this.icon,
    required this.label,
    required this.isSet,
    this.color,
    required this.entities,
    required this.onSelected,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => _showPicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: isSet && color != null
              ? color!.withOpacity(0.1)
              : theme.colorScheme.surfaceVariant.withOpacity(0.3),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSet && color != null
                ? color!.withOpacity(0.3)
                : theme.colorScheme.outline.withOpacity(0.15),
          ),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 12,
              color: isSet && color != null
                  ? color
                  : theme.colorScheme.onSurfaceVariant.withOpacity(0.5)),
          const SizedBox(width: 4),
          Text(label,
              style: theme.textTheme.labelSmall?.copyWith(
                fontSize: 10,
                color: isSet && color != null
                    ? color
                    : theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
              )),
          if (onClear != null) ...[
            const SizedBox(width: 4),
            GestureDetector(
              onTap: onClear,
              child: Icon(Icons.close, size: 10,
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.4)),
            ),
          ],
        ]),
      ),
    );
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => ListView(
        shrinkWrap: true,
        children: entities.map((e) => ListTile(
          leading: CircleAvatar(
            radius: 14,
            backgroundColor: Color(e.iconColor).withOpacity(0.15),
            child: Text(e.name[0].toUpperCase(),
                style: TextStyle(color: Color(e.iconColor), fontSize: 12)),
          ),
          title: Text(e.name, style: const TextStyle(fontSize: 14)),
          onTap: () {
            Navigator.pop(ctx);
            onSelected(e);
          },
        )).toList(),
      ),
    );
  }
}
