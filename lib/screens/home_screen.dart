import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/taller_repository.dart';
import '../data/models/taller_models.dart' as modelos;

class HomeScreen extends StatefulWidget {
  final TallerRepository taller;

  const HomeScreen({super.key, required this.taller});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool get modoOscuro => Theme.of(context).brightness == Brightness.dark;

  bool cargando = true;
  String? errorCarga;

  static const Color naranja = Color(0xFFFF7A1A);

  List<modelos.OrdenServicio> ordenes = [];
  List<modelos.Vehiculo> vehiculos = [];
  List<modelos.Cliente> clientes = [];
  List<modelos.Repuesto> repuestosBajos = [];

  Color get fondo =>
      modoOscuro ? const Color(0xFF171717) : const Color(0xFFF7F7F7);

  Color get superficie => modoOscuro ? const Color(0xFF252525) : Colors.white;

  Color get texto => modoOscuro ? Colors.white : const Color(0xFF252525);

  Color get textoSecundario => modoOscuro ? Colors.white60 : Colors.black54;

  TallerRepository get taller => widget.taller;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    try {
      final resultados = await Future.wait([
        taller.obtenerOrdenes(),
        taller.obtenerVehiculos(),
        taller.obtenerClientes(),
        taller.repuestosConStockBajo(),
      ]);

      if (!mounted) return;

      setState(() {
        ordenes = resultados[0] as List<modelos.OrdenServicio>;
        vehiculos = resultados[1] as List<modelos.Vehiculo>;
        clientes = resultados[2] as List<modelos.Cliente>;
        repuestosBajos = resultados[3] as List<modelos.Repuesto>;
        cargando = false;
        errorCarga = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        cargando = false;
        errorCarga = e.toString();
      });
    }
  }

  List<modelos.OrdenServicio> get ordenesRecientes {
    final lista = [...ordenes];
    lista.sort((a, b) => b.fechaEntrada.compareTo(a.fechaEntrada));
    return lista.take(4).toList();
  }

  int get ordenesAbiertas => ordenes.where((orden) {
    return orden.estado != modelos.EstadoOrden.entregada &&
        orden.estado != modelos.EstadoOrden.cancelada;
  }).length;

  int get ordenesEnReparacion => ordenes
      .where((orden) => orden.estado == modelos.EstadoOrden.enReparacion)
      .length;

  int get ordenesPorEntregar => ordenes
      .where((orden) => orden.estado == modelos.EstadoOrden.listaParaEntregar)
      .length;

  int get cantidadRepuestosBajos => repuestosBajos.length;

  modelos.Vehiculo? obtenerVehiculo(String id) {
    for (final vehiculo in vehiculos) {
      if (vehiculo.id == id) return vehiculo;
    }
    return null;
  }

  modelos.Cliente? obtenerCliente(String id) {
    for (final cliente in clientes) {
      if (cliente.id == id) return cliente;
    }
    return null;
  }

  String nombreEstado(modelos.EstadoOrden estado) {
    switch (estado) {
      case modelos.EstadoOrden.recibida:
        return 'Recibida';
      case modelos.EstadoOrden.enDiagnostico:
        return 'En diagnóstico';
      case modelos.EstadoOrden.enReparacion:
        return 'En reparación';
      case modelos.EstadoOrden.listaParaEntregar:
        return 'Lista para entregar';
      case modelos.EstadoOrden.entregada:
        return 'Entregada';
      case modelos.EstadoOrden.cancelada:
        return 'Cancelada';
    }
  }

  Color colorEstado(modelos.EstadoOrden estado) {
    switch (estado) {
      case modelos.EstadoOrden.recibida:
        return Colors.blue;
      case modelos.EstadoOrden.enDiagnostico:
        return Colors.purple;
      case modelos.EstadoOrden.enReparacion:
        return naranja;
      case modelos.EstadoOrden.listaParaEntregar:
        return Colors.green;
      case modelos.EstadoOrden.entregada:
        return Colors.teal;
      case modelos.EstadoOrden.cancelada:
        return Colors.red;
    }
  }

  String fechaFormato(DateTime fecha) {
    return '${fecha.day.toString().padLeft(2, '0')}/'
        '${fecha.month.toString().padLeft(2, '0')}/'
        '${fecha.year}';
  }

  Future<void> _cambiarEstado(modelos.OrdenServicio orden) async {
    final nuevoEstado = await showModalBottomSheet<modelos.EstadoOrden>(
      context: context,
      backgroundColor: superficie,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cambiar estado de la orden',
                  style: TextStyle(
                    color: texto,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...modelos.EstadoOrden.values.map((estado) {
                  final seleccionado = orden.estado == estado;

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.circle,
                      color: colorEstado(estado),
                      size: 13,
                    ),
                    title: Text(
                      nombreEstado(estado),
                      style: TextStyle(
                        color: texto,
                        fontWeight: seleccionado
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    trailing: seleccionado
                        ? const Icon(Icons.check, color: naranja)
                        : null,
                    onTap: () => Navigator.pop(context, estado),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted || nuevoEstado == null || nuevoEstado == orden.estado) {
      return;
    }

    try {
      await taller.actualizarEstadoOrden(orden.id, nuevoEstado);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Estado actualizado: ${nombreEstado(nuevoEstado)}'),
          backgroundColor: Colors.green,
        ),
      );

      await _cargarDatos();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo actualizar el estado: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _botonNuevaOrden() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: () => context.go('/ordenes/nueva'),
        style: ElevatedButton.styleFrom(
          backgroundColor: naranja,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: const Icon(Icons.add_circle_outline, size: 23),
        label: const Text(
          'Registrar nueva orden',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      body: SafeArea(
        child: Column(
          children: [
            _encabezado(),
            Expanded(
              child: cargando
                  ? const Center(
                      child: CircularProgressIndicator(color: naranja),
                    )
                  : errorCarga != null
                  ? _errorCarga()
                  : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _bienvenida(),
                          const SizedBox(height: 20),
                          _botonNuevaOrden(),
                          const SizedBox(height: 24),
                          _tituloSeccion('Resumen general'),
                          const SizedBox(height: 14),
                          _estadisticas(),
                          const SizedBox(height: 28),
                          _tituloSeccion('Órdenes recientes'),
                          const SizedBox(height: 14),
                          _listaOrdenes(),
                          const SizedBox(height: 26),
                          _tituloSeccion('Alertas de inventario'),
                          const SizedBox(height: 14),
                          _alertasInventario(),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _navegacionInferior(),
    );
  }

  Widget _errorCarga() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 45),
            const SizedBox(height: 12),
            Text(
              'No se pudieron cargar los datos.',
              style: TextStyle(color: texto, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              errorCarga ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(color: textoSecundario, fontSize: 12),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  cargando = true;
                  errorCarga = null;
                });
                _cargarDatos();
              },
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _encabezado() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 17),
      decoration: const BoxDecoration(
        color: naranja,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.go('/clientes'),
            icon: const Icon(
              Icons.people_outline,
              color: Colors.white,
              size: 25,
            ),
            tooltip: 'Clientes',
            visualDensity: VisualDensity.compact,
          ),
          IconButton(
            onPressed: () => context.go('/vehiculos'),
            icon: const Icon(
              Icons.directions_car_outlined,
              color: Colors.white,
              size: 25,
            ),
            tooltip: 'Vehículos',
            visualDensity: VisualDensity.compact,
          ),
          const SizedBox(width: 4),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'El Pistón',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Taller Mecánico',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bienvenida() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¡Hola!',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: texto,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Esto es lo que sucede hoy en tu taller.',
                style: TextStyle(fontSize: 13, color: textoSecundario),
              ),
            ],
          ),
        ),
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: naranja.withValues(alpha: 0.13),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(
            Icons.directions_car_filled,
            color: naranja,
            size: 34,
          ),
        ),
      ],
    );
  }

  Widget _tituloSeccion(String titulo) {
    return Text(
      titulo,
      style: TextStyle(color: texto, fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _estadisticas() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.65,
      children: [
        _tarjetaEstadistica(
          'Órdenes abiertas',
          ordenesAbiertas.toString(),
          Icons.assignment_outlined,
          Colors.blue,
        ),
        _tarjetaEstadistica(
          'En reparación',
          ordenesEnReparacion.toString(),
          Icons.build_outlined,
          naranja,
        ),
        _tarjetaEstadistica(
          'Por entregar',
          ordenesPorEntregar.toString(),
          Icons.check_circle_outline,
          Colors.green,
        ),
        _tarjetaEstadistica(
          'Repuestos por agotar',
          cantidadRepuestosBajos.toString(),
          Icons.inventory_2_outlined,
          Colors.redAccent,
        ),
      ],
    );
  }

  Widget _tarjetaEstadistica(
    String titulo,
    String cantidad,
    IconData icono,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: superficie,
        borderRadius: BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: modoOscuro ? 0.08 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icono, color: color, size: 22),
              const Spacer(),
              Text(
                cantidad,
                style: TextStyle(
                  color: texto,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Text(
            titulo,
            style: TextStyle(
              color: textoSecundario,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _listaOrdenes() {
    final recientes = ordenesRecientes;

    if (recientes.isEmpty) {
      return _mensajeVacio('No hay órdenes registradas todavía.');
    }

    return Column(
      children: recientes.map((orden) {
        final vehiculo = obtenerVehiculo(orden.vehiculoId);
        final cliente = vehiculo == null
            ? null
            : obtenerCliente(vehiculo.clienteId);

        final estadoColor = colorEstado(orden.estado);

        return GestureDetector(
          onLongPress: () => _cambiarEstado(orden),
          child: Container(
            margin: const EdgeInsets.only(bottom: 11),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: superficie,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: naranja.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.directions_car_outlined,
                    color: naranja,
                    size: 25,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vehiculo?.matricula ?? 'Sin vehículo',
                        style: TextStyle(
                          color: texto,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${vehiculo?.marca ?? ''} ${vehiculo?.modelo ?? ''}',
                        style: TextStyle(color: textoSecundario, fontSize: 12),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        cliente?.nombre ?? 'Cliente desconocido',
                        style: TextStyle(color: textoSecundario, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: estadoColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        nombreEstado(orden.estado),
                        style: TextStyle(
                          color: estadoColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      fechaFormato(orden.fechaEntrada),
                      style: TextStyle(color: textoSecundario, fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _alertasInventario() {
    if (repuestosBajos.isEmpty) {
      return _mensajeVacio('No hay repuestos con stock bajo.');
    }

    return Column(
      children: repuestosBajos.map((repuesto) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: superficie,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.redAccent.withValues(alpha: 0.25)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.redAccent,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      repuesto.nombre,
                      style: TextStyle(
                        color: texto,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Quedan ${repuesto.existencias} unidades',
                      style: TextStyle(color: textoSecundario, fontSize: 11),
                    ),
                  ],
                ),
              ),
              const Text(
                'Stock bajo',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _mensajeVacio(String mensaje) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: superficie,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        mensaje,
        textAlign: TextAlign.center,
        style: TextStyle(color: textoSecundario, fontSize: 12),
      ),
    );
  }

  Widget _navegacionInferior() {
    return NavigationBar(
      backgroundColor: superficie,
      indicatorColor: naranja.withValues(alpha: 0.15),
      selectedIndex: 0,
      onDestinationSelected: (index) {
        switch (index) {
          case 0:
            context.go('/');
            break;
          case 1:
            context.go('/ordenes');
            break;
          case 2:
            context.go('/inventario');
            break;
          case 3:
            context.go('/perfil');
            break;
        }
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home, color: naranja),
          label: 'Inicio',
        ),
        NavigationDestination(
          icon: Icon(Icons.assignment_outlined),
          label: 'Órdenes',
        ),
        NavigationDestination(
          icon: Icon(Icons.inventory_2_outlined),
          label: 'Inventario',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          label: 'Perfil',
        ),
      ],
    );
  }
}
