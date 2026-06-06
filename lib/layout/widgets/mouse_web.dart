import 'dart:html' as html;
import 'dart:ui_web' as ui;
import 'package:flutter/material.dart';

class WebCursorOverlay extends StatefulWidget {
  const WebCursorOverlay({super.key});

  @override
  State<WebCursorOverlay> createState() => _WebCursorOverlayState();
}

class _WebCursorOverlayState extends State<WebCursorOverlay> {
  @override
  void initState() {
    super.initState();

    final cursor = html.DivElement()
      ..style.position = 'fixed'
      ..style.width = '40px'
      ..style.height = '40px'
      ..style.borderRadius = '50%'
      ..style.backgroundColor = 'white'
      ..style.mixBlendMode = 'difference'
      ..style.pointerEvents = 'none'
      ..style.zIndex = '9999'
      ..style.transform = 'translate(-50%, -50%)'
      ..style.transition = 'transform 0.1s ease';

    html.document.body!.append(cursor);

    html.document.onMouseMove.listen((e) {
      cursor.style.left = '${e.client.x}px';
      cursor.style.top = '${e.client.y}px';
    });
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
