import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fictionist/domain/entity/entity.dart';
import 'package:fictionist/domain/use_case/entity/list_entities_use_case.dart';
import 'package:fictionist/injection.dart';
import 'package:fictionist/presentation/common/widget/confirm_dialog.dart';
import 'package:fictionist/presentation/common/widget/empty_state.dart';
import 'package:fictionist/presentation/common/widget/loading_indicator.dart';
import 'package:fictionist/presentation/features/entity/widget/entity_peek_sheet.dart';
import 'package:fictionist/presentation/features/manuscript/provider/manuscript_provider.dart';
import 'package:fictionist/presentation/features/manuscript/widget/quill_editor_widget.dart';
import 'package:fictionist/data/compiler/manuscript_compiler.dart';
import 'package:fictionist/domain/manuscript/compile_format.dart';
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
  String? _editingChapterId;
  String _currentContent = '';
  bool _showPreview = false;
  bool _showCodexDrawer = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _selectChapter(String id) {
    final state = ref.read(manuscriptNotifierProvider);
    final chapter = state.chapters.firstWhere((c) => c.id == id);
    _editingChapterId = id;
    _titleController.text = chapter.title;
    _currentContent = chapter.content;
    ref.read(manuscriptNotifierProvider.notifier).selectChapter(id);
  }

  Future<void> _createChapter() async {
    final title = await showDialog<String>(
      context: context,
      builder: (ctx) {
        final controller = TextEditingController();
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Text(
            'New Chapter',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            style: Theme.of(context).textTheme.bodyLarge!,
            decoration: const InputDecoration(
              hintText: 'Chapter title...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, controller.text),
              child: const Text('Create'),
            ),
          ],
        );
      },
    );

    if (title != null && title.trim().isNotEmpty && mounted) {
      await ref.read(manuscriptNotifierProvider.notifier).createChapter(title);
      final state = ref.read(manuscriptNotifierProvider);
      if (state.selectedChapterId != null) {
        _selectChapter(state.selectedChapterId!);
      }
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
    ref.read(manuscriptNotifierProvider.notifier).updateChapterContent(
      _editingChapterId!,
      content,
    );
    ref.read(manuscriptNotifierProvider.notifier).updateChapterTitle(
      _editingChapterId!,
      _titleController.text,
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
      return _buildMobileChapterList(context, state);
    } else {
      return _buildDesktopLayout(context, state);
    }
  }

  Widget _buildMobileChapterList(BuildContext context, ManuscriptState state) {
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
        ],
      ),
      body: ReorderableListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        itemCount: state.chapters.length,
        onReorder: (oldIndex, newIndex) {
          ref.read(manuscriptNotifierProvider.notifier).reorderChapters(oldIndex, newIndex);
        },
        itemBuilder: (context, index) {
          final ch = state.chapters[index];
          final wordCount = ch.content.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;

          return Card(
            key: ValueKey(ch.id),
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                ch.title,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontFamily: 'Lora',
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                '$wordCount words',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    onPressed: () => _deleteChapter(ch.id, ch.title),
                  ),
                  const Icon(Icons.drag_handle, color: Colors.grey),
                ],
              ),
              onTap: () {
                _selectChapter(ch.id);
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        ManuscriptEditorScreen(chapterId: ch.id),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.easeInOut;
                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, ManuscriptState state) {
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
        ],
      ),
      body: Row(
        children: [
          // Chapter list sidebar
          SizedBox(
            width: 200,
            child: Container(
              color: Theme.of(context).colorScheme.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      'Chapters',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ReorderableListView.builder(
                      itemCount: state.chapters.length,
                      onReorder: (oldIndex, newIndex) {
                        ref
                            .read(manuscriptNotifierProvider.notifier)
                            .reorderChapters(oldIndex, newIndex);
                      },
                      itemBuilder: (context, index) {
                        final ch = state.chapters[index];
                        final isSelected =
                            ch.id == state.selectedChapterId;
                        return ListTile(
                          key: ValueKey(ch.id),
                          selected: isSelected,
                          selectedTileColor:
                              Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          dense: true,
                          title: Text(
                            ch.title,
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete_outline,
                              size: 16,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            onPressed: () =>
                                _deleteChapter(ch.id, ch.title),
                          ),
                          onTap: () {
                            _saveCurrentChapter();
                            _selectChapter(ch.id);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Divider
          Container(width: 1, color: Theme.of(context).colorScheme.outline),
          // Editor area
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  // Title
                  TextField(
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
                  const SizedBox(height: 16),
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
                                key: ValueKey(_editingChapterId),
                                initialContent: _currentContent,
                                onContentChanged: (content) {
                                  _currentContent = content;
                                  _saveCurrentChapter();
                                },
                              )
                            : Center(
                                child: Text('Select a chapter to start writing'),
                              ),
                  ),
                  if (_editingChapterId != null && !_showPreview) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Words: ${_currentContent.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length}   |   Characters: ${_currentContent.length}',
                          style: Theme.of(context).textTheme.labelMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          // Codex drawer
          if (_showCodexDrawer) ...[
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
