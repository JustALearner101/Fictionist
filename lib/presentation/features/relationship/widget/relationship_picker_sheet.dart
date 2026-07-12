import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entity/entity.dart';
import '../../../../domain/relationship/relationship_type_def.dart';
import '../../../../domain/relationship/relationship_type_registry.dart';
import '../../../../domain/use_case/relationship/create_relationship_use_case.dart';
import '../../entity/provider/entity_list_provider.dart';
import '../../../common/widget/fictionist_dropdown.dart';

class RelationshipPickerSheet extends ConsumerStatefulWidget {
  final Entity sourceEntity;
  final Entity? targetEntity;

  const RelationshipPickerSheet({
    super.key,
    required this.sourceEntity,
    this.targetEntity,
  });

  @override
  ConsumerState<RelationshipPickerSheet> createState() =>
      _RelationshipPickerSheetState();
}

class _RelationshipPickerSheetState extends ConsumerState<RelationshipPickerSheet> {
  final _searchController = TextEditingController();
  final _descController = TextEditingController();
  String _searchQuery = '';
  Entity? _selectedTarget;
  RelationshipTypeDef? _selectedDef;
  int _weight = 5;

  @override
  void initState() {
    super.initState();
    if (widget.targetEntity != null) {
      _selectedTarget = widget.targetEntity;
    }
    // Get relationship types applicable to the source entity type
    final eligibleDefs = RelationshipTypeRegistry.builtinTypes
        .where((def) => def.applicableSourceTypes.contains(widget.sourceEntity.type))
        .toList();
    if (eligibleDefs.isNotEmpty) {
      _selectedDef = eligibleDefs.first;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _descController.dispose();
    super.dispose();
  }

  bool _isCompatible(Entity target, RelationshipTypeDef def) {
    return def.applicableTargetTypes.contains(target.type);
  }

  @override
  Widget build(BuildContext context) {
    final entitiesState = ref.watch(entityListProvider);
    final eligibleDefs = RelationshipTypeRegistry.builtinTypes
        .where((def) => def.applicableSourceTypes.contains(widget.sourceEntity.type))
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
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle indicator
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Forge Connection',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontFamily: 'Lora',
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Visual connection flow diagram
            _buildConnectionFlow(),
            
            const SizedBox(height: 20),
            Text(
              'Connection Type',
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
            ),
            const SizedBox(height: 8),
            FictionistDropdown<RelationshipTypeDef?>(
              value: _selectedDef,
              items: eligibleDefs.map((def) {
                return FictionistDropdownItem<RelationshipTypeDef?>(
                  value: def,
                  child: Row(
                    children: [
                      Icon(Icons.link, size: 14, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${def.label} (➔ ${def.applicableTargetTypes.map((t) => t.label).join(", ")})',
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedDef = val;
                  // Clear target if it becomes incompatible
                  if (_selectedTarget != null &&
                      val != null &&
                      !_isCompatible(_selectedTarget!, val)) {
                    _selectedTarget = null;
                  }
                });
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Search Target Entity',
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              style: Theme.of(context).textTheme.bodyLarge!,
              decoration: InputDecoration(
                hintText: _selectedDef != null
                    ? 'Search for ${(_selectedDef!.applicableTargetTypes.map((t) => t.label).join(" or "))}...'
                    : 'Search target name...',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            entitiesState.when(
              data: (list) {
                // Filter targets: cannot be source, and matches query
                var targets = list.where((e) => e.id != widget.sourceEntity.id).toList();
                if (_searchQuery.trim().isNotEmpty) {
                  targets = targets
                      .where((e) => e.name.toLowerCase().contains(_searchQuery.toLowerCase()))
                      .toList();
                }

                if (targets.isEmpty) {
                  return Container(
                    height: 120,
                    alignment: Alignment.center,
                    child: Text(
                      'No matching target entities found.',
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  );
                }

                return SizedBox(
                  height: 120,
                  child: ListView.builder(
                    itemCount: targets.length,
                    itemBuilder: (context, index) {
                      final target = targets[index];
                      final isSelected = _selectedTarget?.id == target.id;
                      final isComp = _selectedDef != null && _isCompatible(target, _selectedDef!);
                      final iconColor = Color(target.iconColor);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 6),
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary.withOpacity(0.08)
                            : (isComp ? null : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.2)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.outline.withOpacity(0.3),
                          ),
                        ),
                        child: ListTile(
                          dense: true,
                          leading: CircleAvatar(
                            radius: 14,
                            backgroundColor: iconColor.withOpacity(0.15),
                            child: Text(
                              target.name.isNotEmpty
                                  ? target.name.substring(0, 1).toUpperCase()
                                  : '?',
                              style: TextStyle(color: iconColor, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(
                            target.name,
                            style: TextStyle(
                              color: isComp
                                  ? Theme.of(context).colorScheme.onSurface
                                  : Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.4),
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          subtitle: Text(
                            '${target.type.label.toUpperCase()}${!isComp ? " (Incompatible)" : ""}',
                            style: TextStyle(
                              color: isComp
                                  ? Theme.of(context).colorScheme.onSurfaceVariant
                                  : Theme.of(context).colorScheme.error.withOpacity(0.7),
                              fontSize: 10,
                            ),
                          ),
                          trailing: isSelected
                              ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary)
                              : null,
                          enabled: isComp,
                          onTap: () {
                            setState(() => _selectedTarget = target);
                          },
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () => const SizedBox(
                height: 120,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, _) => Text('Error loading targets: $err'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descController,
              style: Theme.of(context).textTheme.bodyLarge!,
              decoration: const InputDecoration(
                labelText: 'Connection Context/Description (Optional)',
                prefixIcon: Icon(Icons.notes),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Connection Weight: $_weight',
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Expanded(
                  child: Slider(
                    value: _weight.toDouble(),
                    min: 1,
                    max: 10,
                    divisions: 9,
                    label: _weight.toString(),
                    onChanged: (val) {
                      setState(() => _weight = val.round());
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: (_selectedTarget != null && _selectedDef != null)
                      ? () {
                          Navigator.pop(
                            context,
                            CreateRelationshipParams(
                              sourceId: widget.sourceEntity.id,
                              targetId: _selectedTarget!.id,
                              typeKey: _selectedDef!.key,
                              description: _descController.text.trim().isEmpty
                                  ? null
                                  : _descController.text.trim(),
                              weight: _weight,
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.surface,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Forge Link', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionFlow() {
    final sourceColor = Color(widget.sourceEntity.iconColor);
    final targetColor = _selectedTarget != null ? Color(_selectedTarget!.iconColor) : Colors.grey.shade600;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: sourceColor.withOpacity(0.15),
                  child: Text(
                    widget.sourceEntity.name.isNotEmpty
                        ? widget.sourceEntity.name.substring(0,1).toUpperCase()
                        : '?',
                    style: TextStyle(color: sourceColor, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.sourceEntity.name,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  widget.sourceEntity.type.label,
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 9),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _selectedDef != null ? _selectedDef!.label : 'Select relation',
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 4, height: 4, decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, shape: BoxShape.circle)),
                    Container(width: 32, height: 2, color: Theme.of(context).colorScheme.primary),
                    Icon(Icons.arrow_forward_ios, size: 8, color: Theme.of(context).colorScheme.primary),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: _selectedTarget != null ? targetColor.withOpacity(0.15) : Colors.grey.withOpacity(0.1),
                  child: Icon(
                    _selectedTarget != null ? Icons.link : Icons.help_outline,
                    color: _selectedTarget != null ? targetColor : Colors.grey,
                    size: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _selectedTarget != null ? _selectedTarget!.name : 'Choose target',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _selectedTarget != null ? null : Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _selectedTarget != null ? _selectedTarget!.type.label : 'Pending',
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 9),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
