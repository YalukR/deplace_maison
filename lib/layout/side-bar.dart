import 'package:flutter/material.dart';
import 'package:deplace_maison/layout/widgets/text.dart';

/// Barra lateral fija con el nombre de la marca en vertical
/// y los enlaces de navegacion principal en la parte inferior.
class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Nombre de la marca rotado 270 grados, alineado arriba a la izquierda.
        Expanded(
          child: Align(
            alignment: Alignment.topLeft,
            child: RotatedBox(
              quarterTurns: 3,
              child: Padding(
                padding: const EdgeInsets.only(top: 14),
                child: TextWidget(
                  text: 'DÉPLACÉ MAISON',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),

        // Enlaces de navegacion fijos en la parte inferior de la barra.
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              TextWidget(text: 'SHOP', fontSize: 11),
              SizedBox(height: 8),
              TextWidget(text: 'COLLECTIONS', fontSize: 11),
              SizedBox(height: 8),
              TextWidget(text: 'ABOUT', fontSize: 11),
            ],
          ),
        ),
      ],
    );
  }
}