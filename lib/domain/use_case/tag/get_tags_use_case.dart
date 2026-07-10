import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/failure.dart';
import '../../../core/use_case/use_case.dart';
import '../../repository/tag_repository.dart';
import '../../tag/tag.dart';

@lazySingleton
class GetTagsUseCase implements UseCaseNoParams<List<Tag>> {
  final TagRepository _repository;

  GetTagsUseCase(this._repository);

  @override
  Future<Either<Failure, List<Tag>>> call() {
    return _repository.getAllTags();
  }
}
