import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/data/models/activity.dart';
import '../../../../core/exceptions/limitations.dart';
import '../../../../core/extensions/list_ext.dart';
import '../../../../core/providers/global_providers.dart';
import '../../../../objectbox.g.dart';
import '../../../activity_logs/presentation/providers/activity_logs_provider.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../../data/entities/live_activity_entity.dart';
import '../../data/models/live_activity.dart';

part 'generated/live_activity_provider.g.dart';

@riverpod
class LiveActivityNotifier extends _$LiveActivityNotifier {
  late Box<LiveActivityEntity> _box;
  @override
  List<LiveActivity> build() {
    final Store store = ref.watch(objectboxStoreProvider);
    _box = store.box<LiveActivityEntity>();
    _startListener();
    return _box
        .getAll()
        .map((LiveActivityEntity entity) => entity.toModel)
        .toList();
  }

  void _startListener() {
    _box
        .query()
        .watch(triggerImmediately: true)
        .map(
          (Query<LiveActivityEntity> query) => query.find(),
        )
        .listen(
      (List<LiveActivityEntity> list) {
        state =
            list.map((LiveActivityEntity entity) => entity.toModel).toList();
      },
    );
  }

  /// Checks whether a live session of an activity is running or not
  bool isRunning(Activity activity) {
    return state.any((LiveActivity e) => e.activity == activity);
  }

  void startActivity(Activity? activity) {
    if (activity == null || state.isNotEmpty) {
      // Check if multitasking is allowed
      final bool allowed =
          ref.read(settingsProvider.notifier).allowMultitasking;
      if (!allowed) throw MultiTaskingNotAllowedLimitation();
    }

    final LiveActivityEntity newActivity = LiveActivityEntity(
      startedAt: DateTime.now(),
    );
    newActivity.activity.target = activity?.toEntity;
    _box.put(newActivity);
  }

  /// Stops activity through an activity's live session's id
  void stopActivity(int id) {
    ref.read(activityLogsNotifierProvider(null, null).notifier).addActivityLog(
          state.firstWhere((LiveActivity e) => e.id == id).toEntity,
        );
    final bool removed = _box.remove(id);
    log('Activity $id removed: $removed');
  }

  void stopMatchingActivity(Activity activity) {
    final LiveActivity? live = state
        .firstWhereOrNull((LiveActivity live) => live.activity == activity);
    if (live == null) return;
    stopActivity(live.id);
  }
}
