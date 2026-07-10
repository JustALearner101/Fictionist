import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../domain/repository/entity_version_repository.dart';
import '../../../../domain/version/entity_version.dart';
import '../../../../injection.dart';

part 'entity_version_history_provider.g.dart';

@riverpod
Future<List<EntityVersion>> entityVersionHistory(
    EntityVersionHistoryRef ref, String entityId) async {
  final repository = getIt<EntityVersionRepository>();
  final result = await repository.getVersionsForEntity(entityId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (list) => list,
  );
}
