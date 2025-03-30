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
            Text(currentMode.label),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
      itemBuilder: (BuildContext context) => DateRangeMode.values
          .map(
            (DateRangeMode e) => PopupMenuItem<DateRangeMode>(
              value: e,
              child: Text(e.label),
            ),
          )
          .toList(),
    );
  }
}
