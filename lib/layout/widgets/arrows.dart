import 'package:flutter/material.dart';

enum ArrowDirection { up, down, left, right }

class ArrowsWidget extends StatefulWidget {
  final ArrowDirection direction;
  final String? label;
  final double size;

  const ArrowsWidget({
    super.key,
    this.direction = ArrowDirection.right,
    this.label,
    this.size = 48,
  });

  @override
  State<ArrowsWidget> createState() => _ArrowsWidgetState();
}

class _ArrowsWidgetState extends State<ArrowsWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotation;

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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.label != null) ...[
            Text(
              widget.label!,
              style: const TextStyle(
                fontFamily: 'HedvigLettersSans',
                fontSize: 13,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(width: 16),
          ],
          AnimatedBuilder(
            animation: _rotation,
            builder: (context, child) {
              return Transform.rotate(
                angle: (_baseAngle + _rotation.value) * 2 * 3.14159,
                child: child,
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
    );
  }
}
