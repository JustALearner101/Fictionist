import 'package:freezed_annotation/freezed_annotation.dart';

part 'chapter_snapshot.freezed.dart';
part 'chapter_snapshot.g.dart';

/// A point-in-time snapshot of a chapter's content, saved before every update
/// so users can browse and restore previous versions.
@freezed
abstract class ChapterSnapshot with _$ChapterSnapshot {
  const factory ChapterSnapshot({
    required String id,
    required String chapterId,
    required String content,
    required DateTime createdAt,
  }) = _ChapterSnapshot;

  factory ChapterSnapshot.fromJson(Map<String, dynamic> json) =>
      _$ChapterSnapshotFromJson(json);
}
