import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:objectbox/objectbox.dart';

import '../models/activity.dart';

@Entity()
class ActivityEntity {
  @Id()
  int id;
  String name;
  String? description;
  int importanceLevel;
  String? colorHex;

  ActivityEntity({
    required this.name,
    this.id = 0,
    this.description = '',
    this.importanceLevel = 1,
    this.colorHex,
  });

  Activity get toModel {
    return Activity(
      id: id,
      name: name,
      description: description,
      importanceLevel: importanceLevel,
      color: colorHex?.toColor(),
    );
  }
}
