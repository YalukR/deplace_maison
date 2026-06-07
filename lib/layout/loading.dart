import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  final Widget child;
  final VoidCallback? onComplete;
  const LoadingScreen({super.key, required this.child, this.onComplete});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _numCtrl;
  late final Animation<Offset> _numSlide;
  String _currentLabel = '0%';
  bool _visible = false;

  late final AnimationController _overlayCtrl;
  late final Animation<Offset> _overlaySlide;

  static const _steps = [
    (label: '30%', delay: Duration(milliseconds: 200)),
    (label: '68%', delay: Duration(milliseconds: 500)),
    (label: '80%', delay: Duration(milliseconds: 800)),
    (label: '100%', delay: Duration(milliseconds: 1100)),
  ];

  @override
  void initState() {
    super.initState();

    _numCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _numSlide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _numCtrl, curve: Curves.easeOutExpo));

    _overlayCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _overlaySlide = Tween<Offset>(begin: Offset.zero, end: const Offset(0, -1))
        .animate(
          CurvedAnimation(parent: _overlayCtrl, curve: Curves.easeInOutQuart),
        );

    _overlayCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) widget.onComplete?.call();
    });

    _startSequence();
  }

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
        widget.child,
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
                    Positioned(
                      top: 24,
                      left: 0,
                      right: 0,
                      child: Center(child: _Logo()),
                    ),
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
                    const Positioned(
                      bottom: 40,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          Text(
                            '© 2020 DÉPLACÈ MAISON.',
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

class _Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Image.asset('assets/images/logoDM.png', width: 48);
}
