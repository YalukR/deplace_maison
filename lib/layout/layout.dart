import 'package:deplace_maison/layout/widgets/cookies.dart';
import 'package:deplace_maison/layout/widgets/mouse.dart';
import 'package:deplace_maison/layout/widgets/mouse_web.dart';
import 'package:deplace_maison/layout/widgets/way_archive.dart';
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

  static const double _wayArchiveHeight = 80;
  static const double _inkBarHeight = kToolbarHeight;

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
    final topPadding = _wayArchiveHeight + (_showInkBar ? _inkBarHeight : 0);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      body: MouseWidget(
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Padding(
                      padding: EdgeInsets.only(top: topPadding, left: 200),
                      child: Column(children: [widget.child, const Footer()]),
                    ),
                  ),
                ),
              ],
            ),

            const Positioned(top: 0, left: 0, right: 0, child: WayArchive()),

            Positioned(
              top: _wayArchiveHeight,
              left: 0,
              right: 0,
              child: AppBarWidget(showInkBar: _showInkBar),
            ),

            Positioned(
              top: _wayArchiveHeight,
              left: 0,
              bottom: 0,
              width: 100,
              child: SideBar(),
            ),

            if (kIsWeb) const WebCursorOverlay(),
            const CookieBanner(),
          ],
        ),
      ),
    );
  }
}
