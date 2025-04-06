// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/datetime_ext.dart';

class LogTimeField extends HookWidget {
  const LogTimeField({
    required this.onChanged,
    required this.label,
    this.dt,
    super.key,
  });

  final DateTime? dt;
  final String label;
  final void Function(DateTime) onChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool is24Hour = MediaQuery.of(context).alwaysUse24HourFormat;
    final ValueNotifier<DateTime> dtNotifier =
        useValueNotifier<DateTime>(dt ?? DateTime.now());

    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).colorScheme.primary),
      ),
      onTap: () async {
        final DateTime? result = is24Hour
            ? await DatePicker.showTimePicker(
                context,
                showSecondsColumn: false,
                currentTime: dtNotifier.value,
              )
            : await DatePicker.showTime12hPicker(
                context,
                currentTime: dtNotifier.value,
              );

        if (result != null) {
          dtNotifier.value = result;
          onChanged(result);
        }
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ValueListenableBuilder<DateTime>(
              valueListenable: dtNotifier,
              builder: (BuildContext context, DateTime dt, _) {
                return AbsorbPointer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        label,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.primaryFixedDim,
                        ),
                      ),
                      Text(
                        dt.friendlyComplete(use24Hour: is24Hour),
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                );
              },
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Row(
                children: <Widget>[
                  TimeButton(
                    label: '-30',
                    onTap: () {
                      final DateTime newValue = dtNotifier.value
                          .subtract(const Duration(minutes: 30));
                      dtNotifier.value = newValue;
                      onChanged(newValue);
                    },
                  ),
                  TimeButton(
                    label: '-5',
                    onTap: () {
                      final DateTime newValue =
                          dtNotifier.value.subtract(const Duration(minutes: 5));
                      dtNotifier.value = newValue;
                      onChanged(newValue);
                    },
                  ),
                  TimeButton(
                    label: '-1',
                    onTap: () {
                      final DateTime newValue =
                          dtNotifier.value.subtract(const Duration(minutes: 1));
                      dtNotifier.value = newValue;
                      onChanged(newValue);
                    },
                  ),
                  TimeButton(
                    label: '+1',
                    onTap: () {
                      final DateTime newValue =
                          dtNotifier.value.add(const Duration(minutes: 1));
                      dtNotifier.value = newValue;
                      onChanged(newValue);
                    },
                  ),
                  TimeButton(
                    label: '+5',
                    onTap: () {
                      final DateTime newValue =
                          dtNotifier.value.add(const Duration(minutes: 5));
                      dtNotifier.value = newValue;
                      onChanged(newValue);
                    },
                  ),
                  TimeButton(
                    label: '+30',
                    onTap: () {
                      final DateTime newValue =
                          dtNotifier.value.add(const Duration(minutes: 30));
                      dtNotifier.value = newValue;
                      onChanged(newValue);
                    },
                  ),
                  TimeButton(
                    label: 'Now',
                    onTap: () {
                      final DateTime newValue = DateTime.now();
                      dtNotifier.value = newValue;
                      onChanged(newValue);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TimeButton extends ConsumerWidget {
  const TimeButton({required this.label, required this.onTap, super.key});

  final VoidCallback onTap;
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Flexible(
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: const BeveledRectangleBorder(),
        ),
        child: Text(
          label,
        ),
      ),
    );
  }
}
