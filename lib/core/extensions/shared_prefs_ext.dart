import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

extension SharedPrefsX on SharedPreferences {
  Duration? getDuration(String key) {
    final int? seconds = getInt(key);
    if (seconds == null) return null;
    return Duration(seconds: seconds);
  }

  Future<bool> setDuration(String key, Duration value) async {
    final int seconds = value.inSeconds;
    return setInt(key, seconds);
  }

  DateTime? getDateTime(String key) {
    final int? milliseconds = getInt(key);
    if (milliseconds == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(milliseconds);
  }

  Future<bool> setDateTime(String key, DateTime value) async {
    final int milliseconds = value.millisecondsSinceEpoch;
    return setInt(key, milliseconds);
  }

  ThemeMode? getThemeMode(String key) {
    final String? themeModeStr = getString(key);
    if (themeModeStr == null) return null;
    return ThemeMode.values.firstWhere(
      (ThemeMode e) => e.toString() == themeModeStr,
      orElse: () => ThemeMode.system,
    );
  }

  Future<bool> setThemeMode(String key, ThemeMode value) async {
    final String themeModeStr = value.toString();
    return setString(key, themeModeStr);
  }
}
