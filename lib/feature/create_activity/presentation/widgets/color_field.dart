import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../providers/focus_provider.dart';

class ColorPickerField extends HookConsumerWidget {
  const ColorPickerField({required this.form, super.key});
  final FormGroup form;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ActivityFocusedWidget focused =
        ref.watch(focusedWidgetNotifierProvider);

    final ValueNotifier<Color?> pickedColor = useValueNotifier<Color?>(
      (form.control('colorHex').value as String?)?.toColor(),
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
          trailing: ValueListenableBuilder<Color?>(
            valueListenable: pickedColor,
            builder: (BuildContext context, Color? color, Widget? child) {
              return Icon(
                Icons.color_lens,
                color: color,
              );
            },
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
                      pickedColor.value = color;
                      form.control('colorHex').value = color.toHexString();
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
