import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

// import '../../../../core/extensions/color_ext.dart';
import '../../../../core/data/entities/activity_entity.dart';
import '../../../home/presentation/providers/activity_provider.dart';

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
                    labelText: 'Name',
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
    final ValueNotifier<Color?> pickedColor = useValueNotifier<Color?>(null);
    final ExpansionTileController expansionController =
        useExpansionTileController();

    return ExpansionTile(
      controller: expansionController,
      title: const Text(
        'Color',
      ),
      trailing: ValueListenableBuilder<Color?>(
        valueListenable: pickedColor,
        builder: (BuildContext context, Color? color, Widget? child) {
          return Icon(
            Icons.color_lens,
            color: color,
          );
        },
      ),
      children: <Widget>[
        Wrap(
          children: Colors.primaries
              .map(
                (MaterialColor color) => InkWell(
                  onTap: () {
                    pickedColor.value = color;
                    form.control('colorHex').value = color.toHexString();
                    expansionController.collapse();
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
