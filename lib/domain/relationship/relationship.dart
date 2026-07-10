import 'package:freezed_annotation/freezed_annotation.dart';

part 'relationship.freezed.dart';
part 'relationship.g.dart';

@freezed
abstract class Relationship with _$Relationship {
  const factory Relationship({
    required String id,
    required String sourceId,
    required String targetId,
    required String typeKey,
    String? description,
    @Default(5) int weight,
    @Default(false) bool isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Relationship;

  factory Relationship.fromJson(Map<String, dynamic> json) =>
      _$RelationshipFromJson(json);
}
