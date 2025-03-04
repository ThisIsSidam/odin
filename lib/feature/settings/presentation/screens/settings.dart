import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/settings_provider.dart';
import '../widgets/user_prefs_tiles.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => resetIcon(context, ref),
          ),
        ],
      ),
      body: ListView(
        children: const <Widget>[
          AllowMultitaskingTile(),
        ],
      ),
    );
  }

  Widget resetIcon(
    BuildContext context,
    WidgetRef ref,
  ) {
    return IconButton(
      icon: const Icon(Icons.refresh),
      onPressed: () {
        showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Reset settings to default?',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () {
                      ref.read(settingsProvider.notifier).resetSettings();
                      Navigator.pop(context);
                    },
                    child: const Text('Yes'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
