import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../domain/relationship/relationship.dart';
import '../../../../domain/use_case/relationship/get_entity_relationships_use_case.dart';
import '../../../../injection.dart';

part 'entity_relationships_provider.g.dart';

@riverpod
Future<List<Relationship>> entityRelationships(
    EntityRelationshipsRef ref, String entityId) async {
  final getUseCase = getIt<GetEntityRelationshipsUseCase>();
  final result = await getUseCase(entityId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (list) => list,
  );
}
