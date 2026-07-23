import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import 'package:fictionist/core/error/failure.dart';
import 'package:fictionist/domain/manuscript/manuscript_chapter.dart';
import 'package:fictionist/data/repository/manuscript_repository_impl.dart';

class CreateChapterParams {
  final String title;
  final String content;
  final int sortOrder;

  const CreateChapterParams({
    required this.title,
    this.content = '',
    this.sortOrder = 0,
  });
}

@lazySingleton
class CreateChapterUseCase {
  final ManuscriptRepositoryImpl _repository;

  CreateChapterUseCase(this._repository);

  Future<Either<Failure, ManuscriptChapter>> call(
    CreateChapterParams params,
  ) async {
    if (params.title.trim().isEmpty) {
      return const Left(Failure.validation(
        message: 'Chapter title cannot be empty',
        field: 'title',
      ));
    }

    final chapter = ManuscriptChapter(
      id: const Uuid().v4(),
      title: params.title.trim(),
      content: params.content,
      sortOrder: params.sortOrder,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return _repository.create(chapter);
  }
}

class UpdateChapterParams {
  final ManuscriptChapter chapter;

  const UpdateChapterParams({required this.chapter});
}

@lazySingleton
class UpdateChapterUseCase {
  final ManuscriptRepositoryImpl _repository;

  UpdateChapterUseCase(this._repository);

  Future<Either<Failure, ManuscriptChapter>> call(
    UpdateChapterParams params,
  ) async {
    return _repository.update(params.chapter.copyWith(
      updatedAt: DateTime.now(),
    ));
  }
}

@lazySingleton
class DeleteChapterUseCase {
  final ManuscriptRepositoryImpl _repository;

  DeleteChapterUseCase(this._repository);

  Future<Either<Failure, Unit>> call(String id) async {
    return _repository.softDelete(id);
  }
}

@lazySingleton
class ListChaptersUseCase {
  final ManuscriptRepositoryImpl _repository;

  ListChaptersUseCase(this._repository);

  Future<Either<Failure, List<ManuscriptChapter>>> call() async {
    return _repository.getAllActive();
  }
}

class ReorderChaptersParams {
  final List<String> chapterIdsInOrder;

  const ReorderChaptersParams({required this.chapterIdsInOrder});
}

@lazySingleton
class ReorderChaptersUseCase {
  final ManuscriptRepositoryImpl _repository;

  ReorderChaptersUseCase(this._repository);

  Future<Either<Failure, Unit>> call(ReorderChaptersParams params) async {
    return _repository.reorder(params.chapterIdsInOrder);
  }
}
