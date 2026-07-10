import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../domain/entity/custom_field.dart';
import '../../../../domain/entity/entity_status.dart';
import '../../../../domain/entity/entity_type.dart';
import '../../../../domain/use_case/entity/create_entity_use_case.dart';
import '../../../../domain/use_case/template/get_templates_use_case.dart';
import '../../../../injection.dart';
import '../../name_generator/widget/name_generator_sheet.dart';
import '../provider/entity_list_provider.dart';
import '../../../common/widget/fictionist_dropdown.dart';

class EntityCreateScreen extends ConsumerStatefulWidget {
  const EntityCreateScreen({super.key});

  @override
  ConsumerState<EntityCreateScreen> createState() =>
      _EntityCreateScreenState();
}

class _EntityCreateScreenState extends ConsumerState<EntityCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  EntityType _type = EntityType.character;
  EntityStatus _status = EntityStatus.draft;
  int _color = 0xFF8B5CF6;
  List<CustomField> _fields = [];
  bool _loading = false;

  final List<int> _presets = [
    0xFF8B5CF6, 0xFFEC4899, 0xFFEF4444, 0xFFF59E0B,
    0xFF10B981, 0xFF3B82F6, 0xFF06B6D4,
  ];

  static final Map<String, List<CustomField>> _quickTemplates = {
    'Noble Character': [
      const CustomField(key: 'title', label: 'Title / Rank', value: 'Lord'),
      const CustomField(key: 'house', label: 'House / Allegiance', value: ''),
      const CustomField(key: 'lineage', label: 'Lineage / Dynastic Line', value: ''),
      const CustomField(key: 'sigil', label: 'House Sigil / Arms', value: ''),
    ],
    'Settlement / City': [
      const CustomField(key: 'population', label: 'Population size', value: ''),
      const CustomField(key: 'ruler', label: 'Ruling Lord / Council', value: ''),
      const CustomField(key: 'climate', label: 'Regional Climate', value: ''),
      const CustomField(key: 'defense', label: 'Defenses / Fortifications', value: ''),
    ],
    'Military Order': [
      const CustomField(key: 'strength', label: 'Active Troop Strength', value: ''),
      const CustomField(key: 'commander', label: 'Grand Master / Commander', value: ''),
      const CustomField(key: 'headquarters', label: 'Primary Fortress / HQ', value: ''),
      const CustomField(key: 'motto', label: 'Order Motto / Creed', value: ''),
    ],
    'Spiritual Order': [
      const CustomField(key: 'deity', label: 'Patron Deity / Entity', value: ''),
      const CustomField(key: 'hq', label: 'Holy Site / Temple City', value: ''),
      const CustomField(key: 'influence', label: 'Regional Influence', value: ''),
      const CustomField(key: 'sacred_object', label: 'Sacred Relic / Artifact', value: ''),
    ],
  };

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
    _loadTemplate(_type);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final nameParam = GoRouterState.of(context).uri.queryParameters['name'];
      if (nameParam != null && nameParam.isNotEmpty) {
        _nameCtrl.text = nameParam;
      }
    });
  }

  Future<void> _loadTemplate(EntityType type) async {
    final res = await getIt<GetTemplatesUseCase>()(type);
    res.fold((_) {}, (templates) {
      if (mounted) setState(() => _fields = templates.isNotEmpty
          ? templates.first.customFieldsSchema
              .map((f) => f.copyWith(value: ''))
              .toList()
          : []);
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _forge() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final res = await getIt<CreateEntityUseCase>()(CreateEntityParams(
      name: _nameCtrl.text.trim(),
      type: _type,
      status: _status,
      description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
      customFields: _fields,
      iconColor: _color,
    ));
    setState(() => _loading = false);
    res.fold(
      (f) => _snack(f.message, Theme.of(context).colorScheme.error),
      (entity) {
        ref.invalidate(entityListProvider);
        context.pop();
        context.push('/entities/${entity.id}');
      },
    );
  }

  void _snack(String msg, Color c) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: c));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, size: 20, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text('Forge New Entity',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontFamily: 'Lora', fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        actions: [
          if (_loading)
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Center(child: SizedBox(width: 20, height: 20,
                child: CircularProgressIndicator(strokeWidth: 2,
                    color: Theme.of(context).colorScheme.primary))),
            )
          else
            TextButton(onPressed: _forge,
              child: Text('Forge', style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 40),
          children: [
            // Name + generator
            _Label('Name', Icons.edit_outlined),
            SizedBox(height: 8),
            TextFormField(
              controller: _nameCtrl,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 15),
              decoration: _deco('Entity name…').copyWith(
                suffixIcon: IconButton(
                  icon: Icon(Icons.auto_awesome, color: Theme.of(context).colorScheme.primary, size: 20),
                  tooltip: 'Generate name',
                  onPressed: () async {
                    final name = await showNameGeneratorSheet(context);
                    if (name != null && mounted) _nameCtrl.text = name;
                  },
                ),
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Name is required' : null,
            ),
            SizedBox(height: 16),
            // Description
            _Label('Description', Icons.auto_stories),
            SizedBox(height: 8),
            TextFormField(
              controller: _descCtrl,
              maxLines: 3,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 14, height: 1.5),
              decoration: _deco('Describe this entity…'),
            ),
            SizedBox(height: 20),
            // Type + Status
            _Label('Category & Status', Icons.label_outline),
            SizedBox(height: 8),
            Row(children: [
              Expanded(child: FictionistDropdown<EntityType>(
                value: _type,
                items: EntityType.values.map((t) => FictionistDropdownItem(
                  value: t, child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(_typeIcon(t), size: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    const SizedBox(width: 6),
                    Flexible(child: Text(t.label, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)),
                  ]),
                )).toList(),
                onChanged: (v) {
                  setState(() => _type = v);
                  _loadTemplate(v);
                },
              )),
              const SizedBox(width: 12),
              Expanded(child: FictionistDropdown<EntityStatus>(
                value: _status,
                items: EntityStatus.values.map((s) => FictionistDropdownItem(
                  value: s, child: Text(s.label, style: const TextStyle(fontSize: 13)),
                )).toList(),
                onChanged: (v) => setState(() => _status = v),
              )),
            ]),
            const SizedBox(height: 20),
            // Color picker
            _Label('Sigil Color', Icons.palette_outlined),
            const SizedBox(height: 8),
            SizedBox(height: 42, child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _presets.length,
              itemBuilder: (_, i) {
                final c = _presets[i];
                final sel = c == _color;
                return GestureDetector(
                  onTap: () => setState(() => _color = c),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    width: 36, height: 36,
                    margin: EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: Color(c), shape: BoxShape.circle,
                      border: sel ? Border.all(color: Theme.of(context).colorScheme.onSurface, width: 2.5) : null,
                      boxShadow: sel ? [BoxShadow(
                        color: Color(c).withValues(alpha: 0.4), blurRadius: 8,
                      )] : null,
                    ),
                    child: sel ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
                  ),
                );
              },
            )),
            const SizedBox(height: 20),
            // Pre-configured templates row
            _Label('Field Templates', Icons.copy_all_outlined),
            const SizedBox(height: 8),
            SizedBox(
              height: 38,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _quickTemplates.keys.map((title) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ActionChip(
                      label: Text(
                        title,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.08),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                        width: 0.8,
                      ),
                      onPressed: () {
                        setState(() {
                          _fields = _quickTemplates[title]!
                              .map((f) => f.copyWith(value: ''))
                              .toList();
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            // Custom fields
            _Label('Attributes', Icons.psychology_outlined),
            const SizedBox(height: 8),
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
                    'No custom attributes yet. Tap a template above to instantly populate traits!',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      height: 1.4,
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
                  child: TextFormField(
                    key: ValueKey('${f.key}_${_fields.length}'),
                    initialValue: f.value?.toString() ?? '',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 14),
                    decoration: InputDecoration(
                      labelText: f.label,
                      labelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.4), width: 0.6),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.4), width: 0.6),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                      filled: true, fillColor: Theme.of(context).colorScheme.surface,
                    ),
                    onChanged: (val) => _fields[i] = f.copyWith(value: val),
                  ),
                );
              }),
            ],
          ),
        ),
      );
  }

  Widget _Label(String text, IconData icon) => Row(children: [
    Icon(icon, size: 14, color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7)),
    SizedBox(width: 6),
    Text(text, style: Theme.of(context).textTheme.labelMedium!.copyWith(
      color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 11, letterSpacing: 0.5)),
  ]);

  InputDecoration _deco(String hint) => InputDecoration(
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
    filled: true, fillColor: Theme.of(context).colorScheme.surface,
  );
}
