import 'dart:convert';

import 'key_value_ext.dart';

class City extends KeyValueExt {
  City({
    required this.id,
    required this.name,
  });

  String name;
  String id;

  factory City.fromRawJson(String str) => City.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory City.fromJson(Map<String, dynamic> json) => City(
        name: json["name"] ?? "",
        id: json["id"] ?? "",
      );

  Map<String, dynamic> toJson() => {"id": id, "name": name};
  static String encodeCity(List<City> cities) => json.encode(
        cities.map<Map<String, dynamic>>((city) => city.toJson()).toList(),
      );

  static List<City> decodeCity(String cities) =>
      (json.decode(cities) as List<dynamic>)
          .map<City>((item) => City.fromJson(item))
          .toList();

  @override
  String? getItemName() {
    return name;
  }
}
