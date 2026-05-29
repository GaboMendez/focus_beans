// PARTE 2 / PARTE 4 — Temporizador Stateful con sesiones encadenadas
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:focus_beans/main.dart';

const int _focusSeconds = 20; // sesión de foco
const int _breakSeconds = 5;  // descanso automático

/// Gestiona el tiempo, el timer de Dart y el estado de pausa/ejecución.
/// Es Stateful porque su contenido cambia con el tiempo, de forma autónoma, sin que el usuario toque nada.
class FocusTimer extends StatefulWidget {
  const FocusTimer({super.key});

  @override
  State<FocusTimer> createState() => _FocusTimerState();
}

class _FocusTimerState extends State<FocusTimer> {
  int _secondsLeft = _focusSeconds;
  Timer? _timer;
  bool _isRunning = false;

  // Parte 4 — sesiones encadenadas + contador de pomodoros
  bool _isBreak = false;
  // El contador vive aquí intencionalmente: sobrevive a _reset() porque
  // solo reiniciamos el ciclo actual, no el historial de pomodoros completados.
  int _pomodorosCompleted = 0;

  int get _totalSeconds => _isBreak ? _breakSeconds : _focusSeconds;

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
      if (_secondsLeft > 0) {
        setState(() => _secondsLeft--);
        return;
      }
      // Llegó a 0
      _timer?.cancel();
      if (!_isBreak) {
        // Foco completado → auto-arranca descanso de 5 s
        setState(() {
          _pomodorosCompleted++;
          _isBreak = true;
          _secondsLeft = _breakSeconds;
          _isRunning = false;
        });
        _start();
      } else {
        // Descanso terminado → vuelve al foco, espera al usuario
        setState(() {
          _isBreak = false;
          _secondsLeft = _focusSeconds;
          _isRunning = false;
        });
      }
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
      _isBreak = false;
      _secondsLeft = _focusSeconds;
      // _pomodorosCompleted se mantiene: sobrevive al reinicio del ciclo
    });
  }

  // Fase de la planta (derivada del tiempo, nunca guardada a mano)
  BeanPhase get _phase {
    if (_isBreak || _secondsLeft == 0) return BeanPhase.ready;
    if (_secondsLeft > _totalSeconds * 0.66) return BeanPhase.seed;
    return BeanPhase.growing;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      color: _isBreak ? Colors.teal[50] : Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // AnimatedSwitcher anima la transición entre emojis de fase
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: BeanStage(key: ValueKey(_phase), phase: _phase),
          ),
          const SizedBox(height: 24),
          TimeDisplay(secondsLeft: _secondsLeft),
          const SizedBox(height: 8),
          if (_isBreak)
            const Text(
              '¡Tiempo de descanso! ☕',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          const SizedBox(height: 8),
          // 📊 Contador de pomodoros completados
          Text(
            'Pomodoros: $_pomodorosCompleted 🍅',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 32),
          TimerControls(
            isRunning: _isRunning,
            finished: false,
            secondsLeft: _secondsLeft,
            initialSeconds: _totalSeconds,
            onStart: _start,
            onPause: _pause,
            onReset: _reset,
          ),
        ],
      ),
    );
  }
}
// PARTE 3 — Widget de controles extraído
/// Botones Iniciar/Pausar/Reanudar y Reiniciar.
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
