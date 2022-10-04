import 'package:hive/hive.dart';
import 'package:lomo/data/database/db_type.dart';

import 'key_value_ext.dart';

part 'sogiesc.g.dart';

@HiveType(typeId: SOGIESC)
class Sogiesc extends HiveObject with KeyValueExt {
  Sogiesc({
    this.id,
    this.name,
    this.priority = 0,
    this.type,
  });

  @override
  String toString() {
    return 'Sogiesc{id: $id, name: $name}';
  }

  @HiveField(0)
  String? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  int priority;
  List<String>? type;
  bool selected = false;

  factory Sogiesc.fromJson(Map<String, dynamic> json) => Sogiesc(
      id: json["id"],
      name: json["name"],
      type: json["type"] != null
          ? List<String>.from(json["type"].map((x) => x))
          : [],
      priority: json["priority"] ?? 0);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "type": type?.isNotEmpty == true
            ? List<String>.from(type!.map((x) => x))
            : [],
        "priority": priority,
      };

  @override
  String? getItemName() {
    return name;
  }
}
