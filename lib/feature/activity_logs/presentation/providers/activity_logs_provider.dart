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
  List<ActivityLog> build() {
    final Store store = ref.watch(objectboxStoreProvider);
    _box = store.box<ActivityLog>();
    _startListener();
    return _box.query().build().find();
  }

  void _startListener() {
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
  }

  void addActivityLog(LiveActivity live) {
    final ActivityLog log = ActivityLog.fromLive(
      live,
    );
    log.activity.target = live.activity.target;
    _box.put(log);
  }
}
