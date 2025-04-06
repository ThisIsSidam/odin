import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ProxyTextField extends HookWidget {
  const ProxyTextField({
    required this.onChanged,
    this.value,
    this.decoration,
    this.proxyDecoration,
    super.key,
  });

  final String? value;
  final InputDecoration? decoration;
  final InputDecoration? proxyDecoration;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller =
        useTextEditingController(text: value);
    return GestureDetector(
      onTap: () async {
        final String? result = await showModalBottomSheet<String>(
          context: context,
          isScrollControlled: true,
          builder: (_) => FieldSheet(
            value: controller.text,
            decoration: proxyDecoration,
          ),
        );

        if (result != null) {
          controller.text = result;
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

class FieldSheet extends HookWidget {
  const FieldSheet({required this.value, this.decoration, super.key});

  final String value;
  final InputDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller =
        useTextEditingController(text: value);
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        left: 16,
        right: 16,
        top: 20,
      ),
      child: TextField(
        controller: controller,
        autofocus: true,
        decoration: decoration?.copyWith(
              suffixIcon: IconButton(
                icon: const Icon(Icons.done),
                onPressed: () {
                  return Navigator.pop(context, controller.text);
                },
              ),
            ) ??
            InputDecoration(
              hintText: 'Enter',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.done),
                onPressed: () {
                  return Navigator.pop(context, controller.text);
                },
              ),
            ),
        onSubmitted: (String text) => Navigator.pop(context, text),
      ),
    );
  }
}
