import 'dart:math';

import 'package:duration/duration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/data/entities/activity_entities.dart';
import '../../../../core/providers/global_providers.dart';
import '../../../../shared/riverpod_widgets/state_selecter.dart';
import '../../data/entities/live_activity_entity.dart';
import '../providers/live_activity_provider.dart';

class LiveActivitySection extends ConsumerWidget {
  const LiveActivitySection({super.key});

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
        return LiveActivityCard(live: activities[index]);
      },
    );
  }
}

class LiveActivityCard extends ConsumerWidget {
  const LiveActivityCard({
    required this.live,
    super.key,
  });

  final LiveActivityEntity live;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ActivityEntity? activity = live.activity.target;
    return ListTile(
      title: activity?.id == null
          ? Text(
              'Some activity',
              style: Theme.of(context).textTheme.titleMedium,
            )
          : Text(
              activity!.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
      subtitle: StateSelector<AsyncValue<DateTime>, Duration>(
        provider: dateTimeProvider,
        selector: (AsyncValue<DateTime> dtAsync) =>
            (dtAsync.valueOrNull ?? DateTime.now()).difference(live.startedAt),
        builder: (BuildContext context, Duration duration) => Text(
          duration.pretty(
            abbreviated: true,
            tersity: DurationTersity.minute,
          ),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // IconButton.filled(
          //   onPressed: () {
          //     // TODO: Implement pause
          //   },
          //   icon: const Icon(Icons.pause),
          // ),
          // const SizedBox(width: 8),
          IconButton.filled(
            onPressed: () {
              ref.read(liveActivityNotifierProvider.notifier).stopActivity(
                    live.id,
                  );
            },
            icon: const Icon(Icons.stop),
          ),
        ],
      ),
    );
  }
}
