import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../../data/repository/map_repository_impl.dart';
import '../../../../domain/map/map_pin.dart';
import '../../../../domain/map/world_map.dart';
import '../../../../injection.dart';
import '../../project/provider/active_project_provider.dart';

part 'map_provider.g.dart';

MapRepositoryImpl _repo() => getIt<MapRepositoryImpl>();

@riverpod
class WorldMapList extends _$WorldMapList {
  @override
  FutureOr<List<WorldMap>> build() async {
    final projectId = ref.watch(activeProjectProvider).valueOrNull?.id;
    final result = await _repo().getAllMaps(projectId: projectId);
    return result.fold(
      (failure) => throw Exception(failure.message),
      (list) => list,
    );
  }

  Future<WorldMap> addMap(String name, String pickedFilePath) async {
    final projectId = ref.read(activeProjectProvider).valueOrNull?.id;
    final docs = await getApplicationDocumentsDirectory();
    final mapsDir = Directory(p.join(docs.path, 'world_maps'));
    if (!await mapsDir.exists()) {
      await mapsDir.create(recursive: true);
    }

    final uuid = const Uuid().v4();
    final extension = p.extension(pickedFilePath);
    final filename = '$uuid$extension';
    final destinationPath = p.join(mapsDir.path, filename);

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
      final result = await _repo().createMap(newMap, projectId: projectId);
      return result.fold(
        (failure) => throw Exception(failure.message),
        (_) async {
          final listResult = await _repo().getAllMaps(projectId: projectId);
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
    final projectId = ref.read(activeProjectProvider).valueOrNull?.id;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final result = await _repo().deleteMap(id);

      return result.fold(
        (failure) => throw Exception(failure.message),
        (_) async {
          try {
            final docs = await getApplicationDocumentsDirectory();
            final absPath = p.join(docs.path, relativePath);
            final file = File(absPath);
            if (await file.exists()) {
              await file.delete();
            }
          } catch (_) {}

          final listResult = await _repo().getAllMaps(projectId: projectId);
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
    final result = await _repo().getPinsForMap(mapId);
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

      final result = await _repo().createPin(newPin);

      return result.fold(
        (failure) => throw Exception(failure.message),
        (_) async {
          final listResult = await _repo().getPinsForMap(mapId);
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
      final result = await _repo().deletePin(pinId);

      return result.fold(
        (failure) => throw Exception(failure.message),
        (_) async {
          final listResult = await _repo().getPinsForMap(mapId);
          return listResult.fold(
            (f) => throw Exception(f.message),
            (list) => list,
          );
        },
      );
    });
  }
}

final selectedMapIdProvider = StateProvider<String?>((ref) => null);

@riverpod
Future<String> absoluteMapImagePath(AbsoluteMapImagePathRef ref, String relativePath) async {
  final docs = await getApplicationDocumentsDirectory();
  return p.join(docs.path, relativePath);
}
