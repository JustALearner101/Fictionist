import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../../domain/map/map_pin.dart';
import '../../../../domain/map/world_map.dart';
import '../../../../domain/use_case/map/create_world_map_use_case.dart';
import '../../../../domain/use_case/map/delete_world_map_use_case.dart';
import '../../../../domain/use_case/map/get_all_world_maps_use_case.dart';
import '../../../../domain/use_case/map/get_pins_for_map_use_case.dart';
import '../../../../domain/use_case/map/remove_map_pin_use_case.dart';
import '../../../../domain/use_case/map/save_map_pin_use_case.dart';
import '../../../../injection.dart';

part 'map_provider.g.dart';

@riverpod
class WorldMapList extends _$WorldMapList {
  @override
  FutureOr<List<WorldMap>> build() async {
    final getUseCase = getIt<GetAllWorldMapsUseCase>();
    final result = await getUseCase();
    return result.fold(
      (failure) => throw Exception(failure.message),
      (list) => list,
    );
  }

  Future<WorldMap> addMap(String name, String pickedFilePath) async {
    final docs = await getApplicationDocumentsDirectory();
    final mapsDir = Directory(p.join(docs.path, 'world_maps'));
    if (!await mapsDir.exists()) {
      await mapsDir.create(recursive: true);
    }

    final uuid = const Uuid().v4();
    final extension = p.extension(pickedFilePath);
    final filename = '$uuid$extension';
    final destinationPath = p.join(mapsDir.path, filename);

    // Copy image file to documents directory
    final sourceFile = File(pickedFilePath);
    await sourceFile.copy(destinationPath);

    final relativePath = p.join('world_maps', filename);
    final newMap = WorldMap(
      id: uuid,
      name: name,
      imagePath: relativePath,
    );

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final createUseCase = getIt<CreateWorldMapUseCase>();
      final result = await createUseCase(newMap);

      return result.fold(
        (failure) => throw Exception(failure.message),
        (_) async {
          final getUseCase = getIt<GetAllWorldMapsUseCase>();
          final listResult = await getUseCase();
          return listResult.fold(
            (f) => throw Exception(f.message),
            (list) => list,
          );
        },
      );
    });

    return newMap;
  }

  Future<void> deleteMap(String id, String relativePath) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final deleteUseCase = getIt<DeleteWorldMapUseCase>();
      final result = await deleteUseCase(id);

      return result.fold(
        (failure) => throw Exception(failure.message),
        (_) async {
          // Attempt to delete physical file
          try {
            final docs = await getApplicationDocumentsDirectory();
            final absPath = p.join(docs.path, relativePath);
            final file = File(absPath);
            if (await file.exists()) {
              await file.delete();
            }
          } catch (_) {
            // Silently swallow file deletion failures to not block state reload
          }

          final getUseCase = getIt<GetAllWorldMapsUseCase>();
          final listResult = await getUseCase();
          return listResult.fold(
            (f) => throw Exception(f.message),
            (list) => list,
          );
        },
      );
    });
  }
}

@riverpod
class MapPins extends _$MapPins {
  @override
  FutureOr<List<MapPin>> build(String mapId) async {
    final getUseCase = getIt<GetPinsForMapUseCase>();
    final result = await getUseCase(mapId);
    return result.fold(
      (failure) => throw Exception(failure.message),
      (list) => list,
    );
  }

  Future<void> addPin({
    required String entityId,
    required double xPercent,
    required double yPercent,
    String? label,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final newPin = MapPin(
        id: const Uuid().v4(),
        mapId: mapId,
        entityId: entityId,
        xPercent: xPercent,
        yPercent: yPercent,
        label: label,
      );

      final saveUseCase = getIt<SaveMapPinUseCase>();
      final result = await saveUseCase(newPin);

      return result.fold(
        (failure) => throw Exception(failure.message),
        (_) async {
          final getUseCase = getIt<GetPinsForMapUseCase>();
          final listResult = await getUseCase(mapId);
          return listResult.fold(
            (f) => throw Exception(f.message),
            (list) => list,
          );
        },
      );
    });
  }

  Future<void> removePin(String pinId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final removeUseCase = getIt<RemoveMapPinUseCase>();
      final result = await removeUseCase(pinId);

      return result.fold(
        (failure) => throw Exception(failure.message),
        (_) async {
          final getUseCase = getIt<GetPinsForMapUseCase>();
          final listResult = await getUseCase(mapId);
          return listResult.fold(
            (f) => throw Exception(f.message),
            (list) => list,
          );
        },
      );
    });
  }
}

@riverpod
Future<String> absoluteMapImagePath(AbsoluteMapImagePathRef ref, String relativePath) async {
  final docs = await getApplicationDocumentsDirectory();
  return p.join(docs.path, relativePath);
}
