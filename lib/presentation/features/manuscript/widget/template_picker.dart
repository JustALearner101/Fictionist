import 'package:flutter/material.dart';

/// A writing template with chapter structure.
class WritingTemplate {
  final String name;
  final IconData icon;
  final String description;
  final List<String> chapterTitles;

  const WritingTemplate({
    required this.name,
    required this.icon,
    required this.description,
    required this.chapterTitles,
  });
}

/// Built-in writing templates available in the picker.
const List<WritingTemplate> writingTemplates = [
  WritingTemplate(
    name: 'Novel',
    icon: Icons.menu_book,
    description:
        'A full novel arc — prologue, three parts, and epilogue',
    chapterTitles: [
      'Prologue',
      'Part 1: Setup — Chapter 1',
      'Part 1: Setup — Chapter 2',
      'Part 1: Setup — Chapter 3',
      'Part 2: Confrontation — Chapter 4',
      'Part 2: Confrontation — Chapter 5',
      'Part 2: Confrontation — Chapter 6',
      'Part 2: Confrontation — Chapter 7',
      'Part 2: Confrontation — Chapter 8',
      'Part 3: Resolution — Chapter 9',
      'Part 3: Resolution — Chapter 10',
      'Part 3: Resolution — Chapter 11',
      'Epilogue',
    ],
  ),
  WritingTemplate(
    name: 'Short Story',
    icon: Icons.edit_note,
    description: 'A compact four-act story structure',
    chapterTitles: [
      'Opening',
      'Rising Action',
      'Climax',
      'Resolution',
    ],
  ),
  WritingTemplate(
    name: 'Screenplay',
    icon: Icons.movie,
    description:
        'Industry-standard screenplay beats — teaser through tag',
    chapterTitles: [
      'Teaser',
      'Act 1',
      'Act 2A',
      'Midpoint',
      'Act 2B',
      'Act 3',
      'Tag',
    ],
  ),
  WritingTemplate(
    name: 'D&D Campaign',
    icon: Icons.masks,
    description:
        'A tabletop RPG campaign arc — intro to aftermath',
    chapterTitles: [
      'Introduction',
      'Quest Hook 1',
      'Quest Hook 2',
      'Quest Hook 3',
      'Encounter 1',
      'Encounter 2',
      'Encounter 3',
      'Boss Fight',
      'Aftermath',
    ],
  ),
  WritingTemplate(
    name: 'Blank',
    icon: Icons.auto_stories,
    description: 'Start fresh — add chapters as you go',
    chapterTitles: [
      'Untitled Chapter',
    ],
  ),
];

/// Shows a bottom sheet with writing template cards.
///
/// Returns the chosen template's chapter titles, or `null` if cancelled.
Future<List<String>?> showTemplatePicker(BuildContext context) {
  return showModalBottomSheet<List<String>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => const _TemplatePickerSheet(),
  );
}

class _TemplatePickerSheet extends StatelessWidget {
  const _TemplatePickerSheet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (ctx, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
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
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.library_books_outlined,
                      size: 22,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'New from Template',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        size: 20,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      onPressed: () => Navigator.pop(ctx),
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(minWidth: 32, minHeight: 32),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Choose a structure to scaffold your manuscript',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              // Template list
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: writingTemplates.length,
                  itemBuilder: (ctx, index) {
                    final template = writingTemplates[index];
                    final chapterCount = template.chapterTitles.length;
                    return _TemplateCard(
                      template: template,
                      chapterCount: chapterCount,
                      onTap: () =>
                          Navigator.pop(ctx, template.chapterTitles),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TemplateCard extends StatelessWidget {
  final WritingTemplate template;
  final int chapterCount;
  final VoidCallback onTap;

  const _TemplateCard({
    required this.template,
    required this.chapterCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    template.icon,
                    color: theme.colorScheme.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                // Title + description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        template.name,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        template.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Chapter count badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$chapterCount',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
