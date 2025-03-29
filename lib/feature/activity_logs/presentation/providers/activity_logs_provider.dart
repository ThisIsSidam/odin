import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/data/models/activity.dart';
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

  Map<Activity, (Duration, double)> getStats() {
    final Map<Activity, Duration> durations = <Activity, Duration>{};
    Duration totalDuration = Duration.zero;

    // Calculate durations and total
    for (final ActivityLog log in state) {
      final Duration dur = durations[log.activity] ?? Duration.zero;
      durations[log.activity] = dur + log.duration;
      totalDuration += log.duration;
    }

    // Convert to map with tuples containing duration and percentage
    return durations.map((Activity key, Duration value) {
      final double percentage = totalDuration.inSeconds > 0
          ? value.inSeconds / totalDuration.inSeconds
          : 0.0;
      return MapEntry<Activity, (Duration, double)>(key, (value, percentage));
    });
  }
}
