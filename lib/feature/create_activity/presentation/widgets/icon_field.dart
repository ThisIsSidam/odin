import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class IconPickerField extends HookConsumerWidget {
  const IconPickerField({required this.form, super.key});
  final FormGroup form;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ValueNotifier<Color?> pickedColor = useValueNotifier<Color?>(null);
    final ExpansionTileController expansionController =
        useExpansionTileController();

    return ExpansionTile(
      controller: expansionController,
      title: const Text(
        'Icon',
      ),
      shape: const RoundedRectangleBorder(),
      trailing: ValueListenableBuilder<Color?>(
        valueListenable: pickedColor,
        builder: (BuildContext context, Color? color, Widget? child) {
          return Icon(
            Icons.color_lens,
            color: color,
          );
        },
      ),
    );
  }
}
