import 'package:drift/drift.dart';

import 'ordenes_table.dart';

class Pagos extends Table {
  TextColumn get id => text()();

  TextColumn get ordenId =>
      text().references(Ordenes, #id, onDelete: KeyAction.cascade)();

  RealColumn get cantidad => real()();

  DateTimeColumn get fecha => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
