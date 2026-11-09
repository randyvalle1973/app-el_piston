import 'package:flutter/material.dart';

import '../data/taller_repository.dart';
import '../data/models/taller_models.dart' as modelos;

class TrabajosScreen extends StatefulWidget {
  final TallerRepository taller;

  const TrabajosScreen({super.key, required this.taller});

  @override
  State<TrabajosScreen> createState() => _TrabajosScreenState();
}

class _TrabajosScreenState extends State<TrabajosScreen> {
  static const Color naranja = Color(0xFFFF7A1A);

  final TextEditingController busquedaController = TextEditingController();

  List<modelos.OrdenServicio> ordenes = [];
  List<modelos.Vehiculo> vehiculos = [];
  List<modelos.Mecanico> mecanicos = [];

  bool cargando = true;
  String? errorCarga;
  String busqueda = '';

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

  @override
  void dispose() {
    busquedaController.dispose();
    super.dispose();
  }

  Future<void> _cargarDatos() async {
    try {
      final resultados = await Future.wait([
        widget.taller.obtenerOrdenes(),
        widget.taller.obtenerVehiculos(),
        widget.taller.obtenerMecanicos(),
      ]);

      if (!mounted) return;

      setState(() {
        ordenes = resultados[0] as List<modelos.OrdenServicio>;
        vehiculos = resultados[1] as List<modelos.Vehiculo>;
        mecanicos = resultados[2] as List<modelos.Mecanico>;
        cargando = false;
        errorCarga = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        cargando = false;
        errorCarga = 'No se pudieron cargar los trabajos';
      });

      _mostrarMensaje(errorCarga!);
    }
  }

  List<modelos.OrdenServicio> get ordenesFiltradas {
    final consulta = busqueda.toLowerCase().trim();

    if (consulta.isEmpty) return ordenes;

    return ordenes.where((orden) {
      final vehiculo = _buscarVehiculo(orden.vehiculoId);
      final matricula = vehiculo?.matricula ?? '';

      return orden.id.toLowerCase().contains(consulta) ||
          orden.problemaReportado.toLowerCase().contains(consulta) ||
          matricula.toLowerCase().contains(consulta) ||
          orden.trabajos.any(
            (trabajo) => trabajo.descripcion.toLowerCase().contains(consulta),
          );
    }).toList();
  }

  modelos.Vehiculo? _buscarVehiculo(String id) {
    for (final vehiculo in vehiculos) {
      if (vehiculo.id == id) return vehiculo;
    }

    return null;
  }

  String _nombreMecanico(String id) {
    for (final mecanico in mecanicos) {
      if (mecanico.id == id) return mecanico.nombre;
    }

    return 'Mecánico no encontrado';
  }

  String _nombreEstado(modelos.EstadoOrden estado) {
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

  Color _colorEstado(modelos.EstadoOrden estado) {
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

  bool _permiteAgregarTrabajo(modelos.OrdenServicio orden) {
    return orden.estado != modelos.EstadoOrden.entregada &&
        orden.estado != modelos.EstadoOrden.cancelada;
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensaje), backgroundColor: naranja));
  }

  Future<void> _agregarTrabajo(modelos.OrdenServicio orden) async {
    final resultado = await showDialog<modelos.TrabajoRealizado>(
      context: context,
      builder: (dialogContext) =>
          _DialogoAgregarTrabajo(superficie: superficie, texto: texto),
    );

    if (!mounted || resultado == null) return;

    try {
      await widget.taller.agregarTrabajo(orden.id, resultado);

      if (!mounted) return;

      _mostrarMensaje('Trabajo registrado correctamente');
      await _cargarDatos();
    } catch (e) {
      if (!mounted) return;
      _mostrarMensaje('No se pudo registrar el trabajo: $e');
    }
  }

  Widget _tarjetaTrabajo(modelos.TrabajoRealizado trabajo) {
    return Container(
      margin: const EdgeInsets.only(top: 9),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: naranja.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.build_circle_outlined, color: naranja),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              trabajo.descripcion,
              style: TextStyle(color: texto, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '\$${trabajo.precioManoObra.toStringAsFixed(2)}',
            style: const TextStyle(color: naranja, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _tarjetaOrden(modelos.OrdenServicio orden) {
    final vehiculo = _buscarVehiculo(orden.vehiculoId);
    final totalManoObra = orden.totalManoObra;
    final estadoColor = _colorEstado(orden.estado);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: superficie,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Orden ${orden.id}',
                  style: TextStyle(
                    color: texto,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: estadoColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _nombreEstado(orden.estado),
                  style: TextStyle(
                    color: estadoColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.directions_car_outlined,
                color: naranja,
                size: 19,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  vehiculo == null
                      ? 'Vehículo no encontrado'
                      : '${vehiculo.marca} ${vehiculo.modelo} • ${vehiculo.matricula}',
                  style: TextStyle(color: texto, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.engineering_outlined,
                color: textoSecundario,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                _nombreMecanico(orden.mecanicoId),
                style: TextStyle(color: textoSecundario),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Problema reportado: ${orden.problemaReportado}',
            style: TextStyle(color: textoSecundario),
          ),
          const SizedBox(height: 14),
          Divider(color: textoSecundario.withValues(alpha: 0.15)),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Trabajos realizados (${orden.trabajos.length})',
                  style: TextStyle(color: texto, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                '\$${totalManoObra.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: naranja,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          if (orden.trabajos.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Center(
                child: Text(
                  'Todavía no hay trabajos registrados',
                  style: TextStyle(color: textoSecundario),
                ),
              ),
            )
          else
            ...orden.trabajos.map(_tarjetaTrabajo),
          if (_permiteAgregarTrabajo(orden)) ...[
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _agregarTrabajo(orden),
                icon: const Icon(Icons.add, color: naranja),
                label: const Text(
                  'Agregar trabajo',
                  style: TextStyle(color: naranja, fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: naranja.withValues(alpha: 0.5)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtradas = ordenesFiltradas;

    final totalTrabajos = ordenes.fold<int>(
      0,
      (total, orden) => total + orden.trabajos.length,
    );

    final totalManoObra = ordenes.fold<double>(
      0.0,
      (total, orden) => total + orden.totalManoObra,
    );

    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        backgroundColor: naranja,
        foregroundColor: Colors.white,
        title: const Text(
          'Trabajos realizados',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: naranja,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Control de mano de obra',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _resumen(
                        'Trabajos',
                        totalTrabajos.toString(),
                        Icons.build_outlined,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _resumen(
                        'Mano de obra',
                        '\$${totalManoObra.toStringAsFixed(2)}',
                        Icons.attach_money,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: busquedaController,
                  onChanged: (valor) {
                    setState(() {
                      busqueda = valor;
                    });
                  },
                  style: const TextStyle(color: Color(0xFF222222)),
                  decoration: InputDecoration(
                    hintText: 'Buscar orden, matrícula o trabajo...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: busqueda.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              busquedaController.clear();
                              setState(() {
                                busqueda = '';
                              });
                            },
                            icon: const Icon(Icons.close),
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: cargando
                ? const Center(child: CircularProgressIndicator(color: naranja))
                : errorCarga != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 50,
                            color: textoSecundario,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            errorCarga!,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: textoSecundario),
                          ),
                          TextButton(
                            onPressed: _cargarDatos,
                            child: const Text(
                              'Reintentar',
                              style: TextStyle(color: naranja),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : filtradas.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.build_outlined,
                          size: 60,
                          color: textoSecundario,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          busqueda.isEmpty
                              ? 'Todavía no hay órdenes registradas'
                              : 'No se encontraron resultados',
                          style: TextStyle(color: textoSecundario),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    color: naranja,
                    onRefresh: _cargarDatos,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filtradas.length,
                      itemBuilder: (context, index) {
                        return _tarjetaOrden(filtradas[index]);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _resumen(String titulo, String valor, IconData icono) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.17),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, color: Colors.white, size: 21),
          const SizedBox(height: 8),
          Text(
            valor,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            titulo,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _DialogoAgregarTrabajo extends StatefulWidget {
  final Color superficie;
  final Color texto;

  const _DialogoAgregarTrabajo({required this.superficie, required this.texto});

  @override
  State<_DialogoAgregarTrabajo> createState() => _DialogoAgregarTrabajoState();
}

class _DialogoAgregarTrabajoState extends State<_DialogoAgregarTrabajo> {
  final descripcionController = TextEditingController();
  final precioController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    descripcionController.dispose();
    precioController.dispose();
    super.dispose();
  }

  void _guardar() {
    if (!formKey.currentState!.validate()) return;

    Navigator.pop(
      context,
      modelos.TrabajoRealizado(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        descripcion: descripcionController.text.trim(),
        precioManoObra: double.parse(
          precioController.text.trim().replaceAll(',', '.'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: widget.superficie,
      title: Text(
        'Registrar trabajo',
        style: TextStyle(color: widget.texto, fontWeight: FontWeight.bold),
      ),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción del trabajo',
                ),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'Introduce una descripción';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: precioController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Precio de mano de obra',
                ),
                validator: (valor) {
                  final precio = double.tryParse(
                    (valor ?? '').trim().replaceAll(',', '.'),
                  );

                  if (precio == null || precio < 0) {
                    return 'Introduce un precio válido';
                  }

                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _guardar,
          child: const Text('Guardar trabajo'),
        ),
      ],
    );
  }
}
