import 'package:freezed_annotation/freezed_annotation.dart';

part 'custom_field.freezed.dart';
part 'custom_field.g.dart';

@freezed
abstract class CustomField with _$CustomField {
  const factory CustomField({
    required String id,
    required String key,
    required String label,
    required String fieldType, // short_text, long_text, number, toggle, select, multi_select, date_label
    required dynamic value,
    List<String>? options,
    @Default(0) int sortOrder,
  }) = _CustomField;

  factory CustomField.fromJson(Map<String, dynamic> json) =>
      _$CustomFieldFromJson(json);
}
