// PARTE 2 — Temporizador Stateful
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:focus_beans/main.dart';

/// Duración inicial del temporizador (25s).
const int _initialSeconds = 25;

/// Gestiona el tiempo, el timer de Dart y el estado de pausa/ejecución.
/// Es Stateful porque su contenido cambia con el tiempo, de forma autónoma, sin que el usuario toque nada.
class FocusTimer extends StatefulWidget {
  const FocusTimer({super.key});

  @override
  State<FocusTimer> createState() => _FocusTimerState();
}

class _FocusTimerState extends State<FocusTimer> {
  int _secondsLeft = _initialSeconds;
  Timer? _timer;
  bool _isRunning = false;

  // Ciclo de vida
  @override
  void dispose() {
    // Si el widget desaparece mientras el timer corre, el callback
    // intentaría llamar a setState() sobre un State ya desmontado → excepción.
    _timer?.cancel();
    super.dispose();
  }

  // Lógica del timer
  void _start() {
    // Evita crear múltiples timers si se llama dos veces seguidas.
    if (_isRunning) return;

    setState(() => _isRunning = true);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 0) {
        _timer?.cancel();
        setState(() {
          _isRunning = false;
          _secondsLeft = 0;
        });
        return;
      }
      // La mutación DEBE ocurrir dentro de setState para que Flutter
      // sepa que tiene que reconstruir el árbol.
      setState(() => _secondsLeft--);
    });
  }

  void _pause() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _secondsLeft = _initialSeconds;
    });
  }

  // Fase de la planta (derivada del tiempo, nunca guardada a mano)
  BeanPhase get _phase {
    if (_secondsLeft == 0) return BeanPhase.ready;
    if (_secondsLeft > _initialSeconds * 0.66) return BeanPhase.seed;
    return BeanPhase.growing;
  }

  @override
  Widget build(BuildContext context) {
    final bool finished = _secondsLeft == 0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BeanStage(phase: _phase),
        const SizedBox(height: 24),
        TimeDisplay(secondsLeft: _secondsLeft),
        const SizedBox(height: 8),
        if (finished)
          const Text(
            '¡Tiempo de descanso! ☕',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: finished ? null : (_isRunning ? _pause : _start),
              child: Text(
                _isRunning
                    ? 'Pausar'
                    : (_secondsLeft < _initialSeconds)
                    ? 'Reanudar'
                    : 'Iniciar',
              ),
            ),
            const SizedBox(width: 16),
            OutlinedButton(onPressed: _reset, child: const Text('Reiniciar')),
          ],
        ),
      ],
    );
  }
}
