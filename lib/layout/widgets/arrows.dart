import 'package:flutter/material.dart';

enum ArrowDirection { up, down, left, right }

class ArrowsWidget extends StatefulWidget {
  final ArrowDirection direction;
  final String? label;
  final double size;
  final VoidCallback? onTap;

  const ArrowsWidget({
    super.key,
    this.direction = ArrowDirection.right,
    this.label,
    this.size = 48,
    this.onTap,
  });
  @override
  State<ArrowsWidget> createState() => _ArrowsWidgetState();
}

class _ArrowsWidgetState extends State<ArrowsWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotation;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _rotation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _scale = Tween<double>(
      begin: 1.0,
      end: 1.4,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get _baseAngle {
    switch (widget.direction) {
      case ArrowDirection.right:
        return 0;
      case ArrowDirection.down:
        return 0.25;
      case ArrowDirection.left:
        return 0.5;
      case ArrowDirection.up:
        return 0.75;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.label != null) ...[
              Text(
                widget.label!,
                style: const TextStyle(
                  fontFamily: 'HedvigLettersSans',
                  fontSize: 24,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(width: 16),
            ],
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scale.value,
                  child: Transform.rotate(
                    angle: (_baseAngle + _rotation.value) * 2 * 3.14159,
                    child: child,
                  ),
                );
              },
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 1.5),
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  size: 20,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
