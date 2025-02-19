import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

// import '../../../../core/extensions/color_ext.dart';
import '../../../../core/data/entities/activity_models.dart';

class CreateActivityScreen extends HookConsumerWidget {
  const CreateActivityScreen({super.key});

  FormGroup buildForm() => fb.group(<String, List<Object?>>{
        'name': <void>['', Validators.required],
        'description': <String>[''],
        'importanceLevel': <int>[1],
        'colorHex': <void>[null],
      });

  void saveActivity(
    BuildContext context,
    WidgetRef ref,
    FormGroup form,
  ) {
    if (form.valid) {
      // final Map<String, Object?> formValue = form.value;
      // Save activity
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Activity'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: ReactiveFormBuilder(
            form: buildForm,
            builder: (
              BuildContext context,
              FormGroup form,
              Widget? child,
            ) =>
                Column(
              spacing: 16,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ReactiveTextField<String>(
                  formControlName: 'name',
                  decoration: const InputDecoration(
                    labelText: 'Activity Name',
                  ),
                  validationMessages: <String, String Function(dynamic error)>{
                    'required': (_) => 'Please enter an activity name',
                  },
                ),
                buildColorPicker(null, form),
                ReactiveTextField<String>(
                  formControlName: 'description',
                  decoration: const InputDecoration(
                    labelText: 'Description (Optional)',
                  ),
                  maxLines: 3,
                ),
                ElevatedButton(
                  onPressed: () => saveActivity(context, ref, form),
                  child: const Text('Create Activity'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildColorPicker(ActivityEntity? activity, FormGroup form) {
    return HookBuilder(
      builder: (BuildContext context) {
        final TextEditingController colorController = useTextEditingController(
          text: form.control('colorHex').value?.toString() ?? '',
        );

        useEffect(
          () {
            void updateColor(dynamic value) {
              colorController.text = value?.toString() ?? '';
            }

            form.control('colorHex').valueChanges.listen(updateColor);

            return () {
              form.control('colorHex').valueChanges.drain<String>();
            };
          },
          <Object?>[],
        );

        final String? colorHex = form.control('colorHex').value as String?;

        final Color pickerColor =
            colorHex != null ? colorHex.toColor() ?? Colors.blue : Colors.blue;
        return TextField(
          controller: colorController,
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'Color',
            prefix: const Text('#'),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.color_lens,
                color: pickerColor,
              ),
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return PopScope(
                      canPop: false,
                      child: AlertDialog(
                        title: const Text('Pick a color'),
                        content: SingleChildScrollView(
                          child: ColorPicker(
                            pickerColor: pickerColor,
                            onColorChanged: (Color color) {
                              form.control('colorHex').value =
                                  color.toHexString();
                            },
                            pickerAreaHeightPercent: 0.7,
                            enableAlpha: false,
                            displayThumbColor: true,
                            pickerAreaBorderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(2),
                              topRight: Radius.circular(2),
                            ),
                            hexInputBar: true,
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Done'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
