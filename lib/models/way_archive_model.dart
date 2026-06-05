class WayArchiveModel {
  final String year;
  final List<WayArchiveMonth> months;
  final List<int> bars;

  const WayArchiveModel({
    required this.year,
    required this.months,
    required this.bars,
  });
}

class WayArchiveMonth {
  final String label;
  final String shortYear;

  const WayArchiveMonth({required this.label, required this.shortYear});
}
