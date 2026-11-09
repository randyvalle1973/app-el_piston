enum EstadoOrden {
  recibida,
  enDiagnostico,
  enReparacion,
  listaParaEntregar,
  entregada,
  cancelada,
}

class Cliente {
  final String id;
  String nombre;
  String telefono;
  String? direccion;

  Cliente({
    required this.id,
    required this.nombre,
    required this.telefono,
    this.direccion,
  });
}

class Vehiculo {
  final String id;
  final String clienteId;
  String matricula;
  String marca;
  String modelo;
  int anio;
  int ultimoKilometraje;

  Vehiculo({
    required this.id,
    required this.clienteId,
    required this.matricula,
    required this.marca,
    required this.modelo,
    required this.anio,
    required this.ultimoKilometraje,
  });
}

class Mecanico {
  final String id;
  String nombre;
  String telefono;

  Mecanico({required this.id, required this.nombre, required this.telefono});
}

class TrabajoRealizado {
  final String id;
  String descripcion;
  double precioManoObra;

  TrabajoRealizado({
    required this.id,
    required this.descripcion,
    required this.precioManoObra,
  });
}

class Repuesto {
  final String id;
  String nombre;
  String codigo;
  double precioVenta;
  int existencias;
  int stockMinimo;

  Repuesto({
    required this.id,
    required this.nombre,
    required this.codigo,
    required this.precioVenta,
    required this.existencias,
    this.stockMinimo = 5,
  });

  bool get tieneStockBajo => existencias <= stockMinimo;
}

class RepuestoUsado {
  final String repuestoId;
  int cantidad;

  RepuestoUsado({required this.repuestoId, required this.cantidad});
}

class Pago {
  final String id;
  double cantidad;
  DateTime fecha;

  Pago({required this.id, required this.cantidad, required this.fecha});
}

class OrdenServicio {
  final String id;
  final String vehiculoId;
  final DateTime fechaEntrada;
  String problemaReportado;
  String mecanicoId;
  EstadoOrden estado;
  final List<TrabajoRealizado> trabajos;
  final List<RepuestoUsado> repuestosUsados;
  final List<Pago> pagos;

  OrdenServicio({
    required this.id,
    required this.vehiculoId,
    required this.fechaEntrada,
    required this.problemaReportado,
    required this.mecanicoId,
    this.estado = EstadoOrden.recibida,
    List<TrabajoRealizado>? trabajos,
    List<RepuestoUsado>? repuestosUsados,
    List<Pago>? pagos,
  }) : trabajos = trabajos ?? [],
       repuestosUsados = repuestosUsados ?? [],
       pagos = pagos ?? [];

  double get totalManoObra {
    return trabajos.fold(0, (total, trabajo) => total + trabajo.precioManoObra);
  }

  double totalRepuestos(Map<String, Repuesto> repuestos) {
    return repuestosUsados.fold(0, (total, usado) {
      final repuesto = repuestos[usado.repuestoId];

      if (repuesto == null) return total;

      return total + repuesto.precioVenta * usado.cantidad;
    });
  }

  double get totalPagado {
    return pagos.fold(0, (total, pago) => total + pago.cantidad);
  }

  double totalPendiente(Map<String, Repuesto> repuestos) {
    final total = totalManoObra + totalRepuestos(repuestos);
    return (total - totalPagado).clamp(0, double.infinity).toDouble();
  }
}
