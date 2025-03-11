import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
      leading: const Icon(Icons.multiline_chart),
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

class ThemeTile extends HookConsumerWidget {
  const ThemeTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MenuController controller = useMemoized(MenuController.new);
    final SettingsNotifier settingsNotifier = ref.read(settingsProvider);
    final ThemeMode themeMode = ref.watch(settingsProvider).themeMode;
    return MenuAnchor(
      controller: controller,
      menuChildren: <Widget>[
        for (final ThemeMode mode in ThemeMode.values)
          MenuItemButton(
            child: Text(mode.name),
            onPressed: () {
              settingsNotifier.setThemeMode(mode);
            },
          ),
      ],
      child: ListTile(
        onTap: () {
          controller.isOpen ? controller.close() : controller.open();
        },
        leading: Icon(
          themeMode == ThemeMode.system
              ? Icons.brightness_6
              : settingsNotifier.themeMode == ThemeMode.dark
                  ? Icons.dark_mode
                  : Icons.light_mode,
        ),
        title: Text('Theme', style: Theme.of(context).textTheme.titleSmall),
        subtitle: Text(
          themeMode.name,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}
