import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Envuelve cualquier widget con una animacion de entrada:
/// aparece con un leve desplazamiento hacia arriba y un fade-in
/// cuando el widget entra en el viewport por primera vez.
class RevealWidget extends StatefulWidget {
  final Widget child;

  /// Retardo opcional antes de iniciar la animacion, util para
  /// escalonar varios elementos que aparecen al mismo tiempo.
  final Duration delay;

  const RevealWidget({
    super.key,
    required this.child,
    this.delay = Duration.zero,
  });

  @override
  State<RevealWidget> createState() => _RevealWidgetState();
}

class _RevealWidgetState extends State<RevealWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  /// Deslizamiento sutil desde ligeramente abajo hasta la posicion final.
  late Animation<Offset> _slide;

  /// Evita que la animacion se dispare mas de una vez.
  bool _triggered = false;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutExpo));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      // Clave unica para que el detector no colisione entre instancias.
      key: Key(widget.key.toString() + UniqueKey().toString()),
      onVisibilityChanged: (info) {
        // Dispara la animacion solo una vez cuando el widget supera
        // el 10% de visibilidad en pantalla.
        if (!_triggered && info.visibleFraction > 0.1) {
          _triggered = true;
          Future.delayed(widget.delay, () {
            if (mounted) _ctrl.forward();
          });
        }
      },
      child: SlideTransition(
        position: _slide,
        child: FadeTransition(
          opacity: _ctrl,
          child: widget.child,
        ),
      ),
    );
  }
}