import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/failure.dart';
import '../../../core/use_case/use_case.dart';
import '../../repository/entity_repository.dart';
import '../../search/search_result.dart';

@lazySingleton
class SearchEntitiesWithSnippetsUseCase
    implements UseCase<List<SearchResult>, String> {
  final EntityRepository _repository;

  SearchEntitiesWithSnippetsUseCase(this._repository);

  @override
  Future<Either<Failure, List<SearchResult>>> call(String query) {
    return _repository.searchWithSnippets(query);
  }
}
