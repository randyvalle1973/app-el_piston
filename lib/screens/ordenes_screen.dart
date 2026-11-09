import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/taller_repository.dart';
import '../data/models/taller_models.dart' as modelos;

class OrdenesScreen extends StatefulWidget {
  final TallerRepository taller;

  const OrdenesScreen({super.key, required this.taller});

  @override
  State<OrdenesScreen> createState() => _OrdenesScreenState();
}

class _OrdenesScreenState extends State<OrdenesScreen> {
  static const Color naranja = Color(0xFFFF7A1A);
  bool get modoOscuro => Theme.of(context).brightness == Brightness.dark;
  bool cargando = true;
  String? errorCarga;
  String busqueda = '';
  modelos.EstadoOrden? filtroEstado;

  final TextEditingController controladorBusqueda = TextEditingController();

  List<modelos.OrdenServicio> ordenes = [];
  List<modelos.Vehiculo> vehiculos = [];
  List<modelos.Cliente> clientes = [];
  List<modelos.Mecanico> mecanicos = [];

  TallerRepository get taller => widget.taller;

  Color get fondo =>
      modoOscuro ? const Color(0xFF171717) : const Color(0xFFF7F7F7);

  Color get superficie => modoOscuro ? const Color(0xFF252525) : Colors.white;

  Color get texto => modoOscuro ? Colors.white : const Color(0xFF252525);

  Color get textoSecundario => modoOscuro ? Colors.white60 : Colors.black54;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  @override
  void dispose() {
    controladorBusqueda.dispose();
    super.dispose();
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

  Future<void> _cargarDatos() async {
    try {
      final resultados = await Future.wait([
        taller.obtenerOrdenes(),
        taller.obtenerVehiculos(),
        taller.obtenerClientes(),
        taller.obtenerMecanicos(),
      ]);

      if (!mounted) return;

      setState(() {
        ordenes = resultados[0] as List<modelos.OrdenServicio>;
        vehiculos = resultados[1] as List<modelos.Vehiculo>;
        clientes = resultados[2] as List<modelos.Cliente>;
        mecanicos = resultados[3] as List<modelos.Mecanico>;
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

  modelos.Mecanico? obtenerMecanico(String id) {
    for (final mecanico in mecanicos) {
      if (mecanico.id == id) return mecanico;
    }
    return null;
  }

  List<modelos.OrdenServicio> get ordenesFiltradas {
    final resultado = ordenes.where((orden) {
      final vehiculo = obtenerVehiculo(orden.vehiculoId);
      final cliente = vehiculo == null
          ? null
          : obtenerCliente(vehiculo.clienteId);

      final coincideBusqueda =
          busqueda.isEmpty ||
          (vehiculo?.matricula.toLowerCase().contains(busqueda) ?? false) ||
          (cliente?.nombre.toLowerCase().contains(busqueda) ?? false) ||
          orden.problemaReportado.toLowerCase().contains(busqueda);

      final coincideEstado =
          filtroEstado == null || orden.estado == filtroEstado;

      return coincideBusqueda && coincideEstado;
    }).toList();

    resultado.sort((a, b) => b.fechaEntrada.compareTo(a.fechaEntrada));

    return resultado;
  }

  int cantidadEstado(modelos.EstadoOrden estado) {
    return ordenes.where((orden) => orden.estado == estado).length;
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
                  : RefreshIndicator(
                      color: naranja,
                      onRefresh: _cargarDatos,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _resumen(),
                            const SizedBox(height: 25),
                            _buscador(),
                            const SizedBox(height: 22),
                            _tituloSeccion('Filtrar por estado'),
                            const SizedBox(height: 12),
                            _filtros(),
                            const SizedBox(height: 23),
                            Row(
                              children: [
                                _tituloSeccion('Todas las órdenes'),
                                const Spacer(),
                                Text(
                                  '${ordenesFiltradas.length} resultados',
                                  style: TextStyle(
                                    color: textoSecundario,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            _listaOrdenes(),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _navegacionInferior(),
    );
  }

  Widget _encabezado() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
      decoration: const BoxDecoration(
        color: naranja,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.assignment_outlined,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Órdenes de servicio',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Gestión de trabajos del taller',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _resumen() {
    final abiertas = ordenes.where((orden) {
      return orden.estado != modelos.EstadoOrden.entregada &&
          orden.estado != modelos.EstadoOrden.cancelada;
    }).length;

    return Row(
      children: [
        Expanded(
          child: _tarjetaResumen(
            'Total',
            ordenes.length.toString(),
            Icons.assignment_outlined,
            naranja,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _tarjetaResumen(
            'Abiertas',
            abiertas.toString(),
            Icons.pending_actions,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _tarjetaResumen(
            'En reparación',
            cantidadEstado(modelos.EstadoOrden.enReparacion).toString(),
            Icons.build_outlined,
            Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _tarjetaResumen(
    String titulo,
    String cantidad,
    IconData icono,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: BoxDecoration(
        color: superficie,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, color: color, size: 21),
          const SizedBox(height: 9),
          Text(
            cantidad,
            style: TextStyle(
              color: texto,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            titulo,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: textoSecundario, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buscador() {
    return TextField(
      controller: controladorBusqueda,
      style: TextStyle(color: texto, fontSize: 14),
      onChanged: (valor) {
        setState(() {
          busqueda = valor.trim().toLowerCase();
        });
      },
      decoration: InputDecoration(
        hintText: 'Buscar matrícula, cliente o problema...',
        hintStyle: TextStyle(color: textoSecundario, fontSize: 12),
        prefixIcon: const Icon(Icons.search, color: naranja),
        suffixIcon: busqueda.isNotEmpty
            ? IconButton(
                onPressed: () {
                  controladorBusqueda.clear();
                  setState(() {
                    busqueda = '';
                  });
                },
                icon: Icon(Icons.close, color: textoSecundario),
              )
            : null,
        filled: true,
        fillColor: superficie,
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _tituloSeccion(String titulo) {
    return Text(
      titulo,
      style: TextStyle(color: texto, fontSize: 17, fontWeight: FontWeight.bold),
    );
  }

  Widget _filtros() {
    final estados = [null, ...modelos.EstadoOrden.values];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: estados.map((estado) {
          final seleccionado = filtroEstado == estado;
          final color = estado == null ? naranja : colorEstado(estado);

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(estado == null ? 'Todas' : nombreEstado(estado)),
              selected: seleccionado,
              onSelected: (_) {
                setState(() {
                  filtroEstado = estado;
                });
              },
              selectedColor: naranja.withOpacity(0.16),
              backgroundColor: superficie,
              labelStyle: TextStyle(
                color: seleccionado ? naranja : textoSecundario,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              side: BorderSide(
                color: seleccionado ? naranja : Colors.transparent,
              ),
              showCheckmark: false,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _listaOrdenes() {
    final lista = ordenesFiltradas;

    if (lista.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: superficie,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(
              Icons.assignment_late_outlined,
              size: 42,
              color: textoSecundario,
            ),
            const SizedBox(height: 10),
            Text(
              'No se encontraron órdenes',
              style: TextStyle(color: texto, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              'Prueba cambiando los filtros o la búsqueda.',
              textAlign: TextAlign.center,
              style: TextStyle(color: textoSecundario, fontSize: 12),
            ),
          ],
        ),
      );
    }

    return Column(
      children: lista.map((orden) {
        final vehiculo = obtenerVehiculo(orden.vehiculoId);
        final cliente = vehiculo == null
            ? null
            : obtenerCliente(vehiculo.clienteId);
        final mecanico = obtenerMecanico(orden.mecanicoId);
        final color = colorEstado(orden.estado);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: superficie,
            borderRadius: BorderRadius.circular(17),
          ),
          child: InkWell(
            onTap: () => _mostrarDetalle(orden, vehiculo, cliente, mecanico),
            onLongPress: () => _cambiarEstado(orden),
            borderRadius: BorderRadius.circular(17),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 43,
                        height: 43,
                        decoration: BoxDecoration(
                          color: naranja.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: const Icon(
                          Icons.directions_car_outlined,
                          color: naranja,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 11),
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
                            const SizedBox(height: 3),
                            Text(
                              '${vehiculo?.marca ?? ''} ${vehiculo?.modelo ?? ''}',
                              style: TextStyle(
                                color: textoSecundario,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          nombreEstado(orden.estado),
                          style: TextStyle(
                            color: color,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Divider(color: textoSecundario.withOpacity(0.15), height: 1),
                  const SizedBox(height: 12),
                  _datoOrden(
                    Icons.person_outline,
                    cliente?.nombre ?? 'Cliente desconocido',
                  ),
                  const SizedBox(height: 8),
                  _datoOrden(
                    Icons.engineering_outlined,
                    mecanico?.nombre ?? 'Mecánico no disponible',
                  ),
                  const SizedBox(height: 8),
                  _datoOrden(
                    Icons.calendar_today_outlined,
                    fechaFormato(orden.fechaEntrada),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          orden.problemaReportado,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: textoSecundario,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: naranja,
                        size: 15,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _datoOrden(IconData icono, String valor) {
    return Row(
      children: [
        Icon(icono, color: textoSecundario, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            valor,
            style: TextStyle(color: textoSecundario, fontSize: 11),
          ),
        ),
      ],
    );
  }

  void _mostrarDetalle(
    modelos.OrdenServicio orden,
    modelos.Vehiculo? vehiculo,
    modelos.Cliente? cliente,
    modelos.Mecanico? mecanico,
  ) {
    final color = colorEstado(orden.estado);

    showModalBottomSheet(
      context: context,
      backgroundColor: superficie,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 5,
                    decoration: BoxDecoration(
                      color: textoSecundario.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  'Detalle de la orden',
                  style: TextStyle(
                    color: texto,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    nombreEstado(orden.estado),
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _detalleFila(
                  'Matrícula',
                  vehiculo?.matricula ?? 'No disponible',
                ),
                _detalleFila(
                  'Vehículo',
                  '${vehiculo?.marca ?? ''} ${vehiculo?.modelo ?? ''}',
                ),
                _detalleFila('Cliente', cliente?.nombre ?? 'No disponible'),
                _detalleFila('Teléfono', cliente?.telefono ?? 'No disponible'),
                _detalleFila('Mecánico', mecanico?.nombre ?? 'No disponible'),
                _detalleFila(
                  'Fecha de entrada',
                  fechaFormato(orden.fechaEntrada),
                ),
                const SizedBox(height: 15),
                Text(
                  'Problema reportado',
                  style: TextStyle(
                    color: texto,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: fondo,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Text(
                    orden.problemaReportado,
                    style: TextStyle(color: textoSecundario, fontSize: 13),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: naranja,
                      side: const BorderSide(color: naranja),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                    child: const Text('Cerrar'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _detalleFila(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 115,
            child: Text(
              titulo,
              style: TextStyle(color: textoSecundario, fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              valor,
              style: TextStyle(
                color: texto,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
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
              'No se pudieron cargar las órdenes.',
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

  Widget _navegacionInferior() {
    return NavigationBar(
      backgroundColor: superficie,
      indicatorColor: naranja.withOpacity(0.15),
      selectedIndex: 1,
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
          selectedIcon: Icon(Icons.assignment, color: naranja),
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
