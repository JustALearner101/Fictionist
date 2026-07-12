import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../domain/entity/entity.dart';
import '../../../../domain/entity/entity_type.dart';
import '../../../../domain/map/world_map.dart';
import '../../../common/widget/confirm_dialog.dart';
import '../../../common/widget/empty_state.dart';
import '../../../common/widget/error_display.dart';
import '../../../common/widget/loading_indicator.dart';
import '../../entity/provider/entity_list_provider.dart';
import '../../../common/widget/page_header.dart';
import '../../entity/widget/entity_peek_sheet.dart';
import '../../graph/provider/graph_provider.dart';
import '../../timeline/provider/timeline_provider.dart';
import '../provider/map_provider.dart';

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
    final localPos = details.localPosition;
    setState(() {
      _activeRipples.add(localPos);
    });

    final xPercent = details.localPosition.dx / constraints.maxWidth;
    final yPercent = details.localPosition.dy / constraints.maxHeight;

    final entitiesResult = await ref.read(entityListProvider.future);
    final locationEntities =
        entitiesResult.where((e) => e.type == EntityType.location).toList();

    if (locationEntities.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No location entities exist to pin. Create a Location first!'),
          backgroundColor: Theme.of(context).colorScheme.outline,
        ),
      );
      return;
    }

    Entity? selectedLocation;
    String searchQuery = '';

    final confirm = await showModalBottomSheet<Entity?>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filtered = locationEntities
                .where((e) => e.name.toLowerCase().contains(searchQuery.toLowerCase()))
                .toList();

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pin Location',
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontFamily: 'Lora',
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      onChanged: (val) => setModalState(() => searchQuery = val),
                      style: Theme.of(context).textTheme.bodyLarge!,
                      decoration: const InputDecoration(
                        hintText: 'Search location name...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 12),
                    SizedBox(
                      height: 200,
                      child: filtered.isEmpty
                          ? Center(
                              child: Text(
                                'No matching locations found.',
                                style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                              ),
                            )
                          : ListView.builder(
                              itemCount: filtered.length,
                              itemBuilder: (context, idx) {
                                final loc = filtered[idx];
                                final isSelected = selectedLocation?.id == loc.id;
                                final iconColor = Color(loc.iconColor);

                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: iconColor.withOpacity(0.15),
                                    child: Icon(Icons.location_city, color: iconColor),
                                  ),
                                  title: Text(
                                    loc.name,
                                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                  trailing: isSelected
                                      ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary)
                                      : null,
                                  onTap: () {
                                    setModalState(() => selectedLocation = loc);
                                  },
                                );
                              },
                            ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, null),
                          child: Text('Cancel', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                        ),
                        SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: selectedLocation != null
                              ? () => Navigator.pop(ctx, selectedLocation)
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Theme.of(context).colorScheme.surface,
                          ),
                          child: const Text('Place Pin'),
                        ),
                      ],
                    ),
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
                    
                    final (allEntities, allRels) = graphAsyncVal.valueOrNull ?? ([], []);
                    final relatedRels = allRels.where((r) => r.sourceId == entity.id || r.targetId == entity.id).toList();
                    final relatedPairs = relatedRels.map((r) {
                      final otherId = r.sourceId == entity.id ? r.targetId : r.sourceId;
                      final otherEntity = allEntities.where((e) => e.id == otherId).firstOrNull;
                      return otherEntity != null ? (otherEntity, r.typeKey) : null;
                    }).whereType<(Entity, String)>().toList();

                    final events = timelineAsyncVal.valueOrNull ?? [];

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
    } else if (combined.contains('cave') || combined.contains('mine') || combined.contains('tunnel') || combined.contains('dungeon')) {
      return Icons.terrain;
    } else if (combined.contains('lake') || combined.contains('sea') || combined.contains('ocean') || combined.contains('river') || combined.contains('harbor') || combined.contains('port')) {
      return Icons.water;
    } else if (combined.contains('forest') || combined.contains('woods') || combined.contains('jungle') || combined.contains('grove')) {
      return Icons.forest;
    }
    return Icons.location_on;
  }

  @override
  Widget build(BuildContext context) {
    final mapsState = ref.watch(worldMapListProvider);
    final entitiesState = ref.watch(entityListProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        toolbarHeight: 48,
        actions: [
          IconButton(
            icon: Icon(Icons.auto_awesome, color: Theme.of(context).colorScheme.primary),
            tooltip: 'Forge Procedural Map',
            onPressed: () {
              HapticFeedback.lightImpact();
              context.push('/map/generator');
            },
          ),
          IconButton(
            icon: Icon(Icons.upload_file, color: Theme.of(context).colorScheme.onSurface),
            tooltip: 'Upload Map Image',
            onPressed: _uploadMap,
          ),
          PopupMenuButton<MapFilterMode>(
            icon: Icon(Icons.filter_hdr_outlined, color: Theme.of(context).colorScheme.onSurface),
            tooltip: 'Map Filters',
            onSelected: (mode) {
              setState(() => _filterMode = mode);
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: MapFilterMode.original,
                child: Text('Original Map'),
              ),
              const PopupMenuItem(
                value: MapFilterMode.sepia,
                child: Text('Antique Sepia'),
              ),
              const PopupMenuItem(
                value: MapFilterMode.dark,
                child: Text('High Contrast Dark'),
              ),
              const PopupMenuItem(
                value: MapFilterMode.satellite,
                child: Text('Satellite Blueprint'),
              ),
            ],
          ),
          if (_selectedMap != null)
            IconButton(
              icon: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error),
              tooltip: 'Delete Map',
              onPressed: () => _deleteMap(_selectedMap!),
            ),
        ],
      ),
      body: mapsState.when(
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

          final selectedMap = _selectedMap!;

          return entitiesState.when(
            data: (entities) {
              return Column(
                children: [
                  const PageHeader(title: 'World Map', subtitle: 'Cartography and exploration'),
                  if (maps.length > 1)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        children: [
                          Text('Map selector:', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                          SizedBox(width: 12),
                          Expanded(
                            child: DropdownButton<WorldMap>(
                              value: selectedMap,
                              dropdownColor: Theme.of(context).colorScheme.surface,
                              isExpanded: true,
                              items: maps.map((m) {
                                return DropdownMenuItem(
                                  value: m,
                                  child: Text(m.name, style: Theme.of(context).textTheme.bodyLarge!),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _selectedMap = val);
                                }
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
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return GestureDetector(
                                    onLongPressStart: (details) => _onMapLongPress(
                                      context,
                                      details,
                                      constraints,
                                      selectedMap.id,
                                    ),
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
                                        pinsState.when(
                                          data: (pins) {
                                            return Stack(
                                              children: pins.map((pin) {
                                                final peerEntity = entities
                                                    .where((e) => e.id == pin.entityId)
                                                    .firstOrNull;
                                                if (peerEntity == null) {
                                                  return const SizedBox.shrink();
                                                }

                                                final left = pin.xPercent * constraints.maxWidth - 50;
                                                final top = pin.yPercent * constraints.maxHeight - 36;
                                                final iconColor = Color(peerEntity.iconColor);

                                                return Positioned(
                                                  left: left,
                                                  top: top,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      HapticFeedback.lightImpact();
                                                      _showPinDetails(
                                                        context,
                                                        peerEntity,
                                                        pin.id,
                                                        selectedMap.id,
                                                      );
                                                    },
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Icon(
                                                          _getPinIcon(peerEntity),
                                                          size: 24,
                                                          color: iconColor,
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.symmetric(
                                                            horizontal: 4,
                                                            vertical: 2,
                                                          ),
                                                          decoration: BoxDecoration(
                                                            color: Theme.of(context).colorScheme.surface.withOpacity(0.85),
                                                            borderRadius: BorderRadius.circular(4),
                                                            border: Border.all(color: Theme.of(context).colorScheme.outline),
                                                          ),
                                                          child: Text(
                                                            peerEntity.name,
                                                            style: TextStyle(
                                                              fontSize: 8,
                                                              color: Theme.of(context).colorScheme.onSurface,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ).animate()
                                                     .scale(duration: 400.ms, curve: Curves.easeOutBack)
                                                     .animate(onPlay: (c) => c.repeat(reverse: true))
                                                     .slideY(begin: 0.0, end: -0.08, duration: 1500.ms, curve: Curves.easeInOut),
                                                  ),
                                                );
                                              }).toList(),
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
                ],
              );
            },
            loading: () => LoadingIndicator(),
            error: (e, _) => ErrorDisplay(message: e.toString()),
          );
        },
        loading: () => LoadingIndicator(),
        error: (err, _) => ErrorDisplay(message: err.toString()),
      ),
    );
  }
}
