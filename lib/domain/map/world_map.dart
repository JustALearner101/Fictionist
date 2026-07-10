import 'package:freezed_annotation/freezed_annotation.dart';

part 'world_map.freezed.dart';
part 'world_map.g.dart';

@freezed
abstract class WorldMap with _$WorldMap {
  const factory WorldMap({
    required String id,
    required String name,
    required String imagePath,
  }) = _WorldMap;

  factory WorldMap.fromJson(Map<String, dynamic> json) =>
      _$WorldMapFromJson(json);
}
