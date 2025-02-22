import 'package:objectbox/objectbox.dart';

import '../../../../core/data/entities/activity_entities.dart';

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
}
