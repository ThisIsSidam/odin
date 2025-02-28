import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/global_providers.dart';
import '../../../../objectbox.g.dart';
import '../../../home/data/entities/live_activity_entity.dart';
import '../../data/entities/activity_log_entity.dart';

part 'generated/activity_logs_provider.g.dart';

@riverpod
class ActivityLogsNotifier extends _$ActivityLogsNotifier {
  late Box<ActivityLog> _box;

  @override
  List<ActivityLog> build(DateTime? dt) {
    final Store store = ref.watch(objectboxStoreProvider);
    _box = store.box<ActivityLog>();
    _startListener(dt);
    if (dt == null) {
      return _box.getAll();
    }
    return _box
        .query(
          ActivityLog_.startedAt.greaterThanDate(
            DateTime(dt.year, dt.month, dt.day),
          )..and(
              ActivityLog_.startedAt.lessThanDate(
                DateTime(dt.year, dt.month, dt.day + 1),
              ),
            ),
        )
        .build()
        .find();
  }

  void _startListener(DateTime? dt) {
    if (dt == null) {
      _box
          .query()
          .watch(triggerImmediately: true)
          .map(
            (Query<ActivityLog> query) => query.find(),
          )
          .listen(
        (List<ActivityLog> list) {
          state = list;
        },
      );
      return;
    }
    _box
        .query(
          ActivityLog_.startedAt.greaterThanDate(
            DateTime(dt.year, dt.month, dt.day),
          )..and(
              ActivityLog_.startedAt.lessThanDate(
                DateTime(dt.year, dt.month, dt.day + 1),
              ),
            ),
        )
        .watch(triggerImmediately: true)
        .map(
          (Query<ActivityLog> query) => query.find(),
        )
        .listen(
      (List<ActivityLog> list) {
        state = list;
      },
    );
  }

  void addActivityLog(LiveActivity live) {
    final ActivityLog log = ActivityLog.fromLive(
      live,
    );
    log.activity.target = live.activity.target;
    _box.put(log);
  }
}
