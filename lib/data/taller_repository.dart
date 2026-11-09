import 'package:drift/drift.dart';

import 'database/app_database.dart';
import 'models/taller_models.dart' as modelos;

class TallerRepository {
  final AppDatabase db;

  TallerRepository(this.db);

  modelos.EstadoOrden _estadoDesdeTexto(String estado) {
    switch (estado) {
      case 'recibida':
        return modelos.EstadoOrden.recibida;
      case 'enDiagnostico':
      case 'en diagnóstico':
        return modelos.EstadoOrden.enDiagnostico;
      case 'enReparacion':
      case 'en reparación':
        return modelos.EstadoOrden.enReparacion;
      case 'listaParaEntregar':
      case 'lista para entregar':
        return modelos.EstadoOrden.listaParaEntregar;
      case 'entregada':
        return modelos.EstadoOrden.entregada;
      case 'cancelada':
        return modelos.EstadoOrden.cancelada;
      default:
        return modelos.EstadoOrden.recibida;
    }
  }

  String _estadoATexto(modelos.EstadoOrden estado) {
    return estado.name;
  }

  Future<List<modelos.Cliente>> obtenerClientes() async {
    final registros = await db.select(db.clientes).get();

    return registros.map((registro) {
      return modelos.Cliente(
        id: registro.id,
        nombre: registro.nombre,
        telefono: registro.telefono,
        direccion: registro.direccion,
      );
    }).toList();
  }

  Future<List<modelos.Vehiculo>> obtenerVehiculos() async {
    final registros = await db.select(db.vehiculos).get();

    return registros.map((registro) {
      return modelos.Vehiculo(
        id: registro.id,
        clienteId: registro.clienteId,
        matricula: registro.matricula,
        marca: registro.marca,
        modelo: registro.modelo,
        anio: registro.anio,
        ultimoKilometraje: registro.ultimoKilometraje,
      );
    }).toList();
  }

  Future<List<modelos.Mecanico>> obtenerMecanicos() async {
    final registros = await db.select(db.mecanicos).get();

    return registros.map((registro) {
      return modelos.Mecanico(
        id: registro.id,
        nombre: registro.nombre,
        telefono: registro.telefono,
      );
    }).toList();
  }

  Future<List<modelos.Repuesto>> obtenerRepuestos() async {
    final registros = await db.select(db.repuestos).get();

    return registros.map((registro) {
      return modelos.Repuesto(
        id: registro.id,
        nombre: registro.nombre,
        codigo: registro.codigo,
        precioVenta: registro.precioVenta,
        existencias: registro.existencias,
        stockMinimo: registro.stockMinimo,
      );
    }).toList();
  }

  Future<Map<String, modelos.Repuesto>> obtenerMapaRepuestos() async {
    final lista = await obtenerRepuestos();

    return {for (final repuesto in lista) repuesto.id: repuesto};
  }

  Future<modelos.OrdenServicio> _convertirOrden(Ordene orden) async {
    final trabajos = await (db.select(
      db.trabajos,
    )..where((t) => t.ordenId.equals(orden.id))).get();

    final repuestosUsados = await (db.select(
      db.repuestosUsados,
    )..where((t) => t.ordenId.equals(orden.id))).get();

    final pagos = await (db.select(
      db.pagos,
    )..where((t) => t.ordenId.equals(orden.id))).get();

    return modelos.OrdenServicio(
      id: orden.id,
      vehiculoId: orden.vehiculoId,
      fechaEntrada: orden.fechaEntrada,
      problemaReportado: orden.problemaReportado,
      mecanicoId: orden.mecanicoId,
      estado: _estadoDesdeTexto(orden.estado),
      trabajos: trabajos.map((trabajo) {
        return modelos.TrabajoRealizado(
          id: trabajo.id,
          descripcion: trabajo.descripcion,
          precioManoObra: trabajo.precioManoObra,
        );
      }).toList(),
      repuestosUsados: repuestosUsados.map((usado) {
        return modelos.RepuestoUsado(
          repuestoId: usado.repuestoId,
          cantidad: usado.cantidad,
        );
      }).toList(),
      pagos: pagos.map((pago) {
        return modelos.Pago(
          id: pago.id,
          cantidad: pago.cantidad,
          fecha: pago.fecha,
        );
      }).toList(),
    );
  }

  Future<List<modelos.OrdenServicio>> obtenerOrdenes() async {
    final registros = await (db.select(
      db.ordenes,
    )..orderBy([(t) => OrderingTerm.desc(t.fechaEntrada)])).get();

    final resultado = <modelos.OrdenServicio>[];

    for (final registro in registros) {
      resultado.add(await _convertirOrden(registro));
    }

    return resultado;
  }

  Future<List<modelos.Vehiculo>> vehiculosDeCliente(String clienteId) async {
    final registros = await (db.select(
      db.vehiculos,
    )..where((t) => t.clienteId.equals(clienteId))).get();

    return registros.map((registro) {
      return modelos.Vehiculo(
        id: registro.id,
        clienteId: registro.clienteId,
        matricula: registro.matricula,
        marca: registro.marca,
        modelo: registro.modelo,
        anio: registro.anio,
        ultimoKilometraje: registro.ultimoKilometraje,
      );
    }).toList();
  }

  Future<List<modelos.OrdenServicio>> ordenesDeVehiculo(
    String vehiculoId,
  ) async {
    final registros = await (db.select(
      db.ordenes,
    )..where((t) => t.vehiculoId.equals(vehiculoId))).get();

    final resultado = <modelos.OrdenServicio>[];

    for (final registro in registros) {
      resultado.add(await _convertirOrden(registro));
    }

    return resultado;
  }

  Future<List<modelos.OrdenServicio>> ordenesAbiertas() async {
    final ordenes = await obtenerOrdenes();

    return ordenes.where((orden) {
      return orden.estado != modelos.EstadoOrden.entregada &&
          orden.estado != modelos.EstadoOrden.cancelada;
    }).toList();
  }

  Future<modelos.Cliente?> buscarCliente(String id) async {
    final registro = await (db.select(
      db.clientes,
    )..where((t) => t.id.equals(id))).getSingleOrNull();

    if (registro == null) return null;

    return modelos.Cliente(
      id: registro.id,
      nombre: registro.nombre,
      telefono: registro.telefono,
      direccion: registro.direccion,
    );
  }

  Future<modelos.Vehiculo?> buscarVehiculo(String id) async {
    final registro = await (db.select(
      db.vehiculos,
    )..where((t) => t.id.equals(id))).getSingleOrNull();

    if (registro == null) return null;

    return modelos.Vehiculo(
      id: registro.id,
      clienteId: registro.clienteId,
      matricula: registro.matricula,
      marca: registro.marca,
      modelo: registro.modelo,
      anio: registro.anio,
      ultimoKilometraje: registro.ultimoKilometraje,
    );
  }

  Future<modelos.OrdenServicio?> buscarOrden(String id) async {
    final registro = await (db.select(
      db.ordenes,
    )..where((t) => t.id.equals(id))).getSingleOrNull();

    if (registro == null) return null;

    return _convertirOrden(registro);
  }

  Future<modelos.Repuesto?> buscarRepuesto(String id) async {
    final registro = await (db.select(
      db.repuestos,
    )..where((t) => t.id.equals(id))).getSingleOrNull();

    if (registro == null) return null;

    return modelos.Repuesto(
      id: registro.id,
      nombre: registro.nombre,
      codigo: registro.codigo,
      precioVenta: registro.precioVenta,
      existencias: registro.existencias,
      stockMinimo: registro.stockMinimo,
    );
  }

  Future<void> agregarCliente(modelos.Cliente cliente) async {
    await db
        .into(db.clientes)
        .insert(
          ClientesCompanion.insert(
            id: cliente.id,
            nombre: cliente.nombre,
            telefono: cliente.telefono,
            direccion: Value(cliente.direccion),
          ),
        );
  }

  Future<void> eliminarCliente(String clienteId) async {
    final vehiculos = await vehiculosDeCliente(clienteId);

    if (vehiculos.isNotEmpty) {
      throw StateError('No se puede eliminar un cliente que tiene vehículos');
    }

    await (db.delete(db.clientes)..where((t) => t.id.equals(clienteId))).go();
  }

  Future<void> agregarVehiculo(modelos.Vehiculo vehiculo) async {
    final cliente = await buscarCliente(vehiculo.clienteId);

    if (cliente == null) {
      throw StateError('El cliente seleccionado no existe');
    }

    final existente = await (db.select(
      db.vehiculos,
    )..where((t) => t.matricula.equals(vehiculo.matricula))).getSingleOrNull();

    if (existente != null) {
      throw StateError('Ya existe un vehículo con esa matrícula');
    }

    await db
        .into(db.vehiculos)
        .insert(
          VehiculosCompanion.insert(
            id: vehiculo.id,
            clienteId: vehiculo.clienteId,
            matricula: vehiculo.matricula,
            marca: vehiculo.marca,
            modelo: vehiculo.modelo,
            anio: vehiculo.anio,
            ultimoKilometraje: vehiculo.ultimoKilometraje,
          ),
        );
  }

  Future<void> eliminarVehiculo(String vehiculoId) async {
    final ordenes = await ordenesDeVehiculo(vehiculoId);

    if (ordenes.isNotEmpty) {
      throw StateError('No se puede eliminar un vehículo con órdenes');
    }

    await (db.delete(db.vehiculos)..where((t) => t.id.equals(vehiculoId))).go();
  }

  Future<void> agregarOrden(modelos.OrdenServicio orden) async {
    final vehiculo = await buscarVehiculo(orden.vehiculoId);
    final mecanico = await (db.select(
      db.mecanicos,
    )..where((t) => t.id.equals(orden.mecanicoId))).getSingleOrNull();

    if (vehiculo == null) {
      throw StateError('El vehículo seleccionado no existe');
    }

    if (mecanico == null) {
      throw StateError('El mecánico seleccionado no existe');
    }

    await db
        .into(db.ordenes)
        .insert(
          OrdenesCompanion.insert(
            id: orden.id,
            vehiculoId: orden.vehiculoId,
            mecanicoId: orden.mecanicoId,
            fechaEntrada: orden.fechaEntrada,
            problemaReportado: orden.problemaReportado,
            estado: Value(_estadoATexto(orden.estado)),
          ),
        );
  }

  Future<void> eliminarOrden(String ordenId) async {
    await db.transaction(() async {
      final usados = await (db.select(
        db.repuestosUsados,
      )..where((t) => t.ordenId.equals(ordenId))).get();

      for (final usado in usados) {
        final repuesto = await (db.select(
          db.repuestos,
        )..where((t) => t.id.equals(usado.repuestoId))).getSingleOrNull();

        if (repuesto != null) {
          await (db.update(
            db.repuestos,
          )..where((t) => t.id.equals(usado.repuestoId))).write(
            RepuestosCompanion(
              existencias: Value(repuesto.existencias + usado.cantidad),
            ),
          );
        }
      }

      await (db.delete(db.ordenes)..where((t) => t.id.equals(ordenId))).go();
    });
  }

  Future<void> actualizarEstadoOrden(
    String ordenId,
    modelos.EstadoOrden nuevoEstado,
  ) async {
    final orden = await buscarOrden(ordenId);

    if (orden == null) {
      throw StateError('La orden no existe');
    }

    await (db.update(db.ordenes)..where((t) => t.id.equals(ordenId))).write(
      OrdenesCompanion(estado: Value(_estadoATexto(nuevoEstado))),
    );
  }

  Future<void> agregarTrabajo(
    String ordenId,
    modelos.TrabajoRealizado trabajo,
  ) async {
    final orden = await buscarOrden(ordenId);

    if (orden == null) {
      throw StateError('La orden no existe');
    }

    if (trabajo.precioManoObra < 0) {
      throw StateError('El precio no puede ser negativo');
    }

    await db
        .into(db.trabajos)
        .insert(
          TrabajosCompanion.insert(
            id: trabajo.id,
            ordenId: ordenId,
            descripcion: trabajo.descripcion,
            precioManoObra: trabajo.precioManoObra,
          ),
        );
  }

  Future<void> agregarRepuestoAOrden(
    String ordenId,
    String repuestoId,
    int cantidad,
  ) async {
    if (cantidad <= 0) {
      throw StateError('La cantidad debe ser mayor que cero');
    }

    await db.transaction(() async {
      final orden = await (db.select(
        db.ordenes,
      )..where((t) => t.id.equals(ordenId))).getSingleOrNull();

      final repuesto = await (db.select(
        db.repuestos,
      )..where((t) => t.id.equals(repuestoId))).getSingleOrNull();

      if (orden == null || repuesto == null) {
        throw StateError('No se encontró la orden o el repuesto');
      }

      if (repuesto.existencias < cantidad) {
        throw StateError('No hay suficientes unidades disponibles');
      }

      final existente =
          await (db.select(db.repuestosUsados)..where(
                (t) =>
                    t.ordenId.equals(ordenId) & t.repuestoId.equals(repuestoId),
              ))
              .getSingleOrNull();

      if (existente == null) {
        await db
            .into(db.repuestosUsados)
            .insert(
              RepuestosUsadosCompanion.insert(
                id: '${ordenId}_$repuestoId',
                ordenId: ordenId,
                repuestoId: repuestoId,
                cantidad: cantidad,
              ),
            );
      } else {
        await (db.update(
          db.repuestosUsados,
        )..where((t) => t.id.equals(existente.id))).write(
          RepuestosUsadosCompanion(
            cantidad: Value(existente.cantidad + cantidad),
          ),
        );
      }

      await (db.update(
        db.repuestos,
      )..where((t) => t.id.equals(repuestoId))).write(
        RepuestosCompanion(existencias: Value(repuesto.existencias - cantidad)),
      );
    });
  }

  Future<double> _calcularTotalOrden(String ordenId) async {
    final trabajos = await (db.select(
      db.trabajos,
    )..where((t) => t.ordenId.equals(ordenId))).get();

    final usados = await (db.select(
      db.repuestosUsados,
    )..where((t) => t.ordenId.equals(ordenId))).get();

    double total = trabajos.fold(
      0,
      (suma, trabajo) => suma + trabajo.precioManoObra,
    );

    for (final usado in usados) {
      final repuesto = await (db.select(
        db.repuestos,
      )..where((t) => t.id.equals(usado.repuestoId))).getSingleOrNull();

      if (repuesto != null) {
        total += repuesto.precioVenta * usado.cantidad;
      }
    }

    return total;
  }

  Future<double> _calcularTotalPagado(String ordenId) async {
    final pagos = await (db.select(
      db.pagos,
    )..where((t) => t.ordenId.equals(ordenId))).get();

    return pagos.fold<double>(
      0.0,
      (double suma, pago) => suma + pago.cantidad.toDouble(),
    );
  }

  Future<void> agregarPago(String ordenId, modelos.Pago pago) async {
    if (pago.cantidad <= 0) {
      throw StateError('El pago debe ser mayor que cero');
    }

    await db.transaction(() async {
      final orden = await (db.select(
        db.ordenes,
      )..where((t) => t.id.equals(ordenId))).getSingleOrNull();

      if (orden == null) {
        throw StateError('La orden no existe');
      }

      final total = await _calcularTotalOrden(ordenId);
      final pagado = await _calcularTotalPagado(ordenId);
      final pendiente = total - pagado;

      if (pago.cantidad > pendiente) {
        throw StateError(
          'El pago supera el saldo pendiente de \$${pendiente.toStringAsFixed(2)}',
        );
      }

      await db
          .into(db.pagos)
          .insert(
            PagosCompanion.insert(
              id: pago.id,
              ordenId: ordenId,
              cantidad: pago.cantidad,
              fecha: pago.fecha,
            ),
          );
    });
  }

  Future<void> agregarRepuesto(modelos.Repuesto repuesto) async {
    await db
        .into(db.repuestos)
        .insert(
          RepuestosCompanion.insert(
            id: repuesto.id,
            nombre: repuesto.nombre,
            codigo: repuesto.codigo,
            precioVenta: repuesto.precioVenta,
            existencias: repuesto.existencias,
            stockMinimo: Value(repuesto.stockMinimo),
          ),
        );
  }

  Future<void> eliminarRepuesto(String repuestoId) async {
    final usado = await (db.select(
      db.repuestosUsados,
    )..where((t) => t.repuestoId.equals(repuestoId))).getSingleOrNull();

    if (usado != null) {
      throw StateError('No se puede eliminar un repuesto utilizado en órdenes');
    }

    await (db.delete(db.repuestos)..where((t) => t.id.equals(repuestoId))).go();
  }

  Future<List<modelos.Repuesto>> repuestosConStockBajo() async {
    final repuestos = await obtenerRepuestos();

    return repuestos.where((repuesto) {
      return repuesto.tieneStockBajo;
    }).toList();
  }

  Future<double> totalFacturado() async {
    final ordenes = await obtenerOrdenes();

    double total = 0;

    for (final orden in ordenes) {
      if (orden.estado == modelos.EstadoOrden.cancelada) continue;

      total += orden.totalManoObra;
      total += await _calcularTotalRepuestos(orden);
    }

    return total;
  }

  Future<double> _calcularTotalRepuestos(modelos.OrdenServicio orden) async {
    final mapa = await obtenerMapaRepuestos();
    return orden.totalRepuestos(mapa);
  }

  Future<double> totalPendiente() async {
    final ordenes = await obtenerOrdenes();
    final mapa = await obtenerMapaRepuestos();

    double total = 0;

    for (final orden in ordenes) {
      if (orden.estado == modelos.EstadoOrden.cancelada) continue;

      total += orden.totalPendiente(mapa);
    }

    return total;
  }

  Future<void> cerrar() async {
    await db.close();
  }
}
