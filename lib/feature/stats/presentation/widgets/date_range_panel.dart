import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/extensions/datetime_ext.dart';
import '../providers/date_range_provider.dart';
import '../providers/range_mode_provider.dart';

class DateRangePanel extends ConsumerWidget {
  const DateRangePanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateRangeMode mode = ref.watch(rangeModeProvider);
    final DateRange range = ref.watch(dateRangeNotifierProvider);
    return BottomAppBar(
      child: Row(
        spacing: 8,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton.filled(
            onPressed: () =>
                ref.read(dateRangeNotifierProvider.notifier).toPrevious(),
            icon: const Icon(Icons.chevron_left),
          ),
          Text(
            mode == DateRangeMode.daily
                ? range.start.friendly
                : '${range.start.friendly} ~ ${range.end.friendly}',
          ),
          IconButton.filled(
            onPressed: () =>
                ref.read(dateRangeNotifierProvider.notifier).toNext(),
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}
