import 'package:duration/duration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/extensions/datetime_ext.dart';
import '../../../../shared/widgets/app_elements/not_found_widget.dart';
import '../../../home/presentation/widgets/activity_icon_widget.dart';
import '../../data/models/activity_log.dart';
import '../providers/activity_logs_provider.dart';
import '../providers/log_fields_provider.dart';
import 'log_screen.dart';

class ActivityLogsScreen extends HookConsumerWidget {
  const ActivityLogsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ValueNotifier<DateTime> dateNotifier =
        useState<DateTime>(DateTime.now());
    final List<ActivityLog> logs = ref.watch(
      activityLogsNotifierProvider(
        dateNotifier.value,
        dateNotifier.value.add(const Duration(days: 1)),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity logs'),
      ),
      body: logs.isEmpty
          ? const NotFoundWidget()
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
      floatingActionButton: const AddLogButton(),
    );
  }
}

class AddLogButton extends ConsumerWidget {
  const AddLogButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () {
        ref.read(logFieldsNotifierProvider.notifier).clearState();

        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const LogScreen(),
          ),
        );
      },
      child: const Icon(Icons.add),
    );
  }
}

class ActivityLogTile extends ConsumerWidget {
  const ActivityLogTile({required this.log, super.key});

  final ActivityLog log;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: ActivityIconWidget(
        icon: log.activity.icon,
        backgroundColor: log.activity.color,
      ),
      title: Text(log.activity.name),
      subtitle: Text(log.startedAt.getDateRange(log.stoppedAt)),
      trailing: Text(
        log.stoppedAt.difference(log.startedAt).pretty(
              abbreviated: true,
            ),
      ),
      onLongPress: () {
        ref.read(logFieldsNotifierProvider.notifier).updateLogState = log;
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const LogScreen(),
          ),
        );
      },
    );
  }
}
