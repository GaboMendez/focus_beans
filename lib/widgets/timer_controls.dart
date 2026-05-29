import 'package:flutter/material.dart';

/// Botones Iniciar/Pausar/Reanudar y Reiniciar.
///
/// Es Stateless porque no tiene memoria propia: recibe el estado actual
/// ([isRunning], [finished]) y los callbacks del padre. No necesita recordar
/// nada entre frames, se limita a renderizar los botones correctos.
class TimerControls extends StatelessWidget {
  final bool isRunning;
  final bool finished;
  final int secondsLeft;
  final int initialSeconds;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onReset;

  const TimerControls({
    super.key,
    required this.isRunning,
    required this.finished,
    required this.secondsLeft,
    required this.initialSeconds,
    required this.onStart,
    required this.onPause,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final String startLabel = isRunning
        ? 'Pausar'
        : (secondsLeft < initialSeconds ? 'Reanudar' : 'Iniciar');

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: finished ? null : (isRunning ? onPause : onStart),
          child: Text(startLabel),
        ),
        const SizedBox(width: 16),
        OutlinedButton(
          onPressed: onReset,
          child: const Text('Reiniciar'),
        ),
      ],
    );
  }
}
