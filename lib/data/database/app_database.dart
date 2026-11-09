import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/clientes_table.dart';
import 'tables/vehiculos_table.dart';
import 'tables/mecanicos_table.dart';
import 'tables/ordenes_table.dart';
import 'tables/trabajos_table.dart';
import 'tables/repuestos_table.dart';
import 'tables/repuestos_usados_table.dart';
import 'tables/pagos_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Clientes,
    Vehiculos,
    Mecanicos,
    Ordenes,
    Trabajos,
    Repuestos,
    RepuestosUsados,
    Pagos,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'el_piston'));

  @override
  int get schemaVersion => 1;
}
