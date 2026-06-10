import 'package:flutter/material.dart';

/// Banda de texto que se desplaza horizontalmente de forma continua e infinita.
class InfiniteTicker extends StatefulWidget {
  const InfiniteTicker({super.key});

  @override
  State<InfiniteTicker> createState() => _InfiniteTickerState();
}

class _InfiniteTickerState extends State<InfiniteTicker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  /// Texto que se repite para llenar el ancho de la pantalla.
  static const _text = 'DO NOT SCROLL  ·  DEPLACE SHOP  ·  ';

  @override
  void initState() {
    super.initState();

    // El controlador avanza de 0 a 1 en 12 segundos y se repite indefinidamente.
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: const Color(0xFFD4B800),
        border: Border.symmetric(
          horizontal: BorderSide(color: Colors.black, width: 2),
        ),
      ),
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          return CustomPaint(
            painter: _TickerPainter(progress: _ctrl.value, text: _text),
            size: Size(MediaQuery.of(context).size.width, 72),
          );
        },
      ),
    );
  }
}

/// Painter que dibuja el texto repetido y desplazado segun [progress].
class _TickerPainter extends CustomPainter {
  /// Valor de 0 a 1 que indica cuanto ha avanzado el texto en un ciclo.
  final double progress;
  final String text;

  _TickerPainter({required this.progress, required this.text});

  @override
  void paint(Canvas canvas, Size size) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          fontFamily: 'HedvigLettersSans',
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: Colors.black,
          letterSpacing: 1.5,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    // Ancho de un segmento de texto; sirve como unidad de desplazamiento.
    final segmentWidth = tp.width;

    // El offset negativo hace que el texto se mueva hacia la izquierda.
    final offset = -(progress * segmentWidth);

    // Se calculan las copias necesarias para cubrir todo el ancho mas un margen.
    final copies = (size.width / segmentWidth).ceil() + 2;

    for (int i = 0; i < copies; i++) {
      tp.paint(
        canvas,
        Offset(offset + i * segmentWidth, (size.height - tp.height) / 2),
      );
    }
  }

  /// Solo repinta cuando avanza el progreso de la animacion.
  @override
  bool shouldRepaint(_TickerPainter old) => old.progress != progress;
}