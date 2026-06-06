import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MouseWidget extends StatefulWidget {
  final Widget child;
  const MouseWidget({super.key, required this.child});

  @override
  State<MouseWidget> createState() => _MouseWidgetState();
}

class _MouseWidgetState extends State<MouseWidget> {
  Offset _position = Offset.zero;
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) return widget.child;

    return MouseRegion(
      onHover: (e) => setState(() {
        _position = e.localPosition;
        _visible = true;
      }),
      onExit: (_) => setState(() => _visible = false),
      child: Stack(
        children: [
          widget.child,
          if (_visible)
            Positioned(
              left: _position.dx - 10,
              top: _position.dy - 10,
              child: IgnorePointer(child: _DesktopCursor()),
            ),
        ],
      ),
    );
  }
}

class _DesktopCursor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black, width: 1.5),
        color: Colors.transparent,
      ),
    );
  }
}
