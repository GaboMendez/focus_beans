import 'package:flutter/material.dart';

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
