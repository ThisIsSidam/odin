import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/global_providers.dart';
import '../../../../objectbox.g.dart';
import '../../../home/data/entities/live_activity_entity.dart';
import '../../data/entities/activity_log_entity.dart';
import '../../data/models/activity_log.dart';

part 'generated/activity_logs_provider.g.dart';

@riverpod
class ActivityLogsNotifier extends _$ActivityLogsNotifier {
  late Box<ActivityLogEntity> _box;

  @override
  List<ActivityLog> build(DateTime? fromTime, DateTime? toTime) {
    final Store store = ref.watch(objectboxStoreProvider);
    _box = store.box<ActivityLogEntity>();
    _startListener(fromTime, toTime);
    if (fromTime == null) {
      return _box
          .getAll()
          .map((ActivityLogEntity entity) => entity.toModel)
          .toList();
    }
    return _box
        .query(
          ActivityLogEntity_.startedAt.betweenDate(
            DateTime(
              fromTime.year,
              fromTime.month,
              fromTime.day,
            ),
            DateTime(
              (toTime ?? fromTime).year,
              (toTime ?? fromTime).month,
              toTime?.day ?? fromTime.day + 1,
            ),
          ),
        )
        .build()
        .find()
        .map((ActivityLogEntity entity) => entity.toModel)
        .toList();
  }

  void _startListener(DateTime? fromTime, DateTime? toTime) {
    if (fromTime == null) {
      _box
          .query()
          .watch(triggerImmediately: true)
          .map(
            (Query<ActivityLogEntity> query) => query.find(),
          )
          .listen(
        (List<ActivityLogEntity> list) {
          state =
              list.map((ActivityLogEntity entity) => entity.toModel).toList();
        },
      );
      return;
    }
    _box
        .query(
          ActivityLogEntity_.startedAt.betweenDate(
            DateTime(
              fromTime.year,
              fromTime.month,
              fromTime.day,
            ),
            DateTime(
              (toTime ?? fromTime).year,
              (toTime ?? fromTime).month,
              toTime?.day ?? fromTime.day + 1,
            ),
          ),
        )
        .watch(triggerImmediately: true)
        .map(
          (Query<ActivityLogEntity> query) => query.find(),
        )
        .listen(
      (List<ActivityLogEntity> list) {
        state = list.map((ActivityLogEntity entity) => entity.toModel).toList();
      },
    );
  }

  void addActivityLog(LiveActivityEntity live) {
    final ActivityLogEntity log = ActivityLogEntity.fromLive(
      live,
    );
    log.activity.target = live.activity.target;
    _box.put(log);
  }
}
