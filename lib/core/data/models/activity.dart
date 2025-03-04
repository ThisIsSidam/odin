import 'dart:ui';

import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../entities/activity_entity.dart';

class Activity {
  int id;
  String name;
  String? description;
  int importanceLevel;
  Color? color;

  Activity({
    required this.name,
    this.id = 0,
    this.description = '',
    this.importanceLevel = 1,
    this.color,
  });

  Activity.notFound()
      : id = 0,
        name = 'Activity not found!',
        importanceLevel = 1;

  ActivityEntity get toEntity {
    return ActivityEntity(
      id: id,
      name: name,
      description: description,
      importanceLevel: importanceLevel,
      colorHex: color?.toHexString(),
    );
  }
}
