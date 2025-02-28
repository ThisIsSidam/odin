import 'package:objectbox/objectbox.dart';

import '../../../../core/data/entities/activity_entity.dart';

@Entity()
class LiveActivity {
  @Id()
  int id;
  @Property(type: PropertyType.date)
  DateTime startedAt;
  ToOne<Activity> activity = ToOne<Activity>();
  String? note;

  LiveActivity({
    required this.startedAt,
    this.id = 0,
    this.note,
  });
}
