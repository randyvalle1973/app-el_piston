import 'package:flutter/material.dart';

class TemaController extends ChangeNotifier {
  bool _modoOscuro = false;

  bool get modoOscuro => _modoOscuro;

  ThemeMode get themeMode => _modoOscuro ? ThemeMode.dark : ThemeMode.light;

  void alternar() {
    _modoOscuro = !_modoOscuro;
    notifyListeners();
  }
}

class TemasApp {
  static const Color naranja = Color(0xFFFF7A1A);

  static ThemeData claro = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: naranja,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xFFF7F7F7),
    appBarTheme: const AppBarTheme(
      backgroundColor: naranja,
      foregroundColor: Colors.white,
    ),
    cardColor: Colors.white,
  );

  static ThemeData oscuro = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: naranja,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF171717),
    appBarTheme: const AppBarTheme(
      backgroundColor: naranja,
      foregroundColor: Colors.white,
    ),
    cardColor: const Color(0xFF252525),
    dialogTheme: const DialogThemeData(backgroundColor: Color(0xFF252525)),
  );
}
