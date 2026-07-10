import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fictionist/domain/entity/entity.dart';
import 'package:fictionist/domain/use_case/entity/list_entities_use_case.dart';
import 'package:fictionist/injection.dart';

/// A sliding drawer panel showing all Codex entities for reference
/// while writing. On tap, calls [onEntitySelected] with the chosen entity.
/// The parent decides whether to insert a wikilink, open a peek sheet, etc.
class CodexDrawer extends ConsumerStatefulWidget {
  final void Function(Entity entity) onEntitySelected;

  const CodexDrawer({super.key, required this.onEntitySelected});

  @override
  ConsumerState<CodexDrawer> createState() => _CodexDrawerState();
}

class _CodexDrawerState extends ConsumerState<CodexDrawer> {
  String _filter = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'Codex',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 14,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 13),
              decoration: const InputDecoration(
                hintText: 'Filter entities...',
                isDense: true,
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
              ),
              onChanged: (v) => setState(() => _filter = v),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _EntityList(
              filter: _filter,
              onEntityTap: widget.onEntitySelected,
            ),
          ),
        ],
      ),
    );
  }
}

/// Lazy-loading entity list for the codex drawer.
class _EntityList extends ConsumerWidget {
  final String filter;
  final void Function(Entity entity) onEntityTap;

  const _EntityList({required this.filter, required this.onEntityTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final useCase = getIt<ListEntitiesUseCase>();
    return FutureBuilder(
      future: useCase(ListEntitiesParams()),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Theme.of(context).colorScheme.primary,
            ),
          );
        }

        return snapshot.data!.fold(
          (failure) => Center(
            child: Text(
              'Error: ${failure.message}',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
          (entities) {
            final filtered = filter.isEmpty
                ? entities
                : entities
                    .where((e) =>
                        e.name.toLowerCase().contains(filter.toLowerCase()))
                    .toList();

            if (filtered.isEmpty) {
              return Center(
                child: Text(
                  'No entities found.',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
              );
            }

            return ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final entity = filtered[index];
                return ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    radius: 12,
                    backgroundColor:
                        Color(entity.iconColor).withOpacity(0.15),
                    child: Text(
                      entity.name.isNotEmpty
                          ? entity.name[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        color: Color(entity.iconColor),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    entity.name,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  subtitle: Text(
                    entity.type.label,
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      fontSize: 10,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  onTap: () => onEntityTap(entity),
                );
              },
            );
          },
        );
      },
    );
  }
}
