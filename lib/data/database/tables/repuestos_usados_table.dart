import 'package:drift/drift.dart';

import 'ordenes_table.dart';
import 'repuestos_table.dart';

class RepuestosUsados extends Table {
  TextColumn get id => text()();

  TextColumn get ordenId =>
      text().references(Ordenes, #id, onDelete: KeyAction.cascade)();

  TextColumn get repuestoId =>
      text().references(Repuestos, #id, onDelete: KeyAction.restrict)();

  IntColumn get cantidad => integer()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {ordenId, repuestoId},
  ];
}
