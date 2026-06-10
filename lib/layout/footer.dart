import 'package:deplace_maison/layout/widgets/arrows.dart';
import 'package:deplace_maison/layout/widgets/text.dart';
import 'package:flutter/material.dart';

/// Pie de pagina con secciones de newsletter, enlaces informativos,
/// politicas, y datos legales de la marca.
class Footer extends StatelessWidget {
  /// Controlador del scroll principal, usado para volver al inicio de la pagina.
  final ScrollController? scrollController;
  const Footer({super.key, this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F0E8),
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fila superior: newsletter, info, politicas y boton de subir.
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Columna de suscripcion al newsletter con icono de correo.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'SUBSCRIBE TO NEWSLETTER',
                      style: TextStyle(
                        fontFamily: 'HedvigLettersSans',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: 80,
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.5),
                      ),
                      child: const Icon(Icons.mail_outline, size: 28),
                    ),
                  ],
                ),
              ),

              // Columna de enlaces informativos: FAQ, devoluciones y contacto.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'INFO',
                      style: TextStyle(
                        fontFamily: 'HedvigLettersSans',
                        fontSize: 11,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...['FAQ', 'RETURNS', 'CONTACT'].map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: TextWidget(
                          text: item,
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Columna de politicas: terminos, privacidad y cookies.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'POLICY',
                      style: TextStyle(
                        fontFamily: 'HedvigLettersSans',
                        fontSize: 11,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...['TERMS', 'PRIVACY', 'COOKIE'].map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: TextWidget(
                          text: item,
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Boton de flecha que desplaza el scroll de vuelta al inicio.
              ArrowsWidget(
                direction: ArrowDirection.up,
                size: 56,
                onTap: () {
                  scrollController?.animateTo(
                    0,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 48),

          // Fila inferior: formulario de newsletter, creditos y copyright.
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Campo de email con boton de envio para suscribirse.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'SUBSRIBE TO OUR NEWSLETTER',
                      style: TextStyle(
                        fontFamily: 'HedvigLettersSans',
                        fontSize: 10,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: 'email address',
                              hintStyle: TextStyle(
                                fontFamily: 'HedvigLettersSans',
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 0.5,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.only(bottom: 8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const TextWidget(
                          text: 'SUBMIT',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Enlace de creditos centrado entre los espaciadores.
              const TextWidget(text: 'CREDITS', fontSize: 11),

              const Spacer(),

              // Copyright y enlaces a redes sociales alineados a la derecha.
              Row(
                children: [
                  const TextWidget(
                    text: '© 2020 DÉPLACÉ MAISON.',
                    fontSize: 11,
                  ),
                  const SizedBox(width: 24),
                  const Icon(Icons.facebook, size: 20),
                  const SizedBox(width: 12),
                  const Icon(Icons.camera_alt_outlined, size: 20),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}