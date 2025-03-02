import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/data/models/activity.dart';
import '../../../../router/app_routes.dart';
import '../providers/activity_provider.dart';
import '../providers/live_activity_provider.dart';
import '../widgets/live_activity_dock.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Activity> activities = ref.watch(activityNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Ongoing Activities'),
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
          alignment: WrapAlignment.center,
          children: <Widget>[
            ActionChip(
              label: const Text('Add Activity'),
              avatar: const Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.createActivity.path);
              },
            ),
            ...activities.map(
              (Activity activity) => ActionChip(
                label: Text(activity.name),
                backgroundColor: activity.colorHex?.toColor(),
                onPressed: () {
                  ref
                      .read(liveActivityNotifierProvider.notifier)
                      .startActivity(activity);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
