import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:fictionist/domain/entity/entity.dart';

/// A wrapped [QuillEditor] without a built-in toolbar.
///
/// Exposes the internal [QuillController] via [onControllerReady]
/// so the parent can attach a toolbar at any position (top/bottom).
///
/// When [typewriterMode] is true, the editor gets top/bottom padding in
/// the config to simulate centered-cursor scrolling.
class QuillEditorWidget extends StatefulWidget {
  final String? initialContent;
  final ValueChanged<String> onContentChanged;
  final ValueChanged<QuillController>? onControllerReady;
  final bool readOnly;
  final bool typewriterMode;
  final String layoutMode;
  final String focusHighlight;
  final double editorFontSize;
  final List<Entity> entities;
  final ValueChanged<String>? onEntityLinkTapped;

  const QuillEditorWidget({
    super.key,
    this.initialContent,
    required this.onContentChanged,
    this.onControllerReady,
    this.readOnly = false,
    this.typewriterMode = false,
    this.layoutMode = 'normal',
    this.focusHighlight = 'none',
    this.editorFontSize = 16.0,
    this.entities = const [],
    this.onEntityLinkTapped,
  });

  @override
  State<QuillEditorWidget> createState() => _QuillEditorWidgetState();
}

class _QuillEditorWidgetState extends State<QuillEditorWidget> {
  late QuillController _controller;

  bool _isAutocompleteActive = false;
  String _autocompleteQuery = '';
  int _autocompleteTriggerIndex = -1;

  @override
  void initState() {
    super.initState();
    _controller = _buildController();
    _controller.addListener(_handleContentChanged);
    _controller.addListener(_onEditorChanged);
    widget.onControllerReady?.call(_controller);
  }

  void _handleContentChanged() {
    widget.onContentChanged(_controller.document.toPlainText());
  }

  void _onEditorChanged() {
    final selection = _controller.selection;
    if (selection.isCollapsed) {
      final cursorIndex = selection.baseOffset;
      if (cursorIndex > 0) {
        final text = _controller.document.toPlainText();
        
        // Scan backwards to find the start of the word or '@'
        int atIndex = -1;
        for (int i = cursorIndex - 1; i >= 0; i--) {
          if (i >= text.length) continue;
          final char = text[i];
          if (char == '\n') break; // Don't scan across paragraphs
          if (char == '@') {
            // Verify there is a space or start of line before '@'
            if (i == 0 || text[i - 1] == ' ' || text[i - 1] == '\n') {
              atIndex = i;
            }
            break;
          }
          if (char == ' ') {
            // Space indicates word boundary, stop search
            break;
          }
        }

        if (atIndex != -1 && atIndex < text.length) {
          final query = text.substring(atIndex + 1, cursorIndex);
          setState(() {
            _isAutocompleteActive = true;
            _autocompleteQuery = query;
            _autocompleteTriggerIndex = atIndex;
          });
          return;
        }
      }
    }

    if (_isAutocompleteActive) {
      setState(() {
        _isAutocompleteActive = false;
      });
    }
  }

  void _selectEntity(Entity entity) {
    final start = _autocompleteTriggerIndex;
    final length = _controller.selection.baseOffset - start;
    final entityName = entity.name;

    // 1. Replace the "@query" text with the entity name
    _controller.replaceText(
      start,
      length,
      entityName,
      TextSelection.collapsed(offset: start + entityName.length),
    );

    // 2. Format the inserted text as a link
    _controller.formatText(
      start,
      entityName.length,
      LinkAttribute('entity://${entity.id}'),
    );

    // 3. Insert a space after the link so the user can continue typing normally without link style
    _controller.replaceText(
      start + entityName.length,
      0,
      ' ',
      TextSelection.collapsed(offset: start + entityName.length + 1),
    );

    // Remove link attribute from the space we just inserted
    _controller.formatText(
      start + entityName.length,
      1,
      const LinkAttribute(null),
    );

    setState(() {
      _isAutocompleteActive = false;
    });
  }

  QuillController _buildController() {
    if (widget.initialContent != null &&
        widget.initialContent!.isNotEmpty) {
      return QuillController(
        document: Document()..insert(0, widget.initialContent!),
        selection: const TextSelection.collapsed(offset: 0),
      );
    }
    return QuillController.basic();
  }

  @override
  void dispose() {
    _controller.removeListener(_handleContentChanged);
    _controller.removeListener(_onEditorChanged);
    _controller.dispose();
    super.dispose();
  }

  QuillEditorConfig _buildEditorConfig(BuildContext context) {
    final textStyle =
        Theme.of(context).textTheme.bodyLarge ?? const TextStyle(fontSize: 16);
    
    final double fontSize = widget.editorFontSize;
    final String? fontFamily = widget.layoutMode == 'book' ? 'Lora' : null;
    final double lineHeight = widget.layoutMode == 'book' ? 1.6 : 1.4;

    final basePadding =
        const EdgeInsets.only(left: 24, top: 16, right: 40, bottom: 24);
    
    return QuillEditorConfig(
      padding: widget.typewriterMode
          ? basePadding.copyWith(
              top: basePadding.top + MediaQuery.of(context).size.height * 0.35,
              bottom: basePadding.bottom + MediaQuery.of(context).size.height * 0.65,
            )
          : basePadding,
      placeholder: 'Start writing your chapter...',
      customRecognizerBuilder: (attribute, leaf) {
        final link = attribute.value;
        if (link is String && link.startsWith('entity://')) {
          final String entityId = link.substring('entity://'.length);
          return TapGestureRecognizer()
            ..onTap = () {
              widget.onEntityLinkTapped?.call(entityId);
            };
        }
        return null;
      },
      customStyles: DefaultStyles(
        paragraph: DefaultTextBlockStyle(
          textStyle.copyWith(
            fontFamily: fontFamily,
            height: lineHeight,
            fontSize: fontSize,
          ),
          const HorizontalSpacing(0, 0),
          const VerticalSpacing(0, 8),
          const VerticalSpacing(0, 0),
          null,
        ),
        h1: DefaultTextBlockStyle(
          textStyle.copyWith(
            fontFamily: fontFamily,
            color: const Color(0xFFE8853B),
            fontWeight: FontWeight.bold,
            height: lineHeight,
            fontSize: fontSize * 1.5,
          ),
          const HorizontalSpacing(0, 0),
          const VerticalSpacing(24, 12),
          const VerticalSpacing(0, 0),
          null,
        ),
        h2: DefaultTextBlockStyle(
          textStyle.copyWith(
            fontFamily: fontFamily,
            color: const Color(0xFFE8853B),
            fontWeight: FontWeight.w600,
            height: lineHeight,
            fontSize: fontSize * 1.3,
          ),
          const HorizontalSpacing(0, 0),
          const VerticalSpacing(20, 8),
          const VerticalSpacing(0, 0),
          null,
        ),
        h3: DefaultTextBlockStyle(
          textStyle.copyWith(
            fontFamily: fontFamily,
            color: const Color(0xFFE8853B),
            fontWeight: FontWeight.w600,
            height: lineHeight,
            fontSize: fontSize * 1.15,
          ),
          const HorizontalSpacing(0, 0),
          const VerticalSpacing(16, 6),
          const VerticalSpacing(0, 0),
          null,
        ),
        bold: const TextStyle(
          color: Color(0xFF4A90D9),
          fontWeight: FontWeight.bold,
        ),
        italic: const TextStyle(
          color: Color(0xFF50A85A),
          fontStyle: FontStyle.italic,
        ),
        link: const TextStyle(
          color: Color(0xFF9B59B6),
          decoration: TextDecoration.underline,
        ),
        inlineCode: InlineCodeStyle(
          style: TextStyle(
            color: const Color(0xFFE74C3C),
            backgroundColor: const Color(0xFF2D2D2D),
            fontFamily: 'monospace',
            fontSize: fontSize * 0.9,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final editor = QuillEditor.basic(
      controller: _controller,
      config: _buildEditorConfig(context),
    );

    Widget editorContent;
    if (widget.layoutMode == 'normal') {
      editorContent = editor;
    } else {
      final double maxWidth = widget.layoutMode == 'comfort' ? 760.0 : 620.0;
      editorContent = Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: editor,
        ),
      );
    }

    // Wrap with Focus dimming overlay if needed
    Widget mainContent;
    if (widget.focusHighlight == 'none') {
      mainContent = editorContent;
    } else {
      mainContent = LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.maxHeight;
          final activeBandTop = height * 0.35;
          final activeBandHeight = widget.focusHighlight == 'sentence' ? 32.0 : 80.0;
          final activeBandBottom = activeBandTop + activeBandHeight;

          return Stack(
            children: [
              Positioned.fill(child: editorContent),
              
              // Dim top region
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: activeBandTop,
                child: IgnorePointer(
                  child: Container(
                    color: Colors.black.withOpacity(0.55),
                  ),
                ),
              ),
              
              // Dim bottom region
              Positioned(
                top: activeBandBottom,
                left: 0,
                right: 0,
                bottom: 0,
                child: IgnorePointer(
                  child: Container(
                    color: Colors.black.withOpacity(0.55),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    final matchingEntities = widget.entities.where((e) {
      return e.name.toLowerCase().contains(_autocompleteQuery.toLowerCase());
    }).toList();

    if (_isAutocompleteActive && matchingEntities.isNotEmpty) {
      return Stack(
        children: [
          Positioned.fill(child: mainContent),
          Positioned(
            left: 24,
            right: 40,
            bottom: MediaQuery.of(context).viewInsets.bottom + 8,
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.surface.withOpacity(0.95),
              child: Container(
                constraints: const BoxConstraints(maxHeight: 180),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    width: 1.2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: matchingEntities.length,
                    itemBuilder: (ctx, idx) {
                      final entity = matchingEntities[idx];
                      return ListTile(
                        dense: true,
                        leading: CircleAvatar(
                          radius: 12,
                          backgroundColor: Color(entity.iconColor).withOpacity(0.15),
                          child: Text(
                            entity.name.isNotEmpty ? entity.name[0].toUpperCase() : '?',
                            style: TextStyle(
                              color: Color(entity.iconColor),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          entity.name,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          entity.type.label,
                          style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        onTap: () => _selectEntity(entity),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return mainContent;
  }
}
