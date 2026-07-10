import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/failure.dart';
import '../../../core/use_case/use_case.dart';
import '../../repository/map_repository.dart';

@lazySingleton
class RemoveMapPinUseCase implements UseCase<Unit, String> {
  final MapRepository _repository;

  RemoveMapPinUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(String pinId) {
    return _repository.deletePin(pinId);
  }
}
