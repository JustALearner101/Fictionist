import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// Wraps a [QuillEditor.basic] with typewriter scrolling mode.
///
/// When [enabled] is true, the cursor stays vertically centered in the
/// viewport by adding proportional top/bottom padding inside a
/// [SingleChildScrollView]. This mimics the centered-cursor behavior
/// of professional writing apps like JotterPad and iA Writer.
///
/// When [enabled] is false, renders a standard [QuillEditor.basic].
class TypewriterEditor extends StatelessWidget {
  final QuillController controller;
  final bool enabled;
  final QuillEditorConfig config;

  const TypewriterEditor({
    super.key,
    required this.controller,
    required this.enabled,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) {
      return QuillEditor.basic(controller: controller, config: config);
    }

    // Typewriter mode: add proportional top/bottom padding so the
    // cursor naturally sits in the vertical center of the viewport.
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Column(
              children: [
                // Top padding: pushes cursor toward center
                SizedBox(height: constraints.maxHeight * 0.4),
                // Actual editor content
                QuillEditor.basic(
                  controller: controller,
                  config: config,
                ),
                // Bottom padding: allows scrolling past end
                SizedBox(height: constraints.maxHeight * 0.6),
              ],
            ),
          ),
        );
      },
    );
  }
}
