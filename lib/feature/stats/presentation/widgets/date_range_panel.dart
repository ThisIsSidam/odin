import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/extensions/datetime_ext.dart';
import '../providers/date_range_provider.dart';

class DateRangePanel extends ConsumerWidget {
  const DateRangePanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            range.start.friendly,
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
