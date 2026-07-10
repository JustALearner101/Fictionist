import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../domain/entity/entity.dart';
import '../../../../domain/relationship/relationship.dart';
import '../../../../domain/use_case/entity/list_entities_use_case.dart';
import '../../../../domain/use_case/relationship/get_all_relationships_use_case.dart';
import '../../../../injection.dart';

part 'graph_provider.g.dart';

@riverpod
FutureOr<(List<Entity>, List<Relationship>)> graphData(GraphDataRef ref) async {
  final listEntities = getIt<ListEntitiesUseCase>();
  final listRels = getIt<GetAllRelationshipsUseCase>();

  final entitiesResult = await listEntities(const ListEntitiesParams());
  final relsResult = await listRels();

  final entities = entitiesResult.fold(
    (failure) => throw Exception(failure.message),
    (res) => res,
  );

  final rels = relsResult.fold(
    (failure) => throw Exception(failure.message),
    (res) => res,
  );

  return (entities, rels);
}
