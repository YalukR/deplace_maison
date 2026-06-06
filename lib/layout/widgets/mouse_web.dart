import 'dart:html' as html;
import 'dart:math' as math;
import 'package:flutter/material.dart';

class WebCursorOverlay extends StatefulWidget {
  const WebCursorOverlay({super.key});

  @override
  State<WebCursorOverlay> createState() => _WebCursorOverlayState();
}

class _WebCursorOverlayState extends State<WebCursorOverlay> {
  html.CanvasElement? _canvas;
  html.CanvasRenderingContext2D? _ctx;
  final List<_TrailPoint> _positions = [];
  int _dynamicTrailLength = 6;
  final List<_Bubble> _bubbles = [];
  final List<_OrbitalBubble> _orbitals = [];
  final math.Random _rng = math.Random();
  double _cursorX = 0;
  double _cursorY = 0;
  bool _isMoving = false;
  int _stillFrames = 0;
  double _orbitalAngle = 0;

  @override
  void initState() {
    super.initState();

    final flutterView =
        html.document.querySelector('flt-glass-pane') ??
        html.document.querySelector('flt-scene-host') ??
        html.document.body;
    flutterView?.style.isolation = 'auto';
    html.document.body!.style.isolation = 'auto';
    html.document.documentElement?.style.isolation = 'auto';

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

    html.window.onResize.listen((_) {
      _canvas!.width = html.window.innerWidth ?? 1920;
      _canvas!.height = html.window.innerHeight ?? 1080;
    });

    html.document.onMouseMove.listen((e) {
      final x = e.client.x.toDouble();
      final y = e.client.y.toDouble();

      final dx = x - _cursorX;
      final dy = y - _cursorY;
      final speed = math.sqrt(dx * dx + dy * dy);
      _dynamicTrailLength = (speed * 0.8).clamp(8, 35).toInt();

      _cursorX = x;
      _cursorY = y;
      _isMoving = true;
      _stillFrames = 0;

      _positions.insert(0, _TrailPoint(_cursorX, _cursorY));
      _positions.insert(0, _TrailPoint(_cursorX, _cursorY));
      if (_positions.length > _dynamicTrailLength) {
        _positions.length = _dynamicTrailLength;
      }
    });

    html.document.onMouseLeave.listen((_) {
      _positions.clear();
      _bubbles.clear();
      _ctx!.clearRect(0, 0, _canvas!.width!, _canvas!.height!);
    });

    _loop();
  }

  void _loop() {
    html.window.requestAnimationFrame((timestamp) {
      _update(timestamp);
      _draw();
      _loop();
    });
  }

  void _update(num timestamp) {
    _stillFrames++;
    if (_stillFrames > 8) _isMoving = false;

    if (!_isMoving && _positions.length > 1) {
      _positions.removeLast();
    }

    _orbitalAngle += 0.01;

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

    for (final b in _bubbles) {
      b.x += b.vx;
      b.y += b.vy;
      b.size *= 0.97;
      b.opacity -= 0.015;
    }
    _bubbles.removeWhere((b) => b.opacity <= 0 || b.size <= 0.3);
  }

  void _draw() {
    final ctx = _ctx!;
    ctx.clearRect(0, 0, _canvas!.width!, _canvas!.height!);

    if (_positions.isEmpty) return;

    for (int i = _positions.length - 1; i >= 0; i--) {
      final ratio = 1 - (i / _dynamicTrailLength);
      final size = (10 * ratio).clamp(0.0, 16.0); 
      final opacity = ratio.clamp(0.0, 1.0) * 0.9;
      if (size <= 0) continue;
      ctx.beginPath();
      ctx.arc(_positions[i].x, _positions[i].y, size, 0, math.pi * 2);
      ctx.fillStyle = 'rgba(255,255,255,$opacity)';
      ctx.fill();
      ctx.closePath();
    }

    ctx.beginPath();
    ctx.arc(_cursorX, _cursorY, 10, 0, math.pi * 2);
    ctx.fillStyle = 'rgba(255,255,255,1)';
    ctx.fill();
    ctx.closePath();

    for (final b in _bubbles) {
      ctx.beginPath();
      ctx.arc(b.x, b.y, b.size, 0, math.pi * 2);
      ctx.fillStyle = 'rgba(255,255,255,${b.opacity.clamp(0.0, 1.0)})';
      ctx.fill();
      ctx.closePath();
    }

    if (!_isMoving) {
      for (final o in _orbitals) {
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
    _canvas?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class _TrailPoint {
  final double x;
  final double y;
  const _TrailPoint(this.x, this.y);
}

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

class _OrbitalBubble {
  final double angleOffset;
  final double radiusX;
  final double radiusY;
  final double tilt;
  final double speed;
  final double size;
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
