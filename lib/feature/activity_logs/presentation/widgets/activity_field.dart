import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/data/models/activity.dart';
import '../../../home/presentation/providers/activity_provider.dart';
import '../../../home/presentation/widgets/activity_icon_widget.dart';
import '../../data/models/activity_log.dart';
import '../providers/log_fields_provider.dart';

class ActivityField extends ConsumerWidget {
  const ActivityField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final ActivityLog log = ref.watch(logFieldsNotifierProvider);

    final List<Activity> activities = ref.watch(activityNotifierProvider);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.primary,
        ),
      ),
      child: ExpansionTile(
        leading: ActivityIconWidget(
          icon: log.activity.icon,
          backgroundColor: log.activity.color,
        ),
        title: Text(
          log.activity.name,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: colorScheme.primary),
        ),
        children: <Widget>[_buildChild(context, ref, activities)],
      ),
    );
  }

  Widget _buildChild(
    BuildContext context,
    WidgetRef ref,
    List<Activity> activities,
  ) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Align(
        alignment: Alignment.topCenter,
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: activities
              .map(
                (Activity activity) => ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: activity.color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    ref.read(logFieldsNotifierProvider.notifier).activity =
                        activity;
                  },
                  label: Text(
                    activity.name,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: theme.colorScheme.surface,
                    ),
                  ),
                  icon: ActivityIconWidget(
                    icon: activity.icon,
                    foregroundColor: theme.colorScheme.surface,
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
