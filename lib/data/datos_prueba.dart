import 'database/app_database.dart';

import 'package:drift/drift.dart';

import 'database/app_database.dart';

class DatosPrueba {
  static Future<void> insertar(AppDatabase db) async {
    final clientesExistentes = await db.select(db.clientes).get();

    if (clientesExistentes.isNotEmpty) return;

    final hoy = DateTime.now();

    await db.transaction(() async {
      await db.batch((batch) {
        batch.insertAll(db.clientes, [
          ClientesCompanion.insert(
            id: 'C001',
            nombre: 'Carlos Rodríguez',
            telefono: '787-555-1001',
            direccion: const Value('San Juan'),
          ),
          ClientesCompanion.insert(
            id: 'C002',
            nombre: 'María González',
            telefono: '787-555-1002',
            direccion: const Value('Bayamón'),
          ),
          ClientesCompanion.insert(
            id: 'C003',
            nombre: 'José Martínez',
            telefono: '787-555-1003',
            direccion: const Value('Carolina'),
          ),
          ClientesCompanion.insert(
            id: 'C004',
            nombre: 'Ana Rivera',
            telefono: '787-555-1004',
            direccion: const Value('Caguas'),
          ),
        ]);

        batch.insertAll(db.mecanicos, [
          MecanicosCompanion.insert(
            id: 'M001',
            nombre: 'Pedro Sánchez',
            telefono: '787-555-2001',
          ),
          MecanicosCompanion.insert(
            id: 'M002',
            nombre: 'Luis Torres',
            telefono: '787-555-2002',
          ),
        ]);

        batch.insertAll(db.vehiculos, [
          VehiculosCompanion.insert(
            id: 'V001',
            clienteId: 'C001',
            matricula: 'ABC-123',
            marca: 'Toyota',
            modelo: 'Corolla',
            anio: 2018,
            ultimoKilometraje: 85000,
          ),
          VehiculosCompanion.insert(
            id: 'V002',
            clienteId: 'C001',
            matricula: 'XYZ-789',
            marca: 'Honda',
            modelo: 'Civic',
            anio: 2020,
            ultimoKilometraje: 62000,
          ),
          VehiculosCompanion.insert(
            id: 'V003',
            clienteId: 'C002',
            matricula: 'DEF-456',
            marca: 'Hyundai',
            modelo: 'Tucson',
            anio: 2019,
            ultimoKilometraje: 73000,
          ),
          VehiculosCompanion.insert(
            id: 'V004',
            clienteId: 'C003',
            matricula: 'GHI-234',
            marca: 'Kia',
            modelo: 'Rio',
            anio: 2017,
            ultimoKilometraje: 91000,
          ),
          VehiculosCompanion.insert(
            id: 'V005',
            clienteId: 'C004',
            matricula: 'JKL-567',
            marca: 'Nissan',
            modelo: 'Sentra',
            anio: 2021,
            ultimoKilometraje: 48000,
          ),
        ]);

        batch.insertAll(db.repuestos, [
          RepuestosCompanion.insert(
            id: 'R001',
            nombre: 'Filtro de aceite',
            codigo: 'FIL-001',
            precioVenta: 12.50,
            existencias: 3,
          ),
          RepuestosCompanion.insert(
            id: 'R002',
            nombre: 'Bujía',
            codigo: 'BUJ-002',
            precioVenta: 8.00,
            existencias: 16,
          ),
          RepuestosCompanion.insert(
            id: 'R003',
            nombre: 'Pastillas de freno',
            codigo: 'FRE-003',
            precioVenta: 45.00,
            existencias: 7,
          ),
          RepuestosCompanion.insert(
            id: 'R004',
            nombre: 'Aceite sintético',
            codigo: 'ACE-004',
            precioVenta: 35.00,
            existencias: 15,
          ),
          RepuestosCompanion.insert(
            id: 'R005',
            nombre: 'Batería',
            codigo: 'BAT-005',
            precioVenta: 120.00,
            existencias: 1,
          ),
          RepuestosCompanion.insert(
            id: 'R006',
            nombre: 'Filtro de aire',
            codigo: 'FIL-006',
            precioVenta: 18.00,
            existencias: 12,
          ),
        ]);

        batch.insertAll(db.ordenes, [
          OrdenesCompanion.insert(
            id: 'OS001',
            vehiculoId: 'V001',
            mecanicoId: 'M001',
            fechaEntrada: hoy.subtract(const Duration(days: 2)),
            problemaReportado: 'Problemas con el sistema de frenos',
            estado: const Value('en reparación'),
          ),
          OrdenesCompanion.insert(
            id: 'OS002',
            vehiculoId: 'V003',
            mecanicoId: 'M002',
            fechaEntrada: hoy,
            problemaReportado: 'Revisión general del vehículo',
          ),
          OrdenesCompanion.insert(
            id: 'OS003',
            vehiculoId: 'V004',
            mecanicoId: 'M001',
            fechaEntrada: hoy.subtract(const Duration(days: 3)),
            problemaReportado: 'Problemas en el sistema de encendido',
            estado: const Value('lista para entregar'),
          ),
          OrdenesCompanion.insert(
            id: 'OS004',
            vehiculoId: 'V005',
            mecanicoId: 'M002',
            fechaEntrada: hoy.subtract(const Duration(days: 5)),
            problemaReportado: 'Instalación de batería nueva',
            estado: const Value('entregada'),
          ),
        ]);

        batch.insertAll(db.trabajos, [
          TrabajosCompanion.insert(
            id: 'T001',
            ordenId: 'OS001',
            descripcion: 'Revisión de frenos',
            precioManoObra: 35.00,
          ),
          TrabajosCompanion.insert(
            id: 'T002',
            ordenId: 'OS003',
            descripcion: 'Reparación del sistema de encendido',
            precioManoObra: 60.00,
          ),
          TrabajosCompanion.insert(
            id: 'T003',
            ordenId: 'OS004',
            descripcion: 'Instalación de batería',
            precioManoObra: 25.00,
          ),
        ]);

        batch.insertAll(db.repuestosUsados, [
          RepuestosUsadosCompanion.insert(
            id: 'RU001',
            ordenId: 'OS001',
            repuestoId: 'R003',
            cantidad: 1,
          ),
          RepuestosUsadosCompanion.insert(
            id: 'RU002',
            ordenId: 'OS003',
            repuestoId: 'R002',
            cantidad: 4,
          ),
          RepuestosUsadosCompanion.insert(
            id: 'RU003',
            ordenId: 'OS004',
            repuestoId: 'R005',
            cantidad: 1,
          ),
        ]);

        batch.insertAll(db.pagos, [
          PagosCompanion.insert(
            id: 'P001',
            ordenId: 'OS001',
            cantidad: 20.00,
            fecha: hoy.subtract(const Duration(days: 1)),
          ),
          PagosCompanion.insert(
            id: 'P002',
            ordenId: 'OS004',
            cantidad: 145.00,
            fecha: hoy.subtract(const Duration(days: 4)),
          ),
        ]);
      });
    });
  }
}
