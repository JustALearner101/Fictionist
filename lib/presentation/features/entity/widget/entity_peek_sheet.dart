import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fictionist/domain/entity/entity.dart';
import 'package:fictionist/domain/entity/custom_field.dart';
import 'package:fictionist/domain/relationship/relationship_type_registry.dart';
import 'package:fictionist/domain/use_case/relationship/create_relationship_use_case.dart';
import 'package:fictionist/injection.dart';
import 'package:fictionist/presentation/features/relationship/widget/relationship_picker_sheet.dart';
import 'package:fictionist/presentation/features/entity/provider/entity_detail_provider.dart';
import 'package:fictionist/presentation/features/entity/provider/entity_relationships_provider.dart';
import 'package:fictionist/presentation/common/widget/loading_indicator.dart';
import 'package:fictionist/presentation/common/widget/wikilink_text.dart';

/// A peekable bottom sheet showing an entity summary.
///
/// Supports nested peeking: tapping a related entity inside a peek sheet
/// opens another peek sheet on top, up to [maxDepth] layers.
///
/// Usage:
/// ```dart
/// showEntityPeekSheet(context, entityId: 'some-uuid');
/// ```
Future<void> showEntityPeekSheet(
  BuildContext context, {
  required String entityId,
  int currentDepth = 0,
  int maxDepth = 3,
}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (sheetContext) {
      return EntityPeekSheet(
        entityId: entityId,
        depth: currentDepth,
        maxDepth: maxDepth,
      );
    },
  );
}

/// A peek sheet that displays an entity's summary inline,
/// with the ability to open further nested peeks.
class EntityPeekSheet extends ConsumerStatefulWidget {
  final String entityId;
  final int depth;
  final int maxDepth;

  const EntityPeekSheet({
    super.key,
    required this.entityId,
    this.depth = 0,
    this.maxDepth = 3,
  });

  @override
  ConsumerState<EntityPeekSheet> createState() => _EntityPeekSheetState();
}

class _EntityPeekSheetState extends ConsumerState<EntityPeekSheet> {
  @override
  Widget build(BuildContext context) {
    final detailState =
        ref.watch(entityDetailProvider(widget.entityId));

    // Breadcrumb trail for nested peeking
    final breadcrumb = widget.depth > 0
        ? Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Icon(Icons.arrow_back_ios, size: 10,
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
                const SizedBox(width: 4),
                Text(
                  'Depth ${widget.depth + 1}',
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          )
        : null;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.65,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: detailState.when(
        data: (entity) {
          return _buildContent(context, entity, breadcrumb);
        },
        loading: () => const Padding(
          padding: EdgeInsets.all(32),
          child: LoadingIndicator(),
        ),
        error: (err, _) => Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline,
                  color: Theme.of(context).colorScheme.error, size: 32),
              SizedBox(height: 8),
              Text(
                'Failed to load entity',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().slideY(begin: 0.1, duration: 250.ms, curve: Curves.easeOutQuad).fadeIn(duration: 200.ms);
  }

  Widget _buildContent(
    BuildContext context,
    Entity entity,
    Widget? breadcrumb,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar + depth indicator
          Center(
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                if (breadcrumb != null) breadcrumb,
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Entity header
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Color(entity.iconColor).withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color(entity.iconColor),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    entity.name.isNotEmpty
                        ? entity.name[0].toUpperCase()
                        : '?',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Color(entity.iconColor),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entity.name,
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontFamily: Theme.of(context).textTheme.displayLarge?.fontFamily,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          entity.type.label,
                          style: Theme.of(context).textTheme.labelMedium!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.outline,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            entity.status.label,
                            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Description
          if (entity.description != null &&
              entity.description!.trim().isNotEmpty) ...[
            SizedBox(height: 16),
            WikilinkText(
              text: entity.description!,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(height: 1.5),
            ),
          ],

          // Custom Fields (compact chips)
          if (entity.customFields.isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: entity.customFields
                  .map((field) => _buildFieldChip(field))
                  .toList(),
            ),
          ],

          // Related entities (peekable)
          SizedBox(height: 20),
          Text(
            'Connections',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildRelatedEntities(entity),

          // Actions
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Close',
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                icon: const Icon(Icons.link, size: 14),
                label: const Text('Forge Link', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                onPressed: () async {
                  final result = await showModalBottomSheet<CreateRelationshipParams?>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (ctx) => RelationshipPickerSheet(sourceEntity: entity),
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
                      ref.invalidate(entityRelationshipsProvider(widget.entityId));
                      ref.invalidate(entityDetailProvider(widget.entityId));
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
                                    ref.invalidate(entityRelationshipsProvider(widget.entityId));
                                    ref.invalidate(entityDetailProvider(widget.entityId));
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
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Theme.of(context).colorScheme.onSecondary,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton.tonal(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pushNamed('/entities/${entity.id}');
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Open Full Profile', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds a compact chip widget for a custom field.
  Widget _buildFieldChip(CustomField field) {
    final valueStr = field.value?.toString() ?? '';
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            field.label,
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 10,
            ),
          ),
          SizedBox(height: 2),
          Text(
            valueStr.isNotEmpty ? valueStr : '—',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: valueStr.isNotEmpty
                  ? Theme.of(context).colorScheme.onSurface
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedEntities(Entity entity) {
    final relState =
        ref.watch(entityRelationshipsProvider(widget.entityId));

    return relState.when(
      data: (relationships) {
        if (relationships.isEmpty) {
          return Text(
            'No connections yet.',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          );
        }

        final canNest = widget.depth < widget.maxDepth;
        final displayRels = relationships.take(5).toList();

        return Column(
          children: displayRels.map((rel) {
            final isSource = rel.sourceId == entity.id;
            final peerId =
                isSource ? rel.targetId : rel.sourceId;
            final typeDef =
                RelationshipTypeRegistry.getDef(rel.typeKey);
            final label = typeDef != null
                ? (isSource
                    ? typeDef.label
                    : (typeDef.inverseLabel ?? typeDef.label))
                : rel.typeKey;

            return _RelatedEntityTile(
              peerId: peerId,
              label: label,
              canNest: canNest,
              onPeek: () {
                showEntityPeekSheet(
                  context,
                  entityId: peerId,
                  currentDepth: widget.depth + 1,
                  maxDepth: widget.maxDepth,
                );
              },
            );
          }).toList(),
        );
      },
      loading: () => Padding(
        padding: EdgeInsets.all(16),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      error: (err, _) => Text(
        'Could not load connections.',
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// A tile for a related entity within a peek sheet.
///
/// When [canNest] is true, an eye icon allows opening a nested peek.
class _RelatedEntityTile extends ConsumerWidget {
  final String peerId;
  final String label;
  final bool canNest;
  final VoidCallback onPeek;

  const _RelatedEntityTile({
    required this.peerId,
    required this.label,
    required this.canNest,
    required this.onPeek,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailState = ref.watch(entityDetailProvider(peerId));

    return detailState.when(
      data: (peer) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              radius: 14,
              backgroundColor:
                  Color(peer.iconColor).withOpacity(0.15),
              child: Text(
                peer.name.isNotEmpty
                    ? peer.name[0].toUpperCase()
                    : '?',
                style: TextStyle(
                  color: Color(peer.iconColor),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              peer.name,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              label,
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 11,
              ),
            ),
            trailing: canNest
                ? IconButton(
                    icon: Icon(
                      Icons.visibility_outlined,
                      size: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: onPeek,
                    tooltip: 'Peek at ${peer.name}',
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  )
                : Icon(
                    Icons.open_in_new,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            onTap: canNest ? () {
              HapticFeedback.lightImpact();
              onPeek();
            } : null,
          ),
        );
      },
      loading: () => ListTile(
        dense: true,
        leading: SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text('Loading...'),
      ),
      error: (_, __) => ListTile(
        dense: true,
        leading: Icon(Icons.error_outline,
            size: 16, color: Theme.of(context).colorScheme.error),
        title: Text('Error loading'),
      ),
    );
  }
}
