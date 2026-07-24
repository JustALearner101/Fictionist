import 'package:drift/drift.dart';

@DataClassName('ProjectRow')
class Projects extends Table {
  TextColumn get id => text().withLength(min: 36, max: 36)();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  TextColumn get description => text().nullable()();
  TextColumn get coverImagePath => text().nullable()();
  DateTimeColumn get lastAccessedAt => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
