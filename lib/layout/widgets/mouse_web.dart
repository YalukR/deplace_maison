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
  final int _trailLength = 12;

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

    html.window.onResize.listen((_) {
      _canvas!.width = html.window.innerWidth ?? 1920;
      _canvas!.height = html.window.innerHeight ?? 1080;
    });

    html.document.onMouseMove.listen((e) {
      final x = e.client.x.toDouble();
      final y = e.client.y.toDouble();
      _positions.insert(0, _TrailPoint(x, y));
      if (_positions.length > _trailLength) _positions.removeLast();
      _draw();
    });

    html.document.onMouseLeave.listen((_) {
      _positions.clear();
      _ctx!.clearRect(0, 0, _canvas!.width!, _canvas!.height!);
    });
  }

  void _draw() {
    final ctx = _ctx!;
    ctx.clearRect(0, 0, _canvas!.width!, _canvas!.height!);

    for (int i = _positions.length - 1; i >= 0; i--) {
      final ratio = 1 - (i / _trailLength);
      final size = 20 * ratio;
      final opacity = ratio * 0.9;

      ctx.beginPath();
      ctx.arc(_positions[i].x, _positions[i].y, size, 0, math.pi * 2);
      ctx.fillStyle = 'rgba(255, 255, 255, $opacity)';
      ctx.fill();
      ctx.closePath();
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
