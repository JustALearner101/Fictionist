import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import 'package:fictionist/core/error/failure.dart';
import 'package:fictionist/data/dao/plot_dao.dart';
import 'package:fictionist/data/database/app_database.dart';
import 'package:fictionist/domain/plot/plot_card.dart';

@LazySingleton()
class PlotRepository {
  final PlotDao _dao;
  PlotRepository(this._dao);

  Future<Either<Failure, PlotCard>> createCard({
    required String title,
    String? summary,
    double xPosition = 200,
    double yPosition = 200,
    int colorHex = 0xFFA78BFA,
  }) async {
    try {
      final now = DateTime.now();
      final card = PlotCard(
        id: const Uuid().v4(),
        title: title,
        summary: summary,
        xPosition: xPosition,
        yPosition: yPosition,
        colorHex: colorHex,
        createdAt: now,
        updatedAt: now,
      );
      await _dao.insertCard(PlotCardsCompanion(
        id: Value(card.id),
        title: Value(card.title),
        summary: Value(card.summary),
        xPosition: Value(card.xPosition),
        yPosition: Value(card.yPosition),
        colorHex: Value(card.colorHex),
        isDeleted: const Value(false),
        createdAt: Value(card.createdAt),
        updatedAt: Value(card.updatedAt),
      ));
      return Right(card);
    } catch (e) {
      return Left(Failure.database(message: 'Failed to create plot card', originalError: e));
    }
  }

  Future<Either<Failure, PlotCard>> updateCardPosition(String id, double x, double y) async {
    try {
      await _dao.updateCard(PlotCardsCompanion(
        id: Value(id),
        xPosition: Value(x),
        yPosition: Value(y),
        updatedAt: Value(DateTime.now()),
      ));
      return Right(PlotCard(id: id, title: '', xPosition: x, yPosition: y, createdAt: DateTime.now(), updatedAt: DateTime.now()));
    } catch (e) {
      return Left(Failure.database(message: 'Failed to update card position', originalError: e));
    }
  }

  Future<Either<Failure, List<PlotCard>>> getAllCards() async {
    try {
      final rows = await _dao.getAllActiveCards();
      return Right(rows.map((r) => PlotCard(
        id: r.id, title: r.title, summary: r.summary,
        xPosition: r.xPosition, yPosition: r.yPosition,
        colorHex: r.colorHex, isDeleted: r.isDeleted,
        createdAt: r.createdAt, updatedAt: r.updatedAt,
      )).toList());
    } catch (e) {
      return Left(Failure.database(message: 'Failed to load plot cards', originalError: e));
    }
  }

  Future<Either<Failure, PlotConnection>> createConnection(String sourceId, String targetId, {String? label}) async {
    try {
      final conn = PlotConnection(
        id: const Uuid().v4(), sourceId: sourceId, targetId: targetId,
        label: label, createdAt: DateTime.now(),
      );
      await _dao.insertConnection(PlotConnectionsCompanion(
        id: Value(conn.id), sourceId: Value(conn.sourceId),
        targetId: Value(conn.targetId), label: Value(conn.label),
        isDeleted: const Value(false), createdAt: Value(conn.createdAt),
      ));
      return Right(conn);
    } catch (e) {
      return Left(Failure.database(message: 'Failed to create connection', originalError: e));
    }
  }

  Future<Either<Failure, List<PlotConnection>>> getAllConnections() async {
    try {
      final rows = await _dao.getAllActiveConnections();
      return Right(rows.map((r) => PlotConnection(
        id: r.id, sourceId: r.sourceId, targetId: r.targetId,
        label: r.label, isDeleted: r.isDeleted, createdAt: r.createdAt,
      )).toList());
    } catch (e) {
      return Left(Failure.database(message: 'Failed to load connections', originalError: e));
    }
  }

  Future<Either<Failure, Unit>> deleteCard(String id) async {
    try {
      await _dao.deleteCard(id);
      return const Right(unit);
    } catch (e) {
      return Left(Failure.database(message: 'Failed to delete card', originalError: e));
    }
  }

  Future<Either<Failure, Unit>> deleteConnection(String id) async {
    try {
      await _dao.deleteConnection(id);
      return const Right(unit);
    } catch (e) {
      return Left(Failure.database(message: 'Failed to delete connection', originalError: e));
    }
  }
}
