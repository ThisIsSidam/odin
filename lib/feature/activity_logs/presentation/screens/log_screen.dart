import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/reactive_form_widgets/proxy_text_field.dart';
import '../../../../shared/reactive_form_widgets/proxy_time_field.dart';
import '../../data/entities/activity_log_entity.dart';
import '../../data/models/activity_log.dart';
import '../providers/log_fields_provider.dart';

class LogScreen extends ConsumerWidget {
  const LogScreen({required this.log, super.key});
  final ActivityLog log;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ActivityLogEntity log = ref.watch(logFieldsNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ProxyTimeField(
              dt: log.startedAt,
              onChanged: (DateTime newDt) {
                ref.read(logFieldsNotifierProvider.notifier).startedAt = newDt;
              },
              decoration: const InputDecoration(
                labelText: 'Started At',
                hintText: 'Select start time',
                border: InputBorder.none,
              ),
            ),
            ProxyTimeField(
              dt: log.stoppedAt,
              onChanged: (DateTime newDt) {
                ref.read(logFieldsNotifierProvider.notifier).stoppedAt = newDt;
              },
              decoration: const InputDecoration(
                labelText: 'Stopped At',
                hintText: 'Select stop time',
                border: InputBorder.none,
              ),
            ),
            ProxyTextField(
              value: log.note,
              onChanged: (String value) {
                ref.read(logFieldsNotifierProvider.notifier).note = value;
              },
              decoration: const InputDecoration(
                labelText: 'Note',
                hintText: 'Enter a note',
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
