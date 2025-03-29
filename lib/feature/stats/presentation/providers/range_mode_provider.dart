import 'package:riverpod_annotation/riverpod_annotation.dart';

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
    return DateRangeMode.daily; // Default value
  }

  set rangeMode(DateRangeMode mode) {
    state = mode;
  }
}
