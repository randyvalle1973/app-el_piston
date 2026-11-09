import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/taller_repository.dart';
import '../data/models/taller_models.dart' as modelos;

class ClientesScreen extends StatefulWidget {
  final TallerRepository taller;

  const ClientesScreen({super.key, required this.taller});

  @override
  State<ClientesScreen> createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  static const Color naranja = Color(0xFFFF7A1A);

  final TextEditingController busquedaController = TextEditingController();

  List<modelos.Cliente> clientes = [];
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
    _cargarClientes();
  }

  @override
  void dispose() {
    busquedaController.dispose();
    super.dispose();
  }

  Future<void> _cargarClientes() async {
    try {
      final resultado = await widget.taller.obtenerClientes();

      if (!mounted) return;

      setState(() {
        clientes = resultado;
        cargando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        cargando = false;
      });

      _mostrarMensaje('No se pudieron cargar los clientes');
    }
  }

  List<modelos.Cliente> get clientesFiltrados {
    final consulta = busqueda.toLowerCase().trim();

    if (consulta.isEmpty) return clientes;

    return clientes.where((cliente) {
      return cliente.nombre.toLowerCase().contains(consulta) ||
          cliente.telefono.toLowerCase().contains(consulta) ||
          (cliente.direccion ?? '').toLowerCase().contains(consulta);
    }).toList();
  }

  void _mostrarMensaje(String mensaje) {
    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensaje), backgroundColor: naranja));
  }

  Future<void> _agregarCliente() async {
    final nombreController = TextEditingController();
    final telefonoController = TextEditingController();
    final direccionController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    try {
      final resultado = await showDialog<bool>(
        context: context,

        builder: (dialogContext) {
          return AlertDialog(
            backgroundColor: superficie,
            title: Text(
              'Nuevo cliente',
              style: TextStyle(color: texto, fontWeight: FontWeight.bold),
            ),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _campoFormulario(
                      controller: nombreController,
                      etiqueta: 'Nombre completo',
                      icono: Icons.person_outline,
                      obligatorio: true,
                    ),
                    const SizedBox(height: 14),
                    _campoFormulario(
                      controller: telefonoController,
                      etiqueta: 'Teléfono',
                      icono: Icons.phone_outlined,
                      obligatorio: true,
                      tipo: TextInputType.phone,
                    ),
                    const SizedBox(height: 14),
                    _campoFormulario(
                      controller: direccionController,
                      etiqueta: 'Dirección (opcional)',
                      icono: Icons.location_on_outlined,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: Text(
                  'Cancelar',
                  style: TextStyle(color: textoSecundario),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: naranja,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Navigator.pop(dialogContext, true);
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          );
        },
      );

      if (resultado != true || !mounted) return;

      final cliente = modelos.Cliente(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        nombre: nombreController.text.trim(),
        telefono: telefonoController.text.trim(),
        direccion: direccionController.text.trim().isEmpty
            ? null
            : direccionController.text.trim(),
      );

      await widget.taller.agregarCliente(cliente);

      if (!mounted) return;

      await _cargarClientes();

      if (mounted) {
        _mostrarMensaje('Cliente registrado correctamente');
      }
    } catch (e) {
      _mostrarMensaje('No se pudo registrar el cliente: $e');
    } finally {
      await WidgetsBinding.instance.endOfFrame;
      nombreController.dispose();
      telefonoController.dispose();
      direccionController.dispose();
    }
  }

  Widget _campoFormulario({
    required TextEditingController controller,
    required String etiqueta,
    required IconData icono,
    bool obligatorio = false,
    TextInputType tipo = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: tipo,
      style: TextStyle(color: texto),
      decoration: InputDecoration(
        labelText: etiqueta,
        labelStyle: TextStyle(color: textoSecundario),
        prefixIcon: Icon(icono, color: naranja),
        filled: true,
        fillColor: fondo,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: textoSecundario.withValues(alpha: 0.15),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: naranja, width: 1.5),
        ),
      ),
      validator: obligatorio
          ? (valor) {
              if (valor == null || valor.trim().isEmpty) {
                return 'Este campo es obligatorio';
              }
              return null;
            }
          : null,
    );
  }

  Future<void> _eliminarCliente(modelos.Cliente cliente) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: superficie,
        title: Text('Eliminar cliente', style: TextStyle(color: texto)),
        content: Text(
          '¿Deseas eliminar a ${cliente.nombre}?',
          style: TextStyle(color: textoSecundario),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text('Cancelar', style: TextStyle(color: textoSecundario)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar != true || !mounted) return;

    try {
      await widget.taller.eliminarCliente(cliente.id);

      if (!mounted) return;

      await _cargarClientes();

      if (mounted) {
        _mostrarMensaje('Cliente eliminado');
      }
    } catch (e) {
      _mostrarMensaje(
        'No se pudo eliminar. Comprueba si tiene vehículos asociados.',
      );
    }
  }

  Future<void> _mostrarVehiculos(modelos.Cliente cliente) async {
    try {
      final vehiculos = await widget.taller.vehiculosDeCliente(cliente.id);

      if (!mounted) return;

      await showModalBottomSheet(
        context: context,
        backgroundColor: superficie,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Vehículos de ${cliente.nombre}',
                    style: TextStyle(
                      color: texto,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (vehiculos.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          'Este cliente todavía no tiene vehículos',
                          style: TextStyle(color: textoSecundario),
                        ),
                      ),
                    )
                  else
                    ...vehiculos.map(
                      (vehiculo) => Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: fondo,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.directions_car,
                              color: naranja,
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${vehiculo.marca} ${vehiculo.modelo}',
                                    style: TextStyle(
                                      color: texto,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${vehiculo.matricula} • ${vehiculo.anio}',
                                    style: TextStyle(color: textoSecundario),
                                  ),
                                  Text(
                                    '${vehiculo.ultimoKilometraje} km',
                                    style: TextStyle(color: textoSecundario),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      _mostrarMensaje('No se pudieron cargar los vehículos');
    }
  }

  Widget _tarjetaCliente(modelos.Cliente cliente) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: superficie,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: modoOscuro ? 0.15 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: naranja.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.person, color: naranja, size: 27),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cliente.nombre,
                      style: TextStyle(
                        color: texto,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      cliente.telefono,
                      style: TextStyle(color: textoSecundario),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                color: superficie,
                icon: Icon(Icons.more_vert, color: textoSecundario),
                onSelected: (opcion) {
                  if (opcion == 'eliminar') {
                    _eliminarCliente(cliente);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'eliminar',
                    child: Row(
                      children: [
                        const Icon(Icons.delete_outline, color: Colors.red),
                        const SizedBox(width: 8),
                        Text('Eliminar', style: TextStyle(color: texto)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (cliente.direccion != null && cliente.direccion!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: textoSecundario,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    cliente.direccion!,
                    style: TextStyle(color: textoSecundario),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 14),
          Divider(color: textoSecundario.withValues(alpha: 0.15)),
          InkWell(
            onTap: () => _mostrarVehiculos(cliente),
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.directions_car_outlined,
                    color: naranja,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Consultar vehículos',
                    style: TextStyle(
                      color: naranja,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.chevron_right, color: textoSecundario),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtrados = clientesFiltrados;

    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.go('/'),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: naranja,
        foregroundColor: Colors.white,
        title: const Text(
          'Clientes',
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
                  'Gestión de clientes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${clientes.length} clientes registrados',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: busquedaController,
                  style: TextStyle(color: texto),
                  onChanged: (valor) {
                    setState(() {
                      busqueda = valor;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Buscar por nombre, teléfono o dirección...',
                    hintStyle: TextStyle(color: textoSecundario),
                    prefixIcon: const Icon(Icons.search, color: naranja),
                    suffixIcon: busqueda.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              busquedaController.clear();
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
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: textoSecundario.withValues(alpha: 0.15),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: Colors.white,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: cargando
                ? const Center(child: CircularProgressIndicator(color: naranja))
                : filtrados.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 60,
                          color: textoSecundario,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          busqueda.isEmpty
                              ? 'Todavía no hay clientes registrados'
                              : 'No se encontraron clientes',
                          style: TextStyle(color: textoSecundario),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    color: naranja,
                    onRefresh: _cargarClientes,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filtrados.length,
                      itemBuilder: (context, index) {
                        return _tarjetaCliente(filtrados[index]);
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _agregarCliente,
        backgroundColor: naranja,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Nuevo cliente'),
      ),
    );
  }
}
