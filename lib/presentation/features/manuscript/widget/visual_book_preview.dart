import 'package:flutter/material.dart';

/// Book-style page preview (stub — full visual preview planned for later).
class VisualBookPagePreview extends StatelessWidget {
  const VisualBookPagePreview({
    super.key,
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: Center(
        child: Text(
          '📄 $title',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
