import 'package:fpdart/fpdart.dart';
import '../../core/error/failure.dart';
import '../map/map_pin.dart';
import '../map/world_map.dart';

abstract class MapRepository {
  Future<Either<Failure, WorldMap>> createMap(WorldMap map);
  Future<Either<Failure, Unit>> deleteMap(String id);
  Future<Either<Failure, List<WorldMap>>> getAllMaps();
  Future<Either<Failure, WorldMap>> getMapById(String id);
  Future<Either<Failure, MapPin>> createPin(MapPin pin);
  Future<Either<Failure, Unit>> deletePin(String id);
  Future<Either<Failure, List<MapPin>>> getPinsForMap(String mapId);
}
