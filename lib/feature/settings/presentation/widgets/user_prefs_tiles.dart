import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/settings_provider.dart';
import '../screens/settings.dart';

class AllowMultitaskingTile extends ConsumerWidget {
  const AllowMultitaskingTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool allowed = ref.watch(
      settingsProvider.select((SettingsNotifier s) => s.allowMultitasking),
    );
    return SettingTile(
      leading: const Icon(Icons.dashboard),
      title: 'Allow multitasking',
      trailing: Switch(
        value: allowed,
        onChanged: (bool v) async {
          await ref.read(settingsProvider.notifier).setAllowMultitasking(v);
        },
      ),
    );
  }
}

class ThemeTile extends ConsumerWidget {
  const ThemeTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final ThemeMode smode = ref.watch(settingsProvider).themeMode;
    return SettingTile(
      leading: const Icon(Icons.brightness_5_outlined),
      title: 'Theme',
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: ThemeMode.values
            .map(
              (ThemeMode mode) => IconButton.filled(
                onPressed: () {
                  ref.read(settingsProvider.notifier).setThemeMode(mode);
                },
                icon: Icon(
                  switch (mode) {
                    ThemeMode.system => Icons.brightness_auto,
                    ThemeMode.light => Icons.light_mode,
                    ThemeMode.dark => Icons.dark_mode,
                  },
                ),
                style: IconButton.styleFrom(
                  backgroundColor: mode == smode
                      ? colorScheme.primaryContainer
                      : Colors.transparent,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
