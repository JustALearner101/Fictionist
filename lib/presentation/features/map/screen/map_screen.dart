import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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
import '../provider/map_provider.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  WorldMap? _selectedMap;

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
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                          ),
                        ),
                        Text(
                          entity.type.label.toUpperCase(),
                          style: Theme.of(context).textTheme.labelMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (c) => const ConfirmDialog(
                          title: 'Remove Pin',
                          content: 'Are you sure you want to remove this location pin?',
                          confirmLabel: 'Remove',
                          isDestructive: true,
                        ),
                      );

                      if (confirm == true) {
                        await ref.read(mapPinsProvider(mapId).notifier).removePin(pinId);
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Pin removed successfully.'),
                            backgroundColor: Theme.of(context).colorScheme.outline,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 12),
              if (entity.description != null && entity.description!.trim().isNotEmpty) ...[
                Text(
                  entity.description!,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
                SizedBox(height: 16),
              ],
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        showEntityPeekSheet(context, entityId: entity.id);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        side: BorderSide(color: Theme.of(context).colorScheme.primary),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Peek Entry', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        context.push('/entities/${entity.id}');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.surface,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Full Entry', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
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
        title: Text(
          'World Maps',
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
            fontFamily: 'Lora',
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.upload_file, color: Theme.of(context).colorScheme.onSurface),
            tooltip: 'Upload Map Image',
            onPressed: _uploadMap,
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
                                        Image.file(
                                          file,
                                          fit: BoxFit.cover,
                                          width: constraints.maxWidth,
                                          height: constraints.maxHeight,
                                        ),
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
                                                    onTap: () => _showPinDetails(
                                                      context,
                                                      peerEntity,
                                                      pin.id,
                                                      selectedMap.id,
                                                    ),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Icon(
                                                          Icons.location_on,
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
                                                    ),
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
