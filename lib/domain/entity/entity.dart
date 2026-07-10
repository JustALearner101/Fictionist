import 'package:freezed_annotation/freezed_annotation.dart';
import 'custom_field.dart';
import 'entity_status.dart';
import 'entity_type.dart';

part 'entity.freezed.dart';
part 'entity.g.dart';

@freezed
abstract class Entity with _$Entity {
  const factory Entity({
    required String id,
    required String name,
    required EntityType type,
    @Default(EntityStatus.draft) EntityStatus status,
    String? description,
    @Default([]) List<CustomField> customFields,
    required int iconColor,
    @Default(false) bool isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Entity;

  factory Entity.fromJson(Map<String, dynamic> json) => _$EntityFromJson(json);
}
