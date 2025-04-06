// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../core/extensions/datetime_ext.dart';

class ProxyTimeField extends HookWidget {
  const ProxyTimeField({
    required this.onChanged,
    this.dt,
    this.decoration,
    super.key,
  });

  final DateTime? dt;
  final InputDecoration? decoration;
  final void Function(DateTime) onChanged;

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = useTextEditingController(
      text: (dt ?? DateTime.now()).friendlyComplete,
    );
    return GestureDetector(
      onTap: () async {
        final bool is24Hour = MediaQuery.of(context).alwaysUse24HourFormat;

        final DateTime? result = is24Hour
            ? await DatePicker.showTimePicker(
                context,
                showSecondsColumn: false,
                currentTime: DateTime.now(),
              )
            : await DatePicker.showTime12hPicker(
                context,
              );

        if (result != null) {
          controller.text = result.friendlyComplete;
          onChanged(result);
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: controller,
          decoration: decoration,
        ),
      ),
    );
  }
}
