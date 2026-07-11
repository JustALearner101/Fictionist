import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../database/tables/setup_payoff_table.dart';

part 'setup_payoff_dao.g.dart';

@DriftAccessor(tables: [SetupPayoffs])
class SetupPayoffDao extends DatabaseAccessor<AppDatabase>
    with _$SetupPayoffDaoMixin {
  SetupPayoffDao(AppDatabase db) : super(db);

  Future<List<SetupPayoffRow>> getAll() => select(setupPayoffs).get();

  Future<int> insert(SetupPayoffsCompanion entry) =>
      into(setupPayoffs).insert(entry);

  Future<void> markResolved(String id) =>
      (update(setupPayoffs)..where((t) => t.id.equals(id)))
          .write(SetupPayoffsCompanion(isResolved: const Value(true)));

  Future<void> remove(String id) =>
      (delete(setupPayoffs)..where((t) => t.id.equals(id))).go();
}
