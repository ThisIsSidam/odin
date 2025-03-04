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

  ActivityEntity({
    required this.name,
    this.id = 0,
    this.description = '',
    this.productivityLevel = 1,
    this.colorHex,
  });

  Activity get toModel {
    return Activity(
      id: id,
      name: name,
      description: description,
      productivityLevel: productivityLevel,
      color: colorHex?.toColor(),
    );
  }
}
