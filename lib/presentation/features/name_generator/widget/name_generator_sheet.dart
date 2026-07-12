import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fictionist/domain/name_generator/generation_type.dart';
import 'package:fictionist/domain/use_case/name_generator/generate_names_use_case.dart';
import 'package:fictionist/injection.dart';
import 'package:fictionist/presentation/features/name_generator/provider/name_generator_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:fictionist/presentation/common/widget/loading_indicator.dart';
import 'package:fictionist/presentation/common/widget/fictionist_dropdown.dart';

/// A reusable bottom sheet that generates fantasy names.
///
/// Uses culture-based phoneme generation with 6 cultures and 5 generation types.
/// Returns the selected name, or null if the user cancelled.
class NameGeneratorSheet extends ConsumerStatefulWidget {
  const NameGeneratorSheet({super.key});

  @override
  ConsumerState<NameGeneratorSheet> createState() =>
      _NameGeneratorSheetState();
}

class _NameGeneratorSheetState extends ConsumerState<NameGeneratorSheet>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const _types = GenerationType.values;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _types.length,
      vsync: this,
    );
    _tabController.addListener(_onTabChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(nameGeneratorNotifierProvider.notifier)
          .generate();
    });
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) return;
    final type = _types[_tabController.index];
    ref
        .read(nameGeneratorNotifierProvider.notifier)
        .setGenerationType(type);
    ref
        .read(nameGeneratorNotifierProvider.notifier)
        .generate();
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(nameGeneratorNotifierProvider);
    final notifier =
        ref.read(nameGeneratorNotifierProvider.notifier);
    final useCase = getIt<GenerateNamesUseCase>();
    final archetypes = useCase.getArchetypesForType(state.generationType);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  'Name Generator',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
              ],
            ),
          ),

          // Tab bar
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: Theme.of(context).colorScheme.primary,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor:
                Theme.of(context).colorScheme.onSurfaceVariant,
            labelStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            tabs: _types.map((t) => Tab(text: t.label)).toList(),
          ),

          const SizedBox(height: 4),

          // Culture picker
          if (archetypes.length > 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    'Culture:',
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FictionistDropdown<String>(
                      value: archetypes.contains(state.selectedArchetype)
                          ? state.selectedArchetype
                          : archetypes.first,
                      items: archetypes
                          .map((a) => FictionistDropdownItem<String>(
                                value: a,
                                child: Text(a, style: TextStyle(
                                  color: Theme.of(context).colorScheme.secondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                )),
                              ))
                          .toList(),
                      onChanged: (String value) {
                        notifier.setArchetype(value);
                        notifier.generate();
                      },
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 8),

          // Results
          Flexible(
            child: _buildResults(context, state),
          ),

          // Generate button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.tonalIcon(
                onPressed: state.isLoading
                    ? null
                    : () => notifier.generate(),
                icon: const Icon(Icons.casino, size: 18),
                label: const Text('Generate 5'),
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .primary
                      .withOpacity(0.15),
                  foregroundColor:
                      Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResults(BuildContext context, NameGeneratorState state) {
    if (state.isLoading) {
      return Center(
        child: LoadingIndicator(),
      );
    }

    if (state.errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline,
                size: 32,
                color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 8),
            Text(
              state.errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ),
      );
    }

    if (state.names.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: state.names.length,
      itemBuilder: (context, index) {
        final name = state.names[index];
        return _NameCard(name: name, index: index);
      },
    );
  }
}

/// An individual generated name card with copy action and reveal animation.
class _NameCard extends StatelessWidget {
  final dynamic name; // GeneratedName
  final int index;

  const _NameCard({required this.name, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => Navigator.of(context).pop(name.name as String),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                // Name + archetype
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name.name as String,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                      ),
                      if (name.archetype != 'Standard')
                        Text(
                          name.archetype as String,
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                                fontSize: 11,
                              ),
                        ),
                    ],
                  ),
                ),
                // Forge button
                IconButton(
                  icon: Icon(
                    Icons.add_circle_outline,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  tooltip: 'Forge entity with this name',
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.push('/entities/create?name=${Uri.encodeComponent(name.name as String)}');
                  },
                ),
                // Copy button
                IconButton(
                  icon: Icon(
                    Icons.copy,
                    size: 18,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  tooltip: 'Copy to clipboard',
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: name.name as String),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Copied "${name.name}"',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        backgroundColor:
                            Theme.of(context).colorScheme.primary,
                        duration: const Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(
          duration: 300.ms,
          delay: (index * 80).ms,
        )
        .slideX(
          begin: 0.2,
          duration: 300.ms,
          delay: (index * 80).ms,
        );
  }
}

/// Convenience function to show the name generator bottom sheet.
///
/// Returns the selected name [String], or null if the user cancelled.
Future<String?> showNameGeneratorSheet(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => const NameGeneratorSheet(),
  );
}
