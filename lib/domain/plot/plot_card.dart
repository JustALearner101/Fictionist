import 'package:freezed_annotation/freezed_annotation.dart';

part 'plot_card.freezed.dart';
part 'plot_card.g.dart';

@freezed
abstract class PlotCard with _$PlotCard {
  const factory PlotCard({
    required String id,
    required String title,
    String? summary,
    required double xPosition,
    required double yPosition,
    @Default(0xFFA78BFA) int colorHex,
    @Default(false) bool isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _PlotCard;

  factory PlotCard.fromJson(Map<String, dynamic> json) =>
      _$PlotCardFromJson(json);
}

@freezed
abstract class PlotConnection with _$PlotConnection {
  const factory PlotConnection({
    required String id,
    required String sourceId,
    required String targetId,
    String? label,
    @Default(false) bool isDeleted,
    required DateTime createdAt,
  }) = _PlotConnection;

  factory PlotConnection.fromJson(Map<String, dynamic> json) =>
      _$PlotConnectionFromJson(json);
}
