import 'package:objectbox/objectbox.dart';

import '../../../../core/data/models/activity.dart';
import '../entities/live_activity_entity.dart';

class LiveActivity {
  int id;
  @Property(type: PropertyType.date)
  DateTime startedAt;
  Activity? activity;
  String? note;

  LiveActivity({
    required this.startedAt,
    this.id = 0,
    this.activity,
    this.note,
  });

  LiveActivityEntity get toEntity {
    return LiveActivityEntity(
      id: id,
      startedAt: startedAt,
      note: note,
    )..activity.target = activity?.toEntity;
  }
}
