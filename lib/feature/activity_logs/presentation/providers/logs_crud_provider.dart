import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../home/data/entities/live_activity_entity.dart';
import '../../data/entities/activity_log_entity.dart';
import '../../data/models/activity_log.dart';
import '../../data/repositories/activity_logs_repo.dart';

part 'generated/logs_crud_provider.g.dart';

@riverpod
class LogsCrudNotifier extends _$LogsCrudNotifier {
  late final ActivityLogRepository _repo;

  @override
  void build() {
    _repo = ref.watch(activityLogRepositoryProvider);
  }

  void addActivityLog(LiveActivityEntity live) {
    final ActivityLogEntity log = ActivityLogEntity.fromLive(live);
    log.activity.target = live.activity.target;
    _repo.add(log);
  }

  void updateActivityLog(ActivityLogEntity log) {
    _repo.update(log);
  }

  void deleteActivityLog(ActivityLog log) {
    _repo.delete(log.toEntity);
  }
}
