import 'package:drift/drift.dart';

class Mecanicos extends Table {
  TextColumn get id => text()();

  TextColumn get nombre => text()();

  TextColumn get telefono => text()();

  @override
  Set<Column> get primaryKey => {id};
}
