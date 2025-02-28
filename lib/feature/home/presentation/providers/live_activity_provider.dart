import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/data/entities/activity_entities.dart';
import '../../../../core/providers/global_providers.dart';
import '../../../../objectbox.g.dart';
import '../../data/entities/live_activity_entity.dart';

part 'generated/live_activity_provider.g.dart';

@riverpod
class LiveActivityNotifier extends _$LiveActivityNotifier {
  late Box<LiveActivityEntity> _box;
  @override
  List<LiveActivityEntity> build() {
    final Store store = ref.watch(objectboxStoreProvider);
    _box = store.box<LiveActivityEntity>();
    _startListener();
    return _box.query().build().find();
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
        state = list;
      },
    );
  }

  void startActivity(ActivityEntity? activity) {
    final LiveActivityEntity newActivity = LiveActivityEntity(
      startedAt: DateTime.now(),
    );
    newActivity.activity.target = activity;
    _box.put(newActivity);
  }

  // void pauseActivity() {}
  // void resumeActivity() {}
  void stopActivity(int id) {
    // TODO: Add to ActivityLogs box
    final bool removed = _box.remove(id);
    log('Activity $id removed: $removed');
  }
}
