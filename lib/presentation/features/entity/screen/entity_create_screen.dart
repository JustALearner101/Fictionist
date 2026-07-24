import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../domain/entity/custom_field.dart';
import '../../../../domain/entity/entity_status.dart';
import '../../../../domain/entity/entity_type.dart';
import '../../../../domain/use_case/entity/create_entity_use_case.dart';
import '../../../../data/repository/template_repository_impl.dart';
import '../../../../injection.dart';
import '../../name_generator/widget/name_generator_sheet.dart';
import '../../project/provider/active_project_provider.dart';
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
      CustomField(id: 'nob_title', key: 'title', label: 'Title / Rank', fieldType: 'short_text', value: 'Lord'),
      CustomField(id: 'nob_house', key: 'house', label: 'House / Allegiance', fieldType: 'short_text', value: ''),
      CustomField(id: 'nob_lin', key: 'lineage', label: 'Lineage / Dynastic Line', fieldType: 'short_text', value: ''),
      CustomField(id: 'nob_sig', key: 'sigil', label: 'House Sigil / Arms', fieldType: 'short_text', value: ''),
    ],
    'Settlement / City': [
      CustomField(id: 'set_pop', key: 'population', label: 'Population size', fieldType: 'short_text', value: ''),
      CustomField(id: 'set_rul', key: 'ruler', label: 'Ruling Lord / Council', fieldType: 'short_text', value: ''),
      CustomField(id: 'set_clim', key: 'climate', label: 'Regional Climate', fieldType: 'short_text', value: ''),
      CustomField(id: 'set_def', key: 'defense', label: 'Defenses / Fortifications', fieldType: 'short_text', value: ''),
    ],
    'Military Order': [
      CustomField(id: 'mil_str', key: 'strength', label: 'Active Troop Strength', fieldType: 'short_text', value: ''),
      CustomField(id: 'mil_cmd', key: 'commander', label: 'Grand Master / Commander', fieldType: 'short_text', value: ''),
      CustomField(id: 'mil_hq', key: 'headquarters', label: 'Primary Fortress / HQ', fieldType: 'short_text', value: ''),
      CustomField(id: 'mil_motto', key: 'motto', label: 'Order Motto / Creed', fieldType: 'short_text', value: ''),
    ],
    'Spiritual Order': [
      CustomField(id: 'spi_deity', key: 'deity', label: 'Patron Deity / Entity', fieldType: 'short_text', value: ''),
      CustomField(id: 'spi_hq', key: 'hq', label: 'Holy Site / Temple City', fieldType: 'short_text', value: ''),
      CustomField(id: 'spi_inf', key: 'influence', label: 'Regional Influence', fieldType: 'short_text', value: ''),
      CustomField(id: 'spi_sac', key: 'sacred_object', label: 'Sacred Relic / Artifact', fieldType: 'short_text', value: ''),
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

  List<CustomField> _getFallbackFields(EntityType type) {
    switch (type) {
      case EntityType.character:
        return [
          CustomField(id: 'char_age', key: 'age', label: 'Age', fieldType: 'short_text', value: ''),
          CustomField(id: 'char_align', key: 'alignment', label: 'Alignment', fieldType: 'short_text', value: ''),
          CustomField(id: 'char_occ', key: 'occupation', label: 'Occupation/Role', fieldType: 'short_text', value: ''),
          CustomField(id: 'char_back', key: 'backstory', label: 'Backstory Snippet', fieldType: 'long_text', value: ''),
        ];
      case EntityType.faction:
        return [
          CustomField(id: 'fac_ldr', key: 'leader', label: 'Leader', fieldType: 'short_text', value: ''),
          CustomField(id: 'fac_hq', key: 'headquarters', label: 'Headquarters', fieldType: 'short_text', value: ''),
          CustomField(id: 'fac_inf', key: 'influence', label: 'Influence Level', fieldType: 'short_text', value: ''),
          CustomField(id: 'fac_crd', key: 'creed', label: 'Motto/Creed', fieldType: 'short_text', value: ''),
        ];
      case EntityType.raceCulture:
        return [
          CustomField(id: 'race_aesthetic', key: 'aesthetic', label: 'Aesthetic Influences', fieldType: 'short_text', value: ''),
          CustomField(id: 'race_lifespan', key: 'lifespan', label: 'Lifespan', fieldType: 'short_text', value: ''),
          CustomField(id: 'race_physical', key: 'physical_traits', label: 'Physical Traits', fieldType: 'long_text', value: ''),
          CustomField(id: 'race_values', key: 'cultural_values', label: 'Cultural Values', fieldType: 'long_text', value: ''),
        ];
      case EntityType.location:
        return [
          CustomField(id: 'loc_climate', key: 'climate', label: 'Climate', fieldType: 'short_text', value: ''),
          CustomField(id: 'loc_terrain', key: 'terrain', label: 'Terrain', fieldType: 'short_text', value: ''),
          CustomField(id: 'loc_pop', key: 'population', label: 'Population', fieldType: 'short_text', value: ''),
          CustomField(id: 'loc_safety', key: 'safety', label: 'Safety Level', fieldType: 'short_text', value: ''),
        ];
      case EntityType.powerMagicSystem:
        return [
          CustomField(id: 'mag_limit', key: 'limitations', label: 'Rules of Limitation', fieldType: 'long_text', value: ''),
          CustomField(id: 'mag_src', key: 'source', label: 'Source of Power', fieldType: 'short_text', value: ''),
          CustomField(id: 'mag_cost', key: 'cost', label: 'Cost of Usage', fieldType: 'long_text', value: ''),
        ];
      case EntityType.itemArtifact:
        return [
          CustomField(id: 'item_mat', key: 'material', label: 'Material', fieldType: 'short_text', value: ''),
          CustomField(id: 'item_rar', key: 'rarity', label: 'Rarity', fieldType: 'short_text', value: ''),
          CustomField(id: 'item_pwr', key: 'powers', label: 'Magical Properties', fieldType: 'long_text', value: ''),
          CustomField(id: 'item_cr', key: 'creator', label: 'Creator', fieldType: 'short_text', value: ''),
        ];
      case EntityType.event:
        return [
          CustomField(id: 'evt_sig', key: 'significance', label: 'Significance', fieldType: 'long_text', value: ''),
          CustomField(id: 'evt_figs', key: 'figures', label: 'Key Figures', fieldType: 'short_text', value: ''),
          CustomField(id: 'evt_out', key: 'outcome', label: 'Outcome', fieldType: 'long_text', value: ''),
        ];
      case EntityType.conceptGlossary:
        return [
          CustomField(id: 'lore_era', key: 'era', label: 'Historical Era', fieldType: 'short_text', value: ''),
          CustomField(id: 'lore_rel', key: 'reliability', label: 'Reliability', fieldType: 'short_text', value: ''),
          CustomField(id: 'lore_orig', key: 'origin', label: 'Origin', fieldType: 'short_text', value: ''),
        ];
    }
  }

  Future<void> _loadTemplate(EntityType type) async {
    final res = await getIt<TemplateRepositoryImpl>().getTemplatesByType(type);
    res.fold((_) {
      if (mounted) setState(() => _fields = _getFallbackFields(type));
    }, (templates) {
      if (mounted) {
        setState(() {
          if (templates.isNotEmpty) {
            _fields = templates.first.customFieldsSchema
                .map((f) => f.copyWith(value: ''))
                .toList();
          } else {
            _fields = _getFallbackFields(type);
          }
        });
      }
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
    final projectId = ref.read(activeProjectProvider).valueOrNull?.id;
    final res = await getIt<CreateEntityUseCase>()(CreateEntityParams(
      name: _nameCtrl.text.trim(),
      type: _type,
      status: _status,
      description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
      customFields: _fields,
      iconColor: _color,
      projectId: projectId,
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
            fontFamily: Theme.of(context).textTheme.displayLarge?.fontFamily, fontWeight: FontWeight.bold,
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
                    'No custom attributes yet. Tap a template above or add one below to instantly populate traits!',
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
                  child: Row(
                    children: [
                      Expanded(
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
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                            filled: true, fillColor: Theme.of(context).colorScheme.surface,
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
            const SizedBox(height: 12),
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
