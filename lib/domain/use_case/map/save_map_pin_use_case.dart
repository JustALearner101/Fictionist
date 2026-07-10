import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/failure.dart';
import '../../../core/use_case/use_case.dart';
import '../../map/map_pin.dart';
import '../../repository/map_repository.dart';

@lazySingleton
class SaveMapPinUseCase implements UseCase<MapPin, MapPin> {
  final MapRepository _repository;

  SaveMapPinUseCase(this._repository);

  @override
  Future<Either<Failure, MapPin>> call(MapPin pin) {
    return _repository.createPin(pin);
  }
}
