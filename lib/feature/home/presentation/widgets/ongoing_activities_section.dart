import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/riverpod_widgets/async_widget.dart';
import '../../data/models/ongoing_model.dart';
import 'ongoing_activity_card.dart';

class OngoingActivitiesSection extends ConsumerWidget {
  const OngoingActivitiesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const AsyncValue<List<LiveActivity>> ongoingActivities =
        AsyncValue<List<LiveActivity>>.data(<LiveActivity>[]);
    // ref.watch(ongoingNotifierProvider);
    final Size size = MediaQuery.sizeOf(context);

    return AsyncValueWidget<List<LiveActivity>>(
      value: ongoingActivities,
      data: (List<LiveActivity> activities) {
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
      },
    );
  }
}
