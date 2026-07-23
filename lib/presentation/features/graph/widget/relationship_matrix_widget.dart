import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fictionist/domain/entity/entity.dart';
import 'package:fictionist/domain/relationship/relationship.dart';
import 'package:fictionist/domain/relationship/relationship_type_registry.dart';
import 'package:fictionist/presentation/common/widget/confirm_dialog.dart';
import 'package:fictionist/presentation/features/entity/widget/entity_peek_sheet.dart';

class RelationshipMatrixWidget extends StatelessWidget {
  final List<Entity> characters;
  final List<Relationship> relationships;
  final void Function(Entity source, Entity target) onForgeConnection;
  final void Function(Relationship rel) onDeleteConnection;

  const RelationshipMatrixWidget({
    super.key,
    required this.characters,
    required this.relationships,
    required this.onForgeConnection,
    required this.onDeleteConnection,
  });

  void _showCellDetails(
    BuildContext context,
    Entity charA,
    Entity charB,
    Relationship rel,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final def = RelationshipTypeRegistry.getDef(rel.typeKey);
        final label = rel.sourceId == charA.id
            ? (def?.label ?? rel.typeKey)
            : (def?.inverseLabel ?? def?.label ?? rel.typeKey);

        return Container(
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
              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Connection: ${charA.name} & ${charB.name}',
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                            fontFamily: Theme.of(context).textTheme.displayLarge?.fontFamily,
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Relationship info
              Row(
                children: [
                  Icon(Icons.link, color: Theme.of(context).colorScheme.primary, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Bond: ${label.toUpperCase()} (Weight: ${rel.weight}/10)',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                  ),
                ],
              ),
              if (rel.description != null && rel.description!.trim().isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  'Context: "${rel.description}"',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ],
              const SizedBox(height: 20),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.person_outline, size: 14),
                      label: Text('Peek ${charA.name}'),
                      onPressed: () {
                        Navigator.pop(ctx);
                        showEntityPeekSheet(context, entityId: charA.id);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.person_outline, size: 14),
                      label: Text('Peek ${charB.name}'),
                      onPressed: () {
                        Navigator.pop(ctx);
                        showEntityPeekSheet(context, entityId: charB.id);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  icon: const Icon(Icons.link_off, size: 14),
                  label: const Text('Sever Connection', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  onPressed: () async {
                    Navigator.pop(ctx);
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (c) => ConfirmDialog(
                        title: 'Break Connection',
                        content: 'Sever the connection "${label}" between ${charA.name} and ${charB.name}?',
                        confirmLabel: 'Break',
                        isDestructive: true,
                      ),
                    );
                    if (confirm == true) {
                      onDeleteConnection(rel);
                    }
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.error,
                    foregroundColor: Theme.of(context).colorScheme.onError,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (characters.isEmpty) {
      return Center(
        child: Text(
          'No characters exist to display in the matrix.',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      );
    }

    final double firstColWidth = 130.0;
    final double colWidth = 100.0;
    final double rowHeight = 50.0;

    // Header rows
    final headerRow = TableRow(
      children: [
        // Top-left corner cell
        Container(
          height: rowHeight,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.3), width: 0.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.grid_on_outlined, size: 14, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 4),
              Text(
                'MATRIX',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).colorScheme.primary,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),
        // Column Headers
        ...characters.map((char) {
          final color = Color(char.iconColor);
          return Container(
            height: rowHeight,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.3), width: 0.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 8,
                  backgroundColor: color.withOpacity(0.15),
                  child: Text(
                    char.name.isNotEmpty ? char.name[0].toUpperCase() : '?',
                    style: TextStyle(color: color, fontSize: 7, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    char.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );

    final tableRows = <TableRow>[headerRow];

    for (int i = 0; i < characters.length; i++) {
      final charA = characters[i];
      final colorA = Color(charA.iconColor);

      final rowCells = <Widget>[];

      // Row Header
      rowCells.add(
        Container(
          height: rowHeight,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.3), width: 0.5),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 10,
                backgroundColor: colorA.withOpacity(0.15),
                child: Text(
                  charA.name.isNotEmpty ? charA.name[0].toUpperCase() : '?',
                  style: TextStyle(color: colorA, fontSize: 9, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  charA.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

      // Value cells
      for (int j = 0; j < characters.length; j++) {
        final charB = characters[j];

        if (i == j) {
          // Diagonal (same character)
          rowCells.add(
            Container(
              height: rowHeight,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.08),
                border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.3), width: 0.5),
              ),
            ),
          );
        } else {
          // Find active relationship between A and B
          final rel = relationships.where((r) {
            return (r.sourceId == charA.id && r.targetId == charB.id) ||
                (r.sourceId == charB.id && r.targetId == charA.id);
          }).firstOrNull;

          if (rel != null) {
            final isSource = rel.sourceId == charA.id;
            final def = RelationshipTypeRegistry.getDef(rel.typeKey);
            final label = isSource
                ? (def?.label ?? rel.typeKey)
                : (def?.inverseLabel ?? def?.label ?? rel.typeKey);

            rowCells.add(
              Container(
                height: rowHeight,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.3), width: 0.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _showCellDetails(context, charA, charB, rel);
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color: colorA.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: colorA.withOpacity(0.3), width: 0.8),
                      ),
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: colorA,
                        ),
                      ),
                    ).animate().scale(duration: 150.ms, curve: Curves.easeOut),
                  ),
                ),
              ),
            );
          } else {
            // No relationship - render dashed "+" button
            rowCells.add(
              Container(
                height: rowHeight,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.3), width: 0.5),
                ),
                child: IconButton(
                  icon: Icon(Icons.add, size: 14, color: Theme.of(context).colorScheme.primary.withOpacity(0.4)),
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    onForgeConnection(charA, charB);
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                ),
              ),
            );
          }
        }
      }

      tableRows.add(TableRow(children: rowCells));
    }

    return Column(
      children: [
        Container(
          width: double.infinity,
          color: Theme.of(context).colorScheme.surface,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Icon(Icons.info_outline, size: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Character Matrix: View & forge connections directly. Tap empty cells to forge a new bond.',
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: InteractiveViewer(
            constrained: false,
            boundaryMargin: const EdgeInsets.all(120),
            minScale: 0.5,
            maxScale: 1.5,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: {
                  0: FixedColumnWidth(firstColWidth),
                  for (int idx = 1; idx <= characters.length; idx++)
                    idx: FixedColumnWidth(colWidth),
                },
                children: tableRows,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
