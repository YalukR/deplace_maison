import 'package:deplace_maison/models/way_archive_model.dart';
import 'package:deplace_maison/repository/way_archive_repository.dart';
import 'package:flutter/material.dart';

/// Controlador de estado para el widget WayArchive.
/// Gestiona qué sección del timeline está activa y la posición del cursor.
class WayArchiveController extends ChangeNotifier {
  /// Índice de la sección actualmente activa en el timeline.
  int _activeIndex = 2;

  /// Posición X del cursor sobre el timeline; null si el cursor está fuera.
  double? _hoverX;

  int get activeIndex => _activeIndex;
  double? get hoverX => _hoverX;

  /// Devuelve los datos del modelo correspondientes a la sección activa.
  WayArchiveModel get activeData => WayArchiveRepository.data[_activeIndex];

  /// Calcula la sección bajo el cursor y actualiza el índice activo.
  /// [x] es la posición local del cursor; [totalWidth] es el ancho total del timeline.
  void onHover(double x, double totalWidth) {
    final section = (x / (totalWidth / WayArchiveRepository.data.length))
        .floor()
        .clamp(0, WayArchiveRepository.data.length - 1);

    _hoverX = x;
    _activeIndex = section;
    notifyListeners();
  }

  /// Limpia la posición del cursor cuando sale del área del timeline.
  void onExit() {
    _hoverX = null;
    notifyListeners();
  }
}