import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:objectbox/objectbox.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'generated/global_providers.g.dart';

@riverpod
Store objectboxStore(Ref ref) {
  throw UnimplementedError('Objectbox store has not been created yet!');
}

@riverpod
SharedPreferences sharedPrefs(Ref ref) {
  throw UnimplementedError('Objectbox store has not been created yet!');
}

@riverpod
Stream<DateTime> dateTime(Ref ref) {
  const Duration interval = Duration(minutes: 1);
  return Stream<DateTime>.periodic(interval, (_) => DateTime.now());
}
