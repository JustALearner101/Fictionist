import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// Minimal 40px writer-focused toolbar — 8 buttons: B, I, U, H1-H3, Quote, Wiki-link.
/// Replaces the default QuillSimpleToolbar with a distilled, JotterPad-style set.
class MinimalToolbar extends StatelessWidget {
  final QuillController controller;

  const MinimalToolbar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = controller.getSelectionStyle();
    final attrs = style.attributes;

    bool isActive(String key) => attrs.keys.any((a) => a.key == key);

    return Container(
      height: 40,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.08),
          ),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 40),
          _Btn(
            icon: Icons.format_bold,
            tooltip: 'Bold',
            isActive: isActive('bold'),
            onPressed: () => _toggle(Attribute.bold),
          ),
          _Btn(
            icon: Icons.format_italic,
            tooltip: 'Italic',
            isActive: isActive('italic'),
            onPressed: () => _toggle(Attribute.italic),
          ),
          _Btn(
            icon: Icons.format_underlined,
            tooltip: 'Underline',
            isActive: isActive('underline'),
            onPressed: () => _toggle(Attribute.underline),
          ),
          const SizedBox(width: 8),
          for (final lvl in [1, 2, 3])
            _Btn(
              icon: lvl == 1
                  ? Icons.format_h1
                  : lvl == 2
                      ? Icons.format_h2
                      : Icons.format_h3,
              tooltip: 'H$lvl',
              isActive: attrs.entries.any(
                  (e) => e.key.key == 'header' && e.value == lvl),
              onPressed: () => _toggle(HeaderAttribute(level: lvl)),
            ),
          const SizedBox(width: 8),
          _Btn(
            icon: Icons.format_quote,
            tooltip: 'Blockquote',
            isActive: isActive('blockquote'),
            onPressed: () => _toggle(Attribute.blockQuote),
          ),
          const Spacer(),
          _Btn(
            icon: Icons.link,
            tooltip: 'Insert Wiki Link [[ ]]',
            onPressed: () {
              final index = controller.selection.baseOffset;
              controller.document.insert(index - 2 < 0 ? 0 : index, '[[');
              controller.updateSelection(
                TextSelection.collapsed(offset: index + 2),
                ChangeSource.local,
              );
            },
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  void _toggle(Attribute attr) {
    final style = controller.getSelectionStyle();
    final has = style.attributes.entries.any((e) => e.key.key == attr.key);
    if (has) {
      controller.formatSelection(Attribute.clone(attr, null));
    } else {
      controller.formatSelection(attr);
    }
  }
}

class _Btn extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final bool isActive;

  const _Btn({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Tooltip(
      message: tooltip,
      child: SizedBox(
        width: 36,
        height: 36,
        child: IconButton(
          icon: Icon(icon, size: 18),
          color: isActive
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
          onPressed: onPressed,
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
