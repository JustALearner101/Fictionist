import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/failure.dart';
import '../../../core/use_case/use_case.dart';
import '../../map/map_pin.dart';
import '../../repository/map_repository.dart';

@lazySingleton
class GetPinsForMapUseCase implements UseCase<List<MapPin>, String> {
  final MapRepository _repository;

  GetPinsForMapUseCase(this._repository);

  @override
  Future<Either<Failure, List<MapPin>>> call(String mapId) {
    return _repository.getPinsForMap(mapId);
  }
}
