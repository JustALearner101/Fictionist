import 'package:flutter/material.dart';
import '../../../../domain/project/project.dart';

class ProjectDeleteDialog extends StatelessWidget {
  final Project project;

  const ProjectDeleteDialog({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Delete Project'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.warning_amber_rounded,
              size: 48, color: theme.colorScheme.error),
          const SizedBox(height: 16),
          Text(
            'Delete "${project.name}"?',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'This will permanently delete all entities, tags, timelines, maps, '
            'manuscript chapters, plot cards, and setup/payoffs in this project. '
            'This action cannot be undone.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.error,
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
