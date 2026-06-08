import 'package:flutter/material.dart';

class TestimonialsWidget extends StatefulWidget {
  const TestimonialsWidget({super.key});

  @override
  State<TestimonialsWidget> createState() => _TestimonialsWidgetState();
}

class _TestimonialsWidgetState extends State<TestimonialsWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetOut;
  late Animation<Offset> _offsetIn;
  int _currentIndex = 0;
  int _previousIndex = 0;

  static const _testimonials = [
    (
      name: 'JAMIE K. COHEN',
      quote:
          'Déplacé Maison is a convincer for anticipation. The urban trekking as nevers seen before. An exceptional product that has no equal alongside a great team represent the brand professionally.',
    ),
    (
      name: 'WILLIAM GIBSON',
      quote:
          'Good things come to those who wait – Déplacé Maison is what has been missing in the modern fashion industry for years. Buy a shoe of high quality and design it finally happened.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _offsetOut = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _offsetIn = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _startLoop();
  }

  void _startLoop() {
    Future.delayed(const Duration(seconds: 10), () {
      if (!mounted) return;
      _controller.forward().then((_) {
        setState(() {
          _previousIndex = _currentIndex;
          _currentIndex = (_currentIndex + 1) % _testimonials.length;
          _controller.reset();
        });
        _startLoop();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 60, right: 24, top: 80, bottom: 80),
      child: Align(
        alignment: Alignment.centerRight,
        child: ClipRect(
          child: Stack(
            children: [
              SlideTransition(
                position: _offsetOut,
                child: _buildContent(_testimonials[_previousIndex]),
              ),
              SlideTransition(
                position: _offsetIn,
                child: _buildContent(_testimonials[_currentIndex]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(({String name, String quote}) testimonial) {
    return SizedBox(
      width: 700,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 280,
            child: Text(
              testimonial.name,
              style: const TextStyle(
                fontFamily: 'FingerPaint',
                fontSize: 28,
                color: Colors.black,
                height: 1.2,
              ),
            ),
          ),
          const SizedBox(width: 48),
          Expanded(
            child: Text(
              testimonial.quote,
              style: const TextStyle(
                fontFamily: 'HedvigLettersSans',
                fontSize: 16,
                color: Colors.black,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
