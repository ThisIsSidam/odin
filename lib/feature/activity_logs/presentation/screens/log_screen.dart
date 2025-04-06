import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/reactive_form_widgets/proxy_text_field.dart';
import '../../data/models/activity_log.dart';
import '../providers/log_fields_provider.dart';
import '../providers/logs_crud_provider.dart';
import '../widgets/activity_field.dart';
import '../widgets/log_time_field.dart';

class LogScreen extends ConsumerWidget {
  const LogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final ActivityLog log = ref.watch(logFieldsNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const ActivityField(),
            LogTimeField(
              dt: log.startedAt,
              label: 'Started At',
              onChanged: (DateTime newDt) {
                ref.read(logFieldsNotifierProvider.notifier).startedAt = newDt;
              },
            ),
            LogTimeField(
              dt: log.stoppedAt,
              label: 'Stoppped At',
              onChanged: (DateTime newDt) {
                ref.read(logFieldsNotifierProvider.notifier).stoppedAt = newDt;
              },
            ),
            ProxyTextField(
              value: log.note,
              onChanged: (String value) {
                ref.read(logFieldsNotifierProvider.notifier).note = value;
              },
              decoration: InputDecoration(
                labelText: 'Note',
                hintText: 'Enter a note',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final ActivityLog log = ref.read(logFieldsNotifierProvider);
                ref
                    .read(logsCrudNotifierProvider.notifier)
                    .updateActivityLog(log.toEntity);
                Navigator.of(context).pop();
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
