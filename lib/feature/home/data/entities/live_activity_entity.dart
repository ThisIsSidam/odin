import 'package:objectbox/objectbox.dart';

import '../../../../core/data/entities/activity_entity.dart';
import '../models/live_activity.dart';

@Entity()
class LiveActivityEntity {
  @Id()
  int id;
  @Property(type: PropertyType.date)
  DateTime startedAt;
  ToOne<ActivityEntity> activity = ToOne<ActivityEntity>();
  String? note;

  LiveActivityEntity({
    required this.startedAt,
    this.id = 0,
    this.note,
  });

  LiveActivity get toModel {
    return LiveActivity(
      id: id, 
      startedAt: startedAt, 
      activity: activity.target?.toModel,
      note: note,
    );
  }
}
