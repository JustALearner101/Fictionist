import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import '../database/app_database.dart';
import '../database/tables/quick_capture_table.dart';

part 'quick_capture_dao.g.dart';

@lazySingleton
@DriftAccessor(tables: [QuickCaptures])
class QuickCaptureDao extends DatabaseAccessor<AppDatabase>
    with _$QuickCaptureDaoMixin {
  QuickCaptureDao(AppDatabase db) : super(db);

  Future<int> insertCapture(QuickCapturesCompanion entry) {
    return into(quickCaptures).insert(entry);
  }

  Future<int> deleteCapture(String id) {
    return (delete(quickCaptures)..where((t) => t.id.equals(id))).go();
  }

  Future<List<QuickCaptureRow>> getUnprocessedOrdered() {
    return (select(quickCaptures)
          ..where((t) => t.isProcessed.equals(false))
          ..orderBy([
            (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)
          ]))
        .get();
  }

  Future<int> markProcessed(String id) {
    return (update(quickCaptures)..where((t) => t.id.equals(id)))
        .write(const QuickCapturesCompanion(isProcessed: Value(true)));
  }

  Future<QuickCaptureRow?> getById(String id) {
    return (select(quickCaptures)..where((t) => t.id.equals(id))).getSingleOrNull();
  }
}
