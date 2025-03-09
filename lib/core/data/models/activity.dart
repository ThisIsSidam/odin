import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:quiver/core.dart';

import '../entities/activity_entity.dart';

@immutable
class Activity {
  final int id;
  final String name;
  final String? description;
  final int productivityLevel;
  final Color? color;
  final bool hidden;

  const Activity({
    required this.name,
    this.id = 0,
    this.description = '',
    this.productivityLevel = 1,
    this.color,
    this.hidden = false,
  });

  const Activity.notFound()
      : id = 0,
        name = 'Activity not found!',
        productivityLevel = 1,
        hidden = false,
        color = null,
        description = '';

  ActivityEntity get toEntity {
    return ActivityEntity(
      id: id,
      name: name,
      description: description,
      productivityLevel: productivityLevel,
      colorHex: color?.toHexString(),
      hidden: hidden,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Activity && id == other.id;
  }

  @override
  int get hashCode => hash2(
        name.hashCode,
        id.hashCode,
      );
}
