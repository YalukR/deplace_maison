import 'package:deplace_maison/models/way_archive_model.dart';

class WayArchiveRepository {
  static const List<WayArchiveModel> data = [
    WayArchiveModel(
      year: '2019',
      months: [
        WayArchiveMonth(label: 'AUG', shortYear: '19'),
        WayArchiveMonth(label: 'SEP', shortYear: '19'),
        WayArchiveMonth(label: 'OCT', shortYear: '19'),
      ],
      bars: [1, 1, 2, 1, 1, 2, 1, 1, 2, 1, 1, 2],
    ),
    WayArchiveModel(
      year: '2020',
      months: [
        WayArchiveMonth(label: 'JAN', shortYear: '20'),
        WayArchiveMonth(label: 'JUN', shortYear: '20'),
        WayArchiveMonth(label: 'DEC', shortYear: '20'),
      ],
      bars: [2, 3, 2, 4, 3, 2, 3, 4, 2, 3, 2, 3],
    ),
    WayArchiveModel(
      year: '2021',
      months: [
        WayArchiveMonth(label: 'DEC', shortYear: '21'),
        WayArchiveMonth(label: 'JAN', shortYear: '22'),
        WayArchiveMonth(label: 'MAR', shortYear: '23'),
      ],
      bars: [3, 4, 5, 6, 4, 3, 5, 7, 4, 5, 3, 4],
    ),
    WayArchiveModel(
      year: '2022',
      months: [
        WayArchiveMonth(label: 'FEB', shortYear: '22'),
        WayArchiveMonth(label: 'JUL', shortYear: '22'),
        WayArchiveMonth(label: 'NOV', shortYear: '22'),
      ],
      bars: [4, 5, 6, 8, 5, 4, 6, 9, 5, 6, 4, 5],
    ),
    WayArchiveModel(
      year: '2023',
      months: [
        WayArchiveMonth(label: 'MAR', shortYear: '23'),
        WayArchiveMonth(label: 'AUG', shortYear: '23'),
        WayArchiveMonth(label: 'DEC', shortYear: '23'),
      ],
      bars: [3, 4, 5, 7, 4, 3, 5, 8, 4, 5, 3, 4],
    ),
    WayArchiveModel(
      year: '2024',
      months: [
        WayArchiveMonth(label: 'JAN', shortYear: '24'),
        WayArchiveMonth(label: 'MAY', shortYear: '24'),
        WayArchiveMonth(label: 'OCT', shortYear: '24'),
      ],
      bars: [2, 3, 4, 5, 3, 2, 4, 6, 3, 4, 2, 3],
    ),
    WayArchiveModel(
      year: '2025',
      months: [
        WayArchiveMonth(label: 'JAN', shortYear: '25'),
        WayArchiveMonth(label: 'MAY', shortYear: '25'),
        WayArchiveMonth(label: 'SEP', shortYear: '25'),
      ],
      bars: [1, 2, 3, 4, 2, 1, 3, 5, 2, 3, 1, 2],
    ),
  ];
}
