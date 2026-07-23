import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../domain/entity/custom_field.dart';
import '../../../../domain/entity/entity.dart';
import '../../../../domain/entity/entity_status.dart';
import '../../../../domain/entity/entity_type.dart';
import '../../../../domain/use_case/entity/update_entity_use_case.dart';
import '../../../../injection.dart';
import '../provider/entity_detail_provider.dart';
import '../provider/entity_list_provider.dart';
import '../../../common/widget/fictionist_dropdown.dart';

class EntityEditScreen extends ConsumerStatefulWidget {
  final String entityId;
  const EntityEditScreen({super.key, required this.entityId});

  @override
  ConsumerState<EntityEditScreen> createState() => _EntityEditScreenState();
}

class _EntityEditScreenState extends ConsumerState<EntityEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  EntityType _type = EntityType.character;
  EntityStatus _status = EntityStatus.draft;
  int _color = 0xFF8B5CF6;
  List<CustomField> _fields = [];
  bool _loading = false;
  bool _saving = false;

  final List<int> _presetColors = [
    0xFF8B5CF6, 0xFFEC4899, 0xFFEF4444, 0xFFF59E0B,
    0xFF10B981, 0xFF3B82F6, 0xFF06B6D4,
  ];

  IconData _typeIcon(EntityType t) {
    switch (t) {
      case EntityType.character: return Icons.person;
      case EntityType.faction: return Icons.shield;
      case EntityType.raceCulture: return Icons.groups;
      case EntityType.location: return Icons.place;
      case EntityType.powerMagicSystem: return Icons.auto_fix_high;
      case EntityType.itemArtifact: return Icons.category;
      case EntityType.event: return Icons.bolt;
      case EntityType.conceptGlossary: return Icons.menu_book;
    }
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final future = ref.read(entityDetailProvider(widget.entityId).future);
      final entity = await future;
      _nameCtrl.text = entity.name;
      _descCtrl.text = entity.description ?? '';
      _type = entity.type;
      _status = entity.status;
      _color = entity.iconColor;
      _fields = entity.customFields.toList();
    } catch (_) {}
    setState(() => _loading = false);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final useCase = getIt<UpdateEntityUseCase>();
    final entity = Entity(
      id: widget.entityId, name: _nameCtrl.text.trim(), type: _type,
      status: _status, description: _descCtrl.text.trim().isEmpty
          ? null : _descCtrl.text.trim(),
      customFields: _fields, iconColor: _color,
      createdAt: DateTime.now(), updatedAt: DateTime.now(),
    );
    final res = await useCase(UpdateEntityParams(entity: entity));
    setState(() => _saving = false);
    res.fold(
      (f) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(f.message), backgroundColor: Theme.of(context).colorScheme.error)),
      (_) {
        ref.invalidate(entityDetailProvider(widget.entityId));
        ref.invalidate(entityListProvider);
        context.pop();
      },
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary)),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, size: 20, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text('Refine Entry',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontFamily: Theme.of(context).textTheme.displayLarge?.fontFamily, fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        actions: [
          if (_saving)
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Center(child: SizedBox(width: 20, height: 20,
                child: CircularProgressIndicator(strokeWidth: 2,
                    color: Theme.of(context).colorScheme.primary))),
            )
          else
            TextButton(
              onPressed: _save,
              child: Text('Save', style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 40),
          children: [
            // ── Name ──
            _labeledField('Name', Icons.edit_outlined,
              TextFormField(
                controller: _nameCtrl,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 15),
                decoration: _inputDeco('Entity name…'),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Name is required' : null,
              ),
            ),
            SizedBox(height: 16),
            // ── Description ──
            _labeledField('Description', Icons.auto_stories,
              TextFormField(
                controller: _descCtrl,
                maxLines: 4,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 14, height: 1.5),
                decoration: _inputDeco('Describe this entity…'),
              ),
            ),
            SizedBox(height: 20),
            // ── Type & Status ──
            _labeledField('Category & Status', Icons.label_outline,
              Row(
                children: [
                  Expanded(child: FictionistDropdown<EntityType>(
                    value: _type,
                    items: EntityType.values.map((t) => FictionistDropdownItem(
                      value: t, child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(_typeIcon(t), size: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
                        const SizedBox(width: 6),
                        Flexible(child: Text(t.label, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)),
                      ]),
                    )).toList(),
                    onChanged: (v) => setState(() => _type = v),
                  )),
                  const SizedBox(width: 12),
                  Expanded(child: FictionistDropdown<EntityStatus>(
                    value: _status,
                    items: EntityStatus.values.map((s) => FictionistDropdownItem(
                      value: s, child: Text(s.label, style: const TextStyle(fontSize: 13)),
                    )).toList(),
                    onChanged: (v) => setState(() => _status = v),
                  )),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // ── Color ──
            _labeledField('Sigil Color', Icons.palette_outlined,
              SizedBox(
                height: 42,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _presetColors.length,
                  itemBuilder: (_, i) {
                    final c = _presetColors[i];
                    final sel = c == _color;
                    return GestureDetector(
                      onTap: () => setState(() => _color = c),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        width: 36, height: 36,
                        margin: EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: Color(c),
                          shape: BoxShape.circle,
                          border: sel ? Border.all(
                            color: Theme.of(context).colorScheme.onSurface, width: 2.5,
                          ) : null,
                          boxShadow: sel ? [
                            BoxShadow(color: Color(c).withValues(alpha: 0.4),
                                blurRadius: 8)
                          ] : null,
                        ),
                        child: sel ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            // ── Custom Fields ──
            _labeledField('Attributes', Icons.psychology_outlined,
              Column(
                children: [
                  if (_fields.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                            width: 0.8,
                          ),
                        ),
                        child: Text(
                          'No attributes defined for this entity yet.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    )
                  else
                    ..._fields.asMap().entries.map((e) {
                      final i = e.key;
                      final f = e.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                initialValue: f.value?.toString() ?? '',
                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 14),
                                decoration: InputDecoration(
                                  labelText: f.label,
                                  labelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.4),
                                      width: 0.6,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.4),
                                      width: 0.6,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Theme.of(context).colorScheme.primary, width: 1,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 12,
                                  ),
                                  filled: true,
                                  fillColor: Theme.of(context).colorScheme.surface,
                                ),
                                onChanged: (val) => _fields[i] = f.copyWith(value: val),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error, size: 20),
                              tooltip: 'Delete Attribute',
                              onPressed: () {
                                setState(() {
                                  _fields.removeAt(i);
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    }),
                  const SizedBox(height: 4),
                  Center(
                    child: TextButton.icon(
                      onPressed: _addNewAttribute,
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Add Custom Attribute'),
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _labeledField(String label, IconData icon, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Row(children: [
            Icon(icon, size: 14, color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7)),
            SizedBox(width: 6),
            Text(label, style: Theme.of(context).textTheme.labelMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 11, letterSpacing: 0.5,
            )),
          ]),
        ),
        child,
      ],
    );
  }

  InputDecoration _inputDeco(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5), fontSize: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.4), width: 0.6),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.4), width: 0.6),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    filled: true,
    fillColor: Theme.of(context).colorScheme.surface,
  );

  Future<void> _addNewAttribute() async {
    final controller = TextEditingController();
    final label = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text('Add Custom Attribute',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(fontFamily: Theme.of(context).textTheme.displayLarge?.fontFamily, fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Attribute Name (e.g. Hair Color)',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                Navigator.pop(ctx, controller.text.trim());
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
    if (label != null && label.isNotEmpty && mounted) {
      setState(() {
        final key = label.toLowerCase().replaceAll(RegExp(r'[^a-z0-9_]'), '_');
        _fields.add(CustomField(
          id: UniqueKey().toString(),
          key: key,
          label: label,
          fieldType: 'short_text',
          value: '',
        ));
      });
    }
  }
}
