import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/tema_app.dart';
import '../data/taller_repository.dart';

class PerfilScreen extends StatefulWidget {
  final TallerRepository taller;
  final TemaController tema;

  const PerfilScreen({super.key, required this.taller, required this.tema});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  static const Color naranja = Color(0xFFFF7A1A);

  bool get modoOscuro => Theme.of(context).brightness == Brightness.dark;

  bool cargando = true;
  String? errorCarga;

  int cantidadClientes = 0;
  int cantidadVehiculos = 0;
  int cantidadMecanicos = 0;
  int cantidadOrdenes = 0;
  int cantidadRepuestos = 0;

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

  Future<void> _cargarDatos() async {
    try {
      final resultados = await Future.wait([
        widget.taller.obtenerClientes(),
        widget.taller.obtenerVehiculos(),
        widget.taller.obtenerMecanicos(),
        widget.taller.obtenerOrdenes(),
        widget.taller.obtenerRepuestos(),
      ]);

      if (!mounted) return;

      setState(() {
        cantidadClientes = resultados[0].length;
        cantidadVehiculos = resultados[1].length;
        cantidadMecanicos = resultados[2].length;
        cantidadOrdenes = resultados[3].length;
        cantidadRepuestos = resultados[4].length;
        cargando = false;
        errorCarga = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        cargando = false;
        errorCarga = 'No se pudieron cargar los datos del taller';
      });
    }
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
              child: RefreshIndicator(
                color: naranja,
                onRefresh: _cargarDatos,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _tarjetaPerfil(),
                      const SizedBox(height: 24),
                      _titulo('Resumen del taller'),
                      const SizedBox(height: 13),
                      _resumen(),
                      const SizedBox(height: 27),
                      _titulo('Administración'),
                      const SizedBox(height: 13),
                      _opcion(
                        'Trabajos realizados',
                        'Gestionar mano de obra de las órdenes',
                        Icons.build_circle_outlined,
                        '/trabajos',
                      ),
                      _opcion(
                        'Pagos',
                        'Consultar pagos y cuentas pendientes',
                        Icons.payments_outlined,
                        '/pagos',
                      ),
                      _opcion(
                        'Mecánicos',
                        'Administrar el personal del taller',
                        Icons.engineering_outlined,
                        '/mecanicos',
                      ),
                      const SizedBox(height: 18),
                      _titulo('Registros'),
                      const SizedBox(height: 13),
                      _opcion(
                        'Clientes',
                        'Consultar y administrar clientes',
                        Icons.people_outline,
                        '/clientes',
                      ),
                      _opcion(
                        'Vehículos',
                        'Consultar los vehículos registrados',
                        Icons.directions_car_outlined,
                        '/vehiculos',
                      ),
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: const BoxDecoration(
        color: naranja,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
      ),
      child: Row(
        children: [
          const Icon(Icons.person_outline, color: Colors.white, size: 30),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Perfil y administración',
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            onPressed: widget.tema.alternar,
            icon: Icon(
              modoOscuro ? Icons.light_mode : Icons.dark_mode,
              color: Colors.white,
            ),
            tooltip: modoOscuro ? 'Activar modo claro' : 'Activar modo oscuro',
          ),
        ],
      ),
    );
  }

  Widget _tarjetaPerfil() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: naranja,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 29,
            backgroundColor: Colors.white,
            child: Icon(Icons.home_repair_service, color: naranja, size: 30),
          ),
          SizedBox(width: 15),
          Expanded(
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
                SizedBox(height: 5),
                Text(
                  'Sistema de gestión del taller',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _titulo(String titulo) {
    return Text(
      titulo,
      style: TextStyle(color: texto, fontSize: 17, fontWeight: FontWeight.bold),
    );
  }

  Widget _resumen() {
    if (cargando) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(color: naranja),
        ),
      );
    }

    if (errorCarga != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: superficie,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(Icons.error_outline, color: naranja, size: 30),
            const SizedBox(height: 10),
            Text(
              errorCarga!,
              textAlign: TextAlign.center,
              style: TextStyle(color: textoSecundario),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: _cargarDatos,
              child: const Text('Reintentar', style: TextStyle(color: naranja)),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _tarjetaResumen(
                'Clientes',
                cantidadClientes,
                Icons.people_outline,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _tarjetaResumen(
                'Vehículos',
                cantidadVehiculos,
                Icons.directions_car_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _tarjetaResumen(
                'Mecánicos',
                cantidadMecanicos,
                Icons.engineering_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _tarjetaResumen(
                'Órdenes',
                cantidadOrdenes,
                Icons.assignment_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _tarjetaResumen(
                'Repuestos',
                cantidadRepuestos,
                Icons.inventory_2_outlined,
              ),
            ),
            const Spacer(),
          ],
        ),
      ],
    );
  }

  Widget _tarjetaResumen(String titulo, int cantidad, IconData icono) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: superficie,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icono, color: naranja, size: 25),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cantidad.toString(),
                  style: TextStyle(
                    color: texto,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  titulo,
                  style: TextStyle(color: textoSecundario, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _opcion(
    String titulo,
    String descripcion,
    IconData icono,
    String ruta,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: superficie,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        onTap: () => context.push(ruta),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        leading: Container(
          width: 43,
          height: 43,
          decoration: BoxDecoration(
            color: naranja.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icono, color: naranja),
        ),
        title: Text(
          titulo,
          style: TextStyle(
            color: texto,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        subtitle: Text(
          descripcion,
          style: TextStyle(color: textoSecundario, fontSize: 11),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: naranja, size: 16),
      ),
    );
  }

  Widget _navegacionInferior() {
    return NavigationBar(
      backgroundColor: superficie,
      indicatorColor: naranja.withValues(alpha: 0.15),
      selectedIndex: 3,
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
          selectedIcon: Icon(Icons.inventory_2, color: naranja),
          label: 'Inventario',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person, color: naranja),
          label: 'Perfil',
        ),
      ],
    );
  }
}
