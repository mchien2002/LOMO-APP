
import 'key_value_ext.dart';

class Relationship extends KeyValueExt {
  Relationship({
    this.id,
    this.name,
  });

  String? id;
  String? name;

  factory Relationship.fromJson(Map<String, dynamic> json) => Relationship(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  @override
  String? getItemName() {
    return name;
  }
}
