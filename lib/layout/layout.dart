import 'package:deplace_maison/layout/widgets/cookies.dart';
import 'package:deplace_maison/layout/widgets/mouse.dart';
import 'package:deplace_maison/layout/widgets/mouse_web.dart';
import 'package:deplace_maison/layout/widgets/way_archive.dart';
import 'package:flutter/material.dart';
import 'package:deplace_maison/layout/app-bar.dart';
import 'package:deplace_maison/layout/footer.dart';
import 'package:deplace_maison/layout/side-bar.dart';
import 'package:flutter/foundation.dart';

/// Widget raíz que envuelve toda la aplicación.
/// Gestiona el scroll principal y la visibilidad dinámica del AppBar.
class Layout extends StatefulWidget {
  final Widget child;
  const Layout({super.key, required this.child});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  final ScrollController _scrollController = ScrollController();

  /// Controla si el AppBar (ink bar) está visible.
  bool _showInkBar = true;

  /// Guarda el último offset del scroll para detectar dirección.
  double _lastOffset = 0;

  /// Altura reservada para el widget WayArchive en la parte superior.
  static const double _wayArchiveHeight = 80;

  /// Altura del AppBar, igual a la constante estándar de Material.
  static const double _inkBarHeight = kToolbarHeight;

  @override
  void initState() {
    super.initState();

    // Escucha el scroll para mostrar u ocultar el AppBar según la dirección.
    _scrollController.addListener(() {
      final current = _scrollController.offset;
      final goingDown = current > _lastOffset;
      _lastOffset = current;

      // Oculta el AppBar al bajar, lo muestra al subir.
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
    // El padding superior evita que el contenido quede debajo de los widgets fijos.
    final topPadding = _wayArchiveHeight + (_showInkBar ? _inkBarHeight : 0);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      body: MouseWidget(
        child: Stack(
          children: [
            // Contenido principal con scroll, footer incluido.
            Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Padding(
                      padding: EdgeInsets.only(top: topPadding),
                      child: Column(
                        children: [
                          widget.child,
                          Footer(scrollController: _scrollController),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Barra de WayArchive fija en la parte superior.
            const Positioned(top: 0, left: 0, right: 0, child: WayArchive()),

            // AppBar que se oculta o muestra según la dirección del scroll.
            Positioned(
              top: _wayArchiveHeight,
              left: 0,
              right: 0,
              child: AppBarWidget(showInkBar: _showInkBar),
            ),

            // Barra lateral fija a la izquierda, debajo del WayArchive.
            Positioned(
              top: _wayArchiveHeight,
              left: 0,
              bottom: 0,
              width: 100,
              child: SideBar(),
            ),

            // Cursor personalizado solo en web.
            if (kIsWeb) const WebCursorOverlay(),

            // Banner de cookies superpuesto sobre todo el contenido.
            const CookieBanner(),
          ],
        ),
      ),
    );
  }
}