import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/data/entities/activity_entities.dart';
import '../../../../router/app_routes.dart';
import '../../data/entities/live_activity_entity.dart';
import '../providers/activity_provider.dart';
import '../providers/live_activity_provider.dart';
import '../widgets/ongoing_activities_section.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Ongoing Activities'),
      ),
      bottomSheet: const HomeActivityDock(),
      body: const OngoingActivitiesSection(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(liveActivityNotifierProvider.notifier).startActivity(null);
        },
        child: const Icon(Icons.add, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}

class HomeActivityDock extends ConsumerWidget {
  const HomeActivityDock({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<ActivityEntity> activities = ref.watch(activityNotifierProvider);
    final List<LiveActivityEntity> liveActivities =
        ref.watch(liveActivityNotifierProvider);

    final Size size = MediaQuery.sizeOf(context);
    return AnimatedContainer(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      duration: const Duration(milliseconds: 300),
      height: max(size.height * 0.5 - (liveActivities.length * 50), 300),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: _buildActivityChips(context, ref, activities),
    );
  }

  Widget _buildActivityChips(
    BuildContext context,
    WidgetRef ref,
    List<ActivityEntity> activities,
  ) {
    return Wrap(
      spacing: 8,
      children: <Widget>[
        ActionChip(
          label: const Text('Add Activity'),
          avatar: const Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.createActivity.path);
          },
        ),
        ...activities.map(
          (ActivityEntity activity) => ActionChip(
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
    );
  }
}
