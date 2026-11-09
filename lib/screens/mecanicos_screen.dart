import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/taller_repository.dart';
import '../data/models/taller_models.dart' as modelos;

class MecanicosScreen extends StatefulWidget {
  final TallerRepository taller;

  const MecanicosScreen({super.key, required this.taller});

  @override
  State<MecanicosScreen> createState() => _MecanicosScreenState();
}

class _MecanicosScreenState extends State<MecanicosScreen> {
  static const Color naranja = Color(0xFFFF7A1A);

  List<modelos.Mecanico> mecanicos = [];
  List<modelos.OrdenServicio> ordenes = [];
  List<modelos.Vehiculo> vehiculos = [];

  bool cargando = true;

  bool get modoOscuro => Theme.of(context).brightness == Brightness.dark;

  Color get fondo =>
      modoOscuro ? const Color(0xFF121212) : const Color(0xFFF5F5F5);

  Color get superficie => modoOscuro ? const Color(0xFF1E1E1E) : Colors.white;

  Color get texto => modoOscuro ? Colors.white : const Color(0xFF222222);

  Color get textoSecundario => modoOscuro ? Colors.white70 : Colors.black54;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    try {
      final resultados = await Future.wait([
        widget.taller.obtenerMecanicos(),
        widget.taller.obtenerOrdenes(),
        widget.taller.obtenerVehiculos(),
      ]);

      if (!mounted) return;

      setState(() {
        mecanicos = resultados[0] as List<modelos.Mecanico>;
        ordenes = resultados[1] as List<modelos.OrdenServicio>;
        vehiculos = resultados[2] as List<modelos.Vehiculo>;
        cargando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => cargando = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudieron cargar los mecánicos'),
          backgroundColor: naranja,
        ),
      );
    }
  }

  List<modelos.OrdenServicio> _ordenesDelMecanico(modelos.Mecanico mecanico) {
    return ordenes.where((orden) => orden.mecanicoId == mecanico.id).toList();
  }

  List<modelos.OrdenServicio> _ordenesActivas(modelos.Mecanico mecanico) {
    return _ordenesDelMecanico(mecanico)
        .where(
          (orden) =>
              orden.estado != modelos.EstadoOrden.entregada &&
              orden.estado != modelos.EstadoOrden.cancelada,
        )
        .toList();
  }

  int _cantidadPorEstado(
    modelos.Mecanico mecanico,
    modelos.EstadoOrden estado,
  ) {
    return _ordenesDelMecanico(mecanico)
        .where((orden) => orden.estado == estado)
        .length;
  }

  int get totalOrdenesActivas {
    return ordenes
        .where(
          (orden) =>
              orden.estado != modelos.EstadoOrden.entregada &&
              orden.estado != modelos.EstadoOrden.cancelada,
        )
        .length;
  }

  int get totalOrdenesTerminadas {
    return ordenes
        .where((orden) => orden.estado == modelos.EstadoOrden.entregada)
        .length;
  }

  String _nombreEstado(modelos.EstadoOrden estado) {
    switch (estado) {
      case modelos.EstadoOrden.recibida:
        return 'Recibidas';
      case modelos.EstadoOrden.enDiagnostico:
        return 'En diagnóstico';
      case modelos.EstadoOrden.enReparacion:
        return 'En reparación';
      case modelos.EstadoOrden.listaParaEntregar:
        return 'Listas para entregar';
      case modelos.EstadoOrden.entregada:
        return 'Entregadas';
      case modelos.EstadoOrden.cancelada:
        return 'Canceladas';
    }
  }

  Color _colorEstado(modelos.EstadoOrden estado) {
    switch (estado) {
      case modelos.EstadoOrden.recibida:
        return Colors.blue;
      case modelos.EstadoOrden.enDiagnostico:
        return Colors.purple;
      case modelos.EstadoOrden.enReparacion:
        return naranja;
      case modelos.EstadoOrden.listaParaEntregar:
        return Colors.teal;
      case modelos.EstadoOrden.entregada:
        return Colors.green;
      case modelos.EstadoOrden.cancelada:
        return Colors.red;
    }
  }

  modelos.Vehiculo? _vehiculoDeOrden(modelos.OrdenServicio orden) {
    for (final vehiculo in vehiculos) {
      if (vehiculo.id == orden.vehiculoId) {
        return vehiculo;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: naranja,
        foregroundColor: Colors.white,
        title: const Text(
          'Mecánicos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator(color: naranja))
          : RefreshIndicator(
              color: naranja,
              onRefresh: _cargarDatos,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  _resumenGeneral(),
                  const SizedBox(height: 22),
                  Text(
                    'Personal del taller',
                    style: TextStyle(
                      color: texto,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (mecanicos.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(30),
                      child: Center(
                        child: Text(
                          'No hay mecánicos registrados',
                          style: TextStyle(color: textoSecundario),
                        ),
                      ),
                    ),
                  ...mecanicos.map(_tarjetaMecanico),
                ],
              ),
            ),
    );
  }

  Widget _resumenGeneral() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: naranja,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Actividad del taller',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _datoResumen(
                  totalOrdenesActivas.toString(),
                  'Órdenes activas',
                  Icons.build_circle_outlined,
                ),
              ),
              Expanded(
                child: _datoResumen(
                  totalOrdenesTerminadas.toString(),
                  'Entregadas',
                  Icons.check_circle_outline,
                ),
              ),
              Expanded(
                child: _datoResumen(
                  mecanicos.length.toString(),
                  'Mecánicos',
                  Icons.engineering,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _datoResumen(String cantidad, String titulo, IconData icono) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icono, color: Colors.white, size: 23),
        const SizedBox(height: 8),
        Text(
          cantidad,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          titulo,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }

  Widget _tarjetaMecanico(modelos.Mecanico mecanico) {
    final asignadas = _ordenesDelMecanico(mecanico);
    final activas = _ordenesActivas(mecanico);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: superficie,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: naranja.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.engineering, color: naranja, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mecanico.nombre,
                      style: TextStyle(
                        color: texto,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      mecanico.telefono,
                      style: TextStyle(color: textoSecundario, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    activas.length.toString(),
                    style: const TextStyle(
                      color: naranja,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Activas',
                    style: TextStyle(color: textoSecundario, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'Distribución del trabajo',
            style: TextStyle(color: texto, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...[
            modelos.EstadoOrden.recibida,
            modelos.EstadoOrden.enDiagnostico,
            modelos.EstadoOrden.enReparacion,
            modelos.EstadoOrden.listaParaEntregar,
          ].map((estado) {
            final cantidad = _cantidadPorEstado(mecanico, estado);

            return _filaEstado(
              _nombreEstado(estado),
              cantidad,
              _colorEstado(estado),
            );
          }),
          Divider(height: 24, color: textoSecundario.withValues(alpha: 0.2)),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Órdenes asignadas en total',
                  style: TextStyle(color: textoSecundario),
                ),
              ),
              Text(
                asignadas.length.toString(),
                style: TextStyle(color: texto, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (activas.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  'No tiene órdenes pendientes',
                  style: TextStyle(color: textoSecundario),
                ),
              ),
            )
          else ...[
            Text(
              'Órdenes activas',
              style: TextStyle(color: texto, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...activas.map(_tarjetaOrden),
          ],
        ],
      ),
    );
  }

  Widget _filaEstado(String nombre, int cantidad, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              nombre,
              style: TextStyle(color: textoSecundario, fontSize: 13),
            ),
          ),
          Text(
            cantidad.toString(),
            style: TextStyle(color: texto, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _tarjetaOrden(modelos.OrdenServicio orden) {
    final vehiculo = _vehiculoDeOrden(orden);
    final color = _colorEstado(orden.estado);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.directions_car, color: naranja, size: 23),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vehiculo == null
                      ? 'Orden ${orden.id}'
                      : '${vehiculo.marca} ${vehiculo.modelo}',
                  style: TextStyle(color: texto, fontWeight: FontWeight.bold),
                ),
                if (vehiculo != null)
                  Text(
                    vehiculo.matricula,
                    style: TextStyle(color: textoSecundario, fontSize: 12),
                  ),
                const SizedBox(height: 5),
                Text(
                  orden.problemaReportado,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: textoSecundario, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _nombreEstado(orden.estado),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
