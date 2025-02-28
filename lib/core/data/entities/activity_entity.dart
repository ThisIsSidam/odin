import 'package:objectbox/objectbox.dart';

@Entity()
class Activity {
  @Id()
  int id;
  String name;
  String? description;
  int importanceLevel;
  String? colorHex;

  Activity({
    required this.name,
    this.id = 0,
    this.description = '',
    this.importanceLevel = 1,
    this.colorHex,
  });
}
