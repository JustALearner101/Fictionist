import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../domain/search/search_result.dart';
import '../../../../domain/use_case/entity/search_entities_with_snippets_use_case.dart';
import '../../../../injection.dart';

part 'entity_search_provider.g.dart';

@riverpod
class EntitySearch extends _$EntitySearch {
  @override
  FutureOr<List<SearchResult>> build() async {
    return const [];
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final searchUseCase = getIt<SearchEntitiesWithSnippetsUseCase>();
      final result = await searchUseCase(query);
      return result.fold(
        (failure) => throw Exception(failure.message),
        (results) => results,
      );
    });
  }
}
