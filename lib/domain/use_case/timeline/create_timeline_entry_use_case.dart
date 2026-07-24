import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import '../../../core/error/failure.dart';
import '../../../data/repository/timeline_repository_impl.dart';
import '../../timeline/timeline_entry.dart';

class CreateTimelineEntryParams {
  final String title;
  final String? description;
  final String? dateLabel;
  final String? eraLabel;
  final String? entityId;
  final String? projectId;

  const CreateTimelineEntryParams({
    required this.title,
    this.description,
    this.dateLabel,
    this.eraLabel,
    this.entityId,
    this.projectId,
  });
}

@lazySingleton
class CreateTimelineEntryUseCase {
  final TimelineRepositoryImpl _repository;

  CreateTimelineEntryUseCase(this._repository);

  @override
  Future<Either<Failure, TimelineEntry>> call(
      CreateTimelineEntryParams params) async {
    final trimmedTitle = params.title.trim();
    if (trimmedTitle.isEmpty) {
      return const Left(Failure.validation(
        message: 'Timeline entry title cannot be empty',
        field: 'title',
      ));
    }

    final maxOrderResult = await _repository.getMaxSortOrder();
    return maxOrderResult.fold(
      (failure) => Left(failure),
      (maxOrder) async {
        final entry = TimelineEntry(
          id: const Uuid().v4(),
          title: trimmedTitle,
          description: params.description,
          dateLabel: params.dateLabel,
          eraLabel: params.eraLabel,
          sortOrder: maxOrder + 1000,
          entityId: params.entityId,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        return _repository.create(entry, projectId: params.projectId);
      },
    );
  }
}
