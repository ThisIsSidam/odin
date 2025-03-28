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
          ThemeTile(),
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

class SettingTile extends StatelessWidget {
  const SettingTile({
    required this.title,
    this.leading,
    this.trailing,
    this.onTap,
    super.key,
  });

  final String title;
  final Icon? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
