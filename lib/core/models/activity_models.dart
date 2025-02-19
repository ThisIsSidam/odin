import 'package:objectbox/objectbox.dart';

@Entity()
class ActivityModel {
  @Id()
  int id;
  final String name;
  final String description;
  final int importanceLevel;
  final String? colorHex;

  ActivityModel({
    required this.name,
    this.id = 0,
    this.description = '',
    this.importanceLevel = 1,
    this.colorHex,
  });
}

@Entity()
class ActivityLog {
  ActivityLog({
    required this.startedAt,
    required this.stoppedAt,
    this.id = 0,
    this.note,
  });

  @Id()
  int id;
  final DateTime startedAt;
  final DateTime stoppedAt;
  final ToOne<ActivityModel> activity = ToOne<ActivityModel>();
  final String? note;
}
