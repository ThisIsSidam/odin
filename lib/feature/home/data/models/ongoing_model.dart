import 'package:objectbox/objectbox.dart';

import '../../../../core/models/activity_models.dart';

@Entity()
class LiveActivity {
  @Id()
  int id;
  final DateTime startedAt;
  final ToOne<ActivityModel?> activity = ToOne<ActivityModel?>();
  final String? note;

  LiveActivity({
    required this.startedAt,
    this.id = 0,
    this.note,
  });
}
