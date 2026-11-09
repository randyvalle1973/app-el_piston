import 'package:flutter/material.dart';

import '../data/taller_repository.dart';
import '../data/models/taller_models.dart' as modelos;

class PagosScreen extends StatefulWidget {
  final TallerRepository taller;

  const PagosScreen({super.key, required this.taller});

  @override
  State<PagosScreen> createState() => _PagosScreenState();
}

class _PagosScreenState extends State<PagosScreen> {
  static const Color naranja = Color(0xFFFF7A1A);

  List<modelos.OrdenServicio> ordenes = [];
  List<modelos.Vehiculo> vehiculos = [];
  Map<String, modelos.Repuesto> repuestos = {};

  bool cargando = true;
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

  Future<void> _cargarDatos() async {
    try {
      final resultados = await Future.wait([
        widget.taller.obtenerOrdenes(),
        widget.taller.obtenerVehiculos(),
        widget.taller.obtenerMapaRepuestos(),
      ]);

      if (!mounted) return;

      setState(() {
        ordenes = resultados[0] as List<modelos.OrdenServicio>;
        vehiculos = resultados[1] as List<modelos.Vehiculo>;
        repuestos = resultados[2] as Map<String, modelos.Repuesto>;
        cargando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => cargando = false);
      _mensaje('No se pudieron cargar los pagos');
    }
  }

  double _total(modelos.OrdenServicio orden) {
    return orden.totalManoObra + orden.totalRepuestos(repuestos);
  }

  double get totalFacturado {
    return ordenes
        .where((o) => o.estado != modelos.EstadoOrden.cancelada)
        .fold(0.0, (suma, orden) => suma + _total(orden));
  }

  double get totalCobrado {
    return ordenes
        .where((o) => o.estado != modelos.EstadoOrden.cancelada)
        .fold(0.0, (suma, orden) => suma + orden.totalPagado);
  }

  double get totalPendienteGeneral {
    return ordenes
        .where((o) => o.estado != modelos.EstadoOrden.cancelada)
        .fold(0.0, (suma, orden) => suma + orden.totalPendiente(repuestos));
  }

  List<modelos.OrdenServicio> get ordenesFiltradas {
    final textoBusqueda = busqueda.toLowerCase().trim();

    return ordenes.where((orden) {
      if (orden.estado == modelos.EstadoOrden.cancelada) return false;

      final vehiculo = _vehiculoDeOrden(orden);
      final matricula = vehiculo?.matricula.toLowerCase() ?? '';

      return orden.id.toLowerCase().contains(textoBusqueda) ||
          matricula.contains(textoBusqueda);
    }).toList();
  }

  modelos.Vehiculo? _vehiculoDeOrden(modelos.OrdenServicio orden) {
    for (final vehiculo in vehiculos) {
      if (vehiculo.id == orden.vehiculoId) {
        return vehiculo;
      }
    }

    return null;
  }

  void _mensaje(String mensaje) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensaje), backgroundColor: naranja));
  }

  Future<void> _registrarPago(modelos.OrdenServicio orden) async {
    final controlador = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final cantidad = await showDialog<double>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: superficie,
          title: Text('Registrar abono', style: TextStyle(color: texto)),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Pendiente: \$${orden.totalPendiente(repuestos).toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: naranja,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: controlador,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    style: TextStyle(color: texto),
                    decoration: InputDecoration(
                      labelText: 'Cantidad del abono',
                      prefixText: '\$ ',
                      labelStyle: TextStyle(color: textoSecundario),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: textoSecundario),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: naranja),
                      ),
                    ),
                    validator: (valor) {
                      final cantidad = double.tryParse(
                        (valor ?? '').replaceAll(',', '.'),
                      );

                      if (cantidad == null || cantidad <= 0) {
                        return 'Introduce una cantidad válida';
                      }

                      if (cantidad > orden.totalPendiente(repuestos)) {
                        return 'Supera el saldo pendiente';
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
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: naranja,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final valor = double.parse(
                    controlador.text.replaceAll(',', '.'),
                  );

                  Navigator.pop(dialogContext, valor);
                }
              },
              child: const Text('Registrar'),
            ),
          ],
        );
      },
    );

    await WidgetsBinding.instance.endOfFrame;
    controlador.dispose();

    if (!mounted || cantidad == null) return;

    try {
      final pago = modelos.Pago(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        cantidad: cantidad,
        fecha: DateTime.now(),
      );

      await widget.taller.agregarPago(orden.id, pago);

      if (!mounted) return;

      _mensaje('Pago registrado correctamente');

      await _cargarDatos();
    } catch (e) {
      if (!mounted) return;

      _mensaje(e.toString().replaceFirst('Bad state: ', ''));
    }
  }

  String _fecha(DateTime fecha) {
    return '${fecha.day.toString().padLeft(2, '0')}/'
        '${fecha.month.toString().padLeft(2, '0')}/'
        '${fecha.year}';
  }

  @override
  Widget build(BuildContext context) {
    final pendientes = ordenesFiltradas
        .where((orden) => orden.totalPendiente(repuestos) > 0)
        .length;

    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        backgroundColor: naranja,
        foregroundColor: Colors.white,
        title: const Text(
          'Pagos y facturación',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator(color: naranja))
          : RefreshIndicator(
              color: naranja,
              onRefresh: _cargarDatos,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _resumen(
                    'Total facturado',
                    totalFacturado,
                    Icons.receipt_long,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _resumen(
                          'Cobrado',
                          totalCobrado,
                          Icons.payments,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _resumen(
                          'Pendiente',
                          totalPendienteGeneral,
                          Icons.pending_actions,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'Órdenes y saldos',
                    style: TextStyle(
                      color: texto,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    onChanged: (valor) {
                      setState(() => busqueda = valor);
                    },
                    style: TextStyle(color: texto),
                    decoration: InputDecoration(
                      hintText: 'Buscar por matrícula o número de orden',
                      hintStyle: TextStyle(color: textoSecundario),
                      prefixIcon: const Icon(Icons.search, color: naranja),
                      filled: true,
                      fillColor: superficie,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        '${ordenesFiltradas.length} órdenes',
                        style: TextStyle(color: textoSecundario),
                      ),
                      const Spacer(),
                      Text(
                        '$pendientes con saldo pendiente',
                        style: const TextStyle(
                          color: naranja,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (ordenesFiltradas.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(30),
                      child: Center(
                        child: Text(
                          'No hay órdenes para mostrar',
                          style: TextStyle(color: textoSecundario),
                        ),
                      ),
                    ),
                  ...ordenesFiltradas.map(_tarjetaOrden),
                ],
              ),
            ),
    );
  }

  Widget _resumen(String titulo, double cantidad, IconData icono) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: superficie,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, color: naranja, size: 25),
          const SizedBox(height: 12),
          Text(titulo, style: TextStyle(color: textoSecundario, fontSize: 12)),
          const SizedBox(height: 5),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '\$${cantidad.toStringAsFixed(2)}',
              style: TextStyle(
                color: texto,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tarjetaOrden(modelos.OrdenServicio orden) {
    final total = _total(orden);
    final pagado = orden.totalPagado;
    final pendiente = orden.totalPendiente(repuestos);
    final porcentaje = total > 0 ? (pagado / total).clamp(0.0, 1.0) : 0.0;

    final vehiculo = _vehiculoDeOrden(orden);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: superficie,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: pendiente > 0
              ? naranja.withValues(alpha: 0.35)
              : Colors.green.withValues(alpha: 0.35),
        ),
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
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                pendiente > 0 ? 'Pendiente' : 'Pagada',
                style: TextStyle(
                  color: pendiente > 0 ? naranja : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (vehiculo != null) ...[
            const SizedBox(height: 6),
            Text(
              '${vehiculo.marca} ${vehiculo.modelo} · ${vehiculo.matricula}',
              style: TextStyle(color: textoSecundario),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            orden.problemaReportado,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: textoSecundario),
          ),
          const SizedBox(height: 14),
          _filaDato('Fecha de entrada', _fecha(orden.fechaEntrada)),
          _filaDato(
            'Mano de obra',
            '\$${orden.totalManoObra.toStringAsFixed(2)}',
          ),
          _filaDato(
            'Repuestos',
            '\$${orden.totalRepuestos(repuestos).toStringAsFixed(2)}',
          ),
          const Divider(height: 22),
          _filaDato('Total', '\$${total.toStringAsFixed(2)}'),
          _filaDato('Pagado', '\$${pagado.toStringAsFixed(2)}'),
          _filaDato(
            'Saldo pendiente',
            '\$${pendiente.toStringAsFixed(2)}',
            destacado: true,
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: porcentaje,
              minHeight: 8,
              backgroundColor: textoSecundario.withValues(alpha: 0.2),
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 14),
          if (orden.pagos.isNotEmpty) ...[
            Text(
              'Historial de pagos',
              style: TextStyle(color: texto, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...orden.pagos.map(
              (pago) => Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                      size: 17,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _fecha(pago.fecha),
                        style: TextStyle(color: textoSecundario),
                      ),
                    ),
                    Text(
                      '\$${pago.cantidad.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: texto,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
          if (pendiente > 0)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _registrarPago(orden),
                style: ElevatedButton.styleFrom(
                  backgroundColor: naranja,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: const Icon(Icons.add),
                label: const Text('Registrar abono'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _filaDato(String etiqueta, String valor, {bool destacado = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            child: Text(
              etiqueta,
              style: TextStyle(
                color: destacado ? naranja : textoSecundario,
                fontWeight: destacado ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Text(
            valor,
            style: TextStyle(
              color: destacado ? naranja : texto,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
