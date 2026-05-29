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

/// Fases de crecimiento del grano de café.
enum BeanPhase { seed, growing, ready }

/// Muestra el emoji de la planta según la fase recibida.
///
/// Es Stateless porque no tiene memoria propia: simplemente recibe [phase]
/// del padre y lo renderiza. No necesita recordar nada entre frames.
class BeanStage extends StatelessWidget {
  final BeanPhase phase;

  const BeanStage({super.key, required this.phase});

  String get _emoji => switch (phase) {
    BeanPhase.seed => '🌱',
    BeanPhase.growing => '🌿',
    BeanPhase.ready => '☕',
  };

  @override
  Widget build(BuildContext context) {
    return Text(_emoji, style: const TextStyle(fontSize: 80));
  }
}

/// Muestra los segundos restantes formateados como MM:SS.
///
/// Es Stateless porque su única responsabilidad es transformar un número
/// en texto formateado. No necesita estado propio: cada vez que [secondsLeft]
/// cambia, el padre reconstruye este widget con el nuevo valor.
class TimeDisplay extends StatelessWidget {
  final int secondsLeft;

  const TimeDisplay({super.key, required this.secondsLeft});

  String get _formatted {
    final minutes = secondsLeft ~/ 60;
    final seconds = secondsLeft % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatted,
      style: const TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        fontFeatures: [FontFeature.tabularFigures()],
      ),
    );
  }
}
