import 'package:deplace_maison/repository/way_archive_repository.dart';
import 'package:flutter/material.dart';
import 'package:deplace_maison/layout/widgets/way_archive_controller.dart';

class WayArchive extends StatefulWidget {
  const WayArchive({super.key});

  @override
  State<WayArchive> createState() => _WayArchiveState();
}

class _WayArchiveState extends State<WayArchive> {
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
        final active = _controller.activeData;
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
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

                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 24,
                          child: Row(
                            children: [
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

                        _Timeline(controller: _controller),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  Row(
                    children: [
                      const Icon(
                        Icons.chevron_left,
                        color: Color(0xFF4A9EDB),
                        size: 16,
                      ),
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
                      const Icon(
                        Icons.person_outline,
                        color: Colors.grey,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.info_outline,
                        color: Colors.grey,
                        size: 18,
                      ),
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

class _TimelinePainter extends CustomPainter {
  final List data;
  final int activeIndex;
  final double? hoverX;

  const _TimelinePainter({
    required this.data,
    required this.activeIndex,
    this.hoverX,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final sectionWidth = size.width / data.length;
    final barAreaHeight = size.height - 10;

    for (int s = 0; s < data.length; s++) {
      final sectionX = s * sectionWidth;
      final isActive = activeIndex == s;

      if (isActive) {
        canvas.drawRect(
          Rect.fromLTWH(sectionX, 0, sectionWidth, barAreaHeight),
          Paint()..color = Colors.yellow.withOpacity(0.3),
        );
      }

      canvas.drawRect(
        Rect.fromLTWH(sectionX, 0, sectionWidth, barAreaHeight),
        Paint()
          ..color = isActive ? Colors.yellow : Colors.grey.shade300
          ..style = PaintingStyle.stroke
          ..strokeWidth = isActive ? 1.5 : 0.5,
      );

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

  @override
  bool shouldRepaint(_TimelinePainter old) =>
      old.activeIndex != activeIndex || old.hoverX != hoverX;
}

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
