import 'package:flutter/material.dart';

/// Pantalla de carga animada que se muestra al iniciar la aplicacion.
/// Presenta un contador de porcentaje con animacion de entrada y salida,
/// y al completarse notifica mediante [onComplete].
class LoadingScreen extends StatefulWidget {
  final Widget child;
  final VoidCallback? onComplete;
  const LoadingScreen({super.key, required this.child, this.onComplete});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  /// Controla la animacion de deslizamiento del numero de porcentaje.
  late final AnimationController _numCtrl;
  late final Animation<Offset> _numSlide;

  /// Etiqueta de porcentaje actualmente visible.
  String _currentLabel = '0%';

  /// Indica si el numero ya debe mostrarse (evita flash en el primer frame).
  bool _visible = false;

  /// Controla la animacion de salida del overlay completo hacia arriba.
  late final AnimationController _overlayCtrl;
  late final Animation<Offset> _overlaySlide;

  /// Secuencia de pasos del contador: etiqueta y retardo antes de mostrarse.
  static const _steps = [
    (label: '30%', delay: Duration(milliseconds: 200)),
    (label: '68%', delay: Duration(milliseconds: 500)),
    (label: '80%', delay: Duration(milliseconds: 800)),
    (label: '100%', delay: Duration(milliseconds: 1100)),
  ];

  @override
  void initState() {
    super.initState();

    // Animacion de entrada del numero: sube desde abajo.
    _numCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _numSlide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _numCtrl, curve: Curves.easeOutExpo));

    // Animacion de salida del overlay: sube fuera de pantalla al terminar.
    _overlayCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _overlaySlide = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1),
    ).animate(
      CurvedAnimation(parent: _overlayCtrl, curve: Curves.easeInOutQuart),
    );

    // Notifica al padre cuando la animacion de salida finaliza.
    _overlayCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) widget.onComplete?.call();
    });

    _startSequence();
  }

  /// Ejecuta la secuencia completa: muestra cada paso del contador
  /// y luego lanza la animacion de salida del overlay.
  Future<void> _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 80));
    if (!mounted) return;

    setState(() => _visible = true);
    _numCtrl.forward();

    for (final step in _steps) {
      await Future.delayed(step.delay);
      if (!mounted) return;
      await _swapNumber(step.label);
    }

    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    _overlayCtrl.forward();
  }

  /// Anima la salida del numero actual, actualiza la etiqueta
  /// y anima la entrada del nuevo numero.
  Future<void> _swapNumber(String newLabel) async {
    await _numCtrl.reverse();
    if (!mounted) return;
    setState(() => _currentLabel = newLabel);
    await _numCtrl.forward();
  }

  @override
  void dispose() {
    _numCtrl.dispose();
    _overlayCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Contenido real de la app, oculto debajo del overlay mientras carga.
        widget.child,

        // Overlay oscuro que cubre la app durante la carga.
        SlideTransition(
          position: _overlaySlide,
          child: SizedBox.expand(
            child: ColoredBox(
              color: const Color(0xFF0E0E0E),
              child: DefaultTextStyle(
                style: const TextStyle(
                  decoration: TextDecoration.none,
                  color: Color(0xFFF0EAD6),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Logo centrado en la parte superior.
                    Positioned(
                      top: 24,
                      left: 0,
                      right: 0,
                      child: Center(child: _Logo()),
                    ),

                    // Numero de porcentaje animado al centro de la pantalla.
                    ClipRect(
                      child: _visible
                          ? SlideTransition(
                              position: _numSlide,
                              child: Text(
                                _currentLabel,
                                style: const TextStyle(
                                  fontFamily: 'BebasNeue',
                                  fontSize: 160,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFFF0EAD6),
                                  letterSpacing: -4,
                                  height: 1,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),

                    // Copyright fijo en la parte inferior.
                    const Positioned(
                      bottom: 40,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          Text(
                            '© 2020 DÉPLACÉ MAISON.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFF0EAD6),
                              fontSize: 11,
                              letterSpacing: 2,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          Text(
                            'ALL RIGHTS RESERVED.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFF0EAD6),
                              fontSize: 11,
                              letterSpacing: 2,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Logo de la marca mostrado en la parte superior del overlay de carga.
class _Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Image.asset('assets/images/logoDM.png', width: 48);
}