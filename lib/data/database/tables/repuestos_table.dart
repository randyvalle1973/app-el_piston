import 'package:drift/drift.dart';

class Repuestos extends Table {
  TextColumn get id => text()();

  TextColumn get nombre => text()();

  TextColumn get codigo => text().unique()();

  RealColumn get precioVenta => real()();

  IntColumn get existencias => integer()();

  IntColumn get stockMinimo => integer().withDefault(const Constant(5))();

  @override
  Set<Column> get primaryKey => {id};
}
