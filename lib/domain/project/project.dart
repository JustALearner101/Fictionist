import 'package:freezed_annotation/freezed_annotation.dart';

part 'project.freezed.dart';
part 'project.g.dart';

/// Represents an isolated worldbuilding and writing project workspace.
@freezed
abstract class Project with _$Project {
  const factory Project({
    required String id,
    required String name,
    String? description,
    String? coverImagePath,
    required DateTime lastAccessedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(false) bool isDeleted,
  }) = _Project;

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);
}
