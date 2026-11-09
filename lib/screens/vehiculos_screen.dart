import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/taller_repository.dart';
import '../data/models/taller_models.dart' as modelos;

class VehiculosScreen extends StatefulWidget {
  final TallerRepository taller;

  const VehiculosScreen({super.key, required this.taller});

  @override
  State<VehiculosScreen> createState() => _VehiculosScreenState();
}

class _VehiculosScreenState extends State<VehiculosScreen> {
  static const Color naranja = Color(0xFFFF7A1A);

  final TextEditingController busquedaController = TextEditingController();

  List<modelos.Vehiculo> vehiculos = [];
  List<modelos.Cliente> clientes = [];

  bool cargando = true;
  bool get modoOscuro => Theme.of(context).brightness == Brightness.dark;
  String busqueda = '';

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
        widget.taller.obtenerVehiculos(),
        widget.taller.obtenerClientes(),
      ]);

      if (!mounted) return;

      setState(() {
        vehiculos = resultados[0] as List<modelos.Vehiculo>;
        clientes = resultados[1] as List<modelos.Cliente>;
        cargando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        cargando = false;
      });

      _mostrarMensaje('No se pudieron cargar los datos');
    }
  }

  List<modelos.Vehiculo> get vehiculosFiltrados {
    final consulta = busqueda.toLowerCase().trim();

    if (consulta.isEmpty) return vehiculos;

    return vehiculos.where((vehiculo) {
      final cliente = _nombreCliente(vehiculo.clienteId);

      return vehiculo.matricula.toLowerCase().contains(consulta) ||
          vehiculo.marca.toLowerCase().contains(consulta) ||
          vehiculo.modelo.toLowerCase().contains(consulta) ||
          cliente.toLowerCase().contains(consulta);
    }).toList();
  }

  String _nombreCliente(String clienteId) {
    for (final cliente in clientes) {
      if (cliente.id == clienteId) return cliente.nombre;
    }

    return 'Cliente no encontrado';
  }

  void _mostrarMensaje(String mensaje) {
    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensaje), backgroundColor: naranja));
  }

  Future<void> _agregarVehiculo() async {
    if (clientes.isEmpty) {
      _mostrarMensaje('Primero debes registrar un cliente');
      return;
    }

    final matriculaController = TextEditingController();
    final marcaController = TextEditingController();
    final modeloController = TextEditingController();
    final anioController = TextEditingController();
    final kilometrajeController = TextEditingController();

    final formKey = GlobalKey<FormState>();
    String? clienteSeleccionado = clientes.first.id;

    try {
      final resultado = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (dialogContext, actualizarDialogo) {
              return AlertDialog(
                backgroundColor: superficie,
                title: Text(
                  'Registrar vehículo',
                  style: TextStyle(color: texto, fontWeight: FontWeight.bold),
                ),
                content: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownButtonFormField<String>(
                          value: clienteSeleccionado,
                          decoration: const InputDecoration(
                            labelText: 'Cliente',
                          ),
                          items: clientes.map((cliente) {
                            return DropdownMenuItem<String>(
                              value: cliente.id,
                              child: Text(cliente.nombre),
                            );
                          }).toList(),
                          onChanged: (valor) {
                            actualizarDialogo(() {
                              clienteSeleccionado = valor;
                            });
                          },
                          validator: (valor) {
                            if (valor == null) {
                              return 'Selecciona un cliente';
                            }
                            return null;
                          },
                        ),
                        _campoFormulario(
                          controller: matriculaController,
                          etiqueta: 'Matrícula',
                          icono: Icons.badge_outlined,
                          obligatorio: true,
                        ),
                        _campoFormulario(
                          controller: marcaController,
                          etiqueta: 'Marca',
                          icono: Icons.directions_car_outlined,
                          obligatorio: true,
                        ),
                        _campoFormulario(
                          controller: modeloController,
                          etiqueta: 'Modelo',
                          icono: Icons.car_repair,
                          obligatorio: true,
                        ),
                        _campoFormulario(
                          controller: anioController,
                          etiqueta: 'Año',
                          icono: Icons.calendar_today_outlined,
                          obligatorio: true,
                          tipo: TextInputType.number,
                          numerico: true,
                        ),
                        _campoFormulario(
                          controller: kilometrajeController,
                          etiqueta: 'Kilometraje',
                          icono: Icons.speed,
                          obligatorio: true,
                          tipo: TextInputType.number,
                          numerico: true,
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext, false),
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        Navigator.pop(dialogContext, true);
                      }
                    },
                    child: const Text('Guardar vehículo'),
                  ),
                ],
              );
            },
          );
        },
      );

      if (!mounted || resultado != true) return;

      final anio = int.parse(anioController.text.trim());
      final kilometraje = int.parse(kilometrajeController.text.trim());

      if (anio < 1900 || anio > DateTime.now().year + 1) {
        throw Exception('El año introducido no es válido');
      }

      if (kilometraje < 0) {
        throw Exception('El kilometraje no puede ser negativo');
      }

      if (clienteSeleccionado == null) {
        throw Exception('Selecciona un cliente');
      }

      final vehiculo = modelos.Vehiculo(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        clienteId: clienteSeleccionado!,
        matricula: matriculaController.text.trim().toUpperCase(),
        marca: marcaController.text.trim(),
        modelo: modeloController.text.trim(),
        anio: anio,
        ultimoKilometraje: kilometraje,
      );

      await widget.taller.agregarVehiculo(vehiculo);

      if (!mounted) return;

      await _cargarDatos();

      if (mounted) {
        _mostrarMensaje('Vehículo registrado correctamente');
      }
    } catch (e) {
      if (mounted) {
        _mostrarMensaje('No se pudo registrar el vehículo: $e');
      }
    } finally {
      await WidgetsBinding.instance.endOfFrame;
      matriculaController.dispose();
      marcaController.dispose();
      modeloController.dispose();
      anioController.dispose();
      kilometrajeController.dispose();
    }
  }

  Widget _campoFormulario({
    required TextEditingController controller,
    required String etiqueta,
    required IconData icono,
    bool obligatorio = false,
    bool numerico = false,
    TextInputType tipo = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: tipo,
      textCapitalization: numerico
          ? TextCapitalization.none
          : TextCapitalization.words,
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
      ),
      validator: (valor) {
        if (obligatorio && (valor == null || valor.trim().isEmpty)) {
          return 'Este campo es obligatorio';
        }

        if (valor != null && valor.trim().isNotEmpty && numerico) {
          final numero = int.tryParse(valor.trim());

          if (numero == null) {
            return 'Introduce un número válido';
          }

          if (etiqueta == 'Año' &&
              (numero < 1900 || numero > DateTime.now().year + 1)) {
            return 'Introduce un año válido';
          }

          if (etiqueta == 'Kilometraje' && numero < 0) {
            return 'El kilometraje no puede ser negativo';
          }
        }

        return null;
      },
    );
  }

  Future<void> _eliminarVehiculo(modelos.Vehiculo vehiculo) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: superficie,
        title: Text('Eliminar vehículo', style: TextStyle(color: texto)),
        content: Text(
          '¿Deseas eliminar ${vehiculo.marca} ${vehiculo.modelo} (${vehiculo.matricula})?',
          style: TextStyle(color: textoSecundario),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
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

    if (!mounted || confirmar != true) return;

    try {
      await widget.taller.eliminarVehiculo(vehiculo.id);

      if (!mounted) return;

      await _cargarDatos();

      if (mounted) {
        _mostrarMensaje('Vehículo eliminado');
      }
    } catch (e) {
      if (mounted) {
        _mostrarMensaje(
          'No se puede eliminar: el vehículo tiene órdenes asociadas',
        );
      }
    }
  }

  Future<void> _mostrarHistorial(modelos.Vehiculo vehiculo) async {
    try {
      final ordenes = await widget.taller.ordenesDeVehiculo(vehiculo.id);

      if (!mounted) return;

      showModalBottomSheet(
        context: context,
        backgroundColor: superficie,
        isScrollControlled: true,
        builder: (context) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Historial del vehículo',
                    style: TextStyle(
                      color: texto,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${vehiculo.marca} ${vehiculo.modelo} • ${vehiculo.matricula}',
                    style: TextStyle(color: textoSecundario),
                  ),
                  const SizedBox(height: 18),
                  if (ordenes.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          'Este vehículo todavía no tiene visitas registradas',
                          style: TextStyle(color: textoSecundario),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  else
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: ordenes.length,
                        itemBuilder: (context, index) {
                          final orden = ordenes[index];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: fondo,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Orden ${orden.id}',
                                  style: TextStyle(
                                    color: texto,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  orden.problemaReportado,
                                  style: TextStyle(color: textoSecundario),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Fecha: ${orden.fechaEntrada.day.toString().padLeft(2, '0')}/${orden.fechaEntrada.month.toString().padLeft(2, '0')}/${orden.fechaEntrada.year}',
                                  style: TextStyle(color: textoSecundario),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Estado: ${orden.estado.name}',
                                  style: const TextStyle(
                                    color: naranja,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      if (mounted) {
        _mostrarMensaje('No se pudo consultar el historial');
      }
    }
  }

  Widget _tarjetaVehiculo(modelos.Vehiculo vehiculo) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: naranja.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.directions_car,
                  color: naranja,
                  size: 28,
                ),
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
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      vehiculo.matricula,
                      style: const TextStyle(
                        color: naranja,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: textoSecundario),
                onSelected: (opcion) {
                  if (opcion == 'eliminar') {
                    _eliminarVehiculo(vehiculo);
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'eliminar',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, color: Colors.red),
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
          Row(
            children: [
              Expanded(
                child: _datoVehiculo(
                  Icons.calendar_today_outlined,
                  'Año',
                  vehiculo.anio.toString(),
                ),
              ),
              Expanded(
                child: _datoVehiculo(
                  Icons.speed,
                  'Kilometraje',
                  '${vehiculo.ultimoKilometraje} km',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.person_outline, size: 18, color: textoSecundario),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _nombreCliente(vehiculo.clienteId),
                  style: TextStyle(color: textoSecundario),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(color: textoSecundario.withValues(alpha: 0.15)),
          InkWell(
            onTap: () => _mostrarHistorial(vehiculo),
            borderRadius: BorderRadius.circular(10),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, color: naranja, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Consultar historial de servicios',
                    style: TextStyle(
                      color: naranja,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.chevron_right, color: naranja),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _datoVehiculo(IconData icono, String etiqueta, String valor) {
    return Row(
      children: [
        Icon(icono, color: naranja, size: 19),
        const SizedBox(width: 7),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              etiqueta,
              style: TextStyle(color: textoSecundario, fontSize: 12),
            ),
            Text(
              valor,
              style: TextStyle(color: texto, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtrados = vehiculosFiltrados;

    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        backgroundColor: naranja,
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Vehículos',
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
                  'Gestión de vehículos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${vehiculos.length} vehículos registrados',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: busquedaController,
                  onChanged: (valor) {
                    setState(() {
                      busqueda = valor;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Buscar matrícula, marca o propietario...',
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
                : filtrados.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.directions_car_outlined,
                          size: 60,
                          color: textoSecundario,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          busqueda.isEmpty
                              ? 'Todavía no hay vehículos registrados'
                              : 'No se encontraron vehículos',
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
                      itemCount: filtrados.length,
                      itemBuilder: (context, index) {
                        return _tarjetaVehiculo(filtrados[index]);
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _agregarVehiculo,
        backgroundColor: naranja,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Nuevo vehículo'),
      ),
    );
  }
}
