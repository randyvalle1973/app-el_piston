import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/taller_repository.dart';
import '../data/models/taller_models.dart' as modelos;

class NuevaOrdenScreen extends StatefulWidget {
  final TallerRepository taller;

  const NuevaOrdenScreen({super.key, required this.taller});

  @override
  State<NuevaOrdenScreen> createState() => _NuevaOrdenScreenState();
}

class _NuevaOrdenScreenState extends State<NuevaOrdenScreen> {
  static const Color naranja = Color(0xFFFF7A1A);

  final formularioKey = GlobalKey<FormState>();
  final controladorProblema = TextEditingController();
  final controladorCantidad = TextEditingController(text: '1');

  List<modelos.Vehiculo> vehiculos = [];
  List<modelos.Cliente> clientes = [];
  List<modelos.Mecanico> mecanicos = [];
  List<modelos.Repuesto> repuestos = [];

  String? vehiculoSeleccionado;
  String? mecanicoSeleccionado;
  String? repuestoSeleccionado;

  bool cargando = true;
  bool guardando = false;
  String? errorCarga;

  bool get modoOscuro => Theme.of(context).brightness == Brightness.dark;

  Color get fondo =>
      modoOscuro ? const Color(0xFF121212) : const Color(0xFFF7F7F7);

  Color get superficie => modoOscuro ? const Color(0xFF1E1E1E) : Colors.white;

  Color get texto => modoOscuro ? Colors.white : const Color(0xFF252525);

  Color get textoSecundario => modoOscuro ? Colors.white70 : Colors.black54;

  Color get borde =>
      modoOscuro ? const Color(0xFF383838) : const Color(0xFFEAEAEA);

  List<modelos.Repuesto> get repuestosDisponibles =>
      repuestos.where((r) => r.existencias > 0).toList();

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  @override
  void dispose() {
    controladorProblema.dispose();
    controladorCantidad.dispose();
    super.dispose();
  }

  Future<void> _cargarDatos() async {
    try {
      final resultados = await Future.wait([
        widget.taller.obtenerVehiculos(),
        widget.taller.obtenerClientes(),
        widget.taller.obtenerMecanicos(),
        widget.taller.obtenerRepuestos(),
      ]);

      if (!mounted) return;

      setState(() {
        vehiculos = resultados[0] as List<modelos.Vehiculo>;
        clientes = resultados[1] as List<modelos.Cliente>;
        mecanicos = resultados[2] as List<modelos.Mecanico>;
        repuestos = resultados[3] as List<modelos.Repuesto>;

        if (repuestoSeleccionado != null &&
            !repuestosDisponibles.any((r) => r.id == repuestoSeleccionado)) {
          repuestoSeleccionado = null;
        }

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

  modelos.Cliente? _clienteDelVehiculo(String clienteId) {
    for (final cliente in clientes) {
      if (cliente.id == clienteId) return cliente;
    }
    return null;
  }

  modelos.Repuesto? _repuestoSeleccionado() {
    for (final repuesto in repuestos) {
      if (repuesto.id == repuestoSeleccionado) return repuesto;
    }
    return null;
  }

  String _nombreVehiculo(modelos.Vehiculo vehiculo) {
    return '${vehiculo.matricula} · ${vehiculo.marca} ${vehiculo.modelo}';
  }

  void _mostrarMensaje(String mensaje, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: error ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> _cancelarOrden() async {
    final hayDatos =
        controladorProblema.text.trim().isNotEmpty ||
        vehiculoSeleccionado != null ||
        mecanicoSeleccionado != null ||
        repuestoSeleccionado != null ||
        controladorCantidad.text.trim() != '1';

    if (!hayDatos) {
      context.go('/');
      return;
    }

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: superficie,
        title: Text('Descartar nueva orden', style: TextStyle(color: texto)),
        content: Text(
          'Has introducido información en el formulario. '
          '¿Estás seguro de que deseas cancelar? Se perderán todos los datos introducidos.',
          style: TextStyle(color: textoSecundario),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Continuar editando'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Descartar'),
          ),
        ],
      ),
    );

    if (confirmar == true && mounted) {
      context.go('/');
    }
  }

  Future<void> _guardarOrden() async {
    if (repuestosDisponibles.isEmpty) {
      _mostrarMensaje(
        'No hay repuestos disponibles. Registra existencias en Inventario antes de crear una orden.',
        error: true,
      );
      return;
    }

    if (!formularioKey.currentState!.validate()) return;

    final repuesto = _repuestoSeleccionado();

    if (vehiculoSeleccionado == null ||
        mecanicoSeleccionado == null ||
        repuesto == null) {
      return;
    }

    final cantidad = int.tryParse(controladorCantidad.text.trim());

    if (cantidad == null || cantidad <= 0) {
      _mostrarMensaje('Introduce una cantidad válida.', error: true);
      return;
    }

    if (cantidad > repuesto.existencias) {
      _mostrarMensaje(
        'Solo quedan ${repuesto.existencias} unidades de ${repuesto.nombre}.',
        error: true,
      );
      return;
    }

    setState(() {
      guardando = true;
    });

    final orden = modelos.OrdenServicio(
      id: 'ORD${DateTime.now().microsecondsSinceEpoch}',
      vehiculoId: vehiculoSeleccionado!,
      fechaEntrada: DateTime.now(),
      problemaReportado: controladorProblema.text.trim(),
      mecanicoId: mecanicoSeleccionado!,
      estado: modelos.EstadoOrden.recibida,
    );

    bool ordenCreada = false;

    try {
      await widget.taller.agregarOrden(orden);
      ordenCreada = true;

      await widget.taller.agregarRepuestoAOrden(
        orden.id,
        repuesto.id,
        cantidad,
      );

      if (!mounted) return;

      _mostrarMensaje('Orden registrada y repuesto descontado correctamente');

      context.go('/ordenes');
    } catch (e) {
      if (ordenCreada) {
        try {
          await widget.taller.eliminarOrden(orden.id);
        } catch (_) {}
      }

      if (!mounted) return;

      setState(() {
        guardando = false;
      });

      _mostrarMensaje(
        e.toString().replaceFirst('Bad state: ', ''),
        error: true,
      );
    }
  }

  InputDecoration _decoracion(String etiqueta, IconData icono) {
    return InputDecoration(
      labelText: etiqueta,
      labelStyle: TextStyle(color: textoSecundario),
      prefixIcon: Icon(icono, color: naranja),
      filled: true,
      fillColor: superficie,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: borde),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: naranja, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        backgroundColor: naranja,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Nueva orden',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator(color: naranja))
          : errorCarga != null
          ? _error()
          : _contenido(),
    );
  }

  Widget _contenido() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: formularioKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Registrar servicio',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: texto,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              'Completa los datos para crear una nueva orden de trabajo.',
              style: TextStyle(color: textoSecundario, fontSize: 13),
            ),
            const SizedBox(height: 25),
            _tituloCampo('Vehículo'),
            const SizedBox(height: 9),
            DropdownButtonFormField<String>(
              value: vehiculoSeleccionado,
              isExpanded: true,
              dropdownColor: superficie,
              style: TextStyle(color: texto),
              decoration: _decoracion(
                'Seleccionar vehículo',
                Icons.directions_car_outlined,
              ),
              items: vehiculos.map((vehiculo) {
                final cliente = _clienteDelVehiculo(vehiculo.clienteId);

                return DropdownMenuItem(
                  value: vehiculo.id,
                  child: Text(
                    '${_nombreVehiculo(vehiculo)}${cliente == null ? '' : ' · ${cliente.nombre}'}',
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (valor) {
                setState(() {
                  vehiculoSeleccionado = valor;
                });
              },
              validator: (valor) {
                if (valor == null) return 'Selecciona un vehículo';
                return null;
              },
            ),
            const SizedBox(height: 22),
            _tituloCampo('Mecánico responsable'),
            const SizedBox(height: 9),
            DropdownButtonFormField<String>(
              value: mecanicoSeleccionado,
              isExpanded: true,
              dropdownColor: superficie,
              style: TextStyle(color: texto),
              decoration: _decoracion(
                'Seleccionar mecánico',
                Icons.engineering_outlined,
              ),
              items: mecanicos.map((mecanico) {
                return DropdownMenuItem(
                  value: mecanico.id,
                  child: Text(mecanico.nombre),
                );
              }).toList(),
              onChanged: (valor) {
                setState(() {
                  mecanicoSeleccionado = valor;
                });
              },
              validator: (valor) {
                if (valor == null) return 'Selecciona un mecánico';
                return null;
              },
            ),
            const SizedBox(height: 22),
            _tituloCampo('Repuesto utilizado'),
            const SizedBox(height: 9),
            if (repuestosDisponibles.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.red),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'No hay repuestos disponibles en el inventario. Registra existencias para poder crear una orden.',
                        style: TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              )
            else
              DropdownButtonFormField<String>(
                value: repuestoSeleccionado,
                isExpanded: true,
                dropdownColor: superficie,
                style: TextStyle(color: texto),
                decoration: _decoracion(
                  'Seleccionar repuesto',
                  Icons.build_outlined,
                ),
                items: repuestosDisponibles.map((repuesto) {
                  return DropdownMenuItem(
                    value: repuesto.id,
                    child: Text(
                      '${repuesto.nombre} · Stock: ${repuesto.existencias}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (valor) {
                  setState(() {
                    repuestoSeleccionado = valor;
                  });
                },
                validator: (valor) {
                  if (valor == null) return 'Selecciona un repuesto';
                  return null;
                },
              ),
            if (repuestosDisponibles.isNotEmpty) ...[
              const SizedBox(height: 15),
              _tituloCampo('Cantidad utilizada'),
              const SizedBox(height: 9),
              TextFormField(
                controller: controladorCantidad,
                keyboardType: TextInputType.number,
                style: TextStyle(color: texto),
                decoration: _decoracion('Cantidad', Icons.inventory_2_outlined),
                validator: (valor) {
                  final cantidad = int.tryParse(valor?.trim() ?? '');

                  if (cantidad == null || cantidad <= 0) {
                    return 'Introduce una cantidad válida';
                  }

                  final repuesto = _repuestoSeleccionado();

                  if (repuesto != null && cantidad > repuesto.existencias) {
                    return 'Stock disponible: ${repuesto.existencias}';
                  }

                  return null;
                },
              ),
            ],
            const SizedBox(height: 22),
            _tituloCampo('Problema reportado'),
            const SizedBox(height: 9),
            TextFormField(
              controller: controladorProblema,
              maxLines: 5,
              maxLength: 500,
              style: TextStyle(color: texto),
              decoration: _decoracion(
                'Describe el problema del vehículo',
                Icons.description_outlined,
              ),
              validator: (valor) {
                if (valor == null || valor.trim().isEmpty) {
                  return 'Describe el problema reportado';
                }
                if (valor.trim().length < 5) {
                  return 'Escribe una descripción más detallada';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: naranja.withValues(alpha: 0.09),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: naranja.withValues(alpha: 0.18)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: naranja),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'La orden se registrará con la fecha actual y el estado Recibida. El repuesto seleccionado se descontará del inventario.',
                      style: TextStyle(color: textoSecundario, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: guardando ? null : _guardarOrden,
                style: ElevatedButton.styleFrom(
                  backgroundColor: naranja,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: naranja.withValues(alpha: 0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0,
                ),
                icon: guardando
                    ? const SizedBox(
                        width: 19,
                        height: 19,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.save_outlined),
                label: Text(
                  guardando ? 'Guardando...' : 'Registrar orden',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: guardando ? null : _cancelarOrden,
                style: OutlinedButton.styleFrom(
                  foregroundColor: naranja,
                  side: const BorderSide(color: naranja),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text('Cancelar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tituloCampo(String titulo) {
    return Text(
      titulo,
      style: TextStyle(color: texto, fontSize: 14, fontWeight: FontWeight.bold),
    );
  }

  Widget _error() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 42),
            const SizedBox(height: 12),
            Text(
              'No se pudieron cargar los datos necesarios.',
              textAlign: TextAlign.center,
              style: TextStyle(color: texto),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  cargando = true;
                  errorCarga = null;
                });
                _cargarDatos();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: naranja,
                foregroundColor: Colors.white,
              ),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
