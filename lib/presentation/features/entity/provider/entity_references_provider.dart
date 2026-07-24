import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../domain/use_case/entity/get_entity_references_use_case.dart';
import '../../../../injection.dart';
import '../../entity/provider/entity_list_provider.dart';

part 'entity_references_provider.g.dart';

@riverpod
Future<EntityReferences> entityReferences(
  EntityReferencesRef ref,
  String entityId,
) async {
  final entities = await ref.watch(entityListProvider.future);
  final entity = entities.firstWhere(
    (e) => e.id == entityId,
    orElse: () => throw Exception('Entity not found: $entityId'),
  );

  final useCase = getIt<GetEntityReferencesUseCase>();
  final result = await useCase(entity);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (refs) => refs,
  );
}
