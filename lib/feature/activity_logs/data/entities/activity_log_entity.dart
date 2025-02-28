import 'package:objectbox/objectbox.dart';

import '../../../../core/data/entities/activity_entity.dart';
import '../../../home/data/entities/live_activity_entity.dart';

@Entity()
class ActivityLog {
  ActivityLog({
    required this.startedAt,
    required this.stoppedAt,
    this.id = 0,
    this.note,
  });

  ActivityLog.fromLive(LiveActivity live)
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
  ToOne<Activity> activity = ToOne<Activity>();
  String? note;
}
