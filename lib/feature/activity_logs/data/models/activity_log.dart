import 'package:objectbox/objectbox.dart';

import '../../../../core/data/models/activity.dart';
import '../../../home/data/models/live_activity.dart';
import '../entities/activity_log_entity.dart';

class ActivityLog {
  ActivityLog({
    required this.startedAt,
    required this.stoppedAt,
    required this.activity,
    this.id = 0,
    this.note,
  });

  ActivityLog.fromLive(LiveActivity live)
      : assert(live.activity != null),
        id = 0,
        startedAt = live.startedAt,
        stoppedAt = DateTime.now(),
        activity = live.activity!,
        note = live.note;

  int id;
  @Property(type: PropertyType.date)
  DateTime startedAt;
  @Property(type: PropertyType.date)
  DateTime stoppedAt;
  Activity activity;
  String? note;

  ActivityLogEntity get toEntity {
    return ActivityLogEntity(
      id: id,
      startedAt: startedAt,
      stoppedAt: stoppedAt,
      note: note,
    )..activity.target = activity.toEntity;
  }
}
