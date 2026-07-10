import 'package:freezed_annotation/freezed_annotation.dart';

part 'manuscript_chapter.freezed.dart';
part 'manuscript_chapter.g.dart';

/// Writing status for a chapter.
enum ChapterStatus {
  draft('Draft'),
  revising('Revising'),
  done('Done');

  final String label;
  const ChapterStatus(this.label);
}

/// A chapter in a manuscript, stored as markdown text.
@freezed
abstract class ManuscriptChapter with _$ManuscriptChapter {
  const factory ManuscriptChapter({
    required String id,
    required String title,
    required String content,
    @Default(0) int sortOrder,
    String? dateLabel,
    String? eraLabel,
    @Default(null) String? synopsis,
    @Default(false) bool isDeleted,
    @Default(ChapterStatus.draft) ChapterStatus status,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ManuscriptChapter;

  factory ManuscriptChapter.fromJson(Map<String, dynamic> json) =>
      _$ManuscriptChapterFromJson(json);
}
