import 'package:duration/duration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/data/models/activity.dart';
import '../../../../core/providers/global_providers.dart';
import '../../../../shared/riverpod_widgets/state_selecter.dart';
import '../../data/models/live_activity.dart';
import '../providers/live_activity_provider.dart';

class LiveActivityDock extends ConsumerWidget {
  const LiveActivityDock({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<LiveActivity> liveActivities =
        ref.watch(liveActivityNotifierProvider);

    final Size size = MediaQuery.sizeOf(context);

    if (liveActivities.isEmpty) return const SizedBox.shrink();
    return AnimatedContainer(
      width: size.width > 500 ? 500 : size.width - 16,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: _buildLists(context, liveActivities),
    );
  }

  Widget _buildLists(BuildContext context, List<LiveActivity> activities) {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(8),
      itemCount: activities.length,
      itemBuilder: (BuildContext context, int index) {
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

  final LiveActivity live;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Activity? activity = live.activity;
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
