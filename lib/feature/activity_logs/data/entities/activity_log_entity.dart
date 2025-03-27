import 'package:objectbox/objectbox.dart';

import '../../../../core/data/entities/activity_entity.dart';
import '../../../../core/data/models/activity.dart';
import '../../../home/data/entities/live_activity_entity.dart';
import '../models/activity_log.dart';

@Entity()
class ActivityLogEntity {
  ActivityLogEntity({
    required this.startedAt,
    required this.stoppedAt,
    this.id = 0,
    this.note,
  });

  ActivityLogEntity.fromLive(LiveActivityEntity live)
      : id = 0,
        startedAt = live.startedAt,
        stoppedAt = DateTime.now(),
        note = live.note;

  @Id()
  int id;
  @Property(type: PropertyType.date)
  DateTime startedAt;
  @Property(type: PropertyType.date)
  DateTime stoppedAt;
  ToOne<ActivityEntity> activity = ToOne<ActivityEntity>();
  String? note;

  ActivityLog get toModel {
    return ActivityLog(
      id: id,
      startedAt: startedAt,
      stoppedAt: stoppedAt,
      activity: activity.target?.toModel ?? const Activity.notFound(),
      note: note,
    );
  }
}
