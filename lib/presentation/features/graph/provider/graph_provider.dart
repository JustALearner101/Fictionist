import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../domain/entity/entity.dart';
import '../../../../domain/relationship/relationship.dart';
import '../../../../domain/use_case/relationship/get_all_active_relationships_use_case.dart';
import '../../../../injection.dart';
import '../../entity/provider/entity_list_provider.dart';

part 'graph_provider.g.dart';

@riverpod
FutureOr<(List<Entity>, List<Relationship>)> graphData(GraphDataRef ref) async {
  final entities = await ref.watch(entityListProvider.future);
  final useCase = getIt<GetAllActiveRelationshipsUseCase>();
  final relsResult = await useCase();

  final rels = relsResult.fold(
    (failure) => throw Exception(failure.message),
    (res) => res,
  );

  return (entities, rels);
}
