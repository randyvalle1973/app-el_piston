import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/taller_repository.dart';
import '../data/models/taller_models.dart' as modelos;

class InventarioScreen extends StatefulWidget {
  final TallerRepository taller;

  const InventarioScreen({super.key, required this.taller});

  @override
  State<InventarioScreen> createState() => _InventarioScreenState();
}

class _InventarioScreenState extends State<InventarioScreen> {
  static const Color naranja = Color(0xFFFF7A1A);

  bool get modoOscuro => Theme.of(context).brightness == Brightness.dark;
  bool cargando = true;
  bool mostrarStockBajo = false;
  String busqueda = '';
  String? errorCarga;

  final TextEditingController controladorBusqueda = TextEditingController();

  List<modelos.Repuesto> repuestos = [];

  TallerRepository get taller => widget.taller;

  Color get fondo =>
      modoOscuro ? const Color(0xFF171717) : const Color(0xFFF7F7F7);

  Color get superficie => modoOscuro ? const Color(0xFF252525) : Colors.white;

  Color get texto => modoOscuro ? Colors.white : const Color(0xFF252525);

  Color get textoSecundario => modoOscuro ? Colors.white60 : Colors.black54;

  int get totalUnidades =>
      repuestos.fold(0, (total, repuesto) => total + repuesto.existencias);

  List<modelos.Repuesto> get repuestosFiltrados {
    return repuestos.where((repuesto) {
      final coincideBusqueda =
          busqueda.isEmpty ||
          repuesto.nombre.toLowerCase().contains(busqueda) ||
          repuesto.codigo.toLowerCase().contains(busqueda);

      final coincideStock = !mostrarStockBajo || repuesto.tieneStockBajo;

      return coincideBusqueda && coincideStock;
    }).toList()..sort(
      (a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()),
    );
  }

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

  Future<void> _cargarDatos() async {
    try {
      final resultado = await taller.obtenerRepuestos();

      if (!mounted) return;

      setState(() {
        repuestos = resultado;
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

  Future<bool> _agregarRepuesto({
    required String nombre,
    required String codigo,
    required double precio,
    required int existencias,
    required int stockMinimo,
  }) async {
    try {
      final repuesto = modelos.Repuesto(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        nombre: nombre,
        codigo: codigo,
        precioVenta: precio,
        existencias: existencias,
        stockMinimo: stockMinimo,
      );

      await taller.agregarRepuesto(repuesto);

      if (!mounted) return false;

      await _cargarDatos();

      if (!mounted) return false;

      if (errorCarga != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Repuesto registrado, pero no se pudo actualizar la lista',
            ),
            backgroundColor: Colors.orange,
          ),
        );
        return true;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Repuesto registrado correctamente'),
          backgroundColor: Colors.green,
        ),
      );

      return true;
    } catch (e) {
      if (!mounted) return false;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo registrar el repuesto: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );

      return false;
    }
  }

  Future<void> _eliminarRepuesto(modelos.Repuesto repuesto) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: superficie,
        title: Text('Eliminar repuesto', style: TextStyle(color: texto)),
        content: Text(
          '¿Estás seguro de que deseas eliminar "${repuesto.nombre}"?',
          style: TextStyle(color: textoSecundario),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );

    if (confirmar != true || !mounted) return;

    try {
      await taller.eliminarRepuesto(repuesto.id);

      if (!mounted) return;

      await _cargarDatos();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Repuesto eliminado correctamente'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo eliminar el repuesto: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _mostrarFormulario() async {
    final nombreController = TextEditingController();
    final codigoController = TextEditingController();
    final precioController = TextEditingController();
    final existenciasController = TextEditingController();
    final minimoController = TextEditingController(text: '5');
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (dialogContext) {
        bool guardando = false;

        return StatefulBuilder(
          builder: (context, actualizarDialogo) {
            return AlertDialog(
              backgroundColor: superficie,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                'Nuevo repuesto',
                style: TextStyle(color: texto, fontWeight: FontWeight.bold),
              ),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _campoFormulario(
                        nombreController,
                        'Nombre del repuesto',
                        Icons.inventory_2_outlined,
                      ),
                      const SizedBox(height: 12),
                      _campoFormulario(
                        codigoController,
                        'Código',
                        Icons.qr_code,
                      ),
                      const SizedBox(height: 12),
                      _campoFormulario(
                        precioController,
                        'Precio de venta',
                        Icons.attach_money,
                        numerico: true,
                        decimal: true,
                      ),
                      const SizedBox(height: 12),
                      _campoFormulario(
                        existenciasController,
                        'Existencias iniciales',
                        Icons.warehouse_outlined,
                        numerico: true,
                      ),
                      const SizedBox(height: 12),
                      _campoFormulario(
                        minimoController,
                        'Límite de stock bajo',
                        Icons.warning_amber_outlined,
                        numerico: true,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: guardando
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: naranja,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: guardando
                      ? null
                      : () async {
                          if (!formKey.currentState!.validate()) return;

                          actualizarDialogo(() {
                            guardando = true;
                          });

                          final registrado = await _agregarRepuesto(
                            nombre: nombreController.text.trim(),
                            codigo: codigoController.text.trim(),
                            precio: double.parse(
                              precioController.text.trim().replaceAll(',', '.'),
                            ),
                            existencias: int.parse(
                              existenciasController.text.trim(),
                            ),
                            stockMinimo: int.parse(
                              minimoController.text.trim(),
                            ),
                          );

                          if (!dialogContext.mounted) return;

                          if (registrado) {
                            Navigator.of(dialogContext).pop();
                          } else {
                            actualizarDialogo(() {
                              guardando = false;
                            });
                          }
                        },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );

    nombreController.dispose();
    codigoController.dispose();
    precioController.dispose();
    existenciasController.dispose();
    minimoController.dispose();
  }

  Widget _campoFormulario(
    TextEditingController controlador,
    String etiqueta,
    IconData icono, {
    bool numerico = false,
    bool decimal = false,
  }) {
    return TextFormField(
      controller: controlador,
      style: TextStyle(color: texto, fontSize: 13),
      keyboardType: numerico
          ? TextInputType.numberWithOptions(decimal: decimal)
          : TextInputType.text,
      decoration: InputDecoration(
        labelText: etiqueta,
        labelStyle: TextStyle(color: textoSecundario),
        prefixIcon: Icon(icono, color: naranja, size: 20),
        filled: true,
        fillColor: fondo,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: naranja),
        ),
      ),
      validator: (valor) {
        if (valor == null || valor.trim().isEmpty) {
          return 'Este campo es obligatorio';
        }

        if (numerico) {
          final numero = decimal
              ? double.tryParse(valor.trim().replaceAll(',', '.'))
              : int.tryParse(valor.trim());

          if (numero == null) return 'Introduce un número válido';

          if (numero < 0) return 'No puede ser negativo';

          if (decimal && numero <= 0) {
            return 'El precio debe ser mayor que cero';
          }
        }

        return null;
      },
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
                            const SizedBox(height: 24),
                            _buscador(),
                            const SizedBox(height: 18),
                            _filtroStock(),
                            const SizedBox(height: 22),
                            Row(
                              children: [
                                _tituloSeccion('Repuestos registrados'),
                                const Spacer(),
                                Text(
                                  '${repuestosFiltrados.length} resultados',
                                  style: TextStyle(
                                    color: textoSecundario,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            _listaRepuestos(),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarFormulario,
        backgroundColor: naranja,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
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
              Icons.inventory_2_outlined,
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
                  'Inventario',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Control de repuestos y existencias',
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
    final bajos = repuestos.where((r) => r.tieneStockBajo).length;

    return Row(
      children: [
        Expanded(
          child: _tarjetaResumen(
            'Tipos de repuesto',
            repuestos.length.toString(),
            Icons.category_outlined,
            naranja,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _tarjetaResumen(
            'Unidades totales',
            totalUnidades.toString(),
            Icons.warehouse_outlined,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _tarjetaResumen(
            'Stock bajo',
            bajos.toString(),
            Icons.warning_amber_outlined,
            Colors.redAccent,
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
              fontSize: 21,
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
        hintText: 'Buscar por nombre o código...',
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _filtroStock() {
    return InkWell(
      onTap: () {
        setState(() {
          mostrarStockBajo = !mostrarStockBajo;
        });
      },
      borderRadius: BorderRadius.circular(13),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: mostrarStockBajo
              ? Colors.redAccent.withOpacity(0.10)
              : superficie,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: mostrarStockBajo
                ? Colors.redAccent.withOpacity(0.5)
                : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Colors.redAccent,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Mostrar solamente stock bajo',
                style: TextStyle(
                  color: texto,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Switch(
              value: mostrarStockBajo,
              activeThumbColor: naranja,
              onChanged: (valor) {
                setState(() {
                  mostrarStockBajo = valor;
                });
              },
            ),
          ],
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

  Widget _listaRepuestos() {
    final lista = repuestosFiltrados;

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
            Icon(Icons.inventory_2_outlined, color: textoSecundario, size: 42),
            const SizedBox(height: 10),
            Text(
              'No hay repuestos disponibles',
              style: TextStyle(color: texto, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              'Prueba cambiando la búsqueda o registra un nuevo repuesto.',
              textAlign: TextAlign.center,
              style: TextStyle(color: textoSecundario, fontSize: 12),
            ),
          ],
        ),
      );
    }

    return Column(
      children: lista.map((repuesto) {
        final stockBajo = repuesto.tieneStockBajo;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: superficie,
            borderRadius: BorderRadius.circular(16),
            border: stockBajo
                ? Border.all(color: Colors.redAccent.withOpacity(0.35))
                : null,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: naranja.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: const Icon(
                      Icons.settings_outlined,
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
                          repuesto.nombre,
                          style: TextStyle(
                            color: texto,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Código: ${repuesto.codigo}',
                          style: TextStyle(
                            color: textoSecundario,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, color: textoSecundario),
                    color: superficie,
                    onSelected: (valor) {
                      if (valor == 'eliminar') {
                        _eliminarRepuesto(repuesto);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'eliminar',
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_outline,
                              color: Colors.redAccent,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text('Eliminar'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Divider(color: textoSecundario.withOpacity(0.15), height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _datoInventario(
                      'Precio de venta',
                      '\$${repuesto.precioVenta.toStringAsFixed(2)}',
                    ),
                  ),
                  Expanded(
                    child: _datoInventario(
                      'Existencias',
                      '${repuesto.existencias} unidades',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    stockBajo
                        ? Icons.warning_amber_rounded
                        : Icons.check_circle_outline,
                    color: stockBajo ? Colors.redAccent : Colors.green,
                    size: 17,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      stockBajo
                          ? 'Stock bajo · Mínimo: ${repuesto.stockMinimo}'
                          : 'Existencias suficientes · Mínimo: ${repuesto.stockMinimo}',
                      style: TextStyle(
                        color: stockBajo ? Colors.redAccent : Colors.green,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _datoInventario(String titulo, String valor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo, style: TextStyle(color: textoSecundario, fontSize: 10)),
        const SizedBox(height: 5),
        Text(
          valor,
          style: TextStyle(
            color: texto,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
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
              'No se pudo cargar el inventario.',
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
      selectedIndex: 2,
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
        NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Inicio'),
        NavigationDestination(
          icon: Icon(Icons.assignment_outlined),
          label: 'Órdenes',
        ),
        NavigationDestination(
          icon: Icon(Icons.inventory_2_outlined),
          selectedIcon: Icon(Icons.inventory_2, color: naranja),
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
