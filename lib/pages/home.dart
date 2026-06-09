import 'package:deplace_maison/layout/widgets/arrows.dart';
import 'package:deplace_maison/layout/widgets/reveal_widget.dart';
import 'package:deplace_maison/pages/widgets/catalog.dart';
import 'package:deplace_maison/pages/widgets/infinite-ticker.dart';
import 'package:deplace_maison/pages/widgets/testimonials.dart';
import 'package:flutter/material.dart';

/// Pagina principal de la aplicacion.
/// Presenta el titulo de la coleccion, imagenes de campana, ticker,
/// descripcion de la marca, catalogo de productos y testimonios.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  /// Controlador de la animacion de entrada del titulo.
  late final AnimationController _titleCtrl;

  /// Controlador de la animacion de entrada de las imagenes.
  late final AnimationController _imagesCtrl;

  /// Deslizamiento sutil hacia arriba para el titulo.
  late final Animation<Offset> _titleSlide;

  /// Deslizamiento sutil hacia arriba para las imagenes.
  late final Animation<Offset> _imagesSlide;

  @override
  void initState() {
    super.initState();

    _titleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _imagesCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _titleCtrl, curve: Curves.easeOutExpo));

    _imagesSlide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _imagesCtrl, curve: Curves.easeOutExpo));

    // El titulo anima primero; las imagenes aparecen 150ms despues.
    _titleCtrl.forward();
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) _imagesCtrl.forward();
    });
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _imagesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Titulo de la coleccion con tamano de fuente relativo al ancho.
          SlideTransition(
            position: _titleSlide,
            child: FadeTransition(
              opacity: _titleCtrl,
              child: Padding(
                padding: const EdgeInsets.only(left: 60, top: 24, right: 24),
                child: RichText(
                  textAlign: TextAlign.right,
                  text: TextSpan(
                    style: const TextStyle(
                      fontFamily: 'HedvigLettersSans',
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      height: 0.85,
                    ),
                    children: [
                      TextSpan(
                        text: 'SPRING,\n',
                        style: TextStyle(fontSize: size.width * 0.13),
                      ),
                      TextSpan(
                        text: 'SUMMER',
                        style: TextStyle(fontSize: size.width * 0.13),
                      ),
                      TextSpan(
                        text: '  COLL.\n        2021',
                        style: TextStyle(fontSize: size.width * 0.04),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Imagenes de campana: hombre y mujer en columnas iguales.
          SlideTransition(
            position: _imagesSlide,
            child: FadeTransition(
              opacity: _imagesCtrl,
              child: Padding(
                padding: const EdgeInsets.only(left: 60, right: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Imagen masculina con etiqueta numerada.
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/images/first/man.png',
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    '(01)',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontFamily: 'HedvigLettersSans',
                                    ),
                                  ),
                                  Text(
                                    'MAN',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontFamily: 'HedvigLettersSans',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Imagen femenina con etiqueta numerada.
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/images/first/wmn.png',
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    '(02)',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontFamily: 'HedvigLettersSans',
                                    ),
                                  ),
                                  Text(
                                    'WMNS',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontFamily: 'HedvigLettersSans',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 120),

          // Boton de exploracion alineado a la derecha.
          Padding(
            padding: const EdgeInsets.only(left: 60, right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ArrowsWidget(
                      label: 'EXPLORE',
                      direction: ArrowDirection.right,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 120),

          // Ticker horizontal que aparece al hacer scroll.
          RevealWidget(child: const InfiniteTicker()),

          const SizedBox(height: 120),

          // Seccion "Quienes somos" con descripcion de la marca.
          RevealWidget(
            key: const Key('who-we-are'),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 60,
                right: 24,
                top: 48,
                bottom: 48,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'WHO WE ARE',
                    style: TextStyle(
                      fontFamily: 'HedvigLettersSans',
                      fontSize: 13,
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Parrafo descriptivo con la palabra "brand" subrayada.
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontFamily: 'HedvigLettersSans',
                        fontSize: 56,
                        color: Colors.black,
                        height: 1.05,
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        TextSpan(text: 'An independent '),
                        TextSpan(
                          text: 'brand',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text:
                              ' of urban trekking shoes and accessories that comes from a convergence of arts and personalities.',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 120),

          // Catalogo de productos con scroll horizontal.
          RevealWidget(child: Catalog()),

          const SizedBox(height: 120),

          // Carrusel de testimonios de clientes.
          RevealWidget(child: TestimonialsWidget()),

          const SizedBox(height: 120),
        ],
      ),
    );
  }
}