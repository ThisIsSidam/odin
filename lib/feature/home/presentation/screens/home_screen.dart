import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/data/models/activity.dart';
import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/exceptions/limitations.dart';
import '../../../../router/app_routes.dart';
import '../../../../shared/riverpod_widgets/state_selecter.dart';
import '../../../../shared/utils/app_utils.dart';
import '../../../activity/presentation/providers/activity_fields_provider.dart';
import '../../data/models/live_activity.dart';
import '../providers/activity_provider.dart';
import '../providers/live_activity_provider.dart';
import '../widgets/activity_icon_widget.dart';
import '../widgets/live_activity_dock.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Activity> activities = ref.watch(activityNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Activities'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: _buildActivityChips(context, ref, activities)),
          const LiveActivityDock(),
        ],
      ),
    );
  }

  Widget _buildActivityChips(
    BuildContext context,
    WidgetRef ref,
    List<Activity> activities,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Align(
        alignment: Alignment.topCenter,
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: <Widget>[
            OutlinedButton.icon(
              label: const Text('Add Activity'),
              icon: const Icon(Icons.add, size: 22),
              onPressed: () {
                ref.read(activityFieldsNotifierProvider.notifier).clearState();
                Navigator.pushNamed(context, AppRoutes.activity.path);
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            ...activities.map(
              (Activity activity) => ActivityButton(
                activity: activity,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActivityButton extends ConsumerWidget {
  const ActivityButton({required this.activity, super.key});

  final Activity activity;

  void startActivity(WidgetRef ref) {
    try {
      ref.read(liveActivityNotifierProvider.notifier).startActivity(activity);
    } on MultiTaskingNotAllowedLimitation catch (e) {
      AppUtils.showToast(
        msg: e.message,
        style: ToastificationStyle.simple,
      );
    } on LiveActivityLimitation catch (e) {
      AppUtils.showToast(
        msg: e.message,
        style: ToastificationStyle.simple,
      );
    } catch (_) {
      AppUtils.showToast(
        msg: UnknownException().message,
        style: ToastificationStyle.simple,
      );
    }
  }

  void stopActivity(WidgetRef ref) {
    ref
        .read(liveActivityNotifierProvider.notifier)
        .stopMatchingActivity(activity);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (activity.hidden) {
      return const SizedBox.shrink();
    }
    final ThemeData theme = Theme.of(context);

    return StateSelector<List<LiveActivity>, bool>(
      provider: liveActivityNotifierProvider,
      selector: (List<LiveActivity> lives) {
        return lives.any((LiveActivity e) {
          return e.activity == activity;
        });
      },
      builder: (BuildContext context, bool isRunning) => ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: isRunning ? Colors.transparent : activity.color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isRunning
                  ? theme.colorScheme.inverseSurface
                  : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        onPressed: () => isRunning ? stopActivity(ref) : startActivity(ref),
        onLongPress: () {
          ref
              .read(activityFieldsNotifierProvider.notifier)
              .updateActivityState = activity.toEntity;
          Navigator.pushNamed(
            context,
            AppRoutes.activity.path,
          );
        },
        label: Text(
          activity.name,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium!.copyWith(
            color: isRunning
                ? theme.colorScheme.inverseSurface
                : theme.colorScheme.surface,
          ),
        ),
        icon: ActivityIconWidget(
          icon: activity.icon,
          foregroundColor: isRunning
              ? theme.colorScheme.inverseSurface
              : theme.colorScheme.surface,
        ),
      ),
    );
  }
}
