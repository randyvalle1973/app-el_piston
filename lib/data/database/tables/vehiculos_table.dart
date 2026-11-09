import 'package:drift/drift.dart';

import 'clientes_table.dart';

class Vehiculos extends Table {
  TextColumn get id => text()();

  TextColumn get clienteId =>
      text().references(Clientes, #id, onDelete: KeyAction.restrict)();

  TextColumn get matricula => text().unique()();

  TextColumn get marca => text()();

  TextColumn get modelo => text()();

  IntColumn get anio => integer()();

  IntColumn get ultimoKilometraje => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
