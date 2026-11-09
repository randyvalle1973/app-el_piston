import 'package:drift/drift.dart';

import 'vehiculos_table.dart';
import 'mecanicos_table.dart';

class Ordenes extends Table {
  TextColumn get id => text()();

  TextColumn get vehiculoId =>
      text().references(Vehiculos, #id, onDelete: KeyAction.restrict)();

  TextColumn get mecanicoId =>
      text().references(Mecanicos, #id, onDelete: KeyAction.restrict)();

  DateTimeColumn get fechaEntrada => dateTime()();

  TextColumn get problemaReportado => text()();

  TextColumn get estado => text().withDefault(const Constant('recibida'))();

  @override
  Set<Column> get primaryKey => {id};
}
