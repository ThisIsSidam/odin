import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/focus_provider.dart';

class IconPickerField extends HookConsumerWidget {
  const IconPickerField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ActivityFocusedWidget focused =
        ref.watch(focusedWidgetNotifierProvider);
    final ValueNotifier<IconData?> pickedIcon =
        useValueNotifier<IconData?>(null);

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
          title: const Text('Icon'),
          trailing: ValueListenableBuilder<IconData?>(
            valueListenable: pickedIcon,
            builder: (BuildContext context, IconData? icon, Widget? child) {
              return Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon ?? Icons.question_answer,
                  color: Theme.of(context).colorScheme.surface,
                ),
              );
            },
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Colors.grey),
          ),
        ),
        if (focused == ActivityFocusedWidget.iconPicker)
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 50,
            ),
            itemBuilder: (BuildContext context, int index) {
              return const SizedBox();
              // final IconData icon = icons[index];
              // return InkWell(
              //   onTap: () {
              //     setState(() => _selectedIcon = icon);
              //     Navigator.pop(context);
              //   },
              //   child: Icon(icon, size: 32),
              // );
            },
          ),
      ],
    );
  }
}
