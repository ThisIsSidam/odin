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

  ActivityLog.isNull()
      : id = 0,
        startedAt = DateTime.now(),
        stoppedAt = DateTime.now(),
        activity = const Activity.notFound(),
        note = null;

  int id;
  @Property(type: PropertyType.date)
  DateTime startedAt;
  @Property(type: PropertyType.date)
  DateTime stoppedAt;
  Activity activity;
  String? note;

  Duration get duration => stoppedAt.difference(startedAt);

  ActivityLogEntity get toEntity {
    return ActivityLogEntity(
      id: id,
      startedAt: startedAt,
      stoppedAt: stoppedAt,
      note: note,
    )..activity.target = activity.toEntity;
  }

  ActivityLog copyWith({
    int? id,
    DateTime? startedAt,
    DateTime? stoppedAt,
    Activity? activity,
    String? note,
  }) {
    return ActivityLog(
      id: id ?? this.id,
      startedAt: startedAt ?? this.startedAt,
      stoppedAt: stoppedAt ?? this.stoppedAt,
      activity: activity ?? this.activity,
      note: note ?? this.note,
    );
  }
}
