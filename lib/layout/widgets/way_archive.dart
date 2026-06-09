import 'package:deplace_maison/repository/way_archive_repository.dart';
import 'package:flutter/material.dart';
import 'package:deplace_maison/layout/widgets/way_archive_controller.dart';

/// Barra superior que replica la interfaz del Wayback Machine de Internet Archive.
/// Muestra el logo, la URL capturada, el timeline interactivo y el navegador de meses.
class WayArchive extends StatefulWidget {
  const WayArchive({super.key});

  @override
  State<WayArchive> createState() => _WayArchiveState();
}


// Nota: no estaba seguro de incluir este widget, ya que el Wayback Machine
// no forma parte del sitio original de Déplacé Maison. Lo implemente
// de todas formas porque me parecio un detalle interesante para el ejercicio.

class _WayArchiveState extends State<WayArchive> {
  /// Controlador que gestiona el índice activo y la posición del cursor en el timeline.
  final _controller = WayArchiveController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        // Datos del periodo actualmente seleccionado en el timeline.
        final active = _controller.activeData;

        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  // Columna izquierda: logo y metadatos de capturas.
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/images/logoWA.png', height: 30),
                      const SizedBox(height: 2),
                      const Text(
                        '72 CAPTURES',
                        style: TextStyle(color: Color(0xFF4A9EDB), fontSize: 9),
                      ),
                      const Text(
                        '22 AUG 2019 - 26 SEP 2025',
                        style: TextStyle(color: Colors.grey, fontSize: 9),
                      ),
                    ],
                  ),

                  const SizedBox(width: 12),

                  // Columna central: barra de URL y timeline de capturas.
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        // Barra de URL con boton Go.
                        SizedBox(
                          height: 24,
                          child: Row(
                            children: [
                              // Campo que muestra la URL archivada.
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  alignment: Alignment.centerLeft,
                                  child: const Text(
                                    'https://www.deplacemaison.com/',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              // Boton de navegacion a la URL.
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                color: Colors.grey,
                                child: const Text(
                                  'Go',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 4),

                        // Timeline interactivo de capturas por año.
                        _Timeline(controller: _controller),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Columna derecha: navegador de meses y acciones de la captura.
                  Row(
                    children: [
                      const Icon(
                        Icons.chevron_left,
                        color: Color(0xFF4A9EDB),
                        size: 16,
                      ),
                      // Etiquetas de los meses disponibles; el central es el activo.
                      ...active.months.map(
                        (m) => _MonthLabel(
                          month: m.label,
                          year: m.shortYear,
                          isActive: m == active.months[1],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: Color(0xFF4A9EDB),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'ABOUT THIS CAPTURE',
                        style: TextStyle(color: Colors.grey, fontSize: 9),
                      ),
                      const SizedBox(width: 12),
                      // Iconos de acciones: usuario, info y compartir.
                      const Icon(Icons.person_outline, color: Colors.grey, size: 18),
                      const SizedBox(width: 8),
                      const Icon(Icons.info_outline, color: Colors.grey, size: 18),
                      const SizedBox(width: 8),
                      const Icon(Icons.share, color: Colors.grey, size: 18),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Widget que envuelve el area del timeline y conecta los eventos del mouse
/// con el controlador.
class _Timeline extends StatelessWidget {
  final WayArchiveController controller;
  const _Timeline({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;
          return MouseRegion(
            // Actualiza la seccion activa segun la posicion horizontal del cursor.
            onHover: (e) => controller.onHover(e.localPosition.dx, totalWidth),
            onExit: (_) => controller.onExit(),
            child: CustomPaint(
              size: Size(totalWidth, 28),
              painter: _TimelinePainter(
                data: WayArchiveRepository.data,
                activeIndex: controller.activeIndex,
                hoverX: controller.hoverX,
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Painter que dibuja el timeline completo: secciones por año, barras de actividad
/// y una linea vertical que sigue al cursor.
class _TimelinePainter extends CustomPainter {
  final List data;
  final int activeIndex;

  /// Posicion X del cursor; null cuando el cursor esta fuera del timeline.
  final double? hoverX;

  const _TimelinePainter({
    required this.data,
    required this.activeIndex,
    this.hoverX,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final sectionWidth = size.width / data.length;

    // Altura disponible para las barras; los 10px inferiores son para las etiquetas de año.
    final barAreaHeight = size.height - 10;

    for (int s = 0; s < data.length; s++) {
      final sectionX = s * sectionWidth;
      final isActive = activeIndex == s;

      // Fondo amarillo semitransparente para la seccion activa.
      if (isActive) {
        canvas.drawRect(
          Rect.fromLTWH(sectionX, 0, sectionWidth, barAreaHeight),
          Paint()..color = Colors.yellow.withOpacity(0.3),
        );
      }

      // Borde de la seccion: amarillo y mas grueso si esta activa.
      canvas.drawRect(
        Rect.fromLTWH(sectionX, 0, sectionWidth, barAreaHeight),
        Paint()
          ..color = isActive ? Colors.yellow : Colors.grey.shade300
          ..style = PaintingStyle.stroke
          ..strokeWidth = isActive ? 1.5 : 0.5,
      );

      // Barras de actividad proporcionales al valor maximo de la seccion.
      final bars = data[s].bars as List<int>;
      final maxVal = bars.reduce((a, b) => a > b ? a : b).toDouble();
      final barWidth = (sectionWidth - 4) / bars.length;

      for (int i = 0; i < bars.length; i++) {
        final barHeight = (bars[i] / maxVal) * (barAreaHeight - 4);
        canvas.drawRect(
          Rect.fromLTWH(
            sectionX + 2 + i * barWidth,
            barAreaHeight - barHeight - 2,
            barWidth - 0.5,
            barHeight,
          ),
          Paint()
            ..color = isActive ? Colors.grey.shade600 : Colors.grey.shade400,
        );
      }

      // Etiqueta del año centrada debajo de cada seccion.
      final tp = TextPainter(
        text: TextSpan(
          text: data[s].year,
          style: TextStyle(
            color: isActive ? Colors.black : Colors.grey,
            fontSize: 8,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(
        canvas,
        Offset(sectionX + sectionWidth / 2 - tp.width / 2, barAreaHeight + 1),
      );
    }

    // Linea vertical que sigue al cursor para indicar la posicion exacta.
    if (hoverX != null) {
      canvas.drawLine(
        Offset(hoverX!, 0),
        Offset(hoverX!, barAreaHeight),
        Paint()
          ..color = Colors.black54
          ..strokeWidth = 1,
      );
    }
  }

  /// Solo repinta cuando cambia la seccion activa o la posicion del cursor.
  @override
  bool shouldRepaint(_TimelinePainter old) =>
      old.activeIndex != activeIndex || old.hoverX != hoverX;
}

/// Etiqueta de un mes en el navegador lateral del timeline.
/// Se resalta con fondo amarillo cuando es el mes activo.
class _MonthLabel extends StatelessWidget {
  final String month;
  final String year;
  final bool isActive;

  const _MonthLabel({
    required this.month,
    required this.year,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    if (isActive) {
      // Mes activo: fondo amarillo y texto en negrita.
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        color: Colors.yellow,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              month,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              year,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    // Mes inactivo: texto gris sin decoracion.
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(month, style: const TextStyle(color: Colors.grey, fontSize: 8)),
          Text(year, style: const TextStyle(color: Colors.grey, fontSize: 9)),
        ],
      ),
    );
  }
}