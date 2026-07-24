import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../domain/project/project.dart';
import '../../../../domain/use_case/project/create_project_use_case.dart';
import '../../../../domain/use_case/project/delete_project_use_case.dart';
import '../../../../domain/use_case/project/get_projects_use_case.dart';
import '../../../../injection.dart';
import '../../../common/widget/empty_state.dart';
import '../../../common/widget/error_display.dart';
import '../../../common/widget/loading_indicator.dart';
import '../../project/provider/active_project_provider.dart';
import '../widget/project_card.dart';
import '../widget/project_create_dialog.dart';
import '../widget/project_delete_dialog.dart';

class ProjectSelectionScreen extends ConsumerWidget {
  const ProjectSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fictionist'),
        centerTitle: true,
      ),
      body: _ProjectList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _createProject(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('New Project'),
      ),
    );
  }

  Future<void> _createProject(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<Map<String, String?>>(
      context: context,
      builder: (_) => const ProjectCreateDialog(),
    );
    if (result == null || context.mounted == false) return;

    final useCase = getIt<CreateProjectUseCase>();
    final project = Project(
      id: const Uuid().v4(),
      name: result['name']!,
      description: result['description'],
      lastAccessedAt: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final outcome = await useCase(project);
    outcome.fold(
      (failure) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to create project: ${failure.message}')),
          );
        }
      },
      (created) async {
        await ref.read(activeProjectProvider.notifier).selectProject(created);
        if (context.mounted) context.go('/entities');
      },
    );
  }
}

class _ProjectList extends ConsumerStatefulWidget {
  @override
  ConsumerState<_ProjectList> createState() => _ProjectListState();
}

class _ProjectListState extends ConsumerState<_ProjectList> {
  final _useCase = getIt<GetProjectsUseCase>();
  List<Project>? _projects;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    final result = await _useCase();
    result.fold(
      (f) => setState(() { _loading = false; _error = f.message; }),
      (ps) => setState(() { _loading = false; _projects = ps; }),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const LoadingIndicator();
    if (_error != null) {
      return ErrorDisplay(message: _error!, onRetry: _load);
    }
    if (_projects == null || _projects!.isEmpty) {
      return const EmptyState(
        icon: Icons.folder_open,
        title: 'No Projects Yet',
        message: 'Create your first project to get started.',
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.76, // Elegant book aspect ratio
      ),
      itemCount: _projects!.length,
      itemBuilder: (context, index) {
        final project = _projects![index];
        return ProjectCard(
          project: project,
          onTap: () => _selectProject(context, project),
          onDelete: () => _confirmDelete(context, project),
        );
      },
    );
  }

  Future<void> _selectProject(BuildContext context, Project project) async {
    await ref.read(activeProjectProvider.notifier).selectProject(project);
    if (context.mounted) context.go('/entities');
  }

  Future<void> _confirmDelete(BuildContext context, Project project) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => ProjectDeleteDialog(project: project),
    );
    if (confirmed != true || context.mounted == false) return;

    final deleteUseCase = getIt<DeleteProjectUseCase>();
    final outcome = await deleteUseCase(project.id);
    outcome.fold(
      (failure) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete: ${failure.message}')),
          );
        }
      },
      (_) => _load(),
    );
  }
}
