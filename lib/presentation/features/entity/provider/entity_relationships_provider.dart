import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../domain/relationship/relationship.dart';
import '../../../../domain/use_case/relationship/get_relationships_for_entity_use_case.dart';
import '../../../../injection.dart';

part 'entity_relationships_provider.g.dart';

@riverpod
Future<List<Relationship>> entityRelationships(
    EntityRelationshipsRef ref, String entityId) async {
  final useCase = getIt<GetRelationshipsForEntityUseCase>();
  final result = await useCase(entityId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (list) => list,
  );
}
