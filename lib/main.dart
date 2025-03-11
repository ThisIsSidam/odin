import 'dart:io';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

import 'core/providers/global_providers.dart';
import 'core/theme/color_schemes.dart';
import 'core/theme/theme.dart';
import 'feature/home/presentation/screens/dashboard_screen.dart';
import 'feature/settings/presentation/providers/settings_provider.dart';
import 'objectbox.g.dart';
import 'router/route_builder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final Directory dir = await getApplicationDocumentsDirectory();
  final Store store = Store(
    getObjectBoxModel(),
    directory: path.join(
      dir.path,
      'objectbox-activity-store',
    ),
  );
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: <Override>[
        objectboxStoreProvider.overrideWithValue(store),
        sharedPrefsProvider.overrideWithValue(prefs),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeMode theme = ref.watch(
      settingsProvider.select((SettingsNotifier s) => s.themeMode),
    );
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightColorScheme;
        ColorScheme darkColorScheme;

        if (lightDynamic != null && darkDynamic != null) {
          lightColorScheme = lightDynamic.harmonized();
          darkColorScheme = darkDynamic.harmonized();
        } else {
          lightColorScheme = appColorScheme;
          darkColorScheme = appDarkColorScheme;
        }
        return ToastificationWrapper(
          child: MaterialApp(
            home: const DashboardScreen(),
            themeMode: theme,
            routes: routeBuilder(),
            onGenerateRoute: onGenerateRoute,
            theme: getLightTheme(lightColorScheme),
            darkTheme: getDarkTheme(darkColorScheme),
          ),
        );
      },
    );
  }
}
