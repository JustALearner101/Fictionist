import 'package:freezed_annotation/freezed_annotation.dart';

part 'timeline_entry.freezed.dart';
part 'timeline_entry.g.dart';

@freezed
abstract class TimelineEntry with _$TimelineEntry {
  const factory TimelineEntry({
    required String id,
    required String title,
    String? description,
    String? dateLabel,
    String? eraLabel,
    required int sortOrder,
    String? entityId,
    @Default(false) bool isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _TimelineEntry;

  factory TimelineEntry.fromJson(Map<String, dynamic> json) =>
      _$TimelineEntryFromJson(json);
}
