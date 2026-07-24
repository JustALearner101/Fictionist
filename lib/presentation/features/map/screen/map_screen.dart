import 'dart:io';
import 'dart:math' as math;
import 'dart:convert';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../domain/entity/entity.dart';
import '../../../../domain/entity/entity_type.dart';
import '../../../../domain/entity/entity_status.dart';
import '../../../../domain/use_case/entity/create_entity_use_case.dart';
import '../../../../injection.dart';
import '../../../../domain/map/world_map.dart';
import '../../../common/widget/confirm_dialog.dart';
import '../../../common/widget/empty_state.dart';
import '../../../common/widget/error_display.dart';
import '../../../common/widget/loading_indicator.dart';
import '../../entity/provider/entity_list_provider.dart';
import '../../../common/widget/page_header.dart';
import '../../../common/widget/fictionist_dropdown.dart';
import '../../entity/widget/entity_peek_sheet.dart';
import '../../graph/provider/graph_provider.dart';
import '../../timeline/provider/timeline_provider.dart';
import '../provider/map_provider.dart';
import '../../manuscript/provider/manuscript_provider.dart';
import '../../../../domain/map/map_pin.dart';
import '../../../../domain/relationship/relationship.dart';
import '../../../../domain/manuscript/manuscript_chapter.dart';
import '../../../../domain/timeline/timeline_entry.dart';
import 'package:uuid/uuid.dart';

enum MapFilterMode { original, sepia, dark, satellite }

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  WorldMap? _selectedMap;
  MapFilterMode _filterMode = MapFilterMode.original;
  final List<Offset> _activeRipples = [];
  String? _selectedPinId;
  Entity? _selectedPinEntity;
  
  bool _showHeatmap = false;
  bool _measuringMode = false;
  MapPin? _measureStartPin;
  MapPin? _measureTargetPin;

  bool _showTimelineScrubber = false;
  int _timelineIndex = 0;
  bool _showJourneyTracker = false;
  String? _selectedJourneyCharacterId;

  String? _lastLoadedMapId;

  bool _showGridControls = false;
  bool _showFogControls = false;
  bool _showRouteControls = false;

  bool _showGrid = false;
  String _gridType = 'square';
  double _gridSize = 40.0;
  double _gridOpacity = 0.3;

  bool _showFogOfWar = false;
  bool _isBrushingFog = false;
  double _fogBrushSize = 30.0;
  List<List<Offset>> _revealedStrokes = [];
  List<Offset>? _activeStroke;

  bool _isDrawingRoute = false;
  List<Offset> _activeRoutePoints = [];
  String _activeRouteType = 'road';
  final TextEditingController _activeRouteNameController = TextEditingController();
  List<CustomRoute> _customRoutes = [];
  bool _isAddingPinMode = false;
  bool _toolbarExpanded = false;
  String? _activeToolTab;

  @override
  void dispose() {
    _activeRouteNameController.dispose();
    super.dispose();
  }

  Future<void> _uploadMap() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      final pickedPath = result.files.single.path!;
      final _nameController = TextEditingController();

      final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: Text(
              'Name World Map',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(fontFamily: 'Lora'),
            ),
            content: TextField(
              controller: _nameController,
              style: Theme.of(context).textTheme.bodyLarge!,
              decoration: InputDecoration(
                labelText: 'Map Name (e.g. Scania Region)',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text('Cancel', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_nameController.text.trim().isNotEmpty) {
                    Navigator.of(ctx).pop(true);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.surface,
                ),
                child: const Text('Create'),
              ),
            ],
          );
        },
      );

      if (confirm == true) {
        final name = _nameController.text.trim();
        await ref.read(worldMapListProvider.notifier).addMap(name, pickedPath);
        // Deselect map so we reload the list and pick the new one
        setState(() => _selectedMap = null);
      }
    }
  }

  Future<void> _deleteMap(WorldMap map) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => ConfirmDialog(
        title: 'Delete Map',
        content: 'Are you sure you want to delete "${map.name}" and all of its pins?',
        confirmLabel: 'Delete',
        isDestructive: true,
      ),
    );

    if (confirm == true) {
      await ref.read(worldMapListProvider.notifier).deleteMap(map.id, map.imagePath);
      setState(() => _selectedMap = null);
    }
  }

  Future<void> _onMapLongPress(
    BuildContext context,
    LongPressStartDetails details,
    BoxConstraints constraints,
    String mapId,
  ) async {
    await _onMapDropPinAtOffset(context, details.localPosition, constraints, mapId);
  }

  Future<void> _onMapDropPinAtOffset(
    BuildContext context,
    Offset localPos,
    BoxConstraints constraints,
    String mapId,
  ) async {
    setState(() {
      _activeRipples.add(localPos);
    });

    final xPercent = localPos.dx / constraints.maxWidth;
    final yPercent = localPos.dy / constraints.maxHeight;

    final entitiesResult = await ref.read(entityListProvider.future);
    final locationEntities =
        entitiesResult.where((e) => e.type == EntityType.location).toList();

    Entity? selectedLocation;
    String searchQuery = '';

    final confirm = await showModalBottomSheet<Entity?>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        int activeTab = 0;
        String searchQuery = '';
        Entity? selectedLocation;
        
        final nameController = TextEditingController();
        final descController = TextEditingController();
        String selectedType = 'City';
        int selectedColor = 0xFF3B82F6; // Blue

        return StatefulBuilder(
          builder: (context, setModalState) {
            final theme = Theme.of(context);
            final filtered = locationEntities
                .where((e) => e.name.toLowerCase().contains(searchQuery.toLowerCase()))
                .toList();

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pin Location',
                      style: theme.textTheme.headlineMedium!.copyWith(
                        fontFamily: 'Lora',
                        color: theme.colorScheme.primary,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Segmented Tabs
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => setModalState(() => activeTab = 0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(
                                  color: activeTab == 0 ? theme.colorScheme.primary : Colors.transparent,
                                  width: 2,
                                )),
                              ),
                              alignment: Alignment.center,
                              child: Text('Pin Existing', style: TextStyle(
                                fontWeight: activeTab == 0 ? FontWeight.bold : FontWeight.normal,
                                color: activeTab == 0 ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                              )),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () => setModalState(() => activeTab = 1),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(
                                  color: activeTab == 1 ? theme.colorScheme.primary : Colors.transparent,
                                  width: 2,
                                )),
                              ),
                              alignment: Alignment.center,
                              child: Text('Create Custom', style: TextStyle(
                                fontWeight: activeTab == 1 ? FontWeight.bold : FontWeight.normal,
                                color: activeTab == 1 ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                              )),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    if (activeTab == 0) ...[
                      // Tab 0: Pin Existing Location
                      TextField(
                        onChanged: (val) => setModalState(() => searchQuery = val),
                        style: theme.textTheme.bodyLarge!,
                        decoration: const InputDecoration(
                          hintText: 'Search location name...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 200,
                        child: locationEntities.isEmpty
                            ? Center(
                                child: Text(
                                  'No locations in Codex. Use "Create Custom" tab!',
                                  style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                                ),
                              )
                            : filtered.isEmpty
                                ? Center(
                                    child: Text(
                                      'No matching locations found.',
                                      style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: filtered.length,
                                    itemBuilder: (context, idx) {
                                      final loc = filtered[idx];
                                      final isSelected = selectedLocation?.id == loc.id;
                                      final iconColor = Color(loc.iconColor);

                                      return ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: CircleAvatar(
                                          backgroundColor: iconColor.withOpacity(0.15),
                                          child: Icon(Icons.location_city, color: iconColor),
                                        ),
                                        title: Text(
                                          loc.name,
                                          style: theme.textTheme.bodyLarge!.copyWith(
                                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                          ),
                                        ),
                                        trailing: isSelected
                                            ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
                                            : null,
                                        onTap: () {
                                          setModalState(() => selectedLocation = loc);
                                        },
                                      );
                                    },
                                  ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, null),
                            child: Text('Cancel', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: selectedLocation != null
                                ? () => Navigator.pop(ctx, selectedLocation)
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.surface,
                            ),
                            child: const Text('Place Pin'),
                          ),
                        ],
                      ),
                    ] else ...[
                      // Tab 1: Create Custom Location
                      TextField(
                        controller: nameController,
                        style: theme.textTheme.bodyLarge!,
                        decoration: const InputDecoration(
                          labelText: 'Location Name',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: selectedType,
                        decoration: const InputDecoration(
                          labelText: 'Symbol Category',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'City', child: Text('City / Settlement')),
                          DropdownMenuItem(value: 'Fortress', child: Text('Castle / Fortress')),
                          DropdownMenuItem(value: 'Mountain', child: Text('Mountain / Peak')),
                          DropdownMenuItem(value: 'Cave', child: Text('Cave / Mine')),
                          DropdownMenuItem(value: 'Forest', child: Text('Forest / Grove')),
                          DropdownMenuItem(value: 'Port', child: Text('Water / Port')),
                          DropdownMenuItem(value: 'Oasis', child: Text('Oasis / Garden')),
                          DropdownMenuItem(value: 'Ruins', child: Text('Ancient Ruins')),
                          DropdownMenuItem(value: 'Star', child: Text('Custom Pin Point')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setModalState(() => selectedType = val);
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Pin Color',
                        style: theme.textTheme.labelMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          0xFF10B981,
                          0xFF3B82F6,
                          0xFFEF4444,
                          0xFF8B5CF6,
                          0xFFF59E0B,
                          0xFF64748B,
                        ].map((colorVal) {
                          final color = Color(colorVal);
                          final isSelected = selectedColor == colorVal;
                          return GestureDetector(
                            onTap: () => setModalState(() => selectedColor = colorVal),
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: color,
                              child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: descController,
                        maxLines: 2,
                        style: theme.textTheme.bodyMedium!,
                        decoration: const InputDecoration(
                          labelText: 'Description (Optional)',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, null),
                            child: Text('Cancel', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () async {
                              final name = nameController.text.trim();
                              if (name.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please enter a location name'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              final customDescription = descController.text.trim();
                              final typeDesc = 'A custom $selectedType.';
                              final finalDesc = '$name ($selectedType). $typeDesc ${customDescription.isNotEmpty ? customDescription : ""} Keywords: ${selectedType.toLowerCase()}';

                              final createUseCase = getIt<CreateEntityUseCase>();
                              final result = await createUseCase(CreateEntityParams(
                                name: name,
                                type: EntityType.location,
                                status: EntityStatus.canon,
                                description: finalDesc,
                                iconColor: selectedColor,
                              ));

                              result.fold(
                                (failure) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Failed to create location: ${failure.message}'),
                                      backgroundColor: theme.colorScheme.error,
                                    ),
                                  );
                                },
                                (newEntity) {
                                  ref.invalidate(entityListProvider);
                                  Navigator.pop(ctx, newEntity);
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.surface,
                            ),
                            child: const Text('Create & Place'),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (confirm != null) {
      await ref.read(mapPinsProvider(mapId).notifier).addPin(
            entityId: confirm.id,
            xPercent: xPercent,
            yPercent: yPercent,
          );
      setState(() {
        _isAddingPinMode = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pinned "${confirm.name}" to map.'),
          backgroundColor: Theme.of(context).colorScheme.tertiary,
        ),
      );
    }
  }

  void _showPinDetails(BuildContext context, Entity entity, String pinId, String mapId) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                child: Consumer(
                  builder: (context, ref, _) {
                    final graphAsyncVal = ref.watch(graphDataProvider);
                    final timelineAsyncVal = ref.watch(timelineListProvider(entityId: entity.id));
                    final manuscriptState = ref.watch(manuscriptNotifierProvider);
                    
                    final (allEntities, allRels) = graphAsyncVal.valueOrNull ?? ([], []);
                    final relatedRels = allRels.where((r) => r.sourceId == entity.id || r.targetId == entity.id).toList();
                    final relatedPairs = relatedRels.map((r) {
                      final otherId = r.sourceId == entity.id ? r.targetId : r.sourceId;
                      final otherEntity = allEntities.where((e) => e.id == otherId).firstOrNull;
                      return otherEntity != null ? (otherEntity, r.typeKey) : null;
                    }).whereType<(Entity, String)>().toList();

                    final events = timelineAsyncVal.valueOrNull ?? [];
                    
                    final nameLower = entity.name.toLowerCase();
                    final mentions = manuscriptState.chapters.where((c) {
                      return c.locationId == entity.id ||
                             c.title.toLowerCase().contains(nameLower) ||
                             c.content.toLowerCase().contains(nameLower) ||
                             (c.synopsis?.toLowerCase().contains(nameLower) ?? false);
                    }).toList();

                    return ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(20),
                      children: [
                        // Drag Handle
                        Center(
                          child: Container(
                            width: 40,
                            height: 5,
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        // Title Bento Card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).colorScheme.primary.withOpacity(0.12),
                                Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          entity.name,
                                          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                            fontFamily: 'Lora',
                                            color: Theme.of(context).colorScheme.primary,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          entity.type.label.toUpperCase(),
                                          style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                            color: Theme.of(context).colorScheme.primary,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error),
                                    onPressed: () async {
                                      final confirmDelete = await showDialog<bool>(
                                        context: context,
                                        builder: (c) => const ConfirmDialog(
                                          title: 'Remove Pin',
                                          content: 'Are you sure you want to remove this location pin?',
                                          confirmLabel: 'Remove',
                                          isDestructive: true,
                                        ),
                                      );

                                      if (confirmDelete == true) {
                                        await ref.read(mapPinsProvider(mapId).notifier).removePin(pinId);
                                        Navigator.pop(ctx);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: const Text('Pin removed successfully.'),
                                            backgroundColor: Theme.of(context).colorScheme.outline,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                              if (entity.description != null && entity.description!.trim().isNotEmpty) ...[
                                const Divider(height: 24),
                                Text(
                                  entity.description!,
                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    height: 1.4,
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () {
                                        Navigator.pop(ctx);
                                        showEntityPeekSheet(context, entityId: entity.id);
                                      },
                                      icon: const Icon(Icons.zoom_in, size: 18),
                                      label: const Text('Quick Peek'),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.pop(ctx);
                                        context.push('/entities/${entity.id}');
                                      },
                                      icon: const Icon(Icons.chrome_reader_mode, size: 18),
                                      label: const Text('Full Codex'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context).colorScheme.primary,
                                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        // Inhabitants Bento Card
                        if (relatedPairs.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.outline.withOpacity(0.12),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.people_outline, color: Theme.of(context).colorScheme.primary, size: 18),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Linked Inhabitants / Factions',
                                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  height: 80,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: relatedPairs.length,
                                    itemBuilder: (context, index) {
                                      final (other, role) = relatedPairs[index];
                                      final avatarColor = Color(other.iconColor);
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 12.0),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.pop(ctx);
                                            context.push('/entities/${other.id}');
                                          },
                                          borderRadius: BorderRadius.circular(12),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).colorScheme.surface,
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(
                                                color: Theme.of(context).colorScheme.outline.withOpacity(0.08),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 18,
                                                  backgroundColor: avatarColor.withOpacity(0.12),
                                                  child: Text(
                                                    other.name[0],
                                                    style: TextStyle(color: avatarColor, fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      other.name,
                                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                                    ),
                                                    Text(
                                                      role.replaceAll('_', ' '),
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        // Historical Events Bento Card
                        if (events.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.outline.withOpacity(0.12),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.history_edu_outlined, color: Theme.of(context).colorScheme.primary, size: 18),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Historical Chronicle Here',
                                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                ...events.map((ev) {
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.surface,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Theme.of(context).colorScheme.outline.withOpacity(0.06),
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            ev.dateLabel ?? 'Age ?',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context).colorScheme.primary,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                ev.title,
                                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                              ),
                                              if (ev.description != null && ev.description!.isNotEmpty) ...[
                                                const SizedBox(height: 4),
                                                Text(
                                                  ev.description!,
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ],
                        if (mentions.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.chrome_reader_mode_outlined, color: Theme.of(context).colorScheme.primary, size: 18),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Manuscript Occurrences',
                                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                ...mentions.map((ch) {
                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    dense: true,
                                    leading: Icon(Icons.bookmark_outline, color: Theme.of(context).colorScheme.primary, size: 16),
                                    title: Text(
                                      ch.title,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                    ),
                                    subtitle: Text(
                                      ch.synopsis ?? 'No synopsis available.',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                    trailing: Icon(Icons.chevron_right, size: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
                                    onTap: () {
                                      Navigator.pop(ctx);
                                      ref.read(manuscriptNotifierProvider.notifier).selectChapter(ch.id);
                                      context.push('/manuscript');
                                    },
                                  );
                                }),
                              ],
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  IconData _getPinIcon(Entity entity) {
    final name = entity.name.toLowerCase();
    final desc = (entity.description ?? '').toLowerCase();
    final combined = '$name $desc';
    
    if (combined.contains('castle') || combined.contains('fortress') || combined.contains('keep') || combined.contains('citadel') || combined.contains('bastion')) {
      return Icons.fort;
    } else if (combined.contains('tower') || combined.contains('spire') || combined.contains('beacon')) {
      return Icons.castle;
    } else if (combined.contains('city') || combined.contains('town') || combined.contains('village') || combined.contains('settlement') || combined.contains('capital')) {
      return Icons.location_city;
    } else if (combined.contains('temple') || combined.contains('shrine') || combined.contains('sanctuary') || combined.contains('cathedral') || combined.contains('monastery')) {
      return Icons.church;
    } else if (combined.contains('cave') || combined.contains('mine') || combined.contains('tunnel') || combined.contains('dungeon') || combined.contains('peak') || combined.contains('mountain') || combined.contains('hill')) {
      return Icons.terrain;
    } else if (combined.contains('lake') || combined.contains('sea') || combined.contains('ocean') || combined.contains('river') || combined.contains('harbor') || combined.contains('port')) {
      return Icons.water;
    } else if (combined.contains('forest') || combined.contains('woods') || combined.contains('jungle') || combined.contains('grove')) {
      return Icons.forest;
    } else if (combined.contains('oasis') || combined.contains('garden') || combined.contains('flora')) {
      return Icons.wb_sunny;
    } else if (combined.contains('ruin') || combined.contains('ruins') || combined.contains('tomb') || combined.contains('relic')) {
      return Icons.auto_awesome;
    } else if (combined.contains('star') || combined.contains('custom') || combined.contains('landmark')) {
      return Icons.star;
    }
    return Icons.location_on;
  }

  Widget _buildCustomPinWidget(bool isSelected, bool isStart, bool isTarget, Color iconColor) {
    final size = isSelected ? 32.0 : 26.0;
    final pinColor = isStart ? Colors.green : (isTarget ? Colors.orange : iconColor);
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            pinColor.withOpacity(0.3),
            pinColor,
          ],
          stops: const [0.4, 1.0],
        ),
        border: Border.all(
          color: const Color(0xFFFFD700), // Gold border
          width: isSelected ? 2.2 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: pinColor.withOpacity(0.5),
            blurRadius: isSelected ? 10 : 5,
            spreadRadius: isSelected ? 2 : 1,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.explore,
          size: size * 0.62,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mapsState = ref.watch(worldMapListProvider);
    final entitiesState = ref.watch(entityListProvider);
    final graphAsyncVal = ref.watch(graphDataProvider);
    final List<Relationship> allRels = graphAsyncVal.valueOrNull?.$2 ?? [];
    final manuscriptState = ref.watch(manuscriptNotifierProvider);
    
    final timelineAsyncVal = ref.watch(timelineListProvider());
    final entries = timelineAsyncVal.valueOrNull ?? [];
    if (entries.isNotEmpty && _timelineIndex == 0 && !_showTimelineScrubber) {
      _timelineIndex = entries.length - 1;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          PageHeader(
            title: 'World Map',
            subtitle: 'Cartography and exploration',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_selectedMap != null)
                  IconButton(
                    icon: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error, size: 20),
                    tooltip: 'Delete Map',
                    onPressed: () => _deleteMap(_selectedMap!),
                  ),
              ],
            ),
          ),
          Expanded(
            child: mapsState.when(
              data: (maps) {
                if (maps.isEmpty) {
                  return const EmptyState(
                    title: 'No World Maps Found',
                    message: 'Upload your fantasy cartography image to begin mapping out historical sites and cities.',
                    icon: Icons.map_outlined,
                  );
                }

                // Default selection
                if (_selectedMap == null) {
                  _selectedMap = maps.first;
                } else {
                  // Verify selected map still exists
                  if (!maps.any((m) => m.id == _selectedMap!.id)) {
                    _selectedMap = maps.first;
                  }
                }

                if (_lastLoadedMapId != _selectedMap!.id) {
                  _lastLoadedMapId = _selectedMap!.id;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _loadMapConfig(_selectedMap!.id);
                  });
                }

                final selectedMap = _selectedMap!;

                return entitiesState.when(
                  data: (entities) {
                    return Column(
                      children: [
                  if (maps.length > 1)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        children: [
                          Text('Map selector:', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                          SizedBox(width: 12),
                          Expanded(
                            child: FictionistDropdown<WorldMap>(
                              value: selectedMap,
                              items: maps.map((m) {
                                return FictionistDropdownItem<WorldMap>(
                                  value: m,
                                  child: Text(m.name, style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 12)),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() => _selectedMap = val);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: ref.watch(absoluteMapImagePathProvider(selectedMap.imagePath)).when(
                          data: (absPath) {
                            final file = File(absPath);
                            if (!file.existsSync()) {
                              return const Center(
                                child: ErrorDisplay(message: 'Physical map image file not found on disk.'),
                              );
                            }

                            final pinsState = ref.watch(mapPinsProvider(selectedMap.id));

                            return InteractiveViewer(
                              maxScale: 5.0,
                              minScale: 0.5,
                              panEnabled: !_isBrushingFog && !_isDrawingRoute,
                              scaleEnabled: !_isBrushingFog && !_isDrawingRoute,
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return GestureDetector(
                                    onTapUp: (details) {
                                      if (_isAddingPinMode) {
                                        _onMapDropPinAtOffset(
                                          context,
                                          details.localPosition,
                                          constraints,
                                          selectedMap.id,
                                        );
                                      } else if (_isDrawingRoute) {
                                        setState(() {
                                          final Offset local = details.localPosition;
                                          final double xPercent = (local.dx / constraints.maxWidth).clamp(0.0, 1.0);
                                          final double yPercent = (local.dy / constraints.maxHeight).clamp(0.0, 1.0);
                                          _activeRoutePoints.add(Offset(xPercent, yPercent));
                                        });
                                      } else {
                                        setState(() {
                                          _selectedPinId = null;
                                          _selectedPinEntity = null;
                                        });
                                      }
                                    },
                                    onLongPressStart: (!_isDrawingRoute && !_isBrushingFog)
                                        ? (details) => _onMapLongPress(
                                              context,
                                              details,
                                              constraints,
                                              selectedMap.id,
                                            )
                                        : null,
                                    onPanStart: _isBrushingFog
                                        ? (details) {
                                            setState(() {
                                              final Offset local = details.localPosition;
                                              final double xPercent = (local.dx / constraints.maxWidth).clamp(0.0, 1.0);
                                              final double yPercent = (local.dy / constraints.maxHeight).clamp(0.0, 1.0);
                                              _activeStroke = [Offset(xPercent, yPercent)];
                                              _revealedStrokes.add(_activeStroke!);
                                            });
                                          }
                                        : null,
                                    onPanUpdate: (_isBrushingFog && _activeStroke != null)
                                        ? (details) {
                                            setState(() {
                                              final Offset local = details.localPosition;
                                              final double xPercent = (local.dx / constraints.maxWidth).clamp(0.0, 1.0);
                                              final double yPercent = (local.dy / constraints.maxHeight).clamp(0.0, 1.0);
                                              _activeStroke!.add(Offset(xPercent, yPercent));
                                            });
                                          }
                                        : null,
                                    onPanEnd: _isBrushingFog
                                        ? (details) {
                                            setState(() {
                                              _activeStroke = null;
                                            });
                                            _saveMapConfig();
                                          }
                                        : null,
                                    child: Stack(
                                      children: [
                                        (() {
                                          Widget img = Image.file(
                                            file,
                                            fit: BoxFit.cover,
                                            width: constraints.maxWidth,
                                            height: constraints.maxHeight,
                                          );
                                          if (_filterMode == MapFilterMode.sepia) {
                                            img = ColorFiltered(
                                              colorFilter: const ColorFilter.matrix(<double>[
                                                0.393, 0.769, 0.189, 0, 0,
                                                0.349, 0.686, 0.168, 0, 0,
                                                0.272, 0.534, 0.131, 0, 0,
                                                0,     0,     0,     1, 0,
                                              ]),
                                              child: img,
                                            );
                                          } else if (_filterMode == MapFilterMode.dark) {
                                            img = ColorFiltered(
                                              colorFilter: const ColorFilter.matrix(<double>[
                                                -0.5, 0, 0, 0, 200,
                                                0, -0.5, 0, 0, 200,
                                                0, 0, -0.5, 0, 200,
                                                0, 0, 0, 1, 0,
                                              ]),
                                              child: img,
                                            );
                                          } else if (_filterMode == MapFilterMode.satellite) {
                                            img = ColorFiltered(
                                              colorFilter: const ColorFilter.matrix(<double>[
                                                0.1, 0, 0.5, 0, 0,
                                                0, 0.3, 0.5, 0, 0,
                                                0, 0, 0.9, 0, 50,
                                                0, 0, 0, 1, 0,
                                              ]),
                                              child: img,
                                            );
                                          }
                                          return img;
                                        })(),
                                        if (_showGrid)
                                          Positioned.fill(
                                            child: IgnorePointer(
                                              child: CustomPaint(
                                                painter: GridPainter(
                                                  type: _gridType,
                                                  size: _gridSize,
                                                  opacity: _gridOpacity,
                                                  color: Theme.of(context).colorScheme.onSurface,
                                                ),
                                              ),
                                            ),
                                          ),
                                        if (_customRoutes.isNotEmpty)
                                          Positioned.fill(
                                            child: IgnorePointer(
                                              child: CustomPaint(
                                                painter: CustomRoutesPainter(
                                                  routes: _customRoutes,
                                                ),
                                              ),
                                            ),
                                          ),
                                        if (_isDrawingRoute && _activeRoutePoints.isNotEmpty)
                                          Positioned.fill(
                                            child: IgnorePointer(
                                              child: CustomPaint(
                                                painter: ActiveRoutePainter(
                                                  points: _activeRoutePoints,
                                                  type: _activeRouteType,
                                                ),
                                              ),
                                            ),
                                          ),
                                        if (_showFogOfWar)
                                          Positioned.fill(
                                            child: IgnorePointer(
                                              child: CustomPaint(
                                                painter: FogOfWarPainter(
                                                  revealedStrokes: _revealedStrokes,
                                                  brushSize: _fogBrushSize,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ..._activeRipples.map((rippleOffset) {
                                          return Positioned(
                                            left: rippleOffset.dx - 30,
                                            top: rippleOffset.dy - 30,
                                            child: IgnorePointer(
                                              child: Container(
                                                width: 60,
                                                height: 60,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: Theme.of(context).colorScheme.primary,
                                                    width: 2.5,
                                                  ),
                                                ),
                                              ).animate(onComplete: (_) {
                                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                                  if (mounted) {
                                                    setState(() {
                                                      _activeRipples.remove(rippleOffset);
                                                    });
                                                  }
                                                });
                                              }).scale(
                                                begin: const Offset(0.1, 0.1),
                                                end: const Offset(2.0, 2.0),
                                                duration: 600.ms,
                                                curve: Curves.easeOut,
                                              ).fadeOut(duration: 600.ms),
                                            ),
                                          );
                                        }),
                                                if (_isAddingPinMode)
                                                  Positioned(
                                                    top: 16,
                                                    left: 16,
                                                    right: 16,
                                                    child: Center(
                                                      child: Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                        decoration: BoxDecoration(
                                                          color: Theme.of(context).colorScheme.primary,
                                                          borderRadius: BorderRadius.circular(20),
                                                          boxShadow: const [
                                                            BoxShadow(
                                                              color: Colors.black26,
                                                              blurRadius: 4,
                                                              offset: Offset(0, 2),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            const Icon(Icons.add_location_alt_outlined, color: Colors.white, size: 16),
                                                            const SizedBox(width: 8),
                                                            Text(
                                                              'Tap anywhere on the map to place a pin',
                                                              style: TextStyle(
                                                                color: Theme.of(context).colorScheme.onPrimary,
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                        pinsState.when(
                                          data: (pins) {
                                            final journeyPath = (_showJourneyTracker && _selectedJourneyCharacterId != null)
                                                ? _resolveJourneyPath(_selectedJourneyCharacterId!, entries, entities, pins)
                                                : <Offset>[];

                                            return Stack(
                                              children: [
                                                if (_showHeatmap)
                                                  Positioned.fill(
                                                    child: IgnorePointer(
                                                      child: CustomPaint(
                                                        painter: HeatmapPainter(
                                                          pins: pins,
                                                          entities: entities,
                                                          relationships: allRels,
                                                          chapters: manuscriptState.chapters,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                if (_measuringMode && _measureStartPin != null)
                                                  Positioned.fill(
                                                    child: IgnorePointer(
                                                      child: CustomPaint(
                                                        painter: DistanceLinePainter(
                                                          startPercent: Offset(_measureStartPin!.xPercent, _measureStartPin!.yPercent),
                                                          endPercent: _measureTargetPin != null
                                                              ? Offset(_measureTargetPin!.xPercent, _measureTargetPin!.yPercent)
                                                              : null,
                                                          color: Theme.of(context).colorScheme.primary,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                if (_showJourneyTracker && journeyPath.isNotEmpty)
                                                  Positioned.fill(
                                                    child: IgnorePointer(
                                                      child: CustomPaint(
                                                        painter: JourneyPathPainter(
                                                          pathPercent: journeyPath,
                                                          color: Theme.of(context).colorScheme.secondary,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ...pins.map((pin) {
                                                  final peerEntity = entities
                                                      .where((e) => e.id == pin.entityId)
                                                      .firstOrNull;
                                                  if (peerEntity == null) {
                                                    return const SizedBox.shrink();
                                                  }

                                                  final left = pin.xPercent * constraints.maxWidth - 50;
                                                  final top = pin.yPercent * constraints.maxHeight - 36;
                                                  final iconColor = Color(peerEntity.iconColor);

                                                  final isStart = _measureStartPin?.id == pin.id;
                                                  final isTarget = _measureTargetPin?.id == pin.id;
                                                  
                                                  final isSelected = pin.id == _selectedPinId || (_measuringMode && (isStart || isTarget));
                                                  final ringColor = isStart 
                                                      ? Colors.green 
                                                      : (isTarget ? Colors.orange : iconColor);

                                                  final pinEvents = entries
                                                      .sublist(0, math.min(_timelineIndex + 1, entries.length))
                                                      .where((e) => e.entityId == pin.entityId)
                                                      .toList();
                                                  final hasTimelineEvent = pinEvents.isNotEmpty;

                                                  return Positioned(
                                                    left: left,
                                                    top: top,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        HapticFeedback.lightImpact();
                                                        if (_measuringMode) {
                                                          setState(() {
                                                            if (_measureStartPin == null) {
                                                              _measureStartPin = pin;
                                                            } else if (_measureStartPin!.id == pin.id) {
                                                              _measureStartPin = null;
                                                              _measureTargetPin = null;
                                                            } else if (_measureTargetPin == null) {
                                                              _measureTargetPin = pin;
                                                            } else if (_measureTargetPin!.id == pin.id) {
                                                              _measureTargetPin = null;
                                                            } else {
                                                              _measureTargetPin = pin;
                                                            }
                                                          });
                                                        } else {
                                                          setState(() {
                                                            _selectedPinId = pin.id;
                                                            _selectedPinEntity = peerEntity;
                                                          });
                                                        }
                                                      },
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Stack(
                                                            alignment: Alignment.center,
                                                            children: [
                                                              if (isSelected)
                                                                Container(
                                                                  width: 42,
                                                                  height: 42,
                                                                  decoration: BoxDecoration(
                                                                    shape: BoxShape.circle,
                                                                    color: ringColor.withOpacity(0.25),
                                                                    border: Border.all(color: ringColor.withOpacity(0.3), width: 1.5),
                                                                  ),
                                                                ).animate(onPlay: (c) => c.repeat())
                                                                 .scale(begin: const Offset(0.7, 0.7), end: const Offset(1.4, 1.4), duration: 1200.ms, curve: Curves.easeOut)
                                                                 .fadeOut(duration: 1200.ms),
                                                              if (peerEntity.description?.toLowerCase().contains('star') == true ||
                                                                  peerEntity.name.toLowerCase().contains('star') == true)
                                                                _buildCustomPinWidget(isSelected, isStart, isTarget, iconColor)
                                                              else
                                                                Icon(
                                                                  _getPinIcon(peerEntity),
                                                                  size: isSelected ? 30 : 24,
                                                                  color: isStart ? Colors.green : (isTarget ? Colors.orange : iconColor),
                                                                ).animate(target: isSelected ? 1 : 0)
                                                                 .shimmer(duration: 1000.ms, color: Colors.white.withOpacity(0.5)),
                                                              if (_showTimelineScrubber && hasTimelineEvent)
                                                                Positioned(
                                                                  right: 0,
                                                                  top: 0,
                                                                  child: Container(
                                                                    padding: const EdgeInsets.all(2),
                                                                    decoration: const BoxDecoration(
                                                                      color: Colors.red,
                                                                      shape: BoxShape.circle,
                                                                    ),
                                                                    child: const Icon(
                                                                      Icons.flash_on,
                                                                      size: 8,
                                                                      color: Colors.white,
                                                                    ),
                                                                  ).animate(onPlay: (c) => c.repeat())
                                                                   .shimmer(duration: 1500.ms),
                                                                ),
                                                            ],
                                                          ),
                                                          const SizedBox(height: 2),
                                                          Container(
                                                            padding: const EdgeInsets.symmetric(
                                                              horizontal: 5,
                                                              vertical: 2,
                                                            ),
                                                            decoration: BoxDecoration(
                                                              color: isSelected 
                                                                  ? (isStart ? Colors.green : (isTarget ? Colors.orange : Theme.of(context).colorScheme.primary))
                                                                  : Theme.of(context).colorScheme.surface.withOpacity(0.85),
                                                              borderRadius: BorderRadius.circular(6),
                                                              border: Border.all(
                                                                color: isSelected 
                                                                    ? (isStart ? Colors.green : (isTarget ? Colors.orange : Theme.of(context).colorScheme.primary))
                                                                    : Theme.of(context).colorScheme.outline,
                                                              ),
                                                              boxShadow: isSelected ? [
                                                                BoxShadow(
                                                                  color: ringColor.withOpacity(0.2),
                                                                  blurRadius: 6,
                                                                  spreadRadius: 1,
                                                                )
                                                              ] : null,
                                                            ),
                                                            child: Text(
                                                              peerEntity.name,
                                                              style: TextStyle(
                                                                fontSize: 8.5,
                                                                color: isSelected 
                                                                    ? Colors.white
                                                                    : Theme.of(context).colorScheme.onSurface,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ).animate(key: ValueKey(pin.id))
                                                       .fade(duration: 250.ms)
                                                       .scale(begin: const Offset(0.4, 0.4), end: const Offset(1.0, 1.0), duration: 350.ms, curve: Curves.bounceOut),
                                                    ),
                                                  );
                                                }).toList(),
                                                if (_showJourneyTracker && journeyPath.isNotEmpty) (() {
                                                  final currentPos = journeyPath.last;
                                                  final char = entities.where((e) => e.id == _selectedJourneyCharacterId).firstOrNull;
                                                  if (char == null) return const SizedBox.shrink();
                                                  
                                                  final charColor = Color(char.iconColor);
                                                  final left = currentPos.dx * constraints.maxWidth - 20;
                                                  final top = currentPos.dy * constraints.maxHeight - 20;
                                                  
                                                  return Positioned(
                                                    left: left,
                                                    top: top,
                                                    child: IgnorePointer(
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Stack(
                                                            alignment: Alignment.center,
                                                            children: [
                                                              Container(
                                                                width: 32,
                                                                height: 32,
                                                                decoration: BoxDecoration(
                                                                  shape: BoxShape.circle,
                                                                  color: charColor.withOpacity(0.2),
                                                                  border: Border.all(color: charColor, width: 1.5),
                                                                ),
                                                              ).animate(onPlay: (c) => c.repeat())
                                                               .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.3, 1.3), duration: 1000.ms)
                                                               .fadeOut(),
                                                              CircleAvatar(
                                                                radius: 12,
                                                                backgroundColor: charColor,
                                                                child: Text(
                                                                  char.name[0].toUpperCase(),
                                                                  style: const TextStyle(
                                                                    color: Colors.white,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 10,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(height: 2),
                                                          Container(
                                                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
                                                            decoration: BoxDecoration(
                                                              color: Colors.black.withOpacity(0.75),
                                                              borderRadius: BorderRadius.circular(4),
                                                            ),
                                                            child: Text(
                                                              char.name,
                                                              style: const TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 7.5,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                })(),
                                              ],
                                            );
                                          },
                                          loading: () => const SizedBox.shrink(),
                                          error: (e, _) => Text('Error loading pins: $e'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                          loading: () => LoadingIndicator(),
                          error: (e, _) => ErrorDisplay(message: e.toString()),
                        ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_selectedPinId != null && _selectedPinEntity != null && !_measuringMode) ...[
                          _buildBottomPreviewCard(context, _selectedPinEntity!, _selectedPinId!, selectedMap.id),
                          const SizedBox(height: 8),
                        ],
                        if (_measuringMode) ...[
                          _buildMeasurementOverlay(context, entities),
                          const SizedBox(height: 8),
                        ],
                        _buildTabbedControlsPanel(context, entries, entities, selectedMap.id),
                        const SizedBox(height: 8),
                        _buildCollapsibleToolbar(context),
                      ],
                    ),
                  ),
                ],
              );
            },
              loading: () => const LoadingIndicator(),
              error: (e, _) => ErrorDisplay(message: e.toString()),
            );
        },
        loading: () => const LoadingIndicator(),
        error: (err, _) => ErrorDisplay(message: err.toString()),
      ),
    ),
  ],
),
    );
  }

  Widget _buildBottomPreviewCard(BuildContext context, Entity entity, String pinId, String mapId) {
    final theme = Theme.of(context);
    
    return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withOpacity(0.92),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: theme.colorScheme.primary.withOpacity(0.25),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.08),
              blurRadius: 16,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(entity.iconColor).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getPinIcon(entity),
                size: 24,
                color: Color(entity.iconColor),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    entity.name,
                    style: theme.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: Theme.of(context).textTheme.displayLarge?.fontFamily,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    entity.description ?? 'No description available.',
                    style: theme.textTheme.bodySmall!.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 11,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    _showPinDetails(context, entity, pinId, mapId);
                  },
                  icon: const Icon(Icons.explore_outlined, size: 12),
                  label: const Text('Codex', style: TextStyle(fontSize: 10)),
                  style: ElevatedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 4),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _selectedPinId = null;
                      _selectedPinEntity = null;
                    });
                  },
                  icon: const Icon(Icons.close, size: 12, color: Colors.grey),
                  label: const Text('Close', style: TextStyle(fontSize: 10, color: Colors.grey)),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  ),
                ),
              ],
            ),
          ],
        ),
      ).animate().slideY(begin: 0.2, end: 0.0, curve: Curves.easeOutBack, duration: 300.ms).fadeIn();
  }

  Widget _toolBtn(IconData icon, String tooltip, bool isActive, VoidCallback onPressed) {
    final theme = Theme.of(context);
    return Tooltip(
      message: tooltip,
      child: Material(
        color: isActive ? theme.colorScheme.primary.withOpacity(0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            onPressed();
          },
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              icon,
              color: isActive ? theme.colorScheme.primary : theme.colorScheme.onSurface,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCollapsibleToolbar(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: theme.colorScheme.surface.withOpacity(0.95),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => setState(() => _toolbarExpanded = !_toolbarExpanded),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16), bottom: Radius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.map, color: theme.colorScheme.primary, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Map Tools & Layers',
                        style: theme.textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    _toolbarExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                    size: 20,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
          if (_toolbarExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _toolBtn(
                    _showHeatmap ? Icons.blur_on : Icons.blur_off,
                    'Heatmap',
                    _showHeatmap,
                    () => setState(() => _showHeatmap = !_showHeatmap),
                  ),
                  _toolBtn(
                    _measuringMode ? Icons.straighten : Icons.straighten_outlined,
                    'Measure',
                    _measuringMode,
                    () => setState(() {
                      _measuringMode = !_measuringMode;
                      _isAddingPinMode = false;
                      _measureStartPin = null;
                      _measureTargetPin = null;
                    }),
                  ),
                  _toolBtn(
                    _isAddingPinMode ? Icons.add_location_alt : Icons.add_location_alt_outlined,
                    'Drop Pin',
                    _isAddingPinMode,
                    () => setState(() {
                      _isAddingPinMode = !_isAddingPinMode;
                      if (_isAddingPinMode) {
                        _measuringMode = false;
                        _isDrawingRoute = false;
                        _isBrushingFog = false;
                      }
                    }),
                  ),
                  _toolBtn(
                    _showTimelineScrubber ? Icons.history : Icons.history_toggle_off,
                    'Timeline',
                    _showTimelineScrubber,
                    () => setState(() {
                      _showTimelineScrubber = !_showTimelineScrubber;
                      if (_showTimelineScrubber) {
                        _activeToolTab = 'timeline';
                      }
                    }),
                  ),
                  _toolBtn(
                    _showJourneyTracker ? Icons.person_pin : Icons.person_pin_outlined,
                    'Journey',
                    _showJourneyTracker,
                    () => setState(() {
                      _showJourneyTracker = !_showJourneyTracker;
                      if (_showJourneyTracker) {
                        _activeToolTab = 'journey';
                      } else {
                        _selectedJourneyCharacterId = null;
                      }
                    }),
                  ),
                  _toolBtn(
                    _showGridControls ? Icons.grid_on : Icons.grid_off,
                    'Grid',
                    _showGridControls,
                    () => setState(() {
                      _showGridControls = !_showGridControls;
                      if (_showGridControls) {
                        _activeToolTab = 'grid';
                      }
                    }),
                  ),
                  _toolBtn(
                    _showFogControls ? Icons.cloud : Icons.cloud_outlined,
                    'Fog',
                    _showFogControls,
                    () => setState(() {
                      _showFogControls = !_showFogControls;
                      if (_showFogControls) {
                        _isAddingPinMode = false;
                        _activeToolTab = 'fog';
                      }
                    }),
                  ),
                  _toolBtn(
                    _showRouteControls ? Icons.edit_road : Icons.edit_road_outlined,
                    'Route',
                    _showRouteControls,
                    () => setState(() {
                      _showRouteControls = !_showRouteControls;
                      if (_showRouteControls) {
                        _isAddingPinMode = false;
                        _activeToolTab = 'route';
                      } else {
                        _isDrawingRoute = false;
                        _activeRoutePoints.clear();
                      }
                    }),
                  ),
                  _toolBtn(
                    Icons.auto_awesome,
                    'Forge',
                    false,
                    () {
                      HapticFeedback.lightImpact();
                      context.push('/map/generator');
                    },
                  ),
                  _toolBtn(
                    Icons.upload_file,
                    'Upload',
                    false,
                    _uploadMap,
                  ),
                  PopupMenuButton<MapFilterMode>(
                    icon: Icon(Icons.filter_hdr_outlined, color: theme.colorScheme.onSurface, size: 20),
                    tooltip: 'Map Filters',
                    onSelected: (mode) {
                      setState(() => _filterMode = mode);
                    },
                    itemBuilder: (ctx) => [
                      const PopupMenuItem(value: MapFilterMode.original, child: Text('Original Map')),
                      const PopupMenuItem(value: MapFilterMode.sepia, child: Text('Antique Sepia')),
                      const PopupMenuItem(value: MapFilterMode.dark, child: Text('High Contrast Dark')),
                      const PopupMenuItem(value: MapFilterMode.satellite, child: Text('Satellite Blueprint')),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTabHeader(List<String> activePanels) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: activePanels.map((panel) {
          final isSelected = _activeToolTab == panel;
          String label;
          IconData icon;
          switch (panel) {
            case 'timeline':
              label = 'Timeline';
              icon = Icons.history;
              break;
            case 'journey':
              label = 'Journey';
              icon = Icons.person_pin;
              break;
            case 'grid':
              label = 'Grid';
              icon = Icons.grid_on;
              break;
            case 'fog':
              label = 'Fog';
              icon = Icons.cloud;
              break;
            case 'route':
              label = 'Route';
              icon = Icons.edit_road;
              break;
            default:
              label = '';
              icon = Icons.settings;
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              avatar: Icon(icon, size: 14, color: isSelected ? Colors.white : null),
              label: Text(label, style: const TextStyle(fontSize: 11)),
              selected: isSelected,
              onSelected: (val) {
                if (val) {
                  setState(() => _activeToolTab = panel);
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTabbedControlsPanel(BuildContext context, List<TimelineEntry> entries, List<Entity> entities, String mapId) {
    final List<String> activePanels = [];
    if (_showTimelineScrubber && entries.isNotEmpty) activePanels.add('timeline');
    if (_showJourneyTracker) activePanels.add('journey');
    if (_showGridControls) activePanels.add('grid');
    if (_showFogControls) activePanels.add('fog');
    if (_showRouteControls) activePanels.add('route');

    if (activePanels.isEmpty) return const SizedBox.shrink();

    if (_activeToolTab == null || !activePanels.contains(_activeToolTab)) {
      _activeToolTab = activePanels.last;
    }

    Widget activeCard = const SizedBox.shrink();
    if (_activeToolTab == 'timeline' && _showTimelineScrubber && entries.isNotEmpty) {
      activeCard = _buildTimelineScrubberCard(context, entries);
    } else if (_activeToolTab == 'journey' && _showJourneyTracker) {
      activeCard = _buildJourneySelectorCard(context, entities);
    } else if (_activeToolTab == 'grid' && _showGridControls) {
      activeCard = _buildGridControlsCard(context);
    } else if (_activeToolTab == 'fog' && _showFogControls) {
      activeCard = _buildFogControlsCard(context);
    } else if (_activeToolTab == 'route' && _showRouteControls) {
      activeCard = _buildRouteControlsCard(context);
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Theme.of(context).colorScheme.surface.withOpacity(0.92),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (activePanels.length > 1) ...[
              _buildTabHeader(activePanels),
              const SizedBox(height: 6),
              const Divider(height: 1),
              const SizedBox(height: 6),
            ],
            activeCard,
          ],
        ),
      ),
    );
  }

  Widget _buildMeasurementOverlay(BuildContext context, List<Entity> entities) {
    final theme = Theme.of(context);
    
    double? distanceKm;
    int? walkDays, walkHours;
    int? rideDays, rideHours;
    int? carriageDays, carriageHours;

    if (_measureStartPin != null && _measureTargetPin != null) {
      final dx = _measureTargetPin!.xPercent - _measureStartPin!.xPercent;
      final dy = _measureTargetPin!.yPercent - _measureStartPin!.yPercent;
      final normDist = math.sqrt(dx * dx + dy * dy);
      
      // Let's assume a default scale of 1000 km for the entire map width
      distanceKm = normDist * 1000.0;
      
      // Walking: 4.5 km/h, 8 active hours/day = 36 km/day
      final totalWalkHours = distanceKm / 4.5;
      walkDays = (totalWalkHours / 8).floor();
      walkHours = (totalWalkHours % 8).round();

      // Horseback: 12 km/h, 6 active hours/day = 72 km/day
      final totalRideHours = distanceKm / 12.0;
      rideDays = (totalRideHours / 6).floor();
      rideHours = (totalRideHours % 6).round();

      // Carriage: 7.0 km/h, 8 active hours/day = 56 km/day
      final totalCarriageHours = distanceKm / 7.0;
      carriageDays = (totalCarriageHours / 8).floor();
      carriageHours = (totalCarriageHours % 8).round();
    }

    final startName = _measureStartPin != null ? _getPinName(entities, _measureStartPin!.entityId) : '';
    final targetName = _measureTargetPin != null ? _getPinName(entities, _measureTargetPin!.entityId) : '';

    return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withOpacity(0.95),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: theme.colorScheme.primary.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.straighten, color: theme.colorScheme.primary, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Distance & Travel Calculator',
                      style: theme.textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    setState(() {
                      _measuringMode = false;
                      _measureStartPin = null;
                      _measureTargetPin = null;
                    });
                  },
                ),
              ],
            ),
            const Divider(height: 16),
            if (_measureStartPin == null) ...[
              Text(
                'Select a starting pin on the map...',
                style: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                  fontSize: 12,
                ),
              ),
            ] else if (_measureTargetPin == null) ...[
              Row(
                children: [
                  const Icon(Icons.play_arrow_outlined, color: Colors.green, size: 16),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Start: $startName',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Select a destination pin to calculate travel times...',
                style: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                  fontSize: 12,
                ),
              ),
            ] else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Start: $startName',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Destination: $targetName',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ],
              ),
              const Divider(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTravelTimeTile(
                    context,
                    Icons.straighten,
                    'Distance',
                    '${distanceKm!.toStringAsFixed(1)} km',
                  ),
                  _buildTravelTimeTile(
                    context,
                    Icons.directions_walk,
                    'Walking',
                    walkDays == 0 ? '$walkHours h' : '${walkDays}d ${walkHours}h',
                  ),
                  _buildTravelTimeTile(
                    context,
                    Icons.directions_run,
                    'Horseback',
                    rideDays == 0 ? '$rideHours h' : '${rideDays}d ${rideHours}h',
                  ),
                  _buildTravelTimeTile(
                    context,
                    Icons.airport_shuttle, // Carriage lookalike
                    'Carriage',
                    carriageDays == 0 ? '$carriageHours h' : '${carriageDays}d ${carriageHours}h',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _measureStartPin = null;
                      _measureTargetPin = null;
                    });
                  },
                  child: const Text('Reset Pins', style: TextStyle(fontSize: 11)),
                ),
              ),
            ],
          ],
        ),
      ).animate().slideY(begin: 0.2, end: 0.0, curve: Curves.easeOutBack, duration: 300.ms).fadeIn();
  }

  Widget _buildTravelTimeTile(BuildContext context, IconData icon, String label, String value) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: theme.colorScheme.secondary),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 9, color: Colors.grey)),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  String _getPinName(List<Entity> entities, String entityId) {
    return entities.where((e) => e.id == entityId).firstOrNull?.name ?? 'Unknown';
  }

  Widget _buildTimelineScrubberCard(BuildContext context, List<TimelineEntry> entries) {
    final theme = Theme.of(context);
    if (entries.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withOpacity(0.95),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
        ),
        child: const Text(
          'No timeline events found. Add events in the Timeline tab.',
          style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
        ),
      );
    }

    if (_timelineIndex >= entries.length) {
      _timelineIndex = entries.length - 1;
    }
    if (_timelineIndex < 0) {
      _timelineIndex = 0;
    }

    final currentEntry = entries[_timelineIndex];

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.3),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.history, color: theme.colorScheme.primary, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Chronological Timeline Scrubber',
                    style: theme.textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 16),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  setState(() {
                    _showTimelineScrubber = false;
                  });
                },
              ),
            ],
          ),
          const Divider(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  currentEntry.dateLabel ?? 'Day ?',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  currentEntry.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (currentEntry.description != null && currentEntry.description!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              currentEntry.description!,
              style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurfaceVariant),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, size: 20),
                onPressed: _timelineIndex > 0
                    ? () => setState(() => _timelineIndex--)
                    : null,
              ),
              Expanded(
                child: Slider(
                  value: _timelineIndex.toDouble(),
                  min: 0.0,
                  max: (entries.length - 1).toDouble(),
                  divisions: entries.length - 1,
                  onChanged: (val) {
                    setState(() {
                      _timelineIndex = val.round();
                    });
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, size: 20),
                onPressed: _timelineIndex < entries.length - 1
                    ? () => setState(() => _timelineIndex++)
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJourneySelectorCard(BuildContext context, List<Entity> entities) {
    final theme = Theme.of(context);
    final characters = entities.where((e) => e.type == EntityType.character).toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.secondary.withOpacity(0.3),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.person_pin, color: theme.colorScheme.secondary, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Character Journey Tracker',
                    style: theme.textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 16),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  setState(() {
                    _showJourneyTracker = false;
                    _selectedJourneyCharacterId = null;
                  });
                },
              ),
            ],
          ),
          const Divider(height: 12),
          if (characters.isEmpty) ...[
            const Text(
              'No characters found in Codex. Create characters first.',
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
            ),
          ] else ...[
            Row(
              children: [
                const Text('Select Character:', style: TextStyle(fontSize: 12)),
                const SizedBox(width: 12),
                Expanded(
                  child: FictionistDropdown<String?>(
                    value: _selectedJourneyCharacterId,
                    hint: const Text('Choose a character...', style: TextStyle(fontSize: 12)),
                    items: characters.map((c) {
                      return FictionistDropdownItem<String?>(
                        value: c.id,
                        child: Text(c.name, style: const TextStyle(fontSize: 12)),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedJourneyCharacterId = val;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  List<Offset> _resolveJourneyPath(
    String characterId,
    List<TimelineEntry> entries,
    List<Entity> entities,
    List<MapPin> pins,
  ) {
    final path = <Offset>[];
    final character = entities.where((e) => e.id == characterId).firstOrNull;
    if (character == null) return path;

    final charNameLower = character.name.toLowerCase();

    final pinnedLocations = <Entity, MapPin>{};
    for (final pin in pins) {
      final loc = entities.where((e) => e.id == pin.entityId).firstOrNull;
      if (loc != null) {
        pinnedLocations[loc] = pin;
      }
    }

    final maxIndex = math.min(_timelineIndex, entries.length - 1);
    for (int i = 0; i <= maxIndex; i++) {
      final entry = entries[i];
      
      if (entry.entityId == characterId) {
        final text = '${entry.title} ${entry.description ?? ""}'.toLowerCase();
        for (final loc in pinnedLocations.keys) {
          if (text.contains(loc.name.toLowerCase())) {
            final pin = pinnedLocations[loc]!;
            path.add(Offset(pin.xPercent, pin.yPercent));
            break;
          }
        }
      } else {
        final loc = pinnedLocations.keys.where((l) => l.id == entry.entityId).firstOrNull;
        if (loc != null) {
          final text = '${entry.title} ${entry.description ?? ""}'.toLowerCase();
          if (text.contains(charNameLower)) {
            final pin = pinnedLocations[loc]!;
            path.add(Offset(pin.xPercent, pin.yPercent));
          }
        }
      }
    }
    
    final uniquePath = <Offset>[];
    for (final pt in path) {
      if (uniquePath.isEmpty || uniquePath.last != pt) {
        uniquePath.add(pt);
      }
    }

    return uniquePath;
  }

  Widget _buildGridControlsCard(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.3), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.grid_3x3, color: theme.colorScheme.primary, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Tactical Grid Settings',
                    style: theme.textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 16),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  setState(() {
                    _showGridControls = false;
                  });
                },
              ),
            ],
          ),
          const Divider(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Enable Grid:', style: TextStyle(fontSize: 12)),
              Switch(
                value: _showGrid,
                onChanged: (val) {
                  setState(() {
                    _showGrid = val;
                  });
                  _saveMapConfig();
                },
              ),
            ],
          ),
          if (_showGrid) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Grid Style:', style: TextStyle(fontSize: 12)),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'square', label: Text('Square', style: TextStyle(fontSize: 11))),
                    ButtonSegment(value: 'hex', label: Text('Hexagon', style: TextStyle(fontSize: 11))),
                  ],
                  selected: {_gridType},
                  onSelectionChanged: (val) {
                    setState(() {
                      _gridType = val.first;
                    });
                    _saveMapConfig();
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Size:', style: TextStyle(fontSize: 11)),
                Expanded(
                  child: Slider(
                    value: _gridSize,
                    min: 15.0,
                    max: 100.0,
                    divisions: 17,
                    onChanged: (val) {
                      setState(() {
                        _gridSize = val;
                      });
                      _saveMapConfig();
                    },
                  ),
                ),
                Text('${_gridSize.round()} px', style: const TextStyle(fontSize: 11)),
              ],
            ),
            Row(
              children: [
                const Text('Opacity:', style: TextStyle(fontSize: 11)),
                Expanded(
                  child: Slider(
                    value: _gridOpacity,
                    min: 0.05,
                    max: 0.8,
                    onChanged: (val) {
                      setState(() {
                        _gridOpacity = val;
                      });
                      _saveMapConfig();
                    },
                  ),
                ),
                Text('${(_gridOpacity * 100).round()}%', style: const TextStyle(fontSize: 11)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFogControlsCard(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blueGrey.withOpacity(0.3), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.cloud, color: Colors.blueGrey, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Fog of War Settings',
                    style: theme.textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 16),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  setState(() {
                    _showFogControls = false;
                  });
                },
              ),
            ],
          ),
          const Divider(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Enable Fog:', style: TextStyle(fontSize: 12)),
              Switch(
                value: _showFogOfWar,
                onChanged: (val) {
                  setState(() {
                    _showFogOfWar = val;
                    if (!val) {
                      _isBrushingFog = false;
                    }
                  });
                  _saveMapConfig();
                },
              ),
            ],
          ),
          if (_showFogOfWar) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Brush Mode (Reveal):', style: TextStyle(fontSize: 12)),
                Switch(
                  value: _isBrushingFog,
                  onChanged: (val) {
                    setState(() {
                      _isBrushingFog = val;
                      if (val) {
                        _isDrawingRoute = false;
                        _measuringMode = false;
                      }
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Brush Size:', style: TextStyle(fontSize: 11)),
                Expanded(
                  child: Slider(
                    value: _fogBrushSize,
                    min: 10.0,
                    max: 80.0,
                    onChanged: (val) {
                      setState(() {
                        _fogBrushSize = val;
                      });
                      _saveMapConfig();
                    },
                  ),
                ),
                Text('${_fogBrushSize.round()} px', style: const TextStyle(fontSize: 11)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _revealedStrokes.clear();
                    });
                    _saveMapConfig();
                  },
                  icon: const Icon(Icons.refresh, size: 16, color: Colors.red),
                  label: const Text('Reset Fog', style: TextStyle(color: Colors.red, fontSize: 11)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRouteControlsCard(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.withOpacity(0.3), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.edit_road, color: Colors.green, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Custom Route Builder',
                    style: theme.textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 16),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  setState(() {
                    _showRouteControls = false;
                    _isDrawingRoute = false;
                    _activeRoutePoints.clear();
                  });
                },
              ),
            ],
          ),
          const Divider(height: 12),
          if (!_isDrawingRoute) ...[
            if (_customRoutes.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'No custom routes drawn yet.',
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                ),
              )
            else
              Container(
                constraints: const BoxConstraints(maxHeight: 120),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _customRoutes.length,
                  itemBuilder: (ctx, index) {
                    final r = _customRoutes[index];
                    Color routeColor;
                    if (r.type == 'river') {
                      routeColor = Colors.blue;
                    } else if (r.type == 'trade') {
                      routeColor = Colors.green;
                    } else if (r.type == 'magic') {
                      routeColor = Colors.purple;
                    } else {
                      routeColor = Colors.brown;
                    }
                    return ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.route, color: routeColor, size: 18),
                      title: Text(
                        r.name.isNotEmpty ? r.name : '${r.type[0].toUpperCase()}${r.type.substring(1)} Route',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('${r.points.length} nodes', style: const TextStyle(fontSize: 10)),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _customRoutes.removeAt(index);
                          });
                          _saveMapConfig();
                        },
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 8),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _isDrawingRoute = true;
                    _activeRoutePoints.clear();
                    _activeRouteType = 'road';
                    _activeRouteNameController.text = '';
                    _isBrushingFog = false;
                    _measuringMode = false;
                  });
                },
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Draw New Route', style: TextStyle(fontSize: 11)),
              ),
            ),
          ] else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Route Type:', style: TextStyle(fontSize: 12)),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'road', label: Text('Road', style: TextStyle(fontSize: 10))),
                    ButtonSegment(value: 'river', label: Text('River', style: TextStyle(fontSize: 10))),
                    ButtonSegment(value: 'trade', label: Text('Trade', style: TextStyle(fontSize: 10))),
                    ButtonSegment(value: 'magic', label: Text('Magic', style: TextStyle(fontSize: 10))),
                  ],
                  selected: {_activeRouteType},
                  onSelectionChanged: (val) {
                    setState(() {
                      _activeRouteType = val.first;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _activeRouteNameController,
              decoration: const InputDecoration(
                labelText: 'Route Name (e.g. Silk Road)',
                labelStyle: TextStyle(fontSize: 11),
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding: EdgeInsets.all(8),
              ),
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 8),
            Text(
              'Nodes: ${_activeRoutePoints.length} (Tap on map to place nodes)',
              style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isDrawingRoute = false;
                      _activeRoutePoints.clear();
                    });
                  },
                  child: const Text('Cancel', style: TextStyle(fontSize: 11, color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: _activeRoutePoints.length >= 2
                      ? () {
                          setState(() {
                            _customRoutes.add(CustomRoute(
                              id: Uuid().v4(),
                              name: _activeRouteNameController.text.trim(),
                              type: _activeRouteType,
                              points: List.from(_activeRoutePoints),
                            ));
                            _isDrawingRoute = false;
                            _activeRoutePoints.clear();
                          });
                          _saveMapConfig();
                        }
                      : null,
                  child: const Text('Save Route', style: TextStyle(fontSize: 11)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _loadMapConfig(String mapId) async {
    try {
      final docs = await getApplicationDocumentsDirectory();
      final file = File(p.join(docs.path, 'world_maps', '${mapId}_config.json'));
      if (await file.exists()) {
        final content = await file.readAsString();
        final json = jsonDecode(content) as Map<String, dynamic>;
        
        setState(() {
          final grid = json['grid'] as Map<String, dynamic>?;
          if (grid != null) {
            _showGrid = grid['show'] as bool? ?? false;
            _gridType = grid['type'] as String? ?? 'square';
            _gridSize = (grid['size'] as num? ?? 40.0).toDouble();
            _gridOpacity = (grid['opacity'] as num? ?? 0.3).toDouble();
          } else {
            _showGrid = false;
            _gridType = 'square';
            _gridSize = 40.0;
            _gridOpacity = 0.3;
          }
          
          final fog = json['fogOfWar'] as Map<String, dynamic>?;
          if (fog != null) {
            _showFogOfWar = fog['show'] as bool? ?? false;
            _fogBrushSize = (fog['brushSize'] as num? ?? 30.0).toDouble();
            
            final strokes = fog['revealedStrokes'] as List<dynamic>?;
            if (strokes != null) {
              _revealedStrokes = strokes.map((s) {
                final pts = s as List<dynamic>;
                return pts.map((p) => Offset((p['x'] as num).toDouble(), (p['y'] as num).toDouble())).toList();
              }).toList();
            } else {
              _revealedStrokes = [];
            }
          } else {
            _showFogOfWar = false;
            _fogBrushSize = 30.0;
            _revealedStrokes = [];
          }
          
          final routes = json['customRoutes'] as List<dynamic>?;
          if (routes != null) {
            _customRoutes = routes.map((r) {
              final routeJson = r as Map<String, dynamic>;
              final pts = routeJson['points'] as List<dynamic>;
              return CustomRoute(
                id: routeJson['id'] as String? ?? Uuid().v4(),
                name: routeJson['name'] as String? ?? '',
                type: routeJson['type'] as String? ?? 'road',
                points: pts.map((p) => Offset((p['x'] as num).toDouble(), (p['y'] as num).toDouble())).toList(),
              );
            }).toList();
          } else {
            _customRoutes = [];
          }
        });
      } else {
        setState(() {
          _showGrid = false;
          _gridType = 'square';
          _gridSize = 40.0;
          _gridOpacity = 0.3;
          _showFogOfWar = false;
          _fogBrushSize = 30.0;
          _revealedStrokes = [];
          _customRoutes = [];
        });
      }
    } catch (_) {
      // Silently swallow errors
    }
  }

  Future<void> _saveMapConfig() async {
    final mapId = _selectedMap?.id;
    if (mapId == null) return;
    try {
      final docs = await getApplicationDocumentsDirectory();
      final mapsDir = Directory(p.join(docs.path, 'world_maps'));
      if (!await mapsDir.exists()) {
        await mapsDir.create(recursive: true);
      }
      final file = File(p.join(mapsDir.path, '${mapId}_config.json'));
      
      final json = {
        'grid': {
          'show': _showGrid,
          'type': _gridType,
          'size': _gridSize,
          'opacity': _gridOpacity,
        },
        'fogOfWar': {
          'show': _showFogOfWar,
          'brushSize': _fogBrushSize,
          'revealedStrokes': _revealedStrokes.map((s) {
            return s.map((p) => {'x': p.dx, 'y': p.dy}).toList();
          }).toList(),
        },
        'customRoutes': _customRoutes.map((r) {
          return {
            'id': r.id,
            'name': r.name,
            'type': r.type,
            'points': r.points.map((p) => {'x': p.dx, 'y': p.dy}).toList(),
          };
        }).toList(),
      };
      
      await file.writeAsString(jsonEncode(json));
    } catch (_) {
      // Silently swallow errors
    }
  }
}

class DistanceLinePainter extends CustomPainter {
  final Offset startPercent;
  final Offset? endPercent;
  final Color color;

  DistanceLinePainter({
    required this.startPercent,
    required this.endPercent,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (endPercent == null) return;
    
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final start = Offset(startPercent.dx * size.width, startPercent.dy * size.height);
    final end = Offset(endPercent!.dx * size.width, endPercent!.dy * size.height);

    // Draw wide faint glow path
    final glowPaint = Paint()
      ..color = color.withOpacity(0.2)
      ..strokeWidth = 8.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
      
    canvas.drawLine(start, end, glowPaint);
    canvas.drawLine(start, end, paint);

    // Dotted details or endpoints
    final ringPaint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
      
    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(start, 5, fillPaint);
    canvas.drawCircle(start, 5, ringPaint);
    canvas.drawCircle(start, 2.5, Paint()..color = color);

    canvas.drawCircle(end, 5, fillPaint);
    canvas.drawCircle(end, 5, ringPaint);
    canvas.drawCircle(end, 2.5, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant DistanceLinePainter oldDelegate) =>
      oldDelegate.startPercent != startPercent || oldDelegate.endPercent != endPercent || oldDelegate.color != color;
}

class HeatmapPainter extends CustomPainter {
  final List<MapPin> pins;
  final List<Entity> entities;
  final List<Relationship> relationships;
  final List<ManuscriptChapter> chapters;

  HeatmapPainter({
    required this.pins,
    required this.entities,
    required this.relationships,
    required this.chapters,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final pin in pins) {
      final entity = entities.where((e) => e.id == pin.entityId).firstOrNull;
      if (entity == null) continue;

      final relCount = relationships.where((r) => r.sourceId == entity.id || r.targetId == entity.id).length;
      final mentionCount = chapters.where((c) {
        final nameLower = entity.name.toLowerCase();
        return c.title.toLowerCase().contains(nameLower) ||
               c.content.toLowerCase().contains(nameLower) ||
               c.locationId == entity.id;
      }).length;

      final score = 1.0 + relCount * 1.5 + mentionCount * 2.0;
      final radius = 30.0 + score * 8.0;
      final maxRadius = radius.clamp(35.0, 160.0);
      final opacity = (0.2 + (score * 0.04)).clamp(0.2, 0.7);

      final pinColor = Color(entity.iconColor);
      final center = Offset(pin.xPercent * size.width, pin.yPercent * size.height);

      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            pinColor.withOpacity(opacity),
            pinColor.withOpacity(opacity * 0.4),
            pinColor.withOpacity(0.0),
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: maxRadius));

      canvas.drawCircle(center, maxRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant HeatmapPainter oldDelegate) => true;
}

class JourneyPathPainter extends CustomPainter {
  final List<Offset> pathPercent;
  final Color color;

  JourneyPathPainter({
    required this.pathPercent,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (pathPercent.length < 2) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final glowPaint = Paint()
      ..color = color.withOpacity(0.18)
      ..strokeWidth = 6.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final arrowPaint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < pathPercent.length - 1; i++) {
      final start = Offset(pathPercent[i].dx * size.width, pathPercent[i].dy * size.height);
      final end = Offset(pathPercent[i + 1].dx * size.width, pathPercent[i + 1].dy * size.height);

      final path = Path()
        ..moveTo(start.dx, start.dy)
        ..lineTo(end.dx, end.dy);
      
      canvas.drawPath(path, glowPaint);
      canvas.drawPath(path, paint);

      final mid = Offset((start.dx + end.dx) / 2, (start.dy + end.dy) / 2);
      final angle = math.atan2(end.dy - start.dy, end.dx - start.dx);
      
      final arrowPath = Path()
        ..moveTo(mid.dx - 6 * math.cos(angle - math.pi / 6), mid.dy - 6 * math.sin(angle - math.pi / 6))
        ..lineTo(mid.dx, mid.dy)
        ..lineTo(mid.dx - 6 * math.cos(angle + math.pi / 6), mid.dy - 6 * math.sin(angle + math.pi / 6));
      canvas.drawPath(arrowPath, arrowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant JourneyPathPainter oldDelegate) =>
      oldDelegate.pathPercent != pathPercent || oldDelegate.color != color;
}

class CustomRoute {
  final String id;
  final String name;
  final String type;
  final List<Offset> points;

  CustomRoute({
    required this.id,
    required this.name,
    required this.type,
    required this.points,
  });
}

class GridPainter extends CustomPainter {
  final String type;
  final double size;
  final double opacity;
  final Color color;

  GridPainter({
    required this.type,
    required this.size,
    required this.opacity,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    if (type == 'square') {
      for (double x = 0; x < canvasSize.width; x += size) {
        canvas.drawLine(Offset(x, 0), Offset(x, canvasSize.height), paint);
      }
      for (double y = 0; y < canvasSize.height; y += size) {
        canvas.drawLine(Offset(0, y), Offset(canvasSize.width, y), paint);
      }
    } else {
      final double h = size;
      final double w = math.sqrt(3) * h / 2;

      final double rowHeight = h * 0.75;
      final double colWidth = w;

      int rowCount = (canvasSize.height / rowHeight).ceil() + 1;
      int colCount = (canvasSize.width / colWidth).ceil() + 1;

      for (int r = -1; r < rowCount; r++) {
        final double y = r * rowHeight;
        final double xOffset = (r % 2 == 0) ? 0 : colWidth / 2;

        for (int c = -1; c < colCount; c++) {
          final double x = c * colWidth + xOffset;
          final Offset center = Offset(x, y);

          final path = Path();
          for (int i = 0; i < 6; i++) {
            final double angle = 2 * math.pi / 6 * (i + 0.5);
            final double px = center.dx + (h / 2) * math.cos(angle);
            final double py = center.dy + (h / 2) * math.sin(angle);
            if (i == 0) {
              path.moveTo(px, py);
            } else {
              path.lineTo(px, py);
            }
          }
          path.close();
          canvas.drawPath(path, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant GridPainter oldDelegate) =>
      oldDelegate.type != type || oldDelegate.size != size || oldDelegate.opacity != opacity || oldDelegate.color != color;
}

class FogOfWarPainter extends CustomPainter {
  final List<List<Offset>> revealedStrokes;
  final double brushSize;

  FogOfWarPainter({
    required this.revealedStrokes,
    required this.brushSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    
    canvas.saveLayer(rect, Paint());

    final fogPaint = Paint()
      ..color = Colors.black.withOpacity(0.85);
    canvas.drawRect(rect, fogPaint);

    final erasePaint = Paint()
      ..color = Colors.transparent
      ..blendMode = BlendMode.clear
      ..strokeWidth = brushSize
      ..strokeCap = StrokeCap.round;

    for (final stroke in revealedStrokes) {
      if (stroke.length < 2) {
        if (stroke.isNotEmpty) {
          final p = Offset(stroke.first.dx * size.width, stroke.first.dy * size.height);
          canvas.drawCircle(p, brushSize / 2, erasePaint);
        }
        continue;
      }
      
      final path = Path();
      path.moveTo(stroke.first.dx * size.width, stroke.first.dy * size.height);
      for (int i = 1; i < stroke.length; i++) {
        path.lineTo(stroke[i].dx * size.width, stroke[i].dy * size.height);
      }
      canvas.drawPath(path, erasePaint..style = PaintingStyle.stroke);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant FogOfWarPainter oldDelegate) => true;
}

class CustomRoutesPainter extends CustomPainter {
  final List<CustomRoute> routes;

  CustomRoutesPainter({
    required this.routes,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final r in routes) {
      if (r.points.length < 2) continue;

      Color routeColor;
      double strokeWidth;
      bool isDashed = false;

      if (r.type == 'river') {
        routeColor = Colors.blue.withOpacity(0.8);
        strokeWidth = 3.5;
      } else if (r.type == 'trade') {
        routeColor = Colors.green;
        strokeWidth = 2.0;
        isDashed = true;
      } else if (r.type == 'magic') {
        routeColor = Colors.purple.withOpacity(0.9);
        strokeWidth = 2.5;
      } else {
        routeColor = Colors.brown.withOpacity(0.9);
        strokeWidth = 3.0;
        isDashed = true;
      }

      final paint = Paint()
        ..color = routeColor
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final path = Path();
      path.moveTo(r.points.first.dx * size.width, r.points.first.dy * size.height);
      for (int i = 1; i < r.points.length; i++) {
        path.lineTo(r.points[i].dx * size.width, r.points[i].dy * size.height);
      }

      if (isDashed) {
        _drawDashedPath(canvas, path, paint, 6.0, 4.0);
      } else {
        canvas.drawPath(path, paint);
      }
    }
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint, double dashWidth, double dashSpace) {
    for (final metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final double length = dashWidth;
        final Path extract = metric.extractPath(distance, distance + length);
        canvas.drawPath(extract, paint);
        distance += length + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomRoutesPainter oldDelegate) => true;
}

class ActiveRoutePainter extends CustomPainter {
  final List<Offset> points;
  final String type;

  ActiveRoutePainter({
    required this.points,
    required this.type,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    Color routeColor = Colors.red;
    if (type == 'river') routeColor = Colors.blue;
    else if (type == 'trade') routeColor = Colors.green;
    else if (type == 'magic') routeColor = Colors.purple;

    final paint = Paint()
      ..color = routeColor.withOpacity(0.6)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final nodePaint = Paint()
      ..color = routeColor
      ..style = PaintingStyle.fill;

    if (points.length >= 2) {
      final path = Path();
      path.moveTo(points.first.dx * size.width, points.first.dy * size.height);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx * size.width, points[i].dy * size.height);
      }
      canvas.drawPath(path, paint);
    }

    for (final pt in points) {
      final center = Offset(pt.dx * size.width, pt.dy * size.height);
      canvas.drawCircle(center, 4.5, nodePaint);
      canvas.drawCircle(center, 6.0, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1.0);
    }
  }

  @override
  bool shouldRepaint(covariant ActiveRoutePainter oldDelegate) => true;
}
