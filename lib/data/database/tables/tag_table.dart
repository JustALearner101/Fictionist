import 'package:drift/drift.dart';

@DataClassName('TagRow')
class Tags extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().unique().withLength(min: 1, max: 100)();
  IntColumn get color => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
