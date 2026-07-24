import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../domain/project/project.dart';
import '../../../../domain/use_case/project/get_projects_use_case.dart';
import '../../../../injection.dart';
import '../provider/active_project_provider.dart';

class ProjectSwitcherBottomSheet extends ConsumerStatefulWidget {
  const ProjectSwitcherBottomSheet({super.key});

  @override
  ConsumerState<ProjectSwitcherBottomSheet> createState() =>
      _ProjectSwitcherBottomSheetState();
}

class _ProjectSwitcherBottomSheetState
    extends ConsumerState<ProjectSwitcherBottomSheet> {
  final _getProjectsUseCase = getIt<GetProjectsUseCase>();
  List<Project>? _projects;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    final result = await _getProjectsUseCase();
    if (!mounted) return;
    result.fold(
      (f) => setState(() {
        _error = f.message;
        _loading = false;
      }),
      (ps) => setState(() {
        _projects = ps;
        _loading = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeProjectVal = ref.watch(activeProjectProvider);
    final activeProject = activeProjectVal.valueOrNull;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Icon(Icons.collections_bookmark_outlined,
                      color: theme.colorScheme.primary, size: 22),
                  const SizedBox(width: 10),
                  Text(
                    'Chronicle Shelf',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: theme.textTheme.displayLarge?.fontFamily,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Divider(color: theme.colorScheme.outline.withOpacity(0.12)),

            // Projects List
            if (_loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_error != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                child: Column(
                  children: [
                    Text('Failed to load projects: $_error',
                        style: TextStyle(color: theme.colorScheme.error)),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _loadProjects,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
            else if (_projects == null || _projects!.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                child: Text('No projects found. Go back to the shelf to create one.'),
              )
            else
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: _projects!.length,
                  itemBuilder: (context, index) {
                    final project = _projects![index];
                    final isActive = activeProject?.id == project.id;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      child: InkWell(
                        onTap: () async {
                          if (!isActive) {
                            await ref
                                .read(activeProjectProvider.notifier)
                                .selectProject(project);
                          }
                          if (context.mounted) Navigator.of(context).pop();
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isActive
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.outline.withOpacity(0.08),
                              width: isActive ? 1.5 : 1,
                            ),
                            color: isActive
                                ? theme.colorScheme.primary.withOpacity(0.05)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isActive
                                    ? Icons.auto_stories
                                    : Icons.auto_stories_outlined,
                                color: isActive
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurfaceVariant,
                                size: 18,
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      project.name,
                                      style: theme.textTheme.titleSmall?.copyWith(
                                        fontWeight: isActive
                                            ? FontWeight.bold
                                            : FontWeight.w500,
                                        color: isActive
                                            ? theme.colorScheme.primary
                                            : theme.colorScheme.onSurface,
                                      ),
                                    ),
                                    if (project.description != null &&
                                        project.description!.isNotEmpty) ...[
                                      const SizedBox(height: 3),
                                      Text(
                                        project.description!,
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: theme.colorScheme.onSurfaceVariant
                                              .withOpacity(0.7),
                                          fontSize: 11,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              if (isActive)
                                Icon(
                                  Icons.check_circle_rounded,
                                  color: theme.colorScheme.primary,
                                  size: 18,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

            Divider(color: theme.colorScheme.outline.withOpacity(0.12)),

            // Footer action: Manage projects
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ref.read(activeProjectProvider.notifier).clearActiveProject();
                    Navigator.of(context).pop();
                    context.go('/projects');
                  },
                  icon: const Icon(Icons.shelves, size: 18),
                  label: const Text('Manage Shelf & Library'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.onSurfaceVariant,
                    side: BorderSide(color: theme.colorScheme.outline.withOpacity(0.2)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
