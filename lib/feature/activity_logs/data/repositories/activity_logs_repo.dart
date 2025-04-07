import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/global_providers.dart';
import '../../../../objectbox.g.dart';
import '../../data/entities/activity_log_entity.dart';
import '../../data/models/activity_log.dart';

part 'generated/activity_logs_repo.g.dart';

class ActivityLogRepository {
  final Box<ActivityLogEntity> _box;

  ActivityLogRepository(this._box);

  List<ActivityLog> getAll() {
    return _box.getAll().map((ActivityLogEntity e) => e.toModel).toList();
  }

  List<ActivityLog> getBetween(DateTime from, DateTime to) {
    return _box
        .query(ActivityLogEntity_.startedAt.betweenDate(from, to))
        .build()
        .find()
        .map((ActivityLogEntity e) => e.toModel)
        .toList();
  }

  Stream<List<ActivityLog>> watchAll() {
    return _box.query().watch(triggerImmediately: true).map(
          (Query<ActivityLogEntity> q) =>
              q.find().map((ActivityLogEntity e) => e.toModel).toList(),
        );
  }

  Stream<List<ActivityLog>> watchBetween(DateTime from, DateTime to) {
    return _box
        .query(ActivityLogEntity_.startedAt.betweenDate(from, to))
        .watch(triggerImmediately: true)
        .map(
          (Query<ActivityLogEntity> q) =>
              q.find().map((ActivityLogEntity e) => e.toModel).toList(),
        );
  }

  void add(ActivityLogEntity entity) {
    _box.put(entity);
  }

  void update(ActivityLogEntity log) {
    _box.put(log);
  }

  void delete(ActivityLogEntity log) {
    _box.remove(log.id);
  }
}

@riverpod
ActivityLogRepository activityLogRepository(Ref ref) {
  final Store store = ref.watch(objectboxStoreProvider);
  final Box<ActivityLogEntity> box = store.box<ActivityLogEntity>();
  return ActivityLogRepository(box);
}
