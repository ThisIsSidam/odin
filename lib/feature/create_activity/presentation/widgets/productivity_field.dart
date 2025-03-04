import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ProductivityLvlField extends HookWidget {
  const ProductivityLvlField({required this.form, super.key});
  final FormGroup form;

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<int> lvlNotifier =
        useState<int>(form.control('productivityLvl').value as int? ?? 3);
    return ListTile(
      title: const Text('Productivity level'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton.filled(
            onPressed: lvlNotifier.value > 1
                ? () {
                    lvlNotifier.value -= 1;
                    form.control('productivityLvl').value = lvlNotifier.value;
                  }
                : null,
            icon: const Icon(Icons.chevron_left),
          ),
          SizedBox(
            width: 50,
            child: Center(child: Text(lvlNotifier.value.toString())),
          ),
          IconButton.filled(
            onPressed: lvlNotifier.value < 10
                ? () {
                    lvlNotifier.value += 1;
                    form.control('productivityLvl').value = lvlNotifier.value;
                  }
                : null,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}
