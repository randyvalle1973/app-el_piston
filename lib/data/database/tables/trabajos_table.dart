import 'package:drift/drift.dart';

import 'ordenes_table.dart';

class Trabajos extends Table {
  TextColumn get id => text()();

  TextColumn get ordenId =>
      text().references(Ordenes, #id, onDelete: KeyAction.cascade)();

  TextColumn get descripcion => text()();

  RealColumn get precioManoObra => real()();

  @override
  Set<Column> get primaryKey => {id};
}
