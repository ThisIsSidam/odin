import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/extensions/shared_prefs_ext.dart';
import '../../../../core/providers/global_providers.dart';
import 'default_settings.dart';

final ChangeNotifierProvider<SettingsNotifier> settingsProvider =
    ChangeNotifierProvider<SettingsNotifier>((Ref<SettingsNotifier> ref) {
  final SharedPreferences prefs = ref.watch(sharedPrefsProvider);
  return SettingsNotifier(prefs: prefs);
});

class SettingsNotifier extends ChangeNotifier {
  SettingsNotifier({required this.prefs});
  final SharedPreferences prefs;

  void resetSettings() {
    for (final MapEntry<String, dynamic> entry in defaultSettings.entries) {
      final dynamic value = entry.value;
      if (value is double) {
        prefs.setDouble(entry.key, value);
      } else if (value is ThemeMode) {
        prefs.setThemeMode(entry.key, value);
      } else {
        log(
          // ignore: lines_longer_than_80_chars
          'Found unhandled datatype value when resettings settings: ${value.runtimeType}',
        );
      }
    }
    notifyListeners();
  }

  bool get allowMultitasking {
    const String key = 'allowMultitasking';
    final bool? value = prefs.getBool(key);
    if (value == null) {
      return defaultSettings[key] as bool;
    }
    return value;
  }

  Future<void> setAllowMultitasking(bool value) async {
    const String key = 'allowMultitasking';
    await prefs.setBool(key, value);
    notifyListeners();
  }

  ThemeMode get themeMode {
    const String key = 'themeMode';
    final ThemeMode? value = prefs.getThemeMode(key);
    if (value == null) {
      return ThemeMode.system;
    }
    return value;
  }

  Future<void> setThemeMode(ThemeMode value) async {
    const String key = 'themeMode';
    await prefs.setThemeMode(key, value);
    notifyListeners();
  }
}
