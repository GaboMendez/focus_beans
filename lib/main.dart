import 'package:flutter/material.dart';
import 'package:focus_beans/focus_timer.dart';

void main() {
  runApp(const FocusBeansApp());
}

/// Widget raíz de la aplicación. Es Stateless porque no guarda ningún estado
/// propio: solo define la configuración global (MaterialApp, tema, ruta inicial).
class FocusBeansApp extends StatelessWidget {
  const FocusBeansApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FocusBeans',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('🌱 FocusBeans 🌱'),
          backgroundColor: Colors.brown[200],
          centerTitle: true,
        ),
        body: const Center(child: FocusTimer()),
      ),
    );
  }
}
