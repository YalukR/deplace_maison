import 'package:flutter/material.dart';

/// Banner de consentimiento de cookies posicionado en la esquina
/// inferior derecha. Se descarta al pulsar "OK".
class CookieBanner extends StatefulWidget {
  const CookieBanner({super.key});

  @override
  State<CookieBanner> createState() => _CookieBannerState();
}

class _CookieBannerState extends State<CookieBanner> {
  /// Controla si el banner es visible; pasa a false al aceptar.
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    // Una vez aceptado, no ocupa espacio en el arbol de widgets.
    if (!_visible) return const SizedBox.shrink();

    return Positioned(
      bottom: 16,
      right: 16,
      child: Container(
        width: 260,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: const Color(0xFF1A1A1A),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Texto informativo con "cookies" subrayado.
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    height: 1.5,
                  ),
                  children: [
                    const TextSpan(text: 'This website use '),
                    TextSpan(
                      text: 'cookies',
                      style: const TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const TextSpan(
                      text: '.\nBy continuing to browse\nyou accept their use.',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Boton de aceptacion que oculta el banner.
            GestureDetector(
              onTap: () => setState(() => _visible = false),
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}