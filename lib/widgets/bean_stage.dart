import 'package:flutter/material.dart';
import 'package:focus_beans/models/bean_phase.dart';

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
