import 'package:freezed_annotation/freezed_annotation.dart';
import '../entity/custom_field.dart';
import '../entity/entity_type.dart';

part 'template.freezed.dart';
part 'template.g.dart';

@freezed
abstract class Template with _$Template {
  const factory Template({
    required String id,
    required String name,
    required EntityType entityType,
    @Default([]) List<CustomField> customFieldsSchema,
    @Default(false) bool isBuiltIn,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Template;

  factory Template.fromJson(Map<String, dynamic> json) =>
      _$TemplateFromJson(json);
}
