import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/extensions/datetime_ext.dart';
import '../../data/models/activity_log.dart';
import '../providers/activity_logs_provider.dart';

class ActivityLogsScreen extends HookConsumerWidget {
  const ActivityLogsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ValueNotifier<DateTime> dateNotifier =
        useState<DateTime>(DateTime.now());
    final List<ActivityLog> logs =
        ref.watch(activityLogsNotifierProvider(dateNotifier.value));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity logs'),
      ),
      body: logs.isEmpty
          ? _buildEmptyScreen()
          : ListView.builder(
              itemCount: logs.length,
              itemBuilder: (BuildContext context, int index) =>
                  ActivityLogTile(log: logs[index]),
            ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          spacing: 8,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton.filled(
              onPressed: () {
                dateNotifier.value =
                    dateNotifier.value.subtract(const Duration(days: 1));
              },
              icon: const Icon(Icons.chevron_left),
            ),
            Text(
              dateNotifier.value.friendly,
            ),
            IconButton.filled(
              onPressed: () {
                dateNotifier.value =
                    dateNotifier.value.add(const Duration(days: 1));
              },
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyScreen() {
    return const Center(
      child: Text('No logs found!'),
    );
  }
}

class ActivityLogTile extends ConsumerWidget {
  const ActivityLogTile({required this.log, super.key});

  final ActivityLog log;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.question_mark),
      title: Text(log.activity.name),
      subtitle: Text(log.startedAt.getDateRange(log.stoppedAt)),
    );
  }
}
