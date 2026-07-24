import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../domain/project/project.dart';
import '../../../../domain/use_case/project/get_latest_accessed_project_use_case.dart';
import '../../../../domain/use_case/project/update_project_last_accessed_use_case.dart';
import '../../../../injection.dart';

part 'active_project_provider.g.dart';

@Riverpod(keepAlive: true)
class ActiveProject extends _$ActiveProject {
  @override
  FutureOr<Project?> build() async {
    final getLatestUseCase = getIt<GetLatestAccessedProjectUseCase>();
    final result = await getLatestUseCase();

    return result.fold(
      (failure) => throw Exception(failure.message),
      (project) async {
        if (project == null) {
          return null;
        }

        final updateLastAccessed = getIt<UpdateProjectLastAccessedUseCase>();
        final touchResult = await updateLastAccessed(project.id);

        return touchResult.fold(
          (_) => project,
          (updatedProject) => updatedProject,
        );
      },
    );
  }

  Future<void> selectProject(Project project) async {
    final updateLastAccessed = getIt<UpdateProjectLastAccessedUseCase>();
    final result = await updateLastAccessed(project.id);

    final updatedProject = result.fold(
      (failure) => project,
      (p) => p,
    );

    state = AsyncValue.data(updatedProject);
  }

  void clearActiveProject() {
    state = const AsyncValue.data(null);
  }
}
