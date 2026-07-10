import 'package:drift/drift.dart';

@DataClassName('QuickCaptureRow')
class QuickCaptures extends Table {
  TextColumn get id => text()();
  TextColumn get rawText => text()();
  BoolColumn get isProcessed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
