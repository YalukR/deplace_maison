import 'package:flutter/material.dart';

enum TextOrientation { horizontal, verticalUp, verticalDown }

class TextWidget extends StatefulWidget {
  final String text;
  final TextOrientation orientation;
  final double fontSize;
  final Color color;
  final String fontFamily;

  const TextWidget({
    super.key,
    required this.text,
    this.orientation = TextOrientation.horizontal,
    this.fontSize = 13,
    this.color = Colors.black,
    this.fontFamily = 'HedvigLettersSans',
  });

  @override
  State<TextWidget> createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetOut;
  late Animation<Offset> _offsetIn;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _offsetOut = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _offsetIn = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onEnter() {
    setState(() => _hovered = true);
    _controller.forward();
  }

  void _onExit() {
    setState(() => _hovered = false);
    _controller.reverse();
  }

  Widget _buildText() {
    final textWidget = Text(
      widget.text,
      style: TextStyle(
        fontFamily: widget.fontFamily,
        fontSize: widget.fontSize,
        color: widget.color,
        letterSpacing: 1,
      ),
    );

    switch (widget.orientation) {
      case TextOrientation.horizontal:
        return textWidget;
      case TextOrientation.verticalUp:
        return RotatedBox(quarterTurns: 3, child: textWidget);
      case TextOrientation.verticalDown:
        return RotatedBox(quarterTurns: 1, child: textWidget);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onEnter(),
      onExit: (_) => _onExit(),
      cursor: SystemMouseCursors.click,
      child: ClipRect(
        child: Stack(
          children: [
            SlideTransition(position: _offsetOut, child: _buildText()),
            SlideTransition(position: _offsetIn, child: _buildText()),
          ],
        ),
      ),
    );
  }
}
