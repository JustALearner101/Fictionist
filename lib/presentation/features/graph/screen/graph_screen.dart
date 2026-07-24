import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphview/GraphView.dart';
import '../../../../domain/entity/entity.dart';
import '../../../../domain/entity/entity_type.dart';
import '../../../../domain/relationship/relationship.dart';
import '../../../../domain/relationship/relationship_type_registry.dart';
import '../../../../domain/timeline/timeline_entry.dart';
import '../../../../domain/trait/trait_inheritance.dart';
import '../../../../domain/use_case/trait/analyze_trait_inheritance_use_case.dart';
import '../../../../domain/use_case/continuity_check_use_case.dart';
import '../../../../data/repository/timeline_repository_impl.dart';
import '../../../../data/repository/relationship_repository_impl.dart';
import '../../../../domain/use_case/relationship/create_relationship_use_case.dart';
import '../../../../injection.dart';
import '../../../common/widget/empty_state.dart';
import '../../../common/widget/error_display.dart';
import '../../../common/widget/loading_indicator.dart';
import '../../../common/widget/page_header.dart';
import '../../../common/widget/fictionist_dropdown.dart';
import '../provider/graph_provider.dart';
import '../widget/timeline_scrubber.dart';
import '../widget/relationship_matrix_widget.dart';
import '../../entity/widget/entity_peek_sheet.dart';
import '../../relationship/widget/relationship_picker_sheet.dart';

enum GraphLayoutMode {
  chronicleWeb,
  familyTree,
  factionMap,
  relationshipMatrix,
}

class GraphScreen extends ConsumerStatefulWidget {
  const GraphScreen({super.key});

  @override
  ConsumerState<GraphScreen> createState() => _GraphScreenState();
}

class _GraphScreenState extends ConsumerState<GraphScreen> {
  GraphLayoutMode _layoutMode = GraphLayoutMode.chronicleWeb;
  final Set<EntityType> _enabledTypes = Set.from(EntityType.values);
  Map<String, List<TraitInheritance>> _traitMap = {};
  final TransformationController _transformationController = TransformationController();
  final Map<String, Offset> _draggedPositions = {};

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
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

  BorderRadius _getNodeBorderRadius(EntityType type) {
    switch (type) {
      case EntityType.faction:
        return BorderRadius.circular(8);
      case EntityType.location:
        return BorderRadius.circular(14);
      case EntityType.event:
        return BorderRadius.circular(4);
      default:
        return BorderRadius.circular(24);
    }
  }

  // Timeline scrubber state
  bool _scrubberVisible = false;
  int? _scrubYear;
  ({int min, int max})? _scrubMinMax;

  // Algorithms
  final FruchtermanReingoldAlgorithm _forceAlgorithm =
      FruchtermanReingoldAlgorithm(FruchtermanReingoldConfiguration());

  final SugiyamaAlgorithm _treeAlgorithm = SugiyamaAlgorithm(
    SugiyamaConfiguration()
      ..nodeSeparation = 50
      ..levelSeparation = 80
      ..coordinateAssignment = CoordinateAssignment.Average,
  );

  /// Builds positioned colored dot badges around a family tree node
  /// indicating inherited traits.
  List<Widget> _buildTraitBadges(List<TraitInheritance> traits) {
    // Positions around the avatar circle (clockwise from top-right)
    const positions = [
      Offset(32, -8),  // top-right
      Offset(-6, -8),  // top-left
      Offset(32, 18),  // bottom-right
      Offset(-6, 18),  // bottom-left
    ];

    final badges = <Widget>[];
    for (int i = 0; i < traits.length && i < positions.length; i++) {
      final trait = traits[i];
      final color = Color(
        AnalyzeTraitInheritanceUseCase.badgeColor(trait.colorIndex),
      );
      final pos = positions[i];

      badges.add(
        Positioned(
          left: pos.dx,
          top: pos.dy,
          child: Tooltip(
            message: '${trait.traitLabel}: ${trait.traitValue}',
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.surface,
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.check,
                size: 8,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }
    return badges;
  }

  /// Shows a dialog with trait inheritance details for a character.
  void _showTraitTooltip(
    BuildContext context,
    Entity entity,
    List<TraitInheritance> traits,
  ) {
    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Text(
            'Traits of ${entity.name}',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontFamily: Theme.of(context).textTheme.displayLarge?.fontFamily,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: traits.length,
              itemBuilder: (_, i) {
                final t = traits[i];
                final badgeColor = Color(
                  AnalyzeTraitInheritanceUseCase.badgeColor(
                    t.colorIndex,
                  ),
                );
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        margin: const EdgeInsets.only(top: 4, right: 10),
                        decoration: BoxDecoration(
                          color: badgeColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${t.traitLabel}: ${t.traitValue}',
                              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            if (t.isInherited) ...[
                              SizedBox(height: 4),
                              Text(
                                'Inherited from: '
                                '${t.inheritedFromNames.join(', ')}',
                                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  /// Runs a continuity check across all entities,
  /// relationships, and timeline entries.
  Future<void> _showContinuityCheck(
    List<Entity> entities,
    List<Relationship> relationships,
  ) async {
    final timelineRepo = getIt<TimelineRepositoryImpl>();
    final tlResult = await timelineRepo.getAllActiveOrdered();
    final timelineEntries = tlResult.fold((_) => <TimelineEntry>[], (l) => l);

    final checkUseCase = getIt<ContinuityCheckUseCase>();
    final result = await checkUseCase(ContinuityCheckParams(
      entities: entities,
      relationships: relationships,
      timelineEntries: timelineEntries,
    ));

    if (!mounted) return;

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Check failed: ${failure.message}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      },
      (checkResult) {
        showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: Row(
              children: [
                Icon(
                  checkResult.isClean
                      ? Icons.check_circle_outline
                      : Icons.warning_amber_outlined,
                  color: checkResult.isClean
                      ? Theme.of(context).colorScheme.tertiary
                      : Colors.amber,
                ),
                SizedBox(width: 8),
                Text(
                  checkResult.isClean
                      ? 'All Clear!'
                      : '${checkResult.violations.length} Issue${checkResult.violations.length == 1 ? '' : 's'} Found',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: checkResult.isClean
                  ? Text(
                      'No continuity issues detected in your world.',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: checkResult.violations.length,
                      itemBuilder: (_, i) {
                        final v = checkResult.violations[i];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    v.severity == 'error'
                                        ? Icons.error
                                        : Icons.info_outline,
                                    size: 16,
                                    color: v.severity == 'error'
                                        ? Theme.of(context).colorScheme.error
                                        : Colors.amber,
                                  ),
                                  SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      v.message,
                                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                        fontSize: 13,
                                        color: Theme.of(context).colorScheme.onSurface,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (v.fixSuggestion != null) ...[
                                SizedBox(height: 4),
                                Padding(
                                  padding: EdgeInsets.only(left: 22),
                                  child: Text(
                                    '💡 ${v.fixSuggestion}',
                                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Extract min/max year ranges from entity custom fields.
  ({int min, int max}) _extractYearRange(List<Entity> entities) {
    int? minYear;
    int? maxYear;
    for (final entity in entities) {
      for (final field in entity.customFields) {
        final key = field.key.toLowerCase();
        final val = field.value?.toString() ?? '';
        if (val.isEmpty) continue;
        final isDateKey = key.contains('birth') ||
            key.contains('born') ||
            key.contains('founded') ||
            key.contains('formed') ||
            key.contains('start') ||
            key.contains('begin') ||
            key.contains('death') ||
            key.contains('died') ||
            key.contains('dissolved') ||
            key.contains('end') ||
            key.contains('era');
        if (!isDateKey) continue;
        final year = int.tryParse(
          val.replaceAll(RegExp(r'[^0-9-]'), ''),
        );
        if (year != null) {
          minYear = minYear == null
              ? year
              : (year < minYear ? year : minYear);
          maxYear = maxYear == null
              ? year
              : (year > maxYear ? year : maxYear);
        }
      }
    }
    return (min: minYear ?? 0, max: maxYear ?? 0);
  }

  /// Keep entities whose temporal range includes [year].
  List<Entity> _filterByYear(List<Entity> entities, int year) {
    return entities.where((entity) {
      int? start;
      int? end;
      for (final field in entity.customFields) {
        final key = field.key.toLowerCase();
        final val = field.value?.toString() ?? '';
        if (val.isEmpty) continue;
        final yearVal =
            int.tryParse(val.replaceAll(RegExp(r'[^0-9-]'), ''));
        if (yearVal == null) continue;
        if (key.contains('birth') ||
            key.contains('born') ||
            key.contains('founded') ||
            key.contains('formed') ||
            key.contains('start') ||
            key.contains('begin')) {
          start = yearVal;
        }
        if (key.contains('death') ||
            key.contains('died') ||
            key.contains('dissolved') ||
            key.contains('end')) {
          end = yearVal;
        }
      }
      if (start == null && end == null) return true;
      if (start != null && year < start) return false;
      if (end != null && year > end) return false;
      return true;
    }).toList();
  }

  /// Build era markers from entities with era custom fields.
  List<EraMarker> _buildEraMarkers(List<Entity> entities) {
    final eraColors = [
      Colors.amber,
      Colors.teal,
      Colors.deepPurple,
      Colors.red,
      Colors.indigo,
      Colors.orange,
    ];
    final eras = <String, ({int start, int end})>{};
    for (final entity in entities) {
      int? start;
      int? end;
      String? eraName;
      for (final field in entity.customFields) {
        final key = field.key.toLowerCase();
        final val = field.value?.toString() ?? '';
        if (val.isEmpty) continue;
        if (key == 'era' || key == 'era_name') {
          eraName = val;
        }
        if (key.contains('start') || key.contains('begin') || key.contains('founded')) {
          start = int.tryParse(val.replaceAll(RegExp(r'[^0-9-]'), ''));
        }
        if (key.contains('end') || key.contains('dissolved') || key.contains('died')) {
          end = int.tryParse(val.replaceAll(RegExp(r'[^0-9-]'), ''));
        }
      }
      if (eraName != null && start != null && end != null) {
        eras[eraName] = (start: start, end: end);
      }
    }
    if (eras.isEmpty) return [];
    return eras.entries.toList().asMap().entries.map((e) {
      final idx = e.key;
      final era = e.value;
      return EraMarker(
        label: era.key,
        startYear: era.value.start,
        endYear: era.value.end,
        color: eraColors[idx % eraColors.length],
      );
    }).toList();
  }

  void _zoom(double factor) {
    final matrix = _transformationController.value.clone();
    matrix.scale(factor, factor);
    _transformationController.value = matrix;
  }

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
  }

  Future<void> _startConnectionForge(List<Entity> entities) async {
    final source = await showModalBottomSheet<Entity>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        String query = '';
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filtered = entities
                .where((e) => e.name.toLowerCase().contains(query.toLowerCase()))
                .toList();

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.all(20),
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Source Entity',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontFamily: Theme.of(context).textTheme.displayLarge?.fontFamily,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      autofocus: true,
                      style: Theme.of(context).textTheme.bodyLarge!,
                      decoration: const InputDecoration(
                        hintText: 'Search entity name...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (val) {
                        setModalState(() {
                          query = val;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final e = filtered[index];
                          final color = Color(e.iconColor);
                          return ListTile(
                            dense: true,
                            leading: CircleAvatar(
                              radius: 12,
                              backgroundColor: color.withOpacity(0.15),
                              child: Text(
                                e.name.isNotEmpty ? e.name[0].toUpperCase() : '?',
                                style: TextStyle(
                                    color: color,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            title: Text(e.name, style: Theme.of(context).textTheme.bodyLarge!),
                            subtitle: Text(e.type.label, style: Theme.of(context).textTheme.labelMedium!),
                            onTap: () => Navigator.pop(ctx, e),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (source == null || !mounted) return;

    final result = await showModalBottomSheet<CreateRelationshipParams?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => RelationshipPickerSheet(sourceEntity: source),
    );

    if (result == null || !mounted) return;

    final cr = getIt<CreateRelationshipUseCase>();
    final res = await cr(result);
    res.fold(
      (f) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(f.message), backgroundColor: Theme.of(context).colorScheme.error),
        );
      },
      (success) {
        ref.invalidate(graphDataProvider);

        if (success.reciprocalSuggestionTypeKey != null) {
          final def = RelationshipTypeRegistry.getDef(success.reciprocalSuggestionTypeKey!);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Connection forged. Create reciprocal link "${def?.label}" back?'),
              backgroundColor: Theme.of(context).colorScheme.primary,
              duration: const Duration(seconds: 8),
              action: SnackBarAction(
                label: 'Forge Link',
                textColor: Theme.of(context).colorScheme.surface,
                onPressed: () async {
                  final recParams = CreateRelationshipParams(
                    sourceId: result.targetId,
                    targetId: result.sourceId,
                    typeKey: success.reciprocalSuggestionTypeKey!,
                    description: 'Reciprocal link created automatically',
                  );
                  final recRes = await getIt<CreateRelationshipUseCase>()(recParams);
                  recRes.fold(
                    (f) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(f.message), backgroundColor: Theme.of(context).colorScheme.error),
                      );
                    },
                    (_) {
                      ref.invalidate(graphDataProvider);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Reciprocal link successfully forged.'),
                          backgroundColor: Theme.of(context).colorScheme.tertiary,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Connection forged.'),
              backgroundColor: Theme.of(context).colorScheme.tertiary,
            ),
          );
        }
      },
    );
  }

  Widget _buildZoomControls() {
    return Positioned(
      bottom: 16,
      right: 16,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _zoom(1.2),
                tooltip: 'Zoom In',
              ),
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () => _zoom(0.85),
                tooltip: 'Zoom Out',
              ),
              IconButton(
                icon: const Icon(Icons.filter_center_focus),
                onPressed: _resetZoom,
                tooltip: 'Reset Zoom',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConnectionFAB(List<Entity> entities) {
    return Positioned(
      bottom: 16,
      left: 16,
      child: FloatingActionButton.extended(
        heroTag: 'graph_connect_fab',
        onPressed: () => _startConnectionForge(entities),
        icon: const Icon(Icons.link),
        label: const Text('Forge Connection', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }

  Widget _buildLayoutDropdown() {
    return Positioned(
      top: 16,
      right: 16,
      child: Container(
        width: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: FictionistDropdown<GraphLayoutMode>(
          value: _layoutMode,
          items: [
            DropdownMenuItem(value: GraphLayoutMode.chronicleWeb, child: Text('Web')),
            DropdownMenuItem(value: GraphLayoutMode.familyTree, child: Text('Family')),
            DropdownMenuItem(value: GraphLayoutMode.factionMap, child: Text('Faction')),
            DropdownMenuItem(value: GraphLayoutMode.relationshipMatrix, child: Text('Matrix')),
          ].map((item) => FictionistDropdownItem<GraphLayoutMode>(
            value: item.value!,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getLayoutIcon(item.value!),
                  size: 14,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  (item.child as Text).data!,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          )).toList(),
          onChanged: (val) {
            HapticFeedback.selectionClick();
            setState(() => _layoutMode = val);
          },
        ),
      ),
    );
  }

  IconData _getLayoutIcon(GraphLayoutMode mode) {
    switch (mode) {
      case GraphLayoutMode.chronicleWeb:
        return Icons.hub_outlined;
      case GraphLayoutMode.familyTree:
        return Icons.account_tree_outlined;
      case GraphLayoutMode.factionMap:
        return Icons.shield_outlined;
      case GraphLayoutMode.relationshipMatrix:
        return Icons.grid_on_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final graphState = ref.watch(graphDataProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          PageHeader(
            title: 'Web',
            subtitle: 'Entity relationship graph',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.refresh, color: Theme.of(context).colorScheme.onSurface, size: 20),
                  tooltip: 'Refresh Graph',
                  onPressed: () => ref.invalidate(graphDataProvider),
                ),
                IconButton(
                  icon: Icon(Icons.plagiarism_outlined, color: Theme.of(context).colorScheme.secondary, size: 20),
                  tooltip: 'Continuity Check',
                  onPressed: () async {
                    final graphData = ref.read(graphDataProvider).valueOrNull;
                    if (graphData == null || !mounted) return;
                    _showContinuityCheck(
                      graphData.$1,
                      graphData.$2,
                    );
                  },
                ),
                if (_layoutMode != GraphLayoutMode.relationshipMatrix)
                  IconButton(
                    icon: Icon(
                      _scrubberVisible ? Icons.timeline : Icons.timeline_outlined,
                      color: _scrubberVisible
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    tooltip: 'Timeline Scrubber',
                    onPressed: () {
                      setState(() => _scrubberVisible = !_scrubberVisible);
                    },
                  ),
              ],
            ),
          ),
          Expanded(
            child: graphState.when(
              data: (data) {
                final entities = data.$1;
                final relationships = data.$2;



          if (entities.isEmpty) {
            return const EmptyState(
              title: 'No Entities Exist',
              message: 'Add entities and link them to view the connection web.',
              icon: Icons.hub_outlined,
            );
          }

          // Apply filters depending on Layout Mode
          List<Entity> filteredEntities = [];
          List<Relationship> activeRels = [];
          Algorithm activeAlgorithm;

          switch (_layoutMode) {
            case GraphLayoutMode.chronicleWeb:
              filteredEntities =
                  entities.where((e) => _enabledTypes.contains(e.type)).toList();
              final filteredIds = filteredEntities.map((e) => e.id).toSet();
              activeRels = relationships
                  .where((r) =>
                      filteredIds.contains(r.sourceId) &&
                      filteredIds.contains(r.targetId))
                  .toList();
              activeAlgorithm = _forceAlgorithm;
              break;

            case GraphLayoutMode.familyTree:
              filteredEntities =
                  entities.where((e) => e.type == EntityType.character).toList();
              final filteredIds = filteredEntities.map((e) => e.id).toSet();
              final familyKeys = {
                'parent_of',
                'child_of',
                'sibling_of',
                'married_to'
              };
              activeRels = relationships
                  .where((r) =>
                      familyKeys.contains(r.typeKey) &&
                      filteredIds.contains(r.sourceId) &&
                      filteredIds.contains(r.targetId))
                  .toList();
              activeAlgorithm = _treeAlgorithm;
              break;

            case GraphLayoutMode.factionMap:
              filteredEntities = entities
                  .where((e) =>
                      e.type == EntityType.faction ||
                      e.type == EntityType.character)
                  .toList();
              final filteredIds = filteredEntities.map((e) => e.id).toSet();
              final politicalKeys = {
                'ally_of',
                'enemy_of',
                'rival_of',
                'rules_over',
                'member_of',
                'leader_of'
              };
              activeRels = relationships
                  .where((r) =>
                      politicalKeys.contains(r.typeKey) &&
                      filteredIds.contains(r.sourceId) &&
                      filteredIds.contains(r.targetId))
                  .toList();
              activeAlgorithm = _forceAlgorithm;
              break;

            case GraphLayoutMode.relationshipMatrix:
              filteredEntities =
                  entities.where((e) => e.type == EntityType.character).toList();
              final characterIds = filteredEntities.map((e) => e.id).toSet();
              activeRels = relationships
                  .where((r) =>
                      characterIds.contains(r.sourceId) &&
                      characterIds.contains(r.targetId))
                  .toList();
              activeAlgorithm = _forceAlgorithm;
              break;
          }

          if (filteredEntities.isEmpty) {
            return Center(
              child: Text(
                'No entities fit current filter criteria.',
                style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            );
          }

          // Extract temporal ranges for timeline scrubbing
          if (!_scrubberVisible) {
            _scrubMinMax = _extractYearRange(filteredEntities);
            _scrubYear ??= _scrubMinMax?.min;
          }
          
          // Compute trait inheritance for family tree mode
          if (_layoutMode == GraphLayoutMode.familyTree) {
            final traitUseCase = getIt<AnalyzeTraitInheritanceUseCase>();
            final traitResult = traitUseCase(AnalyzeTraitInheritanceParams(
              characters: filteredEntities,
              relationships: activeRels,
            ));
            traitResult.then((either) {
              either.fold((_) {}, (traits) {
                if (mounted) {
                  setState(() {
                    _traitMap = {};
                    for (final t in traits) {
                      _traitMap.putIfAbsent(t.entityId, () => []);
                      _traitMap[t.entityId]!.add(t);
                    }
                  });
                }
              });
            });
          }

          // Filter by scrub year if enabled
          if (_scrubberVisible && _scrubYear != null) {
            filteredEntities = _filterByYear(
              filteredEntities,
              _scrubYear!,
            );
            final filteredIds = filteredEntities.map((e) => e.id).toSet();
            activeRels = activeRels
                .where((r) =>
                    filteredIds.contains(r.sourceId) &&
                    filteredIds.contains(r.targetId))
                .toList();
          }

          // Build GraphView nodes & edges
          final Graph graph = Graph()..isTree = (_layoutMode == GraphLayoutMode.familyTree);
          final Map<String, Node> nodeMap = {};

          final isDraggableMode = (_layoutMode == GraphLayoutMode.chronicleWeb ||
              _layoutMode == GraphLayoutMode.factionMap);

          int isolatedCount = 0;
          for (final entity in filteredEntities) {
            final node = Node.Id(entity.id);
            graph.addNode(node);
            nodeMap[entity.id] = node;

            if (isDraggableMode) {
              if (_draggedPositions.containsKey(entity.id)) {
                node.position = _draggedPositions[entity.id]!;
              } else {
                // If it's isolated (has no relationships in activeRels), spread it out
                final hasRels = activeRels.any((r) =>
                    r.sourceId == entity.id || r.targetId == entity.id);
                if (!hasRels) {
                  final angle = isolatedCount * 0.5;
                  final radius = 120.0 + (isolatedCount * 30.0);
                  final pos = Offset(
                    500.0 + radius * math.cos(angle),
                    500.0 + radius * math.sin(angle),
                  );
                  _draggedPositions[entity.id] = pos;
                  node.position = pos;
                  isolatedCount++;
                }
              }
            }
          }

          for (final rel in activeRels) {
            final sourceNode = nodeMap[rel.sourceId];
            final targetNode = nodeMap[rel.targetId];
            if (sourceNode != null && targetNode != null) {
              final edgePaint = Paint()
                ..color = Theme.of(context).colorScheme.primary.withOpacity(0.1 + (rel.weight / 10.0) * 0.4)
                ..strokeWidth = 1.0 + (rel.weight / 10.0) * 4.0
                ..style = PaintingStyle.stroke;
              graph.addEdge(sourceNode, targetNode, paint: edgePaint);
            }
          }

          return Column(
            children: [
              // Filters Chip Bar (Only in Web Mode)
              if (_layoutMode == GraphLayoutMode.chronicleWeb)
                Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: EntityType.values.map((type) {
                      final isSelected = _enabledTypes.contains(type);
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text(type.label, style: const TextStyle(fontSize: 11)),
                          selected: isSelected,
                          selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                          checkmarkColor: Theme.of(context).colorScheme.primary,
                          onSelected: (val) {
                            setState(() {
                              if (val) {
                                _enabledTypes.add(type);
                              } else {
                                if (_enabledTypes.length > 1) {
                                  _enabledTypes.remove(type);
                                }
                              }
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                )
              else if (_layoutMode != GraphLayoutMode.relationshipMatrix)
                Container(
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.surface,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    _layoutMode == GraphLayoutMode.familyTree
                        ? 'Family Tree: Displays character bloodlines & generations.'
                        : 'Faction Map: Displays political allegiances & leaders.',
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ),
              Expanded(
                child: _layoutMode == GraphLayoutMode.relationshipMatrix
                    ? Stack(
                        children: [
                          RelationshipMatrixWidget(
                            characters: entities.where((e) => e.type == EntityType.character).toList(),
                            relationships: relationships,
                            onForgeConnection: (source, target) async {
                              final result = await showModalBottomSheet<CreateRelationshipParams?>(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (ctx) => RelationshipPickerSheet(
                                  sourceEntity: source,
                                  targetEntity: target,
                                ),
                              );
                              if (result == null || !mounted) return;
                              final cr = getIt<CreateRelationshipUseCase>();
                              final res = await cr(result);
                              res.fold(
                                (f) => ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(f.message), backgroundColor: Theme.of(context).colorScheme.error),
                                ),
                                (success) {
                                  ref.invalidate(graphDataProvider);
                                  if (success.reciprocalSuggestionTypeKey != null) {
                                    final def = RelationshipTypeRegistry.getDef(success.reciprocalSuggestionTypeKey!);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Connection forged. Create reciprocal link "${def?.label}" back?'),
                                        backgroundColor: Theme.of(context).colorScheme.primary,
                                        duration: const Duration(seconds: 8),
                                        action: SnackBarAction(
                                          label: 'Forge Link',
                                          textColor: Theme.of(context).colorScheme.surface,
                                          onPressed: () async {
                                            final recParams = CreateRelationshipParams(
                                              sourceId: result.targetId,
                                              targetId: result.sourceId,
                                              typeKey: success.reciprocalSuggestionTypeKey!,
                                              description: 'Reciprocal link created automatically',
                                            );
                                            final recRes = await getIt<CreateRelationshipUseCase>()(recParams);
                                            recRes.fold(
                                              (f) => ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text(f.message), backgroundColor: Theme.of(context).colorScheme.error),
                                              ),
                                              (_) {
                                                ref.invalidate(graphDataProvider);
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: const Text('Reciprocal link successfully forged.'),
                                                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text('Connection forged.'),
                                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                            onDeleteConnection: (rel) async {
                              final relRepo = getIt<RelationshipRepositoryImpl>();
                              final res = await relRepo.delete(rel.id);
                              res.fold(
                                (f) => ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(f.message), backgroundColor: Theme.of(context).colorScheme.error),
                                ),
                                (_) {
                                  ref.invalidate(graphDataProvider);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: const Text('Connection severed.')),
                                  );
                                },
                              );
                            },
                          ),
                          _buildLayoutDropdown(),
                        ],
                      )
                    : (graph.nodes.isNotEmpty
                        ? Stack(
                            children: [
                              InteractiveViewer(
                                transformationController: _transformationController,
                                constrained: false,
                                boundaryMargin: const EdgeInsets.all(500),
                                minScale: 0.1,
                                maxScale: 3.0,
                                child: GraphView(
                                  graph: graph,
                                  algorithm: activeAlgorithm,
                                  paint: Paint()
                                    ..color = Theme.of(context).colorScheme.primary.withOpacity(0.35)
                                    ..strokeWidth = 2.0
                                    ..style = PaintingStyle.stroke,
                                  builder: (Node node) {
                                    final entityId = node.key!.value as String;
                                    final entity = filteredEntities.firstWhere(
                                      (e) => e.id == entityId,
                                      orElse: () => filteredEntities.first,
                                    );
                                    final iconColor = Color(entity.iconColor);

                                    // Trait badges for family tree mode
                                    final traits = _traitMap[entityId] ?? [];
                                    final showTraits =
                                        _layoutMode == GraphLayoutMode.familyTree &&
                                        traits.isNotEmpty;

                                    final isFaction = entity.type == EntityType.faction;

                                    return GestureDetector(
                                      onTap: () => showEntityPeekSheet(context, entityId: entity.id),
                                      onLongPress: showTraits
                                          ? () => _showTraitTooltip(context, entity, traits)
                                          : null,
                                      onPanUpdate: isDraggableMode
                                          ? (details) {
                                              setState(() {
                                                final double zoomScale = _transformationController.value.getMaxScaleOnAxis();
                                                final newPos = Offset(
                                                  node.position.dx + details.delta.dx / zoomScale,
                                                  node.position.dy + details.delta.dy / zoomScale,
                                                );
                                                _draggedPositions[entity.id] = newPos;
                                                node.position = newPos;
                                              });
                                            }
                                          : null,
                                      child: Column(
                                        key: ValueKey(entity.id),
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Avatar with optional trait badges
                                          Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              Container(
                                                width: isFaction ? 56 : 48,
                                                height: isFaction ? 56 : 48,
                                                decoration: BoxDecoration(
                                                  color: iconColor.withOpacity(0.12),
                                                  shape: BoxShape.rectangle,
                                                  borderRadius: _getNodeBorderRadius(entity.type),
                                                  border: Border.all(
                                                    color: iconColor,
                                                    width: isFaction ? 2.5 : 1.5,
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: iconColor.withOpacity(0.3),
                                                      blurRadius: 10,
                                                      spreadRadius: 1,
                                                    ),
                                                    BoxShadow(
                                                      color: iconColor.withOpacity(0.15),
                                                      blurRadius: 4,
                                                      offset: const Offset(0, 2),
                                                    ),
                                                  ],
                                                  gradient: RadialGradient(
                                                    colors: [
                                                      iconColor.withOpacity(0.2),
                                                      iconColor.withOpacity(0.04),
                                                    ],
                                                    radius: 0.85,
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                    _getEntityIcon(entity.type),
                                                    color: iconColor,
                                                    size: isFaction ? 28 : 22,
                                                  ),
                                                ),
                                              ),
                                              // Trait badges (colored dots around border)
                                              if (showTraits)
                                                ..._buildTraitBadges(traits),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 3,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(
                                                color: iconColor.withOpacity(0.3),
                                                width: 0.8,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.06),
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 1),
                                                ),
                                              ],
                                            ),
                                            child: Text(
                                              entity.name,
                                              style: TextStyle(
                                                color: Theme.of(context).colorScheme.onSurface,
                                                fontSize: 9.5,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.2,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              _buildZoomControls(),
                              _buildConnectionFAB(filteredEntities),
                              _buildLayoutDropdown(),
                            ],
                          )
                        : const SizedBox.shrink()),
              ),
              // Timeline Scrubber
              if (_scrubberVisible && _scrubMinMax != null)
                TimelineScrubber(
                  minYear: _scrubMinMax!.min,
                  maxYear: _scrubMinMax!.max,
                  totalEntityCount: entities.length,
                  visibleEntityCount: filteredEntities.length,
                  eras: _buildEraMarkers(entities),
                  onYearChanged: (year) => setState(() => _scrubYear = year),
                  onClose: () => setState(() => _scrubberVisible = false),
                  enabled: true,
                ),
            ],
          );
        },
        loading: () => const LoadingIndicator(),
        error: (err, _) => ErrorDisplay(
          message: err.toString(),
          onRetry: () => ref.refresh(graphDataProvider),
        ),
      ),
    ),
  ],
),
    );
  }
}
