import 'dart:ui';

import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../entities/activity_entity.dart';

class Activity {
  int id;
  String name;
  String? description;
  int productivityLevel;
  Color? color;

  Activity({
    required this.name,
    this.id = 0,
    this.description = '',
    this.productivityLevel = 1,
    this.color,
  });

  Activity.notFound()
      : id = 0,
        name = 'Activity not found!',
        productivityLevel = 1;

  ActivityEntity get toEntity {
    return ActivityEntity(
      id: id,
      name: name,
      description: description,
      productivityLevel: productivityLevel,
      colorHex: color?.toHexString(),
    );
  }
}
