import 'package:objectbox/objectbox.dart';

import '../../../../core/data/entities/activity_entity.dart';
import '../../../../core/data/models/activity.dart';
import '../models/task.dart';

@Entity()
class TaskEntity {
  @Id()
  int id = 0;

  String title;
  final ToOne<ActivityEntity> activity = ToOne<ActivityEntity>();
  DateTime scheduleTime;

  TaskEntity({
    required this.title,
    required this.scheduleTime,
  });

  Task get toModel => Task(
        title: title,
        scheduleTime: scheduleTime,
        activity: activity.target?.toModel ?? const Activity.notFound(),
      );
}
