import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_icons_catalog/flutter_icons_catalog.dart';
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
  final ActivityIcon icon;

  const Activity({
    required this.name,
    this.id = 0,
    this.description = '',
    this.productivityLevel = 1,
    this.color,
    this.hidden = false,
    this.icon = const ActivityIcon.none(),
  });

  const Activity.notFound()
      : id = 0,
        name = 'Activity not found!',
        productivityLevel = 1,
        hidden = false,
        color = null,
        description = '',
        icon = const ActivityIcon.none();

  ActivityEntity get toEntity {
    return ActivityEntity(
      id: id,
      name: name,
      description: description,
      productivityLevel: productivityLevel,
      colorHex: color?.toHexString(),
      hidden: hidden,
      iconType: icon.iconType,
      iconName:
          icon.iconData == null ? null : IconsCatalog().getName(icon.iconData!),
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

/// Icon of an Activity
/// [iconType] is an int for the type of icon, which are:
///
/// None - No icon - 101
/// Flutter Icon - [iconData] - 102
/// More later
class ActivityIcon {
  final int iconType;
  final IconData? iconData;

  factory ActivityIcon({int? iconType, IconData? iconData}) {
    if (iconType == 102 && iconData != null) {
      return ActivityIcon.icon(iconData: iconData);
    }
    return const ActivityIcon.none();
  }

  const ActivityIcon.none()
      : iconType = 101,
        iconData = null;

  const ActivityIcon.icon({
    required this.iconData,
  }) : iconType = 102;
}
