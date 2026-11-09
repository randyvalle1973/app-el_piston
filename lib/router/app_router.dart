import 'package:go_router/go_router.dart';

import '../data/tema_app.dart';
import '../data/taller_repository.dart';
import '../screens/home_screen.dart';
import '../screens/ordenes_screen.dart';
import '../screens/inventario_screen.dart';
import '../screens/clientes_screen.dart';
import '../screens/vehiculos_screen.dart';
import '../screens/trabajos_screen.dart';
import '../screens/pagos_screen.dart';
import '../screens/mecanicos_screen.dart';
import '../screens/nueva_orden_screen.dart';
import '../screens/perfil_screen.dart';

class AppRouter {
  static GoRouter crearRouter(TallerRepository taller, TemaController tema) {
    return GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => HomeScreen(taller: taller),
        ),
        GoRoute(
          path: '/ordenes',
          builder: (context, state) => OrdenesScreen(taller: taller),
        ),
        GoRoute(
          path: '/inventario',
          builder: (context, state) => InventarioScreen(taller: taller),
        ),
        GoRoute(
          path: '/clientes',
          builder: (context, state) => ClientesScreen(taller: taller),
        ),
        GoRoute(
          path: '/vehiculos',
          builder: (context, state) => VehiculosScreen(taller: taller),
        ),
        GoRoute(
          path: '/trabajos',
          builder: (context, state) => TrabajosScreen(taller: taller),
        ),
        GoRoute(
          path: '/pagos',
          builder: (context, state) => PagosScreen(taller: taller),
        ),
        GoRoute(
          path: '/mecanicos',
          builder: (context, state) => MecanicosScreen(taller: taller),
        ),
        GoRoute(
          path: '/ordenes/nueva',
          builder: (context, state) => NuevaOrdenScreen(taller: taller),
        ),
        GoRoute(
          path: '/perfil',
          builder: (context, state) => PerfilScreen(taller: taller, tema: tema),
        ),
      ],
    );
  }
}
