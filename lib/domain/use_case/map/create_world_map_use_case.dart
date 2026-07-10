import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/failure.dart';
import '../../../core/use_case/use_case.dart';
import '../../map/world_map.dart';
import '../../repository/map_repository.dart';

@lazySingleton
class CreateWorldMapUseCase implements UseCase<WorldMap, WorldMap> {
  final MapRepository _repository;

  CreateWorldMapUseCase(this._repository);

  @override
  Future<Either<Failure, WorldMap>> call(WorldMap map) {
    return _repository.createMap(map);
  }
}
