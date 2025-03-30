import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'date_range_provider.dart';

part 'generated/range_mode_provider.g.dart';

enum DateRangeMode {
  daily,
  weekly,
  monthly,
}

@riverpod
class RangeMode extends _$RangeMode {
  @override
  DateRangeMode build() {
    return DateRangeMode.daily;
  }

  set rangeMode(DateRangeMode mode) {
    state = mode;
    final DateRangeNotifier dateRangeNotifier =
        ref.read(dateRangeNotifierProvider.notifier);
    final DateTime currentDate = ref.read(dateRangeNotifierProvider).start;

    switch (mode) {
      case DateRangeMode.daily:
        dateRangeNotifier.updateDateRange(
          start: DateTime(currentDate.year, currentDate.month, currentDate.day),
          end: DateTime(
            currentDate.year,
            currentDate.month,
            currentDate.day + 1,
          ),
        );
      case DateRangeMode.weekly:
        final DateTime monday =
            currentDate.subtract(Duration(days: currentDate.weekday - 1));
        final DateTime sunday = monday.add(const Duration(days: 6));
        dateRangeNotifier.updateDateRange(
          start: DateTime(monday.year, monday.month, monday.day),
          end: DateTime(sunday.year, sunday.month, sunday.day),
        );
      case DateRangeMode.monthly:
        final DateTime firstDay = DateTime(currentDate.year, currentDate.month);
        final DateTime lastDay =
            DateTime(currentDate.year, currentDate.month + 1, 0);
        dateRangeNotifier.updateDateRange(
          start: firstDay,
          end: lastDay,
        );
    }
  }
}
