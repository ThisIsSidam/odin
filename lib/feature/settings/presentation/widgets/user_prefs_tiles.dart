import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/settings_provider.dart';

class AllowMultitaskingTile extends ConsumerWidget {
  const AllowMultitaskingTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool allowed = ref.watch(
      settingsProvider.select((SettingsNotifier s) => s.allowMultitasking),
    );
    return ListTile(
      title: const Text('Allow multitasking'),
      trailing: Switch(
        value: allowed,
        onChanged: (bool v) async {
          await ref.read(settingsProvider.notifier).setAllowMultitasking(v);
        },
      ),
    );
  }
}
