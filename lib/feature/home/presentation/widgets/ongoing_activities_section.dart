import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/entities/live_activity_entity.dart';
import '../providers/live_activity_provider.dart';
import 'ongoing_activity_card.dart';

class OngoingActivitiesSection extends ConsumerWidget {
  const OngoingActivitiesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<LiveActivityEntity> activities =
        ref.watch(liveActivityNotifierProvider);
    final Size size = MediaQuery.sizeOf(context);

    if (activities.isEmpty) {
      return const Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(top: 75),
          child: Text('No ongoing activities'),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(8),
      itemCount: activities.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == activities.length) {
          return SizedBox(
            height: max(
              size.height * 0.5 - (activities.length * 50),
              300,
            ),
          );
        }
        return LiveActivityCard(ongoing: activities[index]);
      },
    );
  }
}
