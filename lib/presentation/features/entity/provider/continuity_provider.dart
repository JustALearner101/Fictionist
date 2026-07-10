import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../domain/entity/entity.dart';
import '../../../../domain/relationship/relationship.dart';
import '../../../../domain/use_case/continuity_check_use_case.dart';
import '../../../../domain/use_case/relationship/get_all_relationships_use_case.dart';
import '../../../../injection.dart';
import '../../timeline/provider/timeline_provider.dart';
import 'entity_list_provider.dart';

part 'continuity_provider.g.dart';

@riverpod
Future<List<Relationship>> allRelationships(AllRelationshipsRef ref) async {
  final useCase = getIt<GetAllRelationshipsUseCase>();
  final res = await useCase();
  return res.fold(
    (f) => throw Exception(f.message),
    (list) => list,
  );
}

@riverpod
Future<List<ContinuityViolation>> continuityViolations(ContinuityViolationsRef ref) async {
  final entitiesAsync = ref.watch(entityListProvider);
  final relsAsync = ref.watch(allRelationshipsProvider);
  final timelineAsync = ref.watch(timelineListProvider(entityId: null));

  if (entitiesAsync.isLoading || relsAsync.isLoading || timelineAsync.isLoading) {
    return [];
  }

  final entities = entitiesAsync.value ?? [];
  final rels = relsAsync.value ?? [];
  final timeline = timelineAsync.value ?? [];

  final useCase = getIt<ContinuityCheckUseCase>();
  final res = await useCase(ContinuityCheckParams(
    entities: entities,
    relationships: rels,
    timelineEntries: timeline,
  ));

  return res.fold(
    (f) => [],
    (result) => result.violations,
  );
}
