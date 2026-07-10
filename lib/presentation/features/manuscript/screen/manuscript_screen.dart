import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fictionist/domain/entity/entity.dart';
import 'package:fictionist/domain/use_case/entity/list_entities_use_case.dart';
import 'package:fictionist/injection.dart';
import 'package:fictionist/presentation/common/widget/confirm_dialog.dart';
import 'package:fictionist/presentation/common/widget/empty_state.dart';
import 'package:fictionist/presentation/common/widget/loading_indicator.dart';
import 'package:fictionist/presentation/features/entity/widget/entity_peek_sheet.dart';
import 'package:fictionist/presentation/features/manuscript/provider/manuscript_provider.dart';
import 'package:fictionist/presentation/features/manuscript/provider/writing_preferences_provider.dart';
import 'package:fictionist/presentation/features/manuscript/widget/chapter_sidebar.dart';
import 'package:fictionist/presentation/features/manuscript/widget/quill_editor_widget.dart';
import 'package:fictionist/presentation/features/manuscript/widget/editor_status_bar.dart';
import 'package:fictionist/presentation/features/manuscript/widget/writing_stats_bar.dart';
import 'package:fictionist/presentation/features/manuscript/widget/template_picker.dart';
import 'package:fictionist/presentation/features/manuscript/widget/global_search_sheet.dart';
import 'package:fictionist/presentation/features/manuscript/widget/snapshot_history_sheet.dart';
import 'package:fictionist/presentation/features/manuscript/provider/snapshot_provider.dart';
import 'package:fictionist/presentation/features/manuscript/widget/dashboard_view.dart';
import 'package:fictionist/data/compiler/manuscript_compiler.dart';
import 'package:fictionist/domain/manuscript/compile_format.dart';
import 'package:fictionist/domain/manuscript/manuscript_chapter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;

class ManuscriptScreen extends ConsumerStatefulWidget {
  const ManuscriptScreen({super.key});

  @override
  ConsumerState<ManuscriptScreen> createState() => _ManuscriptScreenState();
}

class _ManuscriptScreenState extends ConsumerState<ManuscriptScreen> {
  final _titleController = TextEditingController();
  final _synopsisController = TextEditingController();
  String? _editingChapterId;
  String _currentContent = '';
  DateTime? _lastEdited;
  bool _showPreview = false;
  bool _showCodexDrawer = false;

  // --- Auto-save tracking ---
  bool _isSaving = false;
  bool _hasUnsavedChanges = false;

  // --- Local undo stack (plain-text snapshots, max 50) ---
  final List<String> _undoStack = [];
  int _editorVersion = 0;

  @override
  void dispose() {
    _titleController.dispose();
    _synopsisController.dispose();
    super.dispose();
  }

  void _selectChapter(String id) {
    final state = ref.read(manuscriptNotifierProvider);
    final chapter = state.chapters.firstWhere((c) => c.id == id);
    _editingChapterId = id;
    _titleController.text = chapter.title;
    _synopsisController.text = chapter.synopsis ?? '';
    _currentContent = chapter.content;
    _lastEdited = chapter.updatedAt;
    // Reset undo stack and save state for new chapter
    _undoStack.clear();
    _editorVersion = 0;
    _isSaving = false;
    _hasUnsavedChanges = false;
    ref.read(manuscriptNotifierProvider.notifier).selectChapter(id);
  }

  Future<void> _createChapter() async {
    final titles = await showTemplatePicker(context);
    if (titles == null || !mounted) return;

    final notifier = ref.read(manuscriptNotifierProvider.notifier);
    final originalCount = ref.read(manuscriptNotifierProvider).chapters.length;

    for (final title in titles) {
      if (title.trim().isEmpty) continue;
      await notifier.createChapter(title.trim());
    }

    // Select the first chapter from the newly created batch
    final state = ref.read(manuscriptNotifierProvider);
    if (originalCount < state.chapters.length) {
      final firstNewChapter = state.chapters[originalCount];
      _selectChapter(firstNewChapter.id);
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

  void _saveCurrentChapter() {
    if (_editingChapterId == null) return;
    final content = _currentContent;
    _isSaving = true;
    _hasUnsavedChanges = false;
    ref.read(manuscriptNotifierProvider.notifier).updateChapterContent(
      _editingChapterId!,
      content,
    );
    ref.read(manuscriptNotifierProvider.notifier).updateChapterTitle(
      _editingChapterId!,
      _titleController.text,
    );
    _isSaving = false;
  }

  void _saveSynopsis() {
    if (_editingChapterId == null) return;
    final synopsis = _synopsisController.text.trim();
    ref.read(manuscriptNotifierProvider.notifier).updateChapterSynopsis(
      _editingChapterId!,
      synopsis.isEmpty ? null : synopsis,
    );
  }

  ChapterStatus _currentChapterStatus() {
    if (_editingChapterId == null) return ChapterStatus.draft;
    final state = ref.read(manuscriptNotifierProvider);
    final chapter = state.chapters.firstWhere(
      (c) => c.id == _editingChapterId,
      orElse: () => state.chapters.first,
    );
    return chapter.status;
  }

  void _cycleStatus() {
    if (_editingChapterId == null) return;
    final current = _currentChapterStatus();
    final next = ChapterStatus.values[
        (current.index + 1) % ChapterStatus.values.length];
    ref.read(manuscriptNotifierProvider.notifier)
        .updateChapterStatus(_editingChapterId!, next);
  }

  /// Undo the last content change by restoring the previous snapshot.
  /// Pushes the current content onto the stack so re-undo keeps cycling.
  void _performUndo() {
    if (_undoStack.isEmpty) return;
    final previousContent = _undoStack.removeLast();
    // Push current content so user can re-undo
    if (_currentContent.isNotEmpty && _currentContent != previousContent) {
      _undoStack.add(_currentContent);
    }
    _currentContent = previousContent;
    _editorVersion++;
    _hasUnsavedChanges = true;
    _saveCurrentChapter();
    setState(() {});
  }

  /// Push the current content to the undo stack before it changes.
  void _pushUndoState() {
    if (_currentContent.isEmpty) return;
    // Don't push duplicates
    if (_undoStack.isNotEmpty && _undoStack.last == _currentContent) return;
    _undoStack.add(_currentContent);
    if (_undoStack.length > 50) {
      _undoStack.removeAt(0);
    }
  }

  void _showSearchSheet() {
    _saveCurrentChapter();
    final state = ref.read(manuscriptNotifierProvider);
    GlobalSearchSheet.show(
      context,
      chapters: state.chapters,
      onChapterSelected: (chapterId) {
        _selectChapter(chapterId);
      },
      onReplaceAll: (query, replacement) async {
        await ref.read(manuscriptNotifierProvider.notifier).replaceAll(query, replacement);
      },
    );
  }

  Future<void> _showSnapshotHistory() async {
    if (_editingChapterId == null) return;
    _saveCurrentChapter();

    final snapshots = await loadSnapshots(_editingChapterId!);
    if (!mounted) return;

    SnapshotHistorySheet.show(
      context,
      snapshots: snapshots,
      onRestore: (snapshot) {
        _currentContent = snapshot.content;
        _titleController.text = ''; // Title stays unchanged on restore
        ref.read(manuscriptNotifierProvider.notifier).updateChapterContent(
          _editingChapterId!,
          snapshot.content,
        );
        setState(() {});
      },
    );
  }

  Future<void> _compileAndExport() async {
    final state = ref.read(manuscriptNotifierProvider);
    if (state.chapters.isEmpty) return;

    _saveCurrentChapter();

    final format = await showDialog<CompileFormat>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Text(
            'Compile Manuscript',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: CompileFormat.values.map((fmt) {
              return ListTile(
                leading: Icon(
                  fmt == CompileFormat.epub
                      ? Icons.book
                      : fmt == CompileFormat.pdf
                          ? Icons.picture_as_pdf
                          : Icons.text_snippet,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                title: Text(fmt.label),
                subtitle: Text(
                  'Export as .${fmt.fileExtension}',
                  style: const TextStyle(fontSize: 12),
                ),
                onTap: () => Navigator.pop(ctx, fmt),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );

    if (format == null || !mounted) return;

    // Show compiling indicator
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 12),
            Text('Compiling manuscript...'),
          ],
        ),
        duration: Duration(seconds: 10),
      ),
    );

    final compiler = getIt<ManuscriptCompiler>();
    final result = await compiler.compile(CompileManuscriptParams(
      chapterIds: state.chapters.map((c) => c.id).toList(),
      bookTitle: 'My Manuscript',
      authorName: '',
      format: format,
      includeAppendix: true,
    ));

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Compile failed: ${failure.message}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      },
      (filePath) async {
        await Share.shareXFiles(
          [XFile(filePath)],
          subject: 'Compiled Manuscript',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(manuscriptNotifierProvider);
    final isMobile = MediaQuery.of(context).size.width < 720;

    // Load editing state on first chapter selection (for desktop)
    if (!isMobile &&
        _editingChapterId == null &&
        state.selectedChapterId != null &&
        state.chapters.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _selectChapter(state.selectedChapterId!);
      });
    }

    if (state.isLoading) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: const Center(
          child: LoadingIndicator(),
        ),
      );
    }

    if (state.chapters.isEmpty) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
          title: Text(
            'Manuscript',
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              fontFamily: 'Lora',
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.dashboard_outlined,
                  color: Theme.of(context).colorScheme.primary),
              tooltip: 'Dashboard',
              onPressed: () => showDashboardSheet(context, ref),
            ),
            IconButton(
              icon: Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
              tooltip: 'New Chapter',
              onPressed: _createChapter,
            ),
          ],
        ),
        body: Center(
          child: EmptyState(
            title: 'No Chapters Yet',
            message: 'Start your manuscript by creating your first chapter.',
            icon: Icons.auto_stories_outlined,
          ),
        ),
      );
    }

    if (isMobile) {
      return _buildMobileLayout(context, state);
    } else {
      return _buildDesktopLayout(context, state);
    }
  }

  /// Shared editor column used by both desktop and mobile layouts.
  Widget _buildEditorArea(BuildContext context) {
    final prefs = ref.watch(writingPreferencesProvider);
    final wordCount =
        _currentContent.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
    return Column(
      children: [
        // Title + Status
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                controller: _titleController,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontFamily: 'Lora',
                  fontSize: 22,
                ),
                decoration: const InputDecoration(
                  hintText: 'Chapter Title',
                  border: InputBorder.none,
                ),
                onChanged: (_) => _saveCurrentChapter(),
              ),
            ),
            if (_editingChapterId != null)
              _StatusCycleButton(
                status: _currentChapterStatus(),
                onTap: _cycleStatus,
              ),
          ],
        ),
        const SizedBox(height: 8),
        // Synopsis
        TextField(
          controller: _synopsisController,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontStyle: FontStyle.italic,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          decoration: InputDecoration(
            hintText: 'Add a brief synopsis...',
            hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontStyle: FontStyle.italic,
              color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.4),
            ),
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.zero,
          ),
          maxLines: 2,
          onChanged: (_) => _saveSynopsis(),
        ),
        const SizedBox(height: 16),
        WritingStatsBar(
          wordCount: wordCount,
          charCount: _currentContent.length,
          lastEdited: _lastEdited,
        ),
        const SizedBox(height: 12),
        // Content
        Expanded(
          child: _showPreview
              ? VisualBookPagePreview(
                  title: _titleController.text.isNotEmpty
                      ? _titleController.text
                      : 'Chapter Untitled',
                  content: _currentContent,
                )
              : _editingChapterId != null
                  ? QuillEditorWidget(
                      key: ValueKey('${_editingChapterId}_v$_editorVersion'),
                      initialContent: _currentContent,
                      typewriterMode: prefs.typewriterMode,
                      onContentChanged: (content) {
                        _pushUndoState();
                        _currentContent = content;
                        _hasUnsavedChanges = true;
                        _saveCurrentChapter();
                      },
                    )
                  : Center(
                      child: Text('Select a chapter to start writing'),
                    ),
        ),
        if (_editingChapterId != null)
          EditorStatusBar(
            wordCount: wordCount,
            charCount: _currentContent.length,
            chapterTitle: _titleController.text.isNotEmpty
                ? _titleController.text
                : null,
            isSaving: _isSaving,
            hasUnsavedChanges: _hasUnsavedChanges,
          ),
      ],
    );
  }

  void _showChapterSheet() {
    final state = ref.read(manuscriptNotifierProvider);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.9,
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
              child: Column(
                children: [
                  // Handle
                  Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 8),
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
                  // Header
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Chapters',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontFamily: 'Lora',
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        TextButton.icon(
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('New'),
                          onPressed: () {
                            Navigator.pop(ctx);
                            _createChapter();
                          },
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  // Chapter list
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: state.chapters.length,
                      itemBuilder: (ctx, index) {
                        final ch = state.chapters[index];
                        final wordCount = ch.content
                            .split(RegExp(r'\s+'))
                            .where((w) => w.isNotEmpty)
                            .length;
                        final isSelected = ch.id == _editingChapterId;
                        return ListTile(
                          selected: isSelected,
                          selectedTileColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.08),
                          leading: CircleAvatar(
                            backgroundColor: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.1),
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: isSelected
                                    ? Theme.of(context).colorScheme.onPrimary
                                    : Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            ch.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontFamily: 'Lora',
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          subtitle: Text(
                            '$wordCount words',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete_outline,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            onPressed: () {
                              Navigator.pop(ctx);
                              _deleteChapter(ch.id, ch.title);
                            },
                          ),
                          onTap: () {
                            _saveCurrentChapter();
                            _selectChapter(ch.id);
                            Navigator.pop(ctx);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMobileLayout(BuildContext context, ManuscriptState state) {
    // Auto-select first chapter if none selected
    if (_editingChapterId == null && state.chapters.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _selectChapter(state.chapters.first.id);
      });
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.list_alt,
              color: Theme.of(context).colorScheme.primary),
          tooltip: 'Chapters',
          onPressed: _showChapterSheet,
        ),
        title: Text(
          _editingChapterId != null && _titleController.text.isNotEmpty
              ? _titleController.text
              : 'Manuscript',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontFamily: 'Lora',
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: Icon(
              _showPreview ? Icons.visibility : Icons.edit_outlined,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            tooltip: _showPreview ? 'Edit' : 'Preview',
            onPressed: () {
              _saveCurrentChapter();
              setState(() => _showPreview = !_showPreview);
            },
          ),
          IconButton(
            icon: Icon(Icons.dashboard_outlined,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
            tooltip: 'Dashboard',
            onPressed: () => showDashboardSheet(context, ref),
          ),
          IconButton(
            icon: Icon(Icons.history,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
            tooltip: 'Version History',
            onPressed: _showSnapshotHistory,
          ),
          IconButton(
            icon: Icon(Icons.file_download_outlined,
                color: Theme.of(context).colorScheme.secondary),
            tooltip: 'Compile & Export',
            onPressed: _compileAndExport,
          ),
        ],
      ),
      body: CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.keyZ, control: true): _performUndo,
        },
        child: _editingChapterId == null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.auto_stories_outlined,
                      size: 64,
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Select a chapter',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      icon: const Icon(Icons.list_alt),
                      label: const Text('Open Chapters'),
                      onPressed: _showChapterSheet,
                    ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildEditorArea(context),
              ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, ManuscriptState state) {
    final prefs = ref.watch(writingPreferencesProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: prefs.distractionFree ? null : AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: Text(
          'Manuscript',
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
            fontFamily: 'Lora',
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Codex drawer toggle
          IconButton(
            icon: Icon(
              _showCodexDrawer
                  ? Icons.menu_book
                  : Icons.menu_book_outlined,
              color: _showCodexDrawer
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            tooltip: 'Codex Drawer',
            onPressed: () {
              setState(() => _showCodexDrawer = !_showCodexDrawer);
            },
          ),
          // Preview toggle
          IconButton(
            icon: Icon(
              _showPreview ? Icons.visibility : Icons.edit_outlined,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            tooltip: _showPreview ? 'Edit' : 'Preview',
            onPressed: () {
              _saveCurrentChapter();
              setState(() => _showPreview = !_showPreview);
            },
          ),
          // Undo
          IconButton(
            icon: Icon(
              Icons.undo,
              color: _undoStack.isNotEmpty
                  ? Theme.of(context).colorScheme.onSurfaceVariant
                  : Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.3),
            ),
            tooltip: 'Undo (Ctrl+Z)',
            onPressed: _undoStack.isNotEmpty ? _performUndo : null,
          ),
          // History
          IconButton(
            icon: Icon(Icons.history,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
            tooltip: 'Version History',
            onPressed: _showSnapshotHistory,
          ),
          // Dashboard
          IconButton(
            icon: Icon(Icons.dashboard_outlined,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
            tooltip: 'Dashboard',
            onPressed: () => showDashboardSheet(context, ref),
          ),
          // Typewriter mode toggle
          IconButton(
            icon: Icon(
              prefs.typewriterMode ? Icons.format_align_center : Icons.format_align_left,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            tooltip: prefs.typewriterMode ? 'Typewriter Mode: ON' : 'Typewriter Mode: OFF',
            onPressed: () {
              ref.read(writingPreferencesProvider.notifier).update(
                (p) => p.copyWith(typewriterMode: !p.typewriterMode),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.search, color: Theme.of(context).colorScheme.onSurfaceVariant),
            tooltip: 'Search All Chapters',
            onPressed: _showSearchSheet,
          ),
          IconButton(
            icon: Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
            tooltip: 'New Chapter',
            onPressed: _createChapter,
          ),
          IconButton(
            icon: Icon(Icons.file_download_outlined,
                color: Theme.of(context).colorScheme.secondary),
            tooltip: 'Compile & Export',
            onPressed: _compileAndExport,
          ),
          // Fullscreen toggle
          IconButton(
            icon: Icon(
              prefs.distractionFree ? Icons.fullscreen_exit : Icons.fullscreen,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            tooltip: prefs.distractionFree ? 'Exit Focus Mode' : 'Focus Mode',
            onPressed: () {
              ref.read(writingPreferencesProvider.notifier).update(
                (p) => p.copyWith(
                  distractionFree: !p.distractionFree,
                  sidebarCollapsed: !p.distractionFree ? true : p.sidebarCollapsed,
                ),
              );
            },
          ),
        ],
      ),
      body: CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.keyZ, control: true): _performUndo,
        },
        child: Row(
        children: [
          if (!prefs.distractionFree)
            ChapterSidebar(
            chapters: state.chapters,
            selectedChapterId: state.selectedChapterId,
            onChapterSelected: (id) {
              _saveCurrentChapter();
              _selectChapter(id);
            },
            onChapterDeleted: (id, title) {
              _deleteChapter(id, title);
            },
            onReorder: (oldIndex, newIndex) {
              ref
                  .read(manuscriptNotifierProvider.notifier)
                  .reorderChapters(oldIndex, newIndex);
            },
          ),
          // Editor area
          Expanded(
            child: prefs.distractionFree
                ? Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 700),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: _buildEditorArea(context),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(20),
                    child: _buildEditorArea(context),
                  ),
          ),
          // Codex drawer
          if (_showCodexDrawer && !prefs.distractionFree) ...[
            Container(width: 1, color: Theme.of(context).colorScheme.outline),
            SizedBox(
              width: 280,
              child: _CodexDrawer(
                onEntityTap: (entity) {
                  showEntityPeekSheet(
                    context,
                    entityId: entity.id,
                  );
                },
              ),
            ),
          ],
        ],
      ),
      ),
    );
  }
}

/// A sliding drawer panel showing all Codex entities for reference
/// while writing.
class _CodexDrawer extends ConsumerStatefulWidget {
  final void Function(Entity entity) onEntityTap;

  const _CodexDrawer({required this.onEntityTap});

  @override
  ConsumerState<_CodexDrawer> createState() => _CodexDrawerState();
}

class _CodexDrawerState extends ConsumerState<_CodexDrawer> {
  String _filter = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Text(
                  'Codex',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 13),
              decoration: const InputDecoration(
                hintText: 'Filter entities...',
                isDense: true,
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              ),
              onChanged: (v) => setState(() => _filter = v),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _EntityList(
              filter: _filter,
              onEntityTap: widget.onEntityTap,
            ),
          ),
        ],
      ),
    );
  }
}

/// Lazy-loading entity list for the codex drawer.
class _EntityList extends ConsumerWidget {
  final String filter;
  final void Function(Entity entity) onEntityTap;

  const _EntityList({
    required this.filter,
    required this.onEntityTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use the existing list entities use case directly
    final useCase = getIt<ListEntitiesUseCase>();
    return FutureBuilder(
      future: useCase(ListEntitiesParams()),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Theme.of(context).colorScheme.primary,
            ),
          );
        }

        return snapshot.data!.fold(
          (failure) => Center(
            child: Text(
              'Error: ${failure.message}',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
          (entities) {
            final filtered = filter.isEmpty
                ? entities
                : entities
                    .where((e) => e.name
                        .toLowerCase()
                        .contains(filter.toLowerCase()))
                    .toList();

            if (filtered.isEmpty) {
              return Center(
                child: Text(
                  'No entities found.',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
              );
            }

            return ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final entity = filtered[index];
                return ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    radius: 12,
                    backgroundColor:
                        Color(entity.iconColor).withOpacity(0.15),
                    child: Text(
                      entity.name.isNotEmpty
                          ? entity.name[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        color: Color(entity.iconColor),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    entity.name,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  subtitle: Text(
                    entity.type.label,
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      fontSize: 10,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  onTap: () => onEntityTap(entity),
                );
              },
            );
          },
        );
      },
    );
  }
}

class ManuscriptEditorScreen extends ConsumerStatefulWidget {
  final String chapterId;

  const ManuscriptEditorScreen({
    super.key,
    required this.chapterId,
  });

  @override
  ConsumerState<ManuscriptEditorScreen> createState() =>
      _ManuscriptEditorScreenState();
}

class _ManuscriptEditorScreenState
    extends ConsumerState<ManuscriptEditorScreen> {
  final _titleController = TextEditingController();
  late String _currentContent;
  bool _showPreview = false;
  QuillController? _editorController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(manuscriptNotifierProvider);
    final chapter = state.chapters.firstWhere((c) => c.id == widget.chapterId);
    _titleController.text = chapter.title;
    _currentContent = chapter.content;
  }

  @override
  void dispose() {
    _editorController?.removeListener(_onEditorTextChanged);
    _titleController.dispose();
    super.dispose();
  }

  void _onEditorTextChanged() {
    if (_editorController == null) return;
    final selection = _editorController!.selection;
    if (!selection.isValid || !selection.isCollapsed) return;

    final text = _editorController!.document.toPlainText();
    final cursorOffset = selection.baseOffset;
    if (cursorOffset >= 2) {
      final lastTwo = text.substring(cursorOffset - 2, cursorOffset);
      if (lastTwo == '[[') {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showInsertWikiLinkDialog();
        });
      }
    }
  }

  Future<void> _showInsertWikiLinkDialog() async {
    final useCase = getIt<ListEntitiesUseCase>();
    final result = await useCase(ListEntitiesParams());

    if (!mounted) return;

    final entities = result.fold((_) => <Entity>[], (l) => l);
    if (entities.isEmpty) return;

    final selected = await showModalBottomSheet<Entity>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        String query = '';
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filtered = entities
                .where((e) => e.name.toLowerCase().contains(query.toLowerCase()))
                .toList();

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.all(20),
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Insert Wiki Link',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontFamily: 'Lora',
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      autofocus: true,
                      style: Theme.of(context).textTheme.bodyLarge!,
                      decoration: const InputDecoration(
                        hintText: 'Search entity to link...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (val) {
                        setModalState(() {
                          query = val;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final e = filtered[index];
                          final color = Color(e.iconColor);
                          return ListTile(
                            dense: true,
                            leading: CircleAvatar(
                              radius: 12,
                              backgroundColor: color.withOpacity(0.15),
                              child: Text(
                                e.name.isNotEmpty ? e.name[0].toUpperCase() : '?',
                                style: TextStyle(
                                    color: color,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            title: Text(e.name, style: Theme.of(context).textTheme.bodyLarge!),
                            subtitle: Text(e.type.label, style: Theme.of(context).textTheme.labelMedium!),
                            onTap: () => Navigator.pop(ctx, e),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (selected != null && _editorController != null && mounted) {
      final selection = _editorController!.selection;
      if (!selection.isValid) return;
      final cursorOffset = selection.baseOffset;
      if (cursorOffset >= 2) {
        final text = _editorController!.document.toPlainText();
        final lastTwo = text.substring(cursorOffset - 2, cursorOffset);
        if (lastTwo == '[[') {
          final index = cursorOffset - 2;
          _editorController!.replaceText(index, 2, '[[${selected.name}]]', null);
          _editorController!.updateSelection(
            TextSelection.collapsed(offset: index + selected.name.length + 4),
            ChangeSource.local,
          );
        }
      }
    }
  }

  void _saveChapter() {
    ref.read(manuscriptNotifierProvider.notifier).updateChapterContent(
          widget.chapterId,
          _currentContent,
        );
    ref.read(manuscriptNotifierProvider.notifier).updateChapterTitle(
          widget.chapterId,
          _titleController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () {
            _saveChapter();
            Navigator.pop(context);
          },
        ),
        title: TextField(
          controller: _titleController,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontFamily: 'Lora',
                fontWeight: FontWeight.bold,
              ),
          decoration: const InputDecoration(
            hintText: 'Chapter Title',
            border: InputBorder.none,
            isDense: true,
          ),
          onChanged: (_) => _saveChapter(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _showPreview ? Icons.visibility : Icons.edit_outlined,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            tooltip: _showPreview ? 'Edit' : 'Preview',
            onPressed: () {
              _saveChapter();
              setState(() => _showPreview = !_showPreview);
            },
          ),
          Builder(
            builder: (ctx) => IconButton(
              icon: const Icon(Icons.menu_book_outlined),
              tooltip: 'Codex Reference',
              onPressed: () {
                _saveChapter();
                Scaffold.of(ctx).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.85,
        child: SafeArea(
          child: _CodexDrawer(
            onEntityTap: (entity) {
              Navigator.pop(context);
              showEntityPeekSheet(
                context,
                entityId: entity.id,
              );
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: _showPreview
            ? VisualBookPagePreview(
                title: _titleController.text.isNotEmpty
                    ? _titleController.text
                    : 'Chapter Untitled',
                content: _currentContent,
              )
            : QuillEditorWidget(
                key: ValueKey(widget.chapterId),
                initialContent: _currentContent,
                onControllerReady: (controller) {
                  _editorController = controller;
                  _editorController!.addListener(_onEditorTextChanged);
                },
                onContentChanged: (content) {
                  _currentContent = content;
                  _saveChapter();
                },
              ),
      ),
      bottomNavigationBar: (!_showPreview)
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Words: ${_currentContent.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length}',
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  Text(
                    'Characters: ${_currentContent.length}',
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}

/// A tappable button that shows the current chapter status and
/// cycles to the next status on tap (draft → revising → done → draft).
class _StatusCycleButton extends StatelessWidget {
  final ChapterStatus status;
  final VoidCallback onTap;

  const _StatusCycleButton({
    required this.status,
    required this.onTap,
  });

  Color get _color {
    switch (status) {
      case ChapterStatus.draft:
        return Colors.grey;
      case ChapterStatus.revising:
        return Colors.amber.shade700;
      case ChapterStatus.done:
        return Colors.green;
    }
  }

  IconData get _icon {
    switch (status) {
      case ChapterStatus.draft:
        return Icons.circle_outlined;
      case ChapterStatus.revising:
        return Icons.edit_note;
      case ChapterStatus.done:
        return Icons.check_circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Status: ${status.label} (tap to cycle)',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_icon, size: 16, color: _color),
                const SizedBox(width: 4),
                Text(
                  status.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VisualBookPagePreview extends StatelessWidget {
  final String title;
  final String content;

  const VisualBookPagePreview({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Container(
          width: 500,
          constraints: const BoxConstraints(
            minHeight: 650,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? const Color(0xFFFDFBF7)
                : Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
              width: 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(36, 40, 36, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  title.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        fontFamily: 'Lora',
                        letterSpacing: 2.0,
                        color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.6),
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 8),
              Divider(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.15),
                thickness: 0.8,
              ),
              const SizedBox(height: 24),
              MarkdownBody(
                data: content.isEmpty ? '*Empty chapter*' : content,
                styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                  p: TextStyle(
                    fontFamily: 'Lora',
                    fontSize: 14.0,
                    height: 1.6,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  h1: TextStyle(
                    fontFamily: 'Lora',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  h2: TextStyle(
                    fontFamily: 'Lora',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 36),
              Center(
                child: Text(
                  '— Page 1 —',
                  style: TextStyle(
                    fontFamily: 'Lora',
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
