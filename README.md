# FocusBeans 🌱

Temporizador Pomodoro con crecimiento visual de un grano de café. Construido con Flutter.

![FocusBeans demo](Video%20Project.gif)

## Widgets Stateless vs Stateful

| Widget | Tipo | Por qué |
|---|---|---|
| `FocusBeansApp` | Stateless | Solo configura `MaterialApp` y la ruta inicial. No cambia nunca. |
| `BeanStage` | Stateless | Recibe la fase y pinta el emoji. No recuerda nada entre frames. |
| `TimeDisplay` | Stateless | Transforma un número en texto `MM:SS`. Presentación pura. |
| `TimerControls` | Stateless | Recibe el estado y callbacks del padre. No necesita memoria propia. |
| `FocusTimer` | Stateful | Su contenido cambia con el tiempo de forma autónoma (cada segundo), sin que el usuario toque nada. |

## Ciclo de vida del Timer

- **Se arranca** en `_start()`, llamado al pulsar Iniciar/Reanudar.
- **Se cancela** en cuatro caminos: al pausar (`_pause`), al reiniciar (`_reset`), al llegar a 0 segundos (dentro del callback) y en `dispose()`.

Si no se cancelara en `dispose()`, el callback del `Timer` seguiría ejecutándose tras desmontar el widget e intentaría llamar a `setState()` sobre un `State` ya destruido, provocando una excepción y una fuga de memoria.
