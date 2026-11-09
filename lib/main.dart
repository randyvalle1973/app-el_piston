import 'package:flutter/material.dart';

import 'data/database/app_database.dart';
import 'data/taller_repository.dart';
import 'router/app_router.dart';
import 'data/datos_prueba.dart';
import 'data/tema_app.dart';

import 'package:go_router/go_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = AppDatabase();
  final taller = TallerRepository(database);

  await DatosPrueba.insertar(database);

  runApp(ElPistonApp(taller: taller));
}

class ElPistonApp extends StatefulWidget {
  final TallerRepository taller;

  const ElPistonApp({super.key, required this.taller});

  @override
  State<ElPistonApp> createState() => _ElPistonAppState();
}

class _ElPistonAppState extends State<ElPistonApp> {
  late final TemaController tema;
  late final GoRouter router;

  @override
  void initState() {
    super.initState();
    tema = TemaController();
    router = AppRouter.crearRouter(widget.taller, tema);
    tema.addListener(_actualizarTema);
  }

  void _actualizarTema() {
    setState(() {});
  }

  @override
  void dispose() {
    tema.removeListener(_actualizarTema);
    router.dispose();
    tema.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'El Pistón',
      theme: TemasApp.claro,
      darkTheme: TemasApp.oscuro,
      themeMode: tema.themeMode,
      routerConfig: router,
    );
  }
}
