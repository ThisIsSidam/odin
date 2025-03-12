import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

// import '../../../../core/extensions/color_ext.dart';
import '../../../../core/data/entities/activity_entity.dart';
import '../../../../core/data/models/activity.dart';
import '../../../home/presentation/providers/activity_provider.dart';
import '../widgets/color_field.dart';
import '../widgets/icon_field.dart';
import '../widgets/productivity_field.dart';

class ActivityScreen extends ConsumerWidget {
  const ActivityScreen({this.id, super.key});

  final int? id;

  FormGroup buildForm(Activity? activity) => fb.group(<String, List<Object?>>{
        'name': <void>[activity?.name ?? '', Validators.required],
        'description': <String>[activity?.description ?? ''],
        'productivityLvl': <int>[activity?.productivityLevel ?? 3],
        'colorHex': <void>[activity?.color?.toHexString()],
      });

  void saveActivity(
    BuildContext context,
    WidgetRef ref,
    FormGroup form,
  ) {
    if (form.valid) {
      final ActivityEntity newActivity = ActivityEntity(
        id: id ?? 0,
        name: form.control('name').value as String,
        description: form.control('description').value as String,
        productivityLevel: form.control('productivityLvl').value as int,
        colorHex: form.control('colorHex').value as String?,
      );
      ref.read(activityNotifierProvider.notifier).createActivity(newActivity);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Activity? activity = id != null
        ? ref.read(activityNotifierProvider.notifier).getActivity(id!)
        : null;
    return Scaffold(
      appBar: AppBar(
        title: Text(id == null ? 'Create Activity' : 'Edit Activiy'),
        actions: <Widget>[
          if (activity != null)
            IconButton(
              icon: const Icon(Icons.hide_source),
              onPressed: () {
                ref
                    .read(activityNotifierProvider.notifier)
                    .hideActivity(activity.id);
                Navigator.pop(context);
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: ReactiveFormBuilder(
            form: () => buildForm(activity),
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
                IconPickerField(form: form),
                ProductivityLvlField(form: form),
                ReactiveTextField<String>(
                  formControlName: 'description',
                  decoration: const InputDecoration(
                    labelText: 'Description (Optional)',
                  ),
                  maxLines: 3,
                ),
                ElevatedButton(
                  onPressed: () => saveActivity(context, ref, form),
                  child: Text(
                    id == null ? 'Create Activity' : 'Save Activiy',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
