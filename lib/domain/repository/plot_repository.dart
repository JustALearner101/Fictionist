import 'package:fpdart/fpdart.dart';
import '../../core/error/failure.dart';
import '../plot/plot_card.dart';

abstract class PlotRepository {
  Future<Either<Failure, PlotCard>> createCard({
    required String title,
    String? summary,
    double xPosition = 200,
    double yPosition = 200,
    int colorHex = 0xFFA78BFA,
  });

  Future<Either<Failure, PlotCard>> updateCardPosition(
    String id,
    double x,
    double y,
  );

  Future<Either<Failure, List<PlotCard>>> getAllCards();

  Future<Either<Failure, PlotConnection>> createConnection(
    String sourceId,
    String targetId, {
    String? label,
  });

  Future<Either<Failure, List<PlotConnection>>> getAllConnections();

  Future<Either<Failure, Unit>> deleteCard(String id);

  Future<Either<Failure, Unit>> deleteConnection(String id);
}
