import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/range_mode_provider.dart';

class DateRangeModeButton extends ConsumerWidget {
  const DateRangeModeButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateRangeMode currentMode = ref.watch(rangeModeProvider);

    return PopupMenuButton<DateRangeMode>(
      initialValue: currentMode,
      onSelected: (DateRangeMode mode) {
        ref.read(rangeModeProvider.notifier).rangeMode = mode;
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(_getModeText(currentMode)),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<DateRangeMode>>[
        const PopupMenuItem<DateRangeMode>(
          value: DateRangeMode.daily,
          child: Text('Daily'),
        ),
        const PopupMenuItem<DateRangeMode>(
          value: DateRangeMode.weekly,
          child: Text('Weekly'),
        ),
        const PopupMenuItem<DateRangeMode>(
          value: DateRangeMode.monthly,
          child: Text('Monthly'),
        ),
      ],
    );
  }

  String _getModeText(DateRangeMode mode) {
    switch (mode) {
      case DateRangeMode.daily:
        return 'Daily';
      case DateRangeMode.weekly:
        return 'Weekly';
      case DateRangeMode.monthly:
        return 'Monthly';
    }
  }
}
