import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../domain/entity/entity.dart';
import '../../../../domain/entity/entity_status.dart';
import '../../../../domain/entity/entity_type.dart';
import '../../../common/widget/empty_state.dart';
import '../../../common/widget/error_display.dart';
import '../../../common/widget/loading_indicator.dart';
import '../../../common/widget/page_header.dart';
import '../../../common/widget/quick_switcher_dialog.dart';
import '../../../../domain/use_case/bootstrap/sample_world_use_case.dart';
import '../../../../domain/use_case/continuity_check_use_case.dart';
import '../../../../injection.dart';
import '../provider/continuity_provider.dart';
import '../provider/entity_list_provider.dart';
import '../provider/unused_entities_provider.dart';
import '../widget/bento_stats_widget.dart';
import '../../manuscript/provider/manuscript_provider.dart';
import '../../map/provider/map_provider.dart';
import '../../timeline/provider/timeline_provider.dart';
import '../../graph/provider/graph_provider.dart';

class EntityListScreen extends ConsumerStatefulWidget {
  const EntityListScreen({super.key});

  @override
  ConsumerState<EntityListScreen> createState() => _EntityListScreenState();
}

class _EntityListScreenState extends ConsumerState<EntityListScreen> {
  final TextEditingController _searchController = TextEditingController();
  EntityType? _selectedType;

  void _showQuickSwitcher(BuildContext context) {
    showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (context) => QuickSwitcherDialog(),
    );
  }

  Future<void> _forgeSampleWorld(BuildContext context) async {
    showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Center(
        child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
      ),
    );
    final useCase = getIt<SampleWorldUseCase>();
    final result = await useCase();
    if (mounted) Navigator.of(context, rootNavigator: true).pop();
    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to forge world: ${failure.message}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      },
      (_) {
        ref.invalidate(entityListProvider);
        ref.invalidate(manuscriptNotifierProvider);
        ref.invalidate(worldMapListProvider);
        ref.invalidate(timelineListProvider());
        ref.invalidate(graphDataProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sample world forged successfully!'),
            backgroundColor: Theme.of(context).colorScheme.tertiary,
          ),
        );
      },
    );
  }

  List<Entity> _filterEntities(List<Entity> list) {
    if (_selectedType == null) return list;
    return list.where((e) => e.type == _selectedType).toList();
  }

  Color _statusColor(EntityStatus s) {
    switch (s) {
      case EntityStatus.canon:
        return Theme.of(context).colorScheme.tertiary;
      case EntityStatus.draft:
        return Theme.of(context).colorScheme.primary;
      case EntityStatus.archived:
        return Theme.of(context).colorScheme.onSurfaceVariant;
      case EntityStatus.deprecated:
        return Theme.of(context).colorScheme.error;
    }
  }

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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final entitiesState = ref.watch(entityListProvider);
    final violationsAsync = ref.watch(continuityViolationsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: Column(
          children: [
            PageHeader(
              title: 'Codex',
              subtitle: 'Manage your world\'s inhabitants and lore',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.bolt, color: Theme.of(context).colorScheme.primary, size: 20),
                    tooltip: 'Quick Switcher',
                    onPressed: () => _showQuickSwitcher(context),
                  ),
                  IconButton(
                    icon: Icon(Icons.search, color: Theme.of(context).colorScheme.onSurface, size: 20),
                    tooltip: 'Codex Search',
                    onPressed: () => context.push('/search'),
                  ),
                  IconButton(
                    icon: Icon(Icons.settings, color: Theme.of(context).colorScheme.onSurface, size: 20),
                    tooltip: 'Settings',
                    onPressed: () => context.push('/settings'),
                  ),
                ],
              ),
            ),
          // ── Search bar ──
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Theme.of(context).colorScheme.outline, width: 0.5),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (val) =>
                    ref.read(entityListProvider.notifier).search(val),
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search the codex…',
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.6),
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary, size: 20),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            ref.read(entityListProvider.notifier).search('');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                ),
              ),
            ),
          ),

          // ── Bento Stats & Story Spark ──
          _UnusedBanner(),
          BentoStatsWidget(
            selectedType: _selectedType,
            onFilterType: (type) => setState(() => _selectedType = type),
          ),

          // ── Entity type filter chips ──
          Container(
            height: 42,
            margin: const EdgeInsets.only(bottom: 6),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _FilterChip(
                  label: 'All',
                  icon: Icons.grid_view_rounded,
                  isSelected: _selectedType == null,
                  onTap: () => setState(() => _selectedType = null),
                ),
                ...EntityType.values.map((type) => _FilterChip(
                  label: type.label,
                  icon: _typeIcon(type),
                  isSelected: _selectedType == type,
                  onTap: () => setState(() => _selectedType = type),
                )),
              ],
            ),
          ),
          violationsAsync.when(
            data: (violations) => _buildViolationsBanner(context, violations),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),

          // ── Content ──
          entitiesState.when(
            data: (list) {
              if (list.isEmpty) {
                return _buildEmptyState(context);
              }
              final filtered = _filterEntities(list);
              if (filtered.isEmpty) {
                return const EmptyState(
                  title: 'No Entities Found',
                  message: 'Create a new entity to begin worldbuilding.',
                  icon: Icons.book_outlined,
                );
              }
              return _buildEntityList(filtered);
            },
            loading: () => const SizedBox(
              height: 200,
              child: LoadingIndicator(),
            ),
            error: (err, stack) => ErrorDisplay(
              message: err.toString(),
              onRetry: () => ref.refresh(entityListProvider),
            ),
          ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/entities/create'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.surface,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 80),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Decorative top ornament
          Text('❦', style: TextStyle(fontSize: 40, color: Theme.of(context).colorScheme.primary.withOpacity(0.4))),
          SizedBox(height: 12),
          Text(
            'Welcome, Archivist',
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
              fontSize: 26,
              fontFamily: 'Lora',
              color: Theme.of(context).colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            'Your legendary grimoire is currently blank. '
            'Create a new entity manually, or forge a pre-built '
            'fantasy setting to begin exploring.',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 28),
          FilledButton.icon(
            icon: Icon(Icons.auto_awesome, size: 18),
            label: Text('Forge Sample World'),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.surface,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              textStyle: TextStyle(fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => _forgeSampleWorld(context),
          ),
          SizedBox(height: 12),
          OutlinedButton.icon(
            icon: Icon(Icons.add, size: 18),
            label: Text('Create New Entity'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onSurface,
              side: BorderSide(color: Theme.of(context).colorScheme.outline),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => context.push('/entities/create'),
          ),
        ],
      ),
    );
  }

  Widget _buildEntityList(List<Entity> entities) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(14, 4, 14, 80),
      itemCount: entities.length,
      itemBuilder: (context, index) {
        final entity = entities[index];
        final color = Color(entity.iconColor);
        return Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Hero(
            tag: 'entity-card-${entity.id}',
            child: Material(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  HapticFeedback.lightImpact();
                  context.push('/entities/${entity.id}');
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.4), width: 0.5),
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar
                      Hero(
                        tag: 'entity-avatar-${entity.id}',
                        child: Material(
                          type: MaterialType.transparency,
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.12),
                              shape: BoxShape.circle,
                              border: Border.all(color: color.withOpacity(0.5), width: 1.2),
                            ),
                            child: Center(
                              child: Text(
                                entity.name.isNotEmpty ? entity.name[0].toUpperCase() : '?',
                                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: color,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    entity.name,
                                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                      fontFamily: 'Lora',
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.onSurface,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: _statusColor(entity.status).withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    entity.status.label.toUpperCase(),
                                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                      color: _statusColor(entity.status),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 9,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(_typeIcon(entity.type), size: 13, color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.6)),
                                SizedBox(width: 4),
                                Text(
                                  entity.type.label,
                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            if (entity.description != null &&
                                entity.description!.trim().isNotEmpty) ...[
                              SizedBox(height: 6),
                              Text(
                                entity.description!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.chevron_right, size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.3)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ).animate().fadeIn(duration: 250.ms, delay: (index * 40).ms).slideY(begin: 0.15, duration: 250.ms, delay: (index * 40).ms, curve: Curves.easeOutQuad);
      },
    );
  }

  Widget _buildViolationsBanner(BuildContext context, List<ContinuityViolation> violations) {
    if (violations.isEmpty) return const SizedBox.shrink();

    final count = violations.length;
    final hasErrors = violations.any((v) => v.severity == 'error');
    final color = hasErrors ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 4, 14, 6),
      child: Material(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showViolationsDialog(context, violations),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.35), width: 1.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Icon(
                  hasErrors ? Icons.warning_amber_rounded : Icons.info_outline,
                  color: color,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lore Consistency Warnings ($count)',
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        hasErrors 
                            ? 'Chronological paradoxes or life bounds errors detected in the timeline.'
                            : 'Potential contradictions or organization anomalies found.',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: color.withOpacity(0.8),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showViolationsDialog(BuildContext context, List<ContinuityViolation> violations) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text(
          'Continuity Paradoxes Detected',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontFamily: 'Lora',
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: violations.map((v) {
                final isErr = v.severity == 'error';
                final color = isErr ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: color.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              isErr ? Icons.error_outline : Icons.warning_amber_outlined,
                              size: 16,
                              color: color,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                v.message,
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      fontSize: 13,
                                      height: 1.4,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        if (v.fixSuggestion != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            'Suggestion: ${v.fixSuggestion}',
                            style: TextStyle(
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Close',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Filter chip widget ──
class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primary.withOpacity(0.15)
                : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.5)
                  : Theme.of(context).colorScheme.outline.withOpacity(0.4),
              width: 0.8,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 15,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
              ),
              SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ).animate(target: isSelected ? 1.0 : 0.0)
       .scale(begin: const Offset(0.96, 0.96), end: const Offset(1.04, 1.04), duration: 150.ms, curve: Curves.easeOutBack),
    );
  }
}

class _UnusedBanner extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(unusedEntitiesReportProvider);
    final theme = Theme.of(context);

    return reportAsync.maybeWhen(
      data: (report) {
        if (report.unused.isEmpty) return const SizedBox.shrink();
        return GestureDetector(
          onTap: () {
            // ponytail: filter to show unused — for now just info banner
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFBBF24).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: const Color(0xFFFBBF24).withOpacity(0.3), width: 0.5),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded,
                    size: 14, color: Color(0xFFFBBF24)),
                const SizedBox(width: 8),
                Text(
                  '${report.unused.length} unused entit${report.unused.length == 1 ? 'y' : 'ies'}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: const Color(0xFFFBBF24),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  '${report.used.length}/${report.total} used',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
