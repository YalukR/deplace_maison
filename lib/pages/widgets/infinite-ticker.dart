import 'package:flutter/material.dart';

class InfiniteTicker extends StatefulWidget {
  const InfiniteTicker({super.key});

  @override
  State<InfiniteTicker> createState() => _InfiniteTickerState();
}

class _InfiniteTickerState extends State<InfiniteTicker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  static const _text = 'DO NOT SCROLL  ·  DEPLACE SHOP  ·  ';
  static const _speed = 60.0; // px por segundo

  @override
  void initState() {
    super.initState();
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
      color: const Color(0xFFD4B800),
      height: 36,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          return CustomPaint(
            painter: _TickerPainter(progress: _ctrl.value, text: _text),
            size: Size(MediaQuery.of(context).size.width, 36),
          );
        },
      ),
    );
  }
}

class _TickerPainter extends CustomPainter {
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
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.black,
          letterSpacing: 1.5,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final segmentWidth = tp.width;
    final offset = -(progress * segmentWidth);

    // Dibuja suficientes repeticiones para llenar la pantalla
    int copies = (size.width / segmentWidth).ceil() + 2;
    for (int i = 0; i < copies; i++) {
      tp.paint(
        canvas,
        Offset(offset + i * segmentWidth, (size.height - tp.height) / 2),
      );
    }
  }

  @override
  bool shouldRepaint(_TickerPainter old) => old.progress != progress;
}
