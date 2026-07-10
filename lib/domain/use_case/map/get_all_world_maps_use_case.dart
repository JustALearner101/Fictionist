import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/failure.dart';
import '../../../core/use_case/use_case.dart';
import '../../map/world_map.dart';
import '../../repository/map_repository.dart';

@lazySingleton
class GetAllWorldMapsUseCase implements UseCaseNoParams<List<WorldMap>> {
  final MapRepository _repository;

  GetAllWorldMapsUseCase(this._repository);

  @override
  Future<Either<Failure, List<WorldMap>>> call() {
    return _repository.getAllMaps();
  }
}
