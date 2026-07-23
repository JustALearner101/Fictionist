import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../domain/search/search_result.dart';
import '../../../../data/repository/entity_repository_impl.dart';
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
      final repo = getIt<EntityRepositoryImpl>();
      final result = await repo.searchWithSnippets(query);
      return result.fold(
        (failure) => throw Exception(failure.message),
        (results) => results,
      );
    });
  }
}
