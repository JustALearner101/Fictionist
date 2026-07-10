import 'package:freezed_annotation/freezed_annotation.dart';

part 'entity_version.freezed.dart';
part 'entity_version.g.dart';

@freezed
abstract class EntityVersion with _$EntityVersion {
  const factory EntityVersion({
    required String id,
    required String entityId,
    required String snapshotJson,
    required DateTime changedAt,
    String? changeNote,
  }) = _EntityVersion;

  factory EntityVersion.fromJson(Map<String, dynamic> json) =>
      _$EntityVersionFromJson(json);
}
