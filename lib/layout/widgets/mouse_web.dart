import 'dart:html' as html;
import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Cursor animado exclusivo para navegadores web.
///
/// NOTA: este widget usa dart:html y solo compila para el target web.
/// No debe incluirse en builds de escritorio o movil; en [MouseWidget]
/// se condiciona su uso con [kIsWeb].
///
/// Efectos que dibuja sobre un canvas HTML fijo (mix-blend-mode: difference):
/// - Circulo principal que sigue al cursor.
/// - Estela de circulos que se adapta a la velocidad del movimiento.
/// - Burbujas flotantes que aparecen cuando el cursor esta quieto.
/// - Orbitales que giran alrededor del cursor cuando esta quieto.
class WebCursorOverlay extends StatefulWidget {
  const WebCursorOverlay({super.key});

  @override
  State<WebCursorOverlay> createState() => _WebCursorOverlayState();
}

class _WebCursorOverlayState extends State<WebCursorOverlay> {
  /// Canvas HTML superpuesto a toda la pagina con pointer-events desactivados.
  html.CanvasElement? _canvas;
  html.CanvasRenderingContext2D? _ctx;

  /// Historial de posiciones que forman la estela del cursor.
  final List<_TrailPoint> _positions = [];

  /// Longitud de la estela; aumenta con la velocidad del cursor.
  int _dynamicTrailLength = 6;

  /// Burbujas flotantes activas cuando el cursor esta quieto.
  final List<_Bubble> _bubbles = [];

  /// Particulas que orbitan alrededor del cursor cuando esta quieto.
  final List<_OrbitalBubble> _orbitals = [];

  final math.Random _rng = math.Random();

  double _cursorX = 0;
  double _cursorY = 0;

  /// Indica si el cursor se movio en los ultimos frames.
  bool _isMoving = false;

  /// Frames transcurridos sin movimiento; al superar 8 se considera quieto.
  int _stillFrames = 0;

  /// Angulo global que avanza cada frame para animar los orbitales.
  double _orbitalAngle = 0;

  /// Velocidad del ultimo movimiento del cursor (pixeles por evento).
  double _lastSpeed = 0;

  @override
  void initState() {
    super.initState();

    // Ajusta el isolation del contenedor Flutter para que mix-blend-mode
    // funcione correctamente sobre el canvas superpuesto.
    final flutterView =
        html.document.querySelector('flt-glass-pane') ??
        html.document.querySelector('flt-scene-host') ??
        html.document.body;
    flutterView?.style.isolation = 'auto';
    html.document.body!.style.isolation = 'auto';
    html.document.documentElement?.style.isolation = 'auto';

    // Canvas fijo sobre toda la ventana; no intercepta eventos del raton.
    _canvas = html.CanvasElement()
      ..style.position = 'fixed'
      ..style.top = '0'
      ..style.left = '0'
      ..style.pointerEvents = 'none'
      ..style.zIndex = '99999'
      ..style.mixBlendMode = 'difference'
      ..style.isolation = 'auto'
      ..width = html.window.innerWidth ?? 1920
      ..height = html.window.innerHeight ?? 1080;

    html.document.body!.append(_canvas!);
    _ctx = _canvas!.context2D;

    // Crea 3 orbitales con parametros aleatorios para variedad visual.
    for (int i = 0; i < 3; i++) {
      _orbitals.add(
        _OrbitalBubble(
          angleOffset: _rng.nextDouble() * math.pi * 2,
          radiusX: 15 + _rng.nextDouble() * 15,
          radiusY: 8 + _rng.nextDouble() * 10,
          tilt: _rng.nextDouble() * math.pi,
          speed: 0.02 + _rng.nextDouble() * 0.03,
          size: 1.5 + _rng.nextDouble() * 2,
          pulseOffset: _rng.nextDouble() * math.pi * 2,
        ),
      );
    }

    // Redimensiona el canvas cuando cambia el tamaño de la ventana.
    html.window.onResize.listen((_) {
      _canvas!.width = html.window.innerWidth ?? 1920;
      _canvas!.height = html.window.innerHeight ?? 1080;
    });

    // Actualiza la posicion del cursor y calcula la velocidad del movimiento.
    html.document.onMouseMove.listen((e) {
      final x = e.client.x.toDouble();
      final y = e.client.y.toDouble();

      final dx = x - _cursorX;
      final dy = y - _cursorY;
      final speed = math.sqrt(dx * dx + dy * dy);

      // La estela es mas larga cuanto mas rapido se mueve el cursor.
      _dynamicTrailLength = (speed * 0.8).clamp(20, 60).toInt();
      _lastSpeed = speed;

      _cursorX = x;
      _cursorY = y;
      _isMoving = true;
      _stillFrames = 0;

      // Solo agrega un punto si se movio mas de 2 px desde el ultimo punto.
      if (_positions.isEmpty ||
          math.sqrt(
                math.pow(_positions.first.x - x, 2) +
                    math.pow(_positions.first.y - y, 2),
              ) >
              2) {
        _positions.insert(0, _TrailPoint(_cursorX, _cursorY, speed));
      }

      // Limita el historial al largo dinamico calculado.
      if (_positions.length > _dynamicTrailLength) {
        _positions.length = _dynamicTrailLength;
      }
    });

    // Limpia la estela y las burbujas cuando el cursor sale de la ventana.
    html.document.onMouseLeave.listen((_) {
      _positions.clear();
      _bubbles.clear();
      _ctx!.clearRect(0, 0, _canvas!.width!, _canvas!.height!);
    });

    _loop();
  }

  /// Bucle de animacion sincronizado con el refresco del navegador.
  void _loop() {
    html.window.requestAnimationFrame((timestamp) {
      _update(timestamp);
      _draw();
      _loop();
    });
  }

  /// Actualiza la fisica de la estela, las burbujas y los orbitales.
  void _update(num timestamp) {
    _stillFrames++;
    if (_stillFrames > 8) _isMoving = false;

    _orbitalAngle += 0.01;

    // Cuando el cursor esta quieto, los puntos de la estela se atraen
    // hacia la posicion actual con friccion para un efecto fluido.
    if (!_isMoving && _positions.isNotEmpty) {
      for (final p in _positions) {
        final dx = _cursorX - p.x;
        final dy = _cursorY - p.y;
        final dist = math.sqrt(dx * dx + dy * dy);
        if (dist < 0.5) continue;

        // Puntos nacidos a alta velocidad se atraen mas lentamente.
        final speedFactor = (p.birthSpeed / 30.0).clamp(0.5, 6.0);
        final attraction = 0.06 / speedFactor;
        const friction = 0.82;

        p.vx = (p.vx + dx * attraction) * friction;
        p.vy = (p.vy + dy * attraction) * friction;
        p.x += p.vx;
        p.y += p.vy;
      }

      // Elimina los puntos que ya llegaron al cursor.
      _positions.removeWhere((p) {
        final dx = p.x - _cursorX;
        final dy = p.y - _cursorY;
        return math.sqrt(dx * dx + dy * dy) < 4.0;
      });
    }

    // Genera una burbuja cada 10 frames mientras el cursor esta quieto.
    if (!_isMoving && _stillFrames % 10 == 0) {
      _bubbles.add(
        _Bubble(
          x: _cursorX + (_rng.nextDouble() - 0.5) * 14,
          y: _cursorY + (_rng.nextDouble() - 0.5) * 14,
          vx: (_rng.nextDouble() - 0.5) * 1.2,
          vy: -0.5 - _rng.nextDouble() * 1.2,
          size: 1.5 + _rng.nextDouble() * 3,
          opacity: 0.8,
        ),
      );
    }

    // Mueve las burbujas y reduce su tamaño y opacidad hasta desaparecer.
    for (final b in _bubbles) {
      b.x += b.vx;
      b.y += b.vy;
      b.size *= 0.97;
      b.opacity -= 0.015;
    }
    _bubbles.removeWhere((b) => b.opacity <= 0 || b.size <= 0.3);
  }

  /// Dibuja todos los elementos sobre el canvas en cada frame.
  void _draw() {
    final ctx = _ctx!;
    ctx.clearRect(0, 0, _canvas!.width!, _canvas!.height!);

    // Estela: circulos que disminuyen de tamaño y opacidad hacia el final.
    for (int i = _positions.length - 1; i >= 0; i--) {
      final ratio = 1 - (i / math.max(_dynamicTrailLength, _positions.length));
      final size = (10 * ratio).clamp(0.0, 16.0);
      final opacity = ratio.clamp(0.0, 1.0) * 0.9;
      if (size <= 0) continue;
      ctx.beginPath();
      ctx.arc(_positions[i].x, _positions[i].y, size, 0, math.pi * 2);
      ctx.fillStyle = 'rgba(255,255,255,$opacity)';
      ctx.fill();
      ctx.closePath();
    }

    // Circulo principal en la posicion exacta del cursor.
    if (_cursorX != 0 || _cursorY != 0) {
      ctx.beginPath();
      ctx.arc(_cursorX, _cursorY, 10, 0, math.pi * 2);
      ctx.fillStyle = 'rgba(255,255,255,1)';
      ctx.fill();
      ctx.closePath();
    }

    // Burbujas flotantes que ascienden y se desvanecen.
    for (final b in _bubbles) {
      ctx.beginPath();
      ctx.arc(b.x, b.y, b.size, 0, math.pi * 2);
      ctx.fillStyle = 'rgba(255,255,255,${b.opacity.clamp(0.0, 1.0)})';
      ctx.fill();
      ctx.closePath();
    }

    // Orbitales: solo visibles cuando el cursor esta quieto.
    if (!_isMoving) {
      for (final o in _orbitals) {
        // Calcula la posicion orbital con elipse inclinada y pulso sinusoidal.
        final angle = _orbitalAngle * o.speed / 0.01 + o.angleOffset;
        final pulse = (math.sin(_orbitalAngle * 2 + o.pulseOffset) + 1) / 2;
        final ex = math.cos(angle) * o.radiusX * pulse;
        final ey = math.sin(angle) * o.radiusY * pulse;
        final ox = _cursorX + ex * math.cos(o.tilt) - ey * math.sin(o.tilt);
        final oy = _cursorY + ex * math.sin(o.tilt) + ey * math.cos(o.tilt);
        final opacity = 0.3 + pulse * 0.7;
        ctx.beginPath();
        ctx.arc(ox, oy, o.size * (0.5 + pulse * 0.5), 0, math.pi * 2);
        ctx.fillStyle = 'rgba(255,255,255,$opacity)';
        ctx.fill();
        ctx.closePath();
      }
    }
  }

  @override
  void dispose() {
    // Elimina el canvas del DOM al destruir el widget.
    _canvas?.remove();
    super.dispose();
  }

  /// Este widget no renderiza nada en Flutter; todo se dibuja en el canvas HTML.
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

/// Punto de la estela con posicion, velocidad y velocidad de nacimiento.
/// La velocidad de nacimiento determina cuanto tarda en atraerse al cursor.
class _TrailPoint {
  double x, y;
  double vx, vy;
  final double birthSpeed;

  _TrailPoint(this.x, this.y, this.birthSpeed) : vx = 0, vy = 0;
}

/// Burbuja flotante con posicion, velocidad, tamaño y opacidad mutables.
class _Bubble {
  double x, y, vx, vy, size, opacity;
  _Bubble({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.size,
    required this.opacity,
  });
}

/// Particula orbital con parametros inmutables que definen su trayectoria
/// y comportamiento de pulso alrededor del cursor.
class _OrbitalBubble {
  /// Desfase angular inicial para distribuir los orbitales uniformemente.
  final double angleOffset;

  /// Radio horizontal de la elipse orbital.
  final double radiusX;

  /// Radio vertical de la elipse orbital.
  final double radiusY;

  /// Inclinacion de la elipse en radianes.
  final double tilt;

  /// Velocidad angular del orbital.
  final double speed;

  final double size;

  /// Desfase de la funcion de pulso para que cada orbital pulse distinto.
  final double pulseOffset;

  const _OrbitalBubble({
    required this.angleOffset,
    required this.radiusX,
    required this.radiusY,
    required this.tilt,
    required this.speed,
    required this.size,
    required this.pulseOffset,
  });
}