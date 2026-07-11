import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fictionist/domain/entity/entity.dart';
import 'package:fictionist/domain/entity/entity_type.dart';
import 'package:fictionist/domain/manuscript/manuscript_chapter.dart';
import 'package:fictionist/domain/use_case/entity/list_entities_use_case.dart';
import 'package:fictionist/domain/use_case/manuscript/manuscript_use_cases.dart';
import 'package:fictionist/presentation/features/manuscript/provider/manuscript_provider.dart';
import 'package:fictionist/presentation/features/name_generator/widget/name_generator_sheet.dart';
import 'package:fictionist/injection.dart';
import 'loading_indicator.dart';

enum QuickSwitcherItemType { entity, chapter, action }

class QuickSwitcherItem {
  final String id;
  final String title;
  final String subtitle;
  final QuickSwitcherItemType type;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const QuickSwitcherItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });
}

class QuickSwitcherDialog extends ConsumerStatefulWidget {
  const QuickSwitcherDialog({super.key});

  @override
  ConsumerState<QuickSwitcherDialog> createState() => _QuickSwitcherDialogState();
}

class _QuickSwitcherDialogState extends ConsumerState<QuickSwitcherDialog> {
  final _controller = TextEditingController();
  List<Entity> _entities = [];
  List<ManuscriptChapter> _chapters = [];
  List<QuickSwitcherItem> _filteredItems = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final listChapters = getIt<ListChaptersUseCase>();
    final chaptersResult = await listChapters();
    final listEntities = getIt<ListEntitiesUseCase>();
    final entitiesResult = await listEntities(const ListEntitiesParams());

    if (mounted) {
      setState(() {
        _chapters = chaptersResult.fold((_) => [], (l) => l);
        _entities = entitiesResult.fold((_) => [], (l) => l);
        _isLoading = false;
        _onSearch('');
      });
    }
  }

  IconData _getEntityIcon(EntityType type) {
    switch (type) {
      case EntityType.character:
        return Icons.person_outline;
      case EntityType.faction:
        return Icons.shield_outlined;
      case EntityType.raceCulture:
        return Icons.fingerprint;
      case EntityType.location:
        return Icons.map_outlined;
      case EntityType.powerMagicSystem:
        return Icons.bolt;
      case EntityType.itemArtifact:
        return Icons.auto_awesome;
      case EntityType.event:
        return Icons.auto_stories;
      case EntityType.conceptGlossary:
        return Icons.lightbulb_outline;
    }
  }

  List<QuickSwitcherItem> _buildDefaultActions() {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;
    final tertiaryColor = theme.colorScheme.tertiary;

    return [
      QuickSwitcherItem(
        id: 'nav-codex',
        title: 'Go to Codex',
        subtitle: 'View and manage all worldbuilding entities',
        type: QuickSwitcherItemType.action,
        icon: Icons.auto_stories,
        iconColor: primaryColor,
        onTap: () {
          Navigator.pop(context);
          context.go('/entities');
        },
      ),
      QuickSwitcherItem(
        id: 'nav-script',
        title: 'Go to Script Editor',
        subtitle: 'Continue writing your manuscript',
        type: QuickSwitcherItemType.action,
        icon: Icons.edit_note,
        iconColor: secondaryColor,
        onTap: () {
          Navigator.pop(context);
          context.go('/manuscript');
        },
      ),
      QuickSwitcherItem(
        id: 'nav-graph',
        title: 'Go to Connection Web',
        subtitle: 'View relationship graph and family tree',
        type: QuickSwitcherItemType.action,
        icon: Icons.hub_outlined,
        iconColor: tertiaryColor,
        onTap: () {
          Navigator.pop(context);
          context.go('/graph');
        },
      ),
      QuickSwitcherItem(
        id: 'nav-map',
        title: 'Go to Interactive Map',
        subtitle: 'Explore location pins and map canvas',
        type: QuickSwitcherItemType.action,
        icon: Icons.explore_outlined,
        iconColor: Colors.teal,
        onTap: () {
          Navigator.pop(context);
          context.go('/map');
        },
      ),
      QuickSwitcherItem(
        id: 'nav-plot',
        title: 'Go to Plot Corkboard',
        subtitle: 'Organize chapters and timelines visually',
        type: QuickSwitcherItemType.action,
        icon: Icons.dashboard_outlined,
        iconColor: Colors.deepOrange,
        onTap: () {
          Navigator.pop(context);
          context.go('/plot');
        },
      ),
      QuickSwitcherItem(
        id: 'action-name-gen',
        title: 'Launch Name Generator',
        subtitle: 'Generate fantasy or cultural names',
        type: QuickSwitcherItemType.action,
        icon: Icons.casino_outlined,
        iconColor: Colors.purple,
        onTap: () {
          Navigator.pop(context);
          showNameGeneratorSheet(context);
        },
      ),
      QuickSwitcherItem(
        id: 'nav-settings',
        title: 'Go to Settings',
        subtitle: 'Change theme, backup, or customize fonts',
        type: QuickSwitcherItemType.action,
        icon: Icons.settings_outlined,
        iconColor: theme.colorScheme.onSurfaceVariant,
        onTap: () {
          Navigator.pop(context);
          context.push('/settings');
        },
      ),
    ];
  }

  void _onSearch(String query) {
    if (query.trim().isEmpty) {
      setState(() {
        _filteredItems = _buildDefaultActions();
      });
      return;
    }

    final q = query.toLowerCase().trim();
    final List<QuickSwitcherItem> matches = [];

    // 1. Filter Entities
    for (final entity in _entities) {
      if (entity.name.toLowerCase().contains(q)) {
        matches.add(QuickSwitcherItem(
          id: 'entity-${entity.id}',
          title: entity.name,
          subtitle: '${entity.type.label.toUpperCase()} · ${entity.status.label.toUpperCase()}',
          type: QuickSwitcherItemType.entity,
          icon: _getEntityIcon(entity.type),
          iconColor: Color(entity.iconColor),
          onTap: () {
            Navigator.pop(context);
            context.push('/entities/${entity.id}');
          },
        ));
      }
    }

    // 2. Filter Chapters
    for (final chapter in _chapters) {
      if (chapter.title.toLowerCase().contains(q)) {
        final words = chapter.content.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
        matches.add(QuickSwitcherItem(
          id: 'chapter-${chapter.id}',
          title: chapter.title,
          subtitle: 'CHAPTER · $words words',
          type: QuickSwitcherItemType.chapter,
          icon: Icons.edit_note,
          iconColor: Theme.of(context).colorScheme.secondary,
          onTap: () {
            Navigator.pop(context);
            ref.read(manuscriptNotifierProvider.notifier).selectChapter(chapter.id);
            context.go('/manuscript');
          },
        ));
      }
    }

    // 3. Add dynamic shortcuts
    matches.add(QuickSwitcherItem(
      id: 'action-forge-entity',
      title: 'Forge Entity: "$query"',
      subtitle: 'Create a new worldbuilding profile with this name',
      type: QuickSwitcherItemType.action,
      icon: Icons.add_box_outlined,
      iconColor: Theme.of(context).colorScheme.primary,
      onTap: () {
        Navigator.pop(context);
        context.push('/entities/create?name=${Uri.encodeComponent(query)}');
      },
    ));

    setState(() {
      _filteredItems = matches;
    });
  }

  Widget _buildHighlightedText(BuildContext context, String text, String query) {
    if (query.isEmpty) {
      return Text(
        text,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
      );
    }
    final textLower = text.toLowerCase();
    final queryLower = query.toLowerCase();
    final spans = <TextSpan>[];
    int start = 0;
    
    while (true) {
      final index = textLower.indexOf(queryLower, start);
      if (index == -1) {
        spans.add(TextSpan(text: text.substring(start)));
        break;
      }
      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index)));
      }
      spans.add(TextSpan(
        text: text.substring(index, index + query.length),
        style: TextStyle(
          fontWeight: FontWeight.w800,
          color: Theme.of(context).colorScheme.primary,
        ),
      ));
      start = index + query.length;
    }

    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
        children: spans,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final query = _controller.text.trim();

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 5.0),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      builder: (context, blurValue, child) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurValue, sigmaY: blurValue),
          child: child,
        );
      },
      child: Dialog(
        backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.85),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Theme.of(context).colorScheme.outline, width: 1.5),
        ),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.85,
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _controller,
                autofocus: true,
                onChanged: _onSearch,
                style: Theme.of(context).textTheme.bodyLarge!,
                decoration: InputDecoration(
                  hintText: 'Quick switcher (Entities, Chapters, Actions)...',
                  hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: Theme.of(context).colorScheme.onSurfaceVariant),
                          onPressed: () {
                            _controller.clear();
                            _onSearch('');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: LoadingIndicator(),
                  ),
                )
              else if (query.isNotEmpty && _filteredItems.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    'No results found matching your query.',
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = _filteredItems[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          leading: CircleAvatar(
                            radius: 18,
                            backgroundColor: item.iconColor.withOpacity(0.12),
                            child: Icon(
                              item.icon,
                              color: item.iconColor,
                              size: 18,
                            ),
                          ),
                          title: _buildHighlightedText(context, item.title, query),
                          subtitle: Text(
                            item.subtitle,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              fontSize: 10.5,
                            ),
                          ),
                          onTap: () {
                            HapticFeedback.lightImpact();
                            item.onTap();
                          },
                        ),
                      ).animate().fadeIn(
                        duration: 150.ms,
                        delay: (index * 20).ms,
                      ).slideY(
                        begin: 0.15,
                        duration: 150.ms,
                        delay: (index * 20).ms,
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    ).animate().scale(duration: 250.ms, curve: Curves.easeOutBack).fadeIn(duration: 150.ms);
  }
}
