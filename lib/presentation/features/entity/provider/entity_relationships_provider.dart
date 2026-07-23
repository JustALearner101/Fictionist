import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../domain/relationship/relationship.dart';
import '../../../../data/repository/relationship_repository_impl.dart';
import '../../../../injection.dart';

part 'entity_relationships_provider.g.dart';

@riverpod
Future<List<Relationship>> entityRelationships(
    EntityRelationshipsRef ref, String entityId) async {
  final repo = getIt<RelationshipRepositoryImpl>();
  final result = await repo.getRelationshipsForEntity(entityId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (list) => list,
  );
}
