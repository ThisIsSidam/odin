import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/data/entities/activity_entity.dart';
import '../../../../core/data/models/activity.dart';
import '../../../../core/exceptions/limitations.dart';
import '../../../../shared/utils/app_utils.dart';
import '../../../home/presentation/providers/activity_provider.dart';
import '../providers/activity_fields_provider.dart';
import '../providers/focus_provider.dart';
import '../widgets/color_field.dart';
import '../widgets/icon_field.dart';
import '../widgets/productivity_field.dart';

class ActivityScreen extends ConsumerWidget {
  const ActivityScreen({super.key});

  void onConfirm(BuildContext context, WidgetRef ref) {
    try {
      final ActivityEntity newActivity =
          ref.read(activityFieldsNotifierProvider);
      ref.read(activityNotifierProvider.notifier).createActivity(newActivity);
      Navigator.of(context).pop();
    } on NameRequiredLimitation catch (e) {
      AppUtils.showToast(
        msg: e.message,
        style: ToastificationStyle.simple,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int id = ref.watch(
      activityFieldsNotifierProvider.select((ActivityEntity a) => a.id),
    );
    final ActivityFocusedWidget focusedWidget =
        ref.watch(focusedWidgetNotifierProvider);
    final Activity? activity = id == 0
        ? null
        : ref.read(activityNotifierProvider.notifier).getActivity(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(id == 0 ? 'Create Activity' : 'Edit Activiy'),
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
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: switch (focusedWidget) {
            ActivityFocusedWidget.none => _buildFullBody(
                context,
                ref,
                id,
              ),
            ActivityFocusedWidget.colorPicker => const ColorPickerField(),
            ActivityFocusedWidget.iconPicker => const IconPickerField(),
          },
        ),
      ),
    );
  }

  Widget _buildFullBody(
    BuildContext context,
    WidgetRef ref,
    int id,
  ) {
    return Column(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const TitleField(),
        const ColorPickerField(),
        const IconPickerField(),
        const ProductivityLvlField(),
        const DescriptionField(),
        ElevatedButton(
          onPressed: () => onConfirm(context, ref),
          child: Text(
            id == 0 ? 'Create Activity' : 'Save Activiy',
          ),
        ),
      ],
    );
  }
}

class TitleField extends HookConsumerWidget {
  const TitleField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController controller = useTextEditingController();

    final String name = ref.read(
      activityFieldsNotifierProvider.select((ActivityEntity a) => a.name),
    );

    useEffect(
      () {
        controller.text = name;
        return null;
      },
      <Object?>[name],
    );

    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Name',
      ),
      onChanged: (String value) {
        ref.read(activityFieldsNotifierProvider.notifier).name = value;
      },
    );
  }
}

class DescriptionField extends HookConsumerWidget {
  const DescriptionField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String? description = ref.read(
      activityFieldsNotifierProvider
          .select((ActivityEntity a) => a.description),
    );
    final TextEditingController controller =
        useTextEditingController(text: description);

    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Description (Optional)',
      ),
      onChanged: (String value) {
        ref.read(activityFieldsNotifierProvider.notifier).description = value;
      },
    );
  }
}
