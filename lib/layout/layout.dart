import 'package:deplace_maison/layout/widgets/cookies.dart';
import 'package:deplace_maison/layout/widgets/mouse.dart';
import 'package:deplace_maison/layout/widgets/mouse_web.dart';
import 'package:flutter/material.dart';
import 'package:deplace_maison/layout/app-bar.dart';
import 'package:deplace_maison/layout/footer.dart';
import 'package:deplace_maison/layout/side-bar.dart';
import 'package:flutter/foundation.dart';

class Layout extends StatefulWidget {
  final Widget child;
  const Layout({super.key, required this.child});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  final ScrollController _scrollController = ScrollController();
  bool _showInkBar = true;
  double _lastOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final current = _scrollController.offset;
      final goingDown = current > _lastOffset;
      _lastOffset = current;

      if (goingDown && _showInkBar) {
        setState(() => _showInkBar = false);
      } else if (!goingDown && !_showInkBar) {
        setState(() => _showInkBar = true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      extendBodyBehindAppBar: true,
      appBar: AppBarWidget(showInkBar: _showInkBar),
      body: Stack(
        children: [
          MouseWidget(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(width: 48, child: SideBar()),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(children: [widget.child, const Footer()]),
                  ),
                ),
              ],
            ),
          ),
          if (kIsWeb) const WebCursorOverlay(),
          const CookieBanner(),
        ],
      ),
    );
  }
}
