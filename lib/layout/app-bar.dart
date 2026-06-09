import 'package:deplace_maison/layout/widgets/text.dart';
import 'package:flutter/material.dart';

/// AppBar personalizado que se anima para aparecer o desaparecer
/// según el parámetro [showInkBar].
class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final bool showInkBar;
  const AppBarWidget({super.key, this.showInkBar = true});

  /// Altura preferida: completa si está visible, cero si está oculto.
  @override
  Size get preferredSize => Size.fromHeight(showInkBar ? kToolbarHeight : 0);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        // La altura colapsa a 0 cuando el AppBar se oculta.
        height: showInkBar ? kToolbarHeight : 0,
        color: Colors.transparent,
        child: SingleChildScrollView(
          // Evita que el contenido interno sea desplazable durante la animación.
          physics: const NeverScrollableScrollPhysics(),
          child: SizedBox(
            height: kToolbarHeight,
            child: Row(
              children: [
                // Espacio flexible a la izquierda para centrar el botón.
                const Expanded(child: SizedBox()),

                // Botón de modo tinta.
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  child: const Text(
                    'INK MODE',
                    style: TextStyle(
                      fontFamily: 'FingerPaint',
                      fontSize: 13,
                      color: Colors.black,
                    ),
                  ),
                ),

                // Enlace al carrito alineado a la derecha.
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextWidget(text: 'CART'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}