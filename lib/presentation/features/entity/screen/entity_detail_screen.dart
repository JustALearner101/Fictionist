import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../domain/entity/custom_field.dart';
import '../../../../domain/entity/entity.dart';
import '../../../../domain/entity/entity_status.dart';
import '../../../../domain/relationship/relationship.dart';
import '../../../../domain/relationship/relationship_type_registry.dart';
import '../../../../domain/use_case/entity/delete_entity_use_case.dart';
import '../../../../domain/use_case/entity/update_entity_use_case.dart';
import '../../../../domain/use_case/relationship/create_relationship_use_case.dart';
import '../../../../domain/use_case/relationship/delete_relationship_use_case.dart';
import '../../../../domain/version/entity_version.dart';
import '../../../../injection.dart';
import '../../../common/widget/confirm_dialog.dart';
import '../../../common/widget/empty_state.dart';
import '../../../common/widget/error_display.dart';
import '../../../common/widget/loading_indicator.dart';
import '../provider/entity_detail_provider.dart';
import '../provider/entity_list_provider.dart';
import '../../relationship/widget/relationship_picker_sheet.dart';
import '../provider/entity_references_provider.dart';
import '../provider/entity_relationships_provider.dart';
import '../provider/entity_version_history_provider.dart';
import '../../timeline/provider/timeline_provider.dart';
import '../widget/entity_peek_sheet.dart';
import '../../../common/widget/wikilink_text.dart';

class EntityDetailScreen extends ConsumerStatefulWidget {
  final String entityId;
  const EntityDetailScreen({super.key, required this.entityId});

  @override
  ConsumerState<EntityDetailScreen> createState() =>
      _EntityDetailScreenState();
}

class _EntityDetailScreenState extends ConsumerState<EntityDetailScreen> {
  Future<void> _deleteEntity(Entity entity) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => const ConfirmDialog(
        title: 'Banish Entity',
        content:
            'Are you sure you want to soft-delete this entity? '
            'All of its relationships will be deleted as well.',
        confirmLabel: 'Banish',
        isDestructive: true,
      ),
    );
    if (confirm == true) {
      final result = await getIt<DeleteEntityUseCase>()(entity.id);
      result.fold(
        (f) => _snack(f.message, Theme.of(context).colorScheme.error),
        (_) { ref.invalidate(entityListProvider); context.go('/entities'); },
      );
    }
  }

  void _snack(String msg, Color c) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: c),
    );
  }

  void _showVersionHistory(Entity currentEntity) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Consumer(
        builder: (_, ref, __) {
          final state =
              ref.watch(entityVersionHistoryProvider(widget.entityId));
          return Container(
            padding: EdgeInsets.all(16),
            height: MediaQuery.of(context).size.height * 0.55,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Chronicle Version History',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontFamily: Theme.of(context).textTheme.displayLarge?.fontFamily,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: state.when(
                    data: (versions) => versions.isEmpty
                        ? const EmptyState(
                            title: 'No Versions',
                            message: 'No older versions recorded.',
                            icon: Icons.history,
                          )
                        : ListView.builder(
                            itemCount: versions.length,
                            itemBuilder: (_, i) {
                              final v = versions[i];
                              final current = i == 0;
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: current
                                      ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)
                                      : Theme.of(context).colorScheme.outline,
                                  child: Icon(
                                    current ? Icons.star : Icons.history,
                                    color: current
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context).colorScheme.onSurfaceVariant,
                                    size: 18,
                                  ),
                                ),
                                title: Text(
                                  v.changeNote ?? 'Version ${versions.length - i}',
                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: current ? FontWeight.bold : FontWeight.normal,
                                    fontSize: 13,
                                  ),
                                ),
                                subtitle: Text(
                                  '${v.changedAt.toLocal().toString().substring(0, 19)}${current ? "" : " · Tap to view diff"}',
                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 11,
                                  ),
                                ),
                                trailing: !current ? TextButton(
                                  onPressed: () => _restoreVersion(v, currentEntity),
                                  child: const Text('Restore'),
                                ) : null,
                                onTap: current ? null : () => _showDiffDialog(currentEntity, v),
                              );
                            },
                          ),
                    loading: () => LoadingIndicator(),
                    error: (e, _) => Center(child: Text('Error: $e')),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<TextSpan> _generateDiffSpans(BuildContext context, String current, String snapshot) {
    final currentWords = current.split(RegExp(r'\s+'));
    final snapshotWords = snapshot.split(RegExp(r'\s+'));
    final spans = <TextSpan>[];
    final currentSet = currentWords.toSet();
    final snapshotSet = snapshotWords.toSet();

    for (final word in snapshotWords) {
      if (currentSet.contains(word)) {
        spans.add(TextSpan(text: '$word ', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)));
      } else {
        spans.add(TextSpan(
          text: '$word ',
          style: TextStyle(
            color: Theme.of(context).colorScheme.error,
            decoration: TextDecoration.lineThrough,
            backgroundColor: Theme.of(context).colorScheme.error.withOpacity(0.1),
          ),
        ));
      }
    }
    
    spans.add(const TextSpan(text: '\n\n[Additions]:\n', style: TextStyle(fontWeight: FontWeight.bold)));
    for (final word in currentWords) {
      if (!snapshotSet.contains(word)) {
        spans.add(TextSpan(
          text: '$word ',
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            decoration: TextDecoration.underline,
            backgroundColor: Theme.of(context).colorScheme.tertiary.withOpacity(0.1),
          ),
        ));
      }
    }
    
    return spans;
  }

  void _showDiffDialog(Entity currentEntity, EntityVersion version) {
    Entity? snapshotEntity;
    try {
      final json = jsonDecode(version.snapshotJson) as Map<String, dynamic>;
      snapshotEntity = Entity.fromJson(json);
    } catch (_) {}

    final snapshot = snapshotEntity;
    if (snapshot == null) return;

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text(
          'Compare Changes',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontFamily: Theme.of(context).textTheme.displayLarge?.fontFamily,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Change Note: ${version.changeNote ?? "Snapshot"}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                    ),
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(height: 1.5),
                      children: _generateDiffSpans(
                        context,
                        currentEntity.description ?? '',
                        snapshot.description ?? '',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Close', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _restoreVersion(version, currentEntity);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.surface,
            ),
            child: const Text('Restore Snapshot', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Future<void> _restoreVersion(EntityVersion ver, Entity current) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => ConfirmDialog(
        title: 'Restore Snapshot',
        content: 'Restore to state from ${ver.changedAt.toLocal()}?',
      ),
    );
    if (confirm != true) return;
    try {
      final json = jsonDecode(ver.snapshotJson) as Map<String, dynamic>;
      final restored = Entity.fromJson(json).copyWith(updatedAt: DateTime.now());
      final res = await getIt<UpdateEntityUseCase>()(UpdateEntityParams(
        entity: restored,
        changeNote: 'Restored from snapshot of ${ver.changedAt.toLocal()}',
      ));
      res.fold(
        (f) => _snack('Failed: ${f.message}', Theme.of(context).colorScheme.error),
        (_) {
          ref.invalidate(entityDetailProvider(widget.entityId));
          ref.invalidate(entityVersionHistoryProvider(widget.entityId));
          Navigator.of(context).pop();
          _snack('Snapshot restored.', Theme.of(context).colorScheme.tertiary);
        },
      );
    } catch (e) {
      _snack('Error: $e', Theme.of(context).colorScheme.error);
    }
  }

  Future<void> _addRelationship(Entity source) async {
    final result = await showModalBottomSheet<CreateRelationshipParams?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => RelationshipPickerSheet(sourceEntity: source),
    );
    if (result == null) return;
    final cr = getIt<CreateRelationshipUseCase>();
    final res = await cr(result);
    res.fold(
      (f) => _snack(f.message, Theme.of(context).colorScheme.error),
      (cr) {
        ref.invalidate(entityRelationshipsProvider(widget.entityId));
        if (cr.reciprocalSuggestionTypeKey != null) {
          final def = RelationshipTypeRegistry.getDef(cr.reciprocalSuggestionTypeKey!);
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
                    typeKey: cr.reciprocalSuggestionTypeKey!,
                    description: 'Reciprocal link created automatically',
                  );
                  final recRes = await getIt<CreateRelationshipUseCase>()(recParams);
                  recRes.fold(
                    (f) => _snack(f.message, Theme.of(context).colorScheme.error),
                    (_) {
                      ref.invalidate(entityRelationshipsProvider(widget.entityId));
                      _snack('Reciprocal link successfully forged.', Theme.of(context).colorScheme.tertiary);
                    },
                  );
                },
              ),
            ),
          );
        } else {
          _snack('Connection forged.', Theme.of(context).colorScheme.tertiary);
        }
      },
    );
  }

  Future<void> _deleteRelationship(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => ConfirmDialog(
        title: 'Break Connection',
        content: 'Sever this connection?',
        confirmLabel: 'Break',
        isDestructive: true,
      ),
    );
    if (confirm != true) return;
    final res = await getIt<DeleteRelationshipUseCase>()(id);
    res.fold(
      (f) => _snack(f.message, Theme.of(context).colorScheme.error),
      (_) {
        ref.invalidate(entityRelationshipsProvider(widget.entityId));
        _snack('Connection severed.', Colors.amber);
      },
    );
  }

  // ── Build ──

  @override
  Widget build(BuildContext context) {
    final detail = ref.watch(entityDetailProvider(widget.entityId));
    final relState = ref.watch(entityRelationshipsProvider(widget.entityId));
    final allEntitiesState = ref.watch(entityListProvider);

    return detail.when(
      data: (entity) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: CustomScrollView(
          slivers: [
            // ── App bar ──
            _SliverAppBar(entity: entity, onDelete: () => _deleteEntity(entity),
              onHistory: () => _showVersionHistory(entity)),
            // ── Hero card ──
            SliverToBoxAdapter(child: _HeroCard(entity: entity)),
            // ── Description ──
            if (entity.description != null && entity.description!.trim().isNotEmpty)
              SliverToBoxAdapter(child: _SectionCard(
                title: 'Codex Log',
                icon: Icons.auto_stories,
                child: WikilinkText(text: entity.description!,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(height: 1.6, fontSize: 14)),
              )),
            // ── Attributes ──
            if (entity.customFields.isNotEmpty)
              SliverToBoxAdapter(child: _SectionCard(
                title: 'Attributes & Traits',
                icon: Icons.psychology_outlined,
                child: _AttributesGrid(fields: entity.customFields),
              )),
            // ── Connections ──
            SliverToBoxAdapter(child: _SectionCard(
              title: 'Connections & Bonds',
              icon: Icons.hub_outlined,
              trailing: IconButton(
                icon: Icon(Icons.add_link, color: Theme.of(context).colorScheme.primary, size: 20),
                onPressed: () => _addRelationship(entity),
              ),
              child: _RelationshipsList(
                relState: relState,
                entity: entity,
                allEntitiesState: allEntitiesState,
                onDeleteRel: _deleteRelationship,
                onPeek: (peerId) => showEntityPeekSheet(context, entityId: peerId),
                onNavigate: (peerId) => context.push('/entities/$peerId'),
              ),
            )),
            // ── Timeline ──
            SliverToBoxAdapter(child: _SectionCard(
              title: 'Chronicle Milestones',
              icon: Icons.history,
              child: _TimelineStrip(entityId: widget.entityId),
            )),
            // ── Appears In ──
            SliverToBoxAdapter(child: _AppearsInSection(entityId: widget.entityId)),
            // Bottom padding
            SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
      loading: () => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: LoadingIndicator(),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: ErrorDisplay(message: e.toString(),
          onRetry: () => ref.refresh(entityDetailProvider(widget.entityId))),
      ),
    );
  }
}

// ── Sub-widgets ──

class _SliverAppBar extends StatelessWidget {
  final Entity entity;
  final VoidCallback onDelete;
  final VoidCallback onHistory;
  _SliverAppBar({required this.entity, required this.onDelete, required this.onHistory});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      pinned: true,
      expandedHeight: 80,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: Theme.of(context).colorScheme.onSurface, size: 18),
        onPressed: () => context.pop(),
      ),
      title: Text(entity.name,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
          fontFamily: Theme.of(context).textTheme.displayLarge?.fontFamily, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topCenter,
              radius: 1.8,
              colors: [
                Color(entity.iconColor).withOpacity(0.12),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(icon: Icon(Icons.edit_outlined, size: 20, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => context.push('/entities/${entity.id}/edit')),
        IconButton(icon: Icon(Icons.history, size: 20, color: Theme.of(context).colorScheme.onSurfaceVariant),
          onPressed: onHistory),
        IconButton(icon: Icon(Icons.delete_outline, size: 20, color: Theme.of(context).colorScheme.error),
          onPressed: onDelete),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  final Entity entity;
  const _HeroCard({required this.entity});

  @override
  Widget build(BuildContext context) {
    final color = Color(entity.iconColor);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Hero(
        tag: 'entity-card-${entity.id}',
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color.withValues(alpha: 0.08), Colors.transparent],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withValues(alpha: 0.25), width: 0.8),
            ),
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                // Avatar
                Hero(
                  tag: 'entity-avatar-${entity.id}',
                  child: Material(
                    type: MaterialType.transparency,
                    child: Container(
                      width: 56, height: 56,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(color: color.withValues(alpha: 0.6), width: 1.5),
                        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.1), blurRadius: 12)],
                      ),
                      child: Center(
                        child: Text(
                          entity.name.isNotEmpty ? entity.name[0].toUpperCase() : '?',
                          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                            color: color, fontWeight: FontWeight.bold, fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _Badge(label: entity.status.label.toUpperCase(),
                            color: _statusColor(context, entity.status)),
                          SizedBox(width: 8),
                          _Badge(label: entity.type.label.toUpperCase(),
                            color: Theme.of(context).colorScheme.primary),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Last updated ${_timeAgo(entity.updatedAt)}',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _statusColor(BuildContext context, EntityStatus s) {
    switch (s) {
      case EntityStatus.canon: return Theme.of(context).colorScheme.tertiary;
      case EntityStatus.draft: return Theme.of(context).colorScheme.primary;
      case EntityStatus.archived: return Theme.of(context).colorScheme.onSurfaceVariant;
      case EntityStatus.deprecated: return Theme.of(context).colorScheme.error;
    }
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'just now';
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 0.5),
      ),
      child: Text(label,
        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700,
          color: color, letterSpacing: 0.6),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final Widget? trailing;
  _SectionCard({required this.title, required this.icon,
    required this.child, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 6, 16, 6),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.4), width: 0.5),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7)),
                SizedBox(width: 8),
                Text(title,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontFamily: Theme.of(context).textTheme.displayLarge?.fontFamily, color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold, fontSize: 15,
                  ),
                ),
                const Spacer(),
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

class _AttributesGrid extends StatelessWidget {
  final List<CustomField> fields;
  const _AttributesGrid({required this.fields});

  @override
  Widget build(BuildContext context) {
    final List<Widget> rows = [];
    List<CustomField> rowBuffer = [];

    void flushBuffer() {
      if (rowBuffer.isEmpty) return;
      if (rowBuffer.length == 1) {
        rows.add(_buildCard(context, rowBuffer[0], isFullWidth: true));
      } else {
        rows.add(
          Row(
            children: [
              Expanded(child: _buildCard(context, rowBuffer[0], isFullWidth: false)),
              const SizedBox(width: 10),
              Expanded(child: _buildCard(context, rowBuffer[1], isFullWidth: false)),
            ],
          ),
        );
      }
      rowBuffer.clear();
    }

    for (final f in fields) {
      final val = f.value?.toString() ?? '';
      if (val.length > 20) {
        flushBuffer();
        rows.add(_buildCard(context, f, isFullWidth: true));
      } else {
        rowBuffer.add(f);
        if (rowBuffer.length == 2) {
          flushBuffer();
        }
      }
    }
    flushBuffer();

    return Column(
      children: rows.asMap().entries.map((e) {
        final idx = e.key;
        final w = e.value;
        return Padding(
          padding: EdgeInsets.only(bottom: idx < rows.length - 1 ? 10 : 0),
          child: w,
        );
      }).toList(),
    );
  }

  Widget _buildCard(BuildContext context, CustomField f, {required bool isFullWidth}) {
    final val = f.value?.toString() ?? '';
    final accent = Theme.of(context).colorScheme.primary.withOpacity(0.06);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: val.isNotEmpty ? accent : Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: val.isNotEmpty
              ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
              : Theme.of(context).colorScheme.outline.withOpacity(0.35),
          width: 0.7,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            f.label.toUpperCase(),
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            val.isNotEmpty ? val : '—',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: val.isNotEmpty
                  ? Theme.of(context).colorScheme.onSurface
                  : Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.4),
              fontSize: 13.5,
              fontWeight: val.isNotEmpty ? FontWeight.w600 : FontWeight.w400,
            ),
            maxLines: isFullWidth ? 3 : 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _RelationshipsList extends StatelessWidget {
  final AsyncValue<List<Relationship>> relState;
  final Entity entity;
  final AsyncValue<List<Entity>> allEntitiesState;
  final void Function(String) onDeleteRel;
  final void Function(String) onPeek;
  final void Function(String) onNavigate;

  const _RelationshipsList({required this.relState, required this.entity,
    required this.allEntitiesState, required this.onDeleteRel,
    required this.onPeek, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return relState.when(
      data: (rels) {
        final outgoing = <Relationship>[];
        final backlinks = <Relationship>[];
        for (final r in rels) {
          final def = RelationshipTypeRegistry.getDef(r.typeKey);
          if (r.sourceId == entity.id || (def?.isBidirectional ?? false)) {
            outgoing.add(r);
          } else {
            backlinks.add(r);
          }
        }

        return allEntitiesState.when(
          data: (all) {
            return Column(
              children: [
                if (outgoing.isEmpty)
                  _emptyBox(context, 'No connections yet.')
                else
                  ...outgoing.map((r) {
                    final isSource = r.sourceId == entity.id;
                    final peerId = isSource ? r.targetId : r.sourceId;
                    final peer = all.where((e) => e.id == peerId).firstOrNull;
                    if (peer == null) return const SizedBox.shrink();
                    final def = RelationshipTypeRegistry.getDef(r.typeKey);
                    final label = isSource ? (def?.label ?? r.typeKey)
                        : (def?.inverseLabel ?? def?.label ?? r.typeKey);
                    return _ConnectionTile(
                      peer: peer, label: label,
                      isEditable: true,
                      onDelete: () => onDeleteRel(r.id),
                      onPeek: () => onPeek(peer.id),
                      onNavigate: () => onNavigate(peer.id),
                    );
                  }),
                if (backlinks.isNotEmpty) ...[
                  SizedBox(height: 16),
                  Text('Backlinks',
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 11, letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...backlinks.map((r) {
                    final peer = all.where((e) => e.id == r.sourceId).firstOrNull;
                    if (peer == null) return const SizedBox.shrink();
                    final def = RelationshipTypeRegistry.getDef(r.typeKey);
                    return _ConnectionTile(
                      peer: peer, label: def?.label ?? r.typeKey,
                      isEditable: false,
                      onPeek: () => onPeek(peer.id),
                      onNavigate: () => onNavigate(peer.id),
                    );
                  }),
                ],
              ],
            );
          },
          loading: () => LoadingIndicator(),
          error: (e, _) => Text('Error: $e', style: TextStyle(color: Theme.of(context).colorScheme.error)),
        );
      },
      loading: () => LoadingIndicator(),
      error: (e, _) => Text('Error: $e', style: TextStyle(color: Theme.of(context).colorScheme.error)),
    );
  }

  Widget _emptyBox(BuildContext context, String msg) {
    return Container(
      width: double.infinity, padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(msg, textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 13,
        ),
      ),
    );
  }
}

class _ConnectionTile extends StatelessWidget {
  final Entity peer;
  final String label;
  final bool isEditable;
  final VoidCallback? onDelete;
  final VoidCallback onPeek;
  final VoidCallback onNavigate;

  _ConnectionTile({required this.peer, required this.label,
    required this.isEditable, this.onDelete, required this.onPeek,
    required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final color = Color(peer.iconColor);
    return Padding(
      padding: EdgeInsets.only(bottom: 6),
      child: Material(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onNavigate,
          onLongPress: onPeek,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: color.withValues(alpha: 0.15),
                  child: Text(peer.name[0].toUpperCase(),
                    style: TextStyle(color: color, fontSize: 12,
                        fontWeight: FontWeight.bold)),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(peer.name,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600, fontSize: 13,
                        ),
                      ),
                      Text(label.toUpperCase(),
                        style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: Theme.of(context).colorScheme.primary, fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.visibility_outlined, size: 16,
                    color: Theme.of(context).colorScheme.primary),
                  onPressed: onPeek, padding: EdgeInsets.zero,
                  constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                ),
                if (isEditable && onDelete != null)
                  IconButton(
                    icon: Icon(Icons.link_off, size: 16,
                      color: Theme.of(context).colorScheme.error),
                    onPressed: onDelete, padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TimelineStrip extends ConsumerWidget {
  final String entityId;
  _TimelineStrip({required this.entityId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(timelineListProvider(entityId: entityId)).when(
      data: (entries) {
        if (entries.isEmpty) {
          return Container(
            width: double.infinity, padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text('No chronicle events yet.', textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 13,
              ),
            ),
          );
        }
        return Column(
          children: entries.asMap().entries.map((e) {
            final i = e.key;
            final entry = e.value;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 8, height: 8,
                      decoration: BoxDecoration(
                        color: i == 0 ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outline,
                        shape: BoxShape.circle,
                      ),
                    ),
                    if (i < entries.length - 1)
                      Container(width: 1.5, height: 40, color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5)),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (entry.dateLabel != null && entry.dateLabel!.isNotEmpty)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            margin: EdgeInsets.only(bottom: 4),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(entry.dateLabel!,
                              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                color: Theme.of(context).colorScheme.primary, fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        Text(entry.title,
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontFamily: Theme.of(context).textTheme.displayLarge?.fontFamily, fontWeight: FontWeight.w600,
                            fontSize: 13, color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        if (entry.description != null && entry.description!.isNotEmpty) ...[
                          SizedBox(height: 2),
                          Text(entry.description!,
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12,
                            ),
                            maxLines: 2, overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        );
      },
      loading: () => LoadingIndicator(),
      error: (e, _) => Text('Error: $e'),
    );
  }
}

// ─── Appears In Section ───────────────────────────────────────────────────

class _AppearsInSection extends ConsumerWidget {
  final String entityId;
  const _AppearsInSection({required this.entityId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final refsAsync = ref.watch(entityReferencesProvider(entityId));
    final theme = Theme.of(context);

    return refsAsync.when(
      data: (refs) {
        final hasData = refs.chapters.isNotEmpty ||
            refs.timelineEntries.isNotEmpty ||
            refs.relationships.isNotEmpty;
        if (!hasData) return const SizedBox.shrink();

        return _SectionCard(
          title: 'Appears In',
          icon: Icons.menu_book_outlined,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Mention stats ──────────────────────────────
              if (refs.totalMentions > 0)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      _MiniStat(
                          icon: Icons.format_quote,
                          label: '${refs.totalMentions} mentions',
                          color: theme.colorScheme.primary),
                      if (refs.dialogueMentions > 0) ...[
                        const SizedBox(width: 12),
                        _MiniStat(
                            icon: Icons.chat_bubble_outline,
                            label: '${refs.dialogueMentions} dialogue',
                            color: const Color(0xFFFBBF24)),
                      ],
                      if (refs.narrationMentions > 0) ...[
                        const SizedBox(width: 12),
                        _MiniStat(
                            icon: Icons.article_outlined,
                            label: '${refs.narrationMentions} narration',
                            color: const Color(0xFF60A5FA)),
                      ],
                    ],
                  ),
                ),
              // ── Chapters ───────────────────────────────────
              if (refs.chapters.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text('Chapters',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        letterSpacing: 1,
                      )),
                ),
                ...refs.chapters.take(8).map((ch) => _ReferenceTile(
                      icon: Icons.article_outlined,
                      title: ch.chapterTitle,
                      subtitle: '${ch.mentionCount} mention${ch.mentionCount == 1 ? '' : 's'}',
                      onTap: () => context.push('/manuscript/write/${ch.chapterId}'),
                    )),
                if (refs.chapters.length > 8)
                  Padding(
                    padding: const EdgeInsets.only(left: 40, top: 2),
                    child: Text('+${refs.chapters.length - 8} more chapters',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
                        )),
                  ),
              ],
              // ── Timeline ───────────────────────────────────
              if (refs.timelineEntries.isNotEmpty) ...[
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text('Timeline',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        letterSpacing: 1,
                      )),
                ),
                ...refs.timelineEntries.map((te) => _ReferenceTile(
                      icon: Icons.history,
                      title: te.entryTitle,
                      subtitle: te.dateLabel ?? '',
                      onTap: () {},
                    )),
              ],
              // ── Relationships ──────────────────────────────
              if (refs.relationships.isNotEmpty) ...[
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text('Relationships',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        letterSpacing: 1,
                      )),
                ),
                ...refs.relationships.take(5).map((rel) => _ReferenceTile(
                      icon: Icons.hub_outlined,
                      title: rel.typeKey,
                      subtitle: 'Connected entity',
                      onTap: () => context.push('/entities/${rel.otherEntityId}'),
                    )),
              ],
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _MiniStat({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 12, color: color),
      const SizedBox(width: 4),
      Text(label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: color,
                fontSize: 11,
              )),
    ]);
  }
}

class _ReferenceTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _ReferenceTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(icon, size: 14,
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  if (subtitle.isNotEmpty)
                    Text(subtitle,
                        style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 10)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, size: 14,
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.3)),
          ],
        ),
      ),
    );
  }
}
