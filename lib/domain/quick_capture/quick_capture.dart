import 'package:freezed_annotation/freezed_annotation.dart';

part 'quick_capture.freezed.dart';
part 'quick_capture.g.dart';

@freezed
abstract class QuickCapture with _$QuickCapture {
  const factory QuickCapture({
    required String id,
    required String rawText,
    @Default(false) bool isProcessed,
    required DateTime createdAt,
  }) = _QuickCapture;

  factory QuickCapture.fromJson(Map<String, dynamic> json) =>
      _$QuickCaptureFromJson(json);
}
