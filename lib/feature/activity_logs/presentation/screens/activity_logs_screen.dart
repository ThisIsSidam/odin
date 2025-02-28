import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/datetime_ext.dart';
import '../../data/entities/activity_log_entity.dart';
import '../providers/activity_logs_provider.dart';

class ActivityLogsScreen extends ConsumerWidget {
  const ActivityLogsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<ActivityLog> logs = ref.watch(activityLogsNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity logs'),
      ),
      body: ListView.builder(
        itemCount: logs.length,
        itemBuilder: (BuildContext context, int index) =>
            ActivityLogTile(log: logs[index]),
      ),
    );
  }
}

class ActivityLogTile extends ConsumerWidget {
  const ActivityLogTile({required this.log, super.key});

  final ActivityLog log;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (log.activity.target == null) return _buildCurroptedTile();
    return ListTile(
      leading: const Icon(Icons.question_mark),
      title: Text(log.activity.target!.name),
      subtitle: Text(log.startedAt.getDateRange(log.stoppedAt)),
    );
  }

  Widget _buildCurroptedTile() {
    return ListTile(
      leading: const Icon(Icons.question_mark),
      title: const Text(
        "Data regarding associated activity wasn't properly saved!",
      ),
      subtitle: Text(log.startedAt.getDateRange(log.stoppedAt)),
    );
  }
}
