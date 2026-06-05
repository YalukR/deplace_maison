import 'package:deplace_maison/models/way_archive_model.dart';
import 'package:deplace_maison/repository/way_archive_repository.dart';
import 'package:flutter/material.dart';

class WayArchiveController extends ChangeNotifier {
  int _activeIndex = 2;
  double? _hoverX;

  int get activeIndex => _activeIndex;
  double? get hoverX => _hoverX;

  WayArchiveModel get activeData => WayArchiveRepository.data[_activeIndex];
  void onHover(double x, double totalWidth) {
    final section = (x / (totalWidth / WayArchiveRepository.data.length))
        .floor()
        .clamp(0, WayArchiveRepository.data.length - 1);
    _hoverX = x;
    _activeIndex = section;
    notifyListeners();
  }

  void onExit() {
    _hoverX = null;
    notifyListeners();
  }
}
