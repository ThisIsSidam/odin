import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

// import '../../../../core/extensions/color_ext.dart';
import '../../../../core/data/entities/activity_entities.dart';
import '../providers/activity_provider.dart';

class CreateActivityScreen extends ConsumerWidget {
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
      final ActivityEntity newActivity = ActivityEntity(
        name: form.control('name').value as String,
        description: form.control('description').value as String,
        importanceLevel: form.control('importanceLevel').value as int,
        colorHex: form.control('colorHex').value as String?,
      );
      ref.read(activityNotifierProvider.notifier).createActivity(newActivity);
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
                ColorPickerField(form: form),
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
}

class ColorPickerField extends HookConsumerWidget {
  const ColorPickerField({required this.form, super.key});
  final FormGroup form;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController colorController = useTextEditingController(
      text: form.control('colorHex').value as String?,
    );

    final ValueNotifier<Color?> pickedColor = useValueNotifier<Color?>(null);

    useEffect(
      () {
        form.control('colorHex').valueChanges.listen(
          (dynamic value) {
            colorController.text = value as String? ?? '';
            pickedColor.value = colorController.text.toColor();
          },
        );

        return null;
      },
      <Object?>[],
    );
    return TextField(
      controller: colorController,
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Color',
        prefix: const Text('#'),
        suffixIcon: IconButton(
          icon: ValueListenableBuilder<Color?>(
            valueListenable: pickedColor,
            builder: (BuildContext context, Color? color, Widget? child) {
              return Icon(
                Icons.color_lens,
                color: color,
              );
            },
          ),
          onPressed: () {
            showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return _buildColorPickerDialog(context, pickedColor);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildColorPickerDialog(
    BuildContext context,
    ValueNotifier<Color?> pickedColor,
  ) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        title: const Text('Pick a color'),
        content: SingleChildScrollView(
          child: ValueListenableBuilder<Color?>(
            valueListenable: pickedColor,
            builder: (BuildContext context, Color? color, Widget? child) {
              return ColorPicker(
                pickerColor: color ?? Colors.blue,
                onColorChanged: (Color color) {
                  form.control('colorHex').value = color.toHexString();
                },
                pickerAreaHeightPercent: 0.7,
                enableAlpha: false,
                displayThumbColor: true,
                pickerAreaBorderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(2),
                  topRight: Radius.circular(2),
                ),
                hexInputBar: true,
              );
            },
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
  }
}
