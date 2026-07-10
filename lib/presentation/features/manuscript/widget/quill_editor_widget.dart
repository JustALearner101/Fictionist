import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// A wrapped [QuillEditor] with an optional [QuillSimpleToolbar].
///
/// Exposes the internal [QuillController] so the parent can insert text
/// (e.g. wikilinks) at the cursor position.
class QuillEditorWidget extends StatefulWidget {
  final String? initialContent;
  final ValueChanged<String> onContentChanged;
  final ValueChanged<QuillController>? onControllerReady;
  final bool readOnly;

  const QuillEditorWidget({
    super.key,
    this.initialContent,
    required this.onContentChanged,
    this.onControllerReady,
    this.readOnly = false,
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!widget.readOnly)
          QuillSimpleToolbar(
            controller: _controller,
            config: const QuillSimpleToolbarConfig(
              multiRowsDisplay: false,
            ),
          ),
        Expanded(
          child: QuillEditor.basic(
            controller: _controller,
            config: QuillEditorConfig(
              padding: const EdgeInsets.all(16),
              placeholder: 'Start writing your chapter...',
            ),
          ),
        ),
      ],
    );
  }
}
