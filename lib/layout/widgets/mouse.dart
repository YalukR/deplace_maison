import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Cursor personalizado segun la plataforma:
/// - En escritorio nativo: circulo hueco que sigue al puntero.
/// - En web: delega en [WebCursorOverlay], que dibuja el efecto
///   con canvas HTML. Este widget no renderiza nada en ese caso.
/// - En movil: se omite cualquier cursor personalizado.
///
/// NOTA: el efecto de cursor animado (estela, burbujas y orbitales)
/// solo esta soportado en navegadores web. En plataformas nativas
/// unicamente se muestra el circulo simple de [_DesktopCursor].
class MouseWidget extends StatefulWidget {
  final Widget child;
  const MouseWidget({super.key, required this.child});

  @override
  State<MouseWidget> createState() => _MouseWidgetState();
}

class _MouseWidgetState extends State<MouseWidget> {
  Offset _position = Offset.zero;
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    // En web el cursor lo gestiona WebCursorOverlay mediante canvas HTML;
    // este widget no necesita hacer nada adicional.
    if (kIsWeb) return widget.child;

    return MouseRegion(
      onHover: (e) => setState(() {
        _position = e.localPosition;
        _visible = true;
      }),
      onExit: (_) => setState(() => _visible = false),
      child: Stack(
        children: [
          widget.child,

          // Cursor circular visible solo mientras el puntero esta dentro del area.
          if (_visible)
            Positioned(
              left: _position.dx - 10,
              top: _position.dy - 10,
              // IgnorePointer evita que el cursor intercepte eventos de entrada.
              child: IgnorePointer(child: _DesktopCursor()),
            ),
        ],
      ),
    );
  }
}

/// Circulo hueco que reemplaza el cursor del sistema en escritorio nativo.
class _DesktopCursor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black, width: 1.5),
        color: Colors.transparent,
      ),
    );
  }
}