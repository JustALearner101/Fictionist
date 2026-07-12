import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../core/error/failure.dart';
import '../../domain/map/map_pin.dart';
import '../../domain/map/world_map.dart';
import '../../domain/repository/map_repository.dart';
import '../dao/map_dao.dart';
import '../mapper/map_pin_mapper.dart';
import '../mapper/world_map_mapper.dart';

@LazySingleton(as: MapRepository)
class MapRepositoryImpl implements MapRepository {
  final MapDao _dao;

  MapRepositoryImpl(this._dao);

  @override
  Future<Either<Failure, WorldMap>> createMap(WorldMap map) async {
    try {
      final companion = WorldMapMapper.toCompanion(map);
      await _dao.insertMap(companion);
      return Right(map);
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to save world map to database',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteMap(String id) async {
    try {
      final count = await _dao.deleteMap(id);
      if (count == 0) {
        return Left(Failure.notFound(resourceType: 'WorldMap', resourceId: id));
      }
      return const Right(unit);
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to delete world map from database',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, List<WorldMap>>> getAllMaps() async {
    try {
      final rows = await _dao.getAllMaps();
      return Right(rows.map(WorldMapMapper.toDomain).toList());
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to retrieve world maps from database',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, WorldMap>> getMapById(String id) async {
    try {
      final row = await _dao.getMapById(id);
      if (row == null) {
        return Left(Failure.notFound(resourceType: 'WorldMap', resourceId: id));
      }
      return Right(WorldMapMapper.toDomain(row));
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to retrieve world map details',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, MapPin>> createPin(MapPin pin) async {
    try {
      final companion = MapPinMapper.toCompanion(pin);
      await _dao.insertPin(companion);
      return Right(pin);
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to save map pin to database',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, Unit>> deletePin(String id) async {
    try {
      final count = await _dao.deletePin(id);
      if (count == 0) {
        return Left(Failure.notFound(resourceType: 'MapPin', resourceId: id));
      }
      return const Right(unit);
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to delete map pin from database',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, List<MapPin>>> getPinsForMap(String mapId) async {
    try {
      final rows = await _dao.getPinsForMap(mapId);
      return Right(rows.map(MapPinMapper.toDomain).toList());
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to retrieve pins for map',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveMapImage(String relativePath, List<int> bytes) async {
    try {
      final docs = await getApplicationDocumentsDirectory();
      final file = File(p.join(docs.path, relativePath));
      if (!await file.parent.exists()) {
        await file.parent.create(recursive: true);
      }
      await file.writeAsBytes(bytes);
      return const Right(unit);
    } catch (e) {
      return Left(Failure.database(
        message: 'Failed to save map image file',
        originalError: e,
      ));
    }
  }
}
