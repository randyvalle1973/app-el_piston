import 'package:drift/drift.dart';

class Clientes extends Table {
  TextColumn get id => text()();

  TextColumn get nombre => text()();

  TextColumn get telefono => text()();

  TextColumn get direccion => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
