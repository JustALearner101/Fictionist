import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import '../../../core/error/failure.dart';
import '../../../core/use_case/use_case.dart';
import '../../repository/tag_repository.dart';
import '../../tag/tag.dart';

class CreateTagParams {
  final String name;
  final int color;

  const CreateTagParams({required this.name, required this.color});
}

@lazySingleton
class CreateTagUseCase implements UseCase<Tag, CreateTagParams> {
  final TagRepository _repository;

  CreateTagUseCase(this._repository);

  @override
  Future<Either<Failure, Tag>> call(CreateTagParams params) async {
    final trimmedName = params.name.trim();
    if (trimmedName.isEmpty) {
      return const Left(Failure.validation(
        message: 'Tag name cannot be empty',
        field: 'name',
      ));
    }

    // Check if tag already exists
    final existingResult = await _repository.getByName(trimmedName);
    return existingResult.fold(
      (failure) => Left(failure),
      (existingTag) async {
        if (existingTag != null) {
          return Right(existingTag);
        }

        final tag = Tag(
          id: const Uuid().v4(),
          name: trimmedName,
          color: params.color,
        );
        return _repository.create(tag);
      },
    );
  }
}
