import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class RevealWidget extends StatefulWidget {
  final Widget child;
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
  late Animation<Offset> _slide;
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
      key: Key(widget.key.toString() + UniqueKey().toString()),
      onVisibilityChanged: (info) {
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