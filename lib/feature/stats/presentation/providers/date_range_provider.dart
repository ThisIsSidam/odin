import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'range_mode_provider.dart';

part 'generated/date_range_provider.g.dart';

class DateRange {
  final DateTime start;
  final DateTime end;

  const DateRange({required this.start, required this.end});
}

@riverpod
class DateRangeNotifier extends _$DateRangeNotifier {
  @override
  DateRange build() {
    final DateTime now = DateTime.now();
    return DateRange(
      start: DateTime(now.year, now.month, now.day),
      end: DateTime(now.year, now.month, now.day + 1),
    );
  }

  void updateDateRange({DateTime? start, DateTime? end}) {
    if ((start ?? state.start).isAfter(end ?? state.end)) return;
    state = DateRange(start: start ?? state.start, end: end ?? state.end);
  }

  void toPrevious() {
    final DateRangeMode mode = ref.read(rangeModeProvider);
    switch (mode) {
      case DateRangeMode.daily:
        toYesterday();
      case DateRangeMode.weekly:
        toLastWeek();
      case DateRangeMode.monthly:
        toLastMonth();
    }
  }

  void toNext() {
    final DateRangeMode mode = ref.read(rangeModeProvider);
    switch (mode) {
      case DateRangeMode.daily:
        toTomorrow();
      case DateRangeMode.weekly:
        toNextWeek();
      case DateRangeMode.monthly:
        toNextMonth();
    }
  }

  void toYesterday() {
    state = DateRange(
      start: state.start.subtract(const Duration(days: 1)),
      end: state.end.subtract(const Duration(days: 1)),
    );
  }

  void toTomorrow() {
    state = DateRange(
      start: state.start.add(const Duration(days: 1)),
      end: state.end.add(const Duration(days: 1)),
    );
  }

  void toLastWeek() {
    state = DateRange(
      start: state.start.subtract(const Duration(days: 7)),
      end: state.end.subtract(const Duration(days: 7)),
    );
  }

  void toNextWeek() {
    state = DateRange(
      start: state.start.add(const Duration(days: 7)),
      end: state.end.add(const Duration(days: 7)),
    );
  }

  void toLastMonth() {
    final DateTime startMonth =
        DateTime(state.start.year, state.start.month - 1, state.start.day);
    final DateTime endMonth =
        DateTime(state.end.year, state.end.month - 1, state.end.day);
    state = DateRange(start: startMonth, end: endMonth);
  }

  void toNextMonth() {
    final DateTime startMonth =
        DateTime(state.start.year, state.start.month + 1, state.start.day);
    final DateTime endMonth =
        DateTime(state.end.year, state.end.month + 1, state.end.day);
    state = DateRange(start: startMonth, end: endMonth);
  }
}
