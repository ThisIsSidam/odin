import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/data/entities/activity_entity.dart';
import '../providers/activity_fields_provider.dart';
import '../providers/focus_provider.dart';

class ColorPickerField extends HookConsumerWidget {
  const ColorPickerField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ActivityFocusedWidget focused =
        ref.watch(focusedWidgetNotifierProvider);

    final Color? pickedColor = ref.watch(
      activityFieldsNotifierProvider.select(
        (ActivityEntity a) => a.colorHex?.toColor(),
      ),
    );

    return Column(
      children: <Widget>[
        ListTile(
          onTap: () {
            if (focused == ActivityFocusedWidget.colorPicker) {
              ref.read(focusedWidgetNotifierProvider.notifier).changeFocus =
                  ActivityFocusedWidget.none;
            } else {
              ref.read(focusedWidgetNotifierProvider.notifier).changeFocus =
                  ActivityFocusedWidget.colorPicker;
            }
          },
          title: const Text('Color'),
          trailing: Icon(
            Icons.color_lens,
            color: pickedColor,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Colors.grey),
          ),
        ),
        if (focused == ActivityFocusedWidget.colorPicker)
          Wrap(
            children: Colors.primaries
                .map(
                  (MaterialColor color) => InkWell(
                    onTap: () {
                      ref
                          .read(activityFieldsNotifierProvider.notifier)
                          .colorHex = color.toHexString();
                    },
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}
