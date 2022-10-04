import 'dart:convert';

import 'key_value_ext.dart';

class Zodiac extends KeyValueExt {
  Zodiac({
    this.id,
    this.name,
  });

  String? id;
  String? name;

  factory Zodiac.fromJson(Map<String, dynamic> json) => Zodiac(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  static String encodeGender(List<Zodiac> zodiac) => json.encode(
        zodiac.map<Map<String, dynamic>>((item) => item.toJson()).toList(),
      );

  static List<Zodiac> decodeGender(String zodiac) =>
      (json.decode(zodiac) as List<dynamic>)
          .map<Zodiac>((item) => Zodiac.fromJson(item))
          .toList();

  @override
  String? getItemName() {
    return name;
  }
}
