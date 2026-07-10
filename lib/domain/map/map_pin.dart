import 'package:freezed_annotation/freezed_annotation.dart';

part 'map_pin.freezed.dart';
part 'map_pin.g.dart';

@freezed
abstract class MapPin with _$MapPin {
  const factory MapPin({
    required String id,
    required String mapId,
    required String entityId,
    required double xPercent,
    required double yPercent,
    String? label,
  }) = _MapPin;

  factory MapPin.fromJson(Map<String, dynamic> json) =>
      _$MapPinFromJson(json);
}
