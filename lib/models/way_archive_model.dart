/// Datos de un año en el timeline del WayArchive.
/// Incluye los meses representativos y los valores de actividad
/// que se usan para dibujar las barras en el timeline.
class WayArchiveModel {
  final String year;

  /// Tres meses representativos del periodo; el central es el activo.
  final List<WayArchiveMonth> months;

  /// Valores relativos de actividad para las barras del histograma.
  final List<int> bars;

  const WayArchiveModel({
    required this.year,
    required this.months,
    required this.bars,
  });
}

/// Mes individual del navegador lateral del WayArchive.
class WayArchiveMonth {
  /// Abreviatura del mes en ingles, por ejemplo 'AUG'.
  final String label;

  /// Año abreviado en dos digitos, por ejemplo '19'.
  final String shortYear;

  const WayArchiveMonth({required this.label, required this.shortYear});
}