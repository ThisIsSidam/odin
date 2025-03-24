import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:objectbox/objectbox.dart';

import '../models/activity.dart';

@Entity()
class ActivityEntity {
  @Id()
  int id;
  String name;
  String? description;
  int productivityLevel;
  String? colorHex;
  bool hidden;

  ActivityEntity({
    required this.name,
    this.id = 0,
    this.description = '',
    this.productivityLevel = 1,
    this.colorHex,
    this.hidden = false,
  });

  Activity get toModel {
    return Activity(
      id: id,
      name: name,
      description: description,
      productivityLevel: productivityLevel,
      color: colorHex?.toColor(),
      hidden: hidden,
    );
  }

  ActivityEntity copyWith({
    int? id,
    String? name,
    String? description,
    int? productivityLevel,
    String? colorHex,
    bool? hidden,
  }) {
    return ActivityEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      productivityLevel: productivityLevel ?? this.productivityLevel,
      colorHex: colorHex ?? this.colorHex,
      hidden: hidden ?? this.hidden,
    );
  }
}
