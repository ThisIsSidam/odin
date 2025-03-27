import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_icons_catalog/flutter_icons_catalog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/data/entities/activity_entity.dart';
import '../../../../core/data/models/activity.dart';
import '../../../../shared/riverpod_widgets/state_selecter.dart';
import '../providers/activity_fields_provider.dart';
import '../providers/focus_provider.dart';

class IconPickerField extends HookConsumerWidget {
  const IconPickerField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ActivityFocusedWidget focused =
        ref.watch(focusedWidgetNotifierProvider);

    final List<IconData> icons = useMemoized(
      () => IconsCatalog().getIconDataList(includeVariants: false),
    );

    return StateSelector<ActivityEntity, ({IconData? icon, Color? color})>(
      provider: activityFieldsNotifierProvider,
      selector: (ActivityEntity a) => (
        icon: a.iconName == null
            ? null
            : IconsCatalog().getIconData(
                a.iconName!,
              ),
        color: a.colorHex?.toColor()
      ),
      builder: (
        BuildContext context,
        ({Color? color, IconData? icon}) selected,
      ) {
        return Column(
          children: <Widget>[
            ListTile(
              onTap: () {
                if (focused == ActivityFocusedWidget.iconPicker) {
                  ref.read(focusedWidgetNotifierProvider.notifier).changeFocus =
                      ActivityFocusedWidget.none;
                } else {
                  ref.read(focusedWidgetNotifierProvider.notifier).changeFocus =
                      ActivityFocusedWidget.iconPicker;
                }
              },
              title: const Text('Icon'),
              trailing: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: selected.color,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    selected.icon ?? Icons.question_answer,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: Colors.grey),
              ),
            ),
            if (focused == ActivityFocusedWidget.iconPicker)
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 75,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    final IconData icon = icons[index];
                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: IconButton.filled(
                        onPressed: () {
                          ref
                              .read(activityFieldsNotifierProvider.notifier)
                              .icon = ActivityIcon.icon(
                            iconData: icon,
                          );
                        },
                        icon: Icon(icon, size: 36),
                        style: IconButton.styleFrom(
                          backgroundColor: selected.color,
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
