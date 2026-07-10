import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import 'package:fictionist/presentation/features/manuscript/widget/typewriter_editor.dart';
import 'package:fictionist/presentation/features/manuscript/widget/minimal_toolbar.dart';

/// A wrapped [QuillEditor] with an optional [QuillSimpleToolbar].
///
/// Exposes the internal [QuillController] so the parent can insert text
/// (e.g. wikilinks) at the cursor position.
///
/// When [typewriterMode] is true, the editor uses [TypewriterEditor] for
/// centered-cursor scrolling instead of the default top-aligned scroll.
class QuillEditorWidget extends StatefulWidget {
  final String? initialContent;
  final ValueChanged<String> onContentChanged;
  final ValueChanged<QuillController>? onControllerReady;
  final bool readOnly;
  final bool typewriterMode;

  const QuillEditorWidget({
    super.key,
    this.initialContent,
    required this.onContentChanged,
    this.onControllerReady,
    this.readOnly = false,
    this.typewriterMode = false,
  });

  @override
  State<QuillEditorWidget> createState() => _QuillEditorWidgetState();
}

class _QuillEditorWidgetState extends State<QuillEditorWidget> {
  late QuillController _controller;

  @override
  void initState() {
    super.initState();
    _controller = _buildController();
    _controller.addListener(_handleContentChanged);
    widget.onControllerReady?.call(_controller);
  }

  void _handleContentChanged() {
    widget.onContentChanged(_controller.document.toPlainText());
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
    _controller.dispose();
    super.dispose();
  }

  QuillEditorConfig _buildEditorConfig(BuildContext context) {
    final textStyle =
        Theme.of(context).textTheme.bodyLarge ?? const TextStyle(fontSize: 16);
    return QuillEditorConfig(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      placeholder: 'Start writing your chapter...',
      customStyles: DefaultStyles(
        h1: DefaultTextBlockStyle(
          textStyle.copyWith(
            color: const Color(0xFFE8853B),
            fontWeight: FontWeight.bold,
            height: 1.4,
          ),
          const HorizontalSpacing(0, 0),
          const VerticalSpacing(24, 12),
          const VerticalSpacing(0, 0),
          null,
        ),
        h2: DefaultTextBlockStyle(
          textStyle.copyWith(
            color: const Color(0xFFE8853B),
            fontWeight: FontWeight.w600,
            height: 1.3,
          ),
          const HorizontalSpacing(0, 0),
          const VerticalSpacing(20, 8),
          const VerticalSpacing(0, 0),
          null,
        ),
        h3: DefaultTextBlockStyle(
          textStyle.copyWith(
            color: const Color(0xFFE8853B),
            fontWeight: FontWeight.w600,
            height: 1.2,
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
            fontSize: (textStyle.fontSize ?? 16) * 0.9,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final editorConfig = _buildEditorConfig(context);

    return Column(
      children: [
        if (!widget.readOnly)
          MinimalToolbar(
            controller: _controller,
          ),
        Expanded(
          child: TypewriterEditor(
            controller: _controller,
            enabled: widget.typewriterMode,
            config: editorConfig,
          ),
        ),
      ],
    );
  }
}
