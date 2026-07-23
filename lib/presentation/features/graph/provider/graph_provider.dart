import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../domain/entity/entity.dart';
import '../../../../domain/relationship/relationship.dart';
import '../../../../data/repository/relationship_repository_impl.dart';
import '../../../../injection.dart';
import '../../entity/provider/entity_list_provider.dart';

part 'graph_provider.g.dart';

@riverpod
FutureOr<(List<Entity>, List<Relationship>)> graphData(GraphDataRef ref) async {
  final entities = await ref.watch(entityListProvider.future);
  final repo = getIt<RelationshipRepositoryImpl>();
  final relsResult = await repo.getAllActive();

  final rels = relsResult.fold(
    (failure) => throw Exception(failure.message),
    (res) => res,
  );

  return (entities, rels);
}
