import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/data/entities/activity_entities.dart';
import '../../data/entities/live_activity_entity.dart';

class LiveActivityCard extends ConsumerWidget {
  const LiveActivityCard({
    required this.ongoing,
    super.key,
  });

  final LiveActivityEntity ongoing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _buildCard(context, ongoing.activity.target);
  }

  Card _buildCard(BuildContext context, ActivityEntity? activity) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: <Widget>[
            //     if (activity.id == null)
            //       const Text('Some activity')
            //     else
            //       Text(
            //         activity.id.toString(),
            //         style: Theme.of(context).textTheme.titleMedium,
            //       ),
            //     const Spacer(),
            //     StreamBuilder<void>(
            //       stream: Stream<void>.periodic(const Duration(minutes: 1)),
            //       builder: (_, __) {
            //         final Duration duration =
            //             DateTime.now().difference(activity.startedAt);
            //         return Text(
            //           duration.pretty(
            //             abbreviated: true,
            //             tersity: DurationTersity.minute,
            //           ),
            //           style: Theme.of(context).textTheme.titleMedium,
            //         );
            //       },
            //     ),
            //   ],
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement pause
                  },
                  child: const Text('Pause'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement end
                  },
                  child: const Text('End Activity'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
