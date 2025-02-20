import 'package:objectbox/objectbox.dart';

@Entity()
class ActivityEntity {
  @Id()
  int id;
  String name;
  String description;
  int importanceLevel;
  String? colorHex;

  ActivityEntity({
    required this.name,
    this.id = 0,
    this.description = '',
    this.importanceLevel = 1,
    this.colorHex,
  });
}

@Entity()
class ActivityLogEntity {
  ActivityLogEntity({
    required this.startedAt,
    required this.stoppedAt,
    this.id = 0,
    this.note,
  });

  @Id()
  int id;
  @Property(type: PropertyType.date)
  DateTime startedAt;
  @Property(type: PropertyType.date)
  DateTime stoppedAt;
  ToOne<ActivityEntity> activity = ToOne<ActivityEntity>();
  String? note;
}
