import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import 'package:fictionist/data/database/app_database.dart';
import 'package:fictionist/data/database/tables/plot_tables.dart';

part 'plot_dao.g.dart';

@lazySingleton
@DriftAccessor(tables: [PlotCards, PlotConnections])
class PlotDao extends DatabaseAccessor<AppDatabase> with _$PlotDaoMixin {
  PlotDao(AppDatabase db) : super(db);

  Future<void> insertCard(PlotCardsCompanion companion) =>
      into(plotCards).insert(companion);

  Future<void> insertConnection(PlotConnectionsCompanion companion) =>
      into(plotConnections).insert(companion);

  Future<List<PlotCardRow>> getAllActiveCards() =>
      (select(plotCards)..where((t) => t.isDeleted.equals(false))).get();

  Future<List<PlotConnectionRow>> getAllActiveConnections() =>
      (select(plotConnections)..where((t) => t.isDeleted.equals(false))).get();

  Future<bool> updateCard(PlotCardsCompanion companion) =>
      (update(plotCards)..where((t) => t.id.equals(companion.id.value)))
          .write(companion)
          .then((c) => c > 0);

  Future<int> deleteCard(String id) =>
      (update(plotCards)..where((t) => t.id.equals(id)))
          .write(const PlotCardsCompanion(isDeleted: Value(true)));

  Future<int> deleteConnection(String id) =>
      (update(plotConnections)..where((t) => t.id.equals(id)))
          .write(const PlotConnectionsCompanion(isDeleted: Value(true)));
}
