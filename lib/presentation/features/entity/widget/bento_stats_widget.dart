import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entity/entity.dart';
import '../../../../domain/entity/entity_type.dart';
import '../../graph/provider/graph_provider.dart';

class BentoStatsWidget extends ConsumerStatefulWidget {
  final void Function(EntityType?) onFilterType;
  final EntityType? selectedType;

  const BentoStatsWidget({
    super.key,
    required this.onFilterType,
    required this.selectedType,
  });

  @override
  ConsumerState<BentoStatsWidget> createState() => _BentoStatsWidgetState();
}

class _BentoStatsWidgetState extends ConsumerState<BentoStatsWidget> with SingleTickerProviderStateMixin {
  String? _currentPrompt;
  bool _rolling = false;
  late AnimationController _rollController;

  @override
  void initState() {
    super.initState();
    _rollController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _rollController.dispose();
    super.dispose();
  }

  void _generateStorySpark(List<Entity> entities) {
    if (entities.isEmpty) return;

    final chars = entities.where((e) => e.type == EntityType.character).toList();
    final factions = entities.where((e) => e.type == EntityType.faction).toList();
    final locations = entities.where((e) => e.type == EntityType.location).toList();
    final events = entities.where((e) => e.type == EntityType.event).toList();
    final items = entities.where((e) => e.type == EntityType.itemArtifact).toList();

    final rand = Random();
    final templates = <String>[];

    if (chars.length >= 2) {
      final c1 = chars[rand.nextInt(chars.length)].name;
      var c2 = chars[rand.nextInt(chars.length)].name;
      while (c1 == c2 && chars.length > 1) {
        c2 = chars[rand.nextInt(chars.length)].name;
      }
      templates.add('What if **$c1** and **$c2** forged a forbidden connection in secret?');
      templates.add('What if **$c1** was forced to betray **$c2** for the greater good?');
    }

    if (chars.isNotEmpty && factions.isNotEmpty) {
      final c = chars[rand.nextInt(chars.length)].name;
      final f = factions[rand.nextInt(factions.length)].name;
      templates.add('How did **$c** become a secret ally of the **$f**?');
      templates.add('What if **$c** is planning to overthrow **$f** from the inside?');
    }

    if (chars.isNotEmpty && locations.isNotEmpty && items.isNotEmpty) {
      final c = chars[rand.nextInt(chars.length)].name;
      final loc = locations[rand.nextInt(locations.length)].name;
      final item = items[rand.nextInt(items.length)].name;
      templates.add('What if **$c** discovered the legendary **$item** hidden deep within **$loc**?');
    }

    if (chars.isNotEmpty && events.isNotEmpty && locations.isNotEmpty) {
      final c = chars[rand.nextInt(chars.length)].name;
      final ev = events[rand.nextInt(events.length)].name;
      final loc = locations[rand.nextInt(locations.length)].name;
      templates.add('How did **$c** survive the tragic events of **$ev** at **$loc**?');
    }

    if (factions.length >= 2) {
      final f1 = factions[rand.nextInt(factions.length)].name;
      var f2 = factions[rand.nextInt(factions.length)].name;
      while (f1 == f2 && factions.length > 1) {
        f2 = factions[rand.nextInt(factions.length)].name;
      }
      templates.add('What if **$f1** declared a silent trade war against **$f2**?');
    }

    if (templates.isEmpty) {
      setState(() {
        _currentPrompt = 'Create more characters, factions, and locations to forge creative prompts here!';
      });
      return;
    }

    setState(() {
      _currentPrompt = templates[rand.nextInt(templates.length)];
    });
  }

  void _triggerRoll(List<Entity> entities) {
    if (_rolling) return;
    HapticFeedback.mediumImpact();
    setState(() => _rolling = true);
    _rollController.forward(from: 0.0).then((_) {
      _generateStorySpark(entities);
      setState(() => _rolling = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final graphDataAsync = ref.watch(graphDataProvider);

    return graphDataAsync.when(
      data: (data) {
        final entities = data.$1;
        final rels = data.$2;

        final totalEntities = entities.length;
        final totalConnections = rels.length;

        final orphansCount = entities.where((e) {
          final hasRel = rels.any((r) => r.sourceId == e.id || r.targetId == e.id);
          return !hasRel;
        }).length;

        if (_currentPrompt == null && entities.isNotEmpty) {
          _generateStorySpark(entities);
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.25,
                children: [
                  _buildBentoCard(
                    context,
                    title: 'Entities',
                    value: '$totalEntities',
                    icon: Icons.auto_stories_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    isSelected: widget.selectedType == null,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      widget.onFilterType(null);
                    },
                  ),
                  _buildBentoCard(
                    context,
                    title: 'Links',
                    value: '$totalConnections',
                    icon: Icons.hub_rounded,
                    color: Theme.of(context).colorScheme.secondary,
                    isSelected: false,
                    onTap: () {
                      HapticFeedback.selectionClick();
                    },
                  ),
                  _buildBentoCard(
                    context,
                    title: 'Orphans',
                    value: '$orphansCount',
                    icon: Icons.warning_amber_rounded,
                    color: orphansCount > 0 ? Colors.amber : Colors.green,
                    isSelected: false,
                    onTap: () {
                      HapticFeedback.selectionClick();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (_currentPrompt != null)
                AnimatedBuilder(
                  animation: _rollController,
                  builder: (context, child) {
                    final rotation = _rollController.value * pi * 2;
                    final scale = 1.0 - (sin(_rollController.value * pi) * 0.05);
                    return Transform.scale(
                      scale: scale,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                            width: 0.8,
                          ),
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.surface,
                              Theme.of(context).colorScheme.primary.withOpacity(0.04),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.auto_awesome_rounded,
                                      size: 16,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'STORY SPARK',
                                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1.2,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () => _triggerRoll(entities),
                                  child: Transform.rotate(
                                    angle: rotation,
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.casino_outlined,
                                        size: 15,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            AnimatedOpacity(
                              opacity: _rolling ? 0.3 : 1.0,
                              duration: const Duration(milliseconds: 150),
                              child: _buildRichText(context, _currentPrompt!),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildBentoCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outline.withOpacity(0.35),
              width: isSelected ? 1.2 : 0.6,
            ),
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.surface,
                color.withOpacity(0.04),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    icon,
                    size: 16,
                    color: isSelected ? Theme.of(context).colorScheme.primary : color.withOpacity(0.8),
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: 'Lora',
                  color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRichText(BuildContext context, String text) {
    final List<TextSpan> spans = [];
    final regex = RegExp(r'\*\*(.*?)\*\*');
    int lastIndex = 0;

    for (final match in regex.allMatches(text)) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(
          text: text.substring(lastIndex, match.start),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 12.5,
            height: 1.45,
          ),
        ));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 12.5,
          height: 1.45,
        ),
      ));
      lastIndex = match.end;
    }

    if (lastIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastIndex),
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: 12.5,
          height: 1.45,
        ),
      ));
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }
}
