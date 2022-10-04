import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:lomo/data/database/db_type.dart';

import 'key_value_ext.dart';

part 'gender.g.dart';

@HiveType(typeId: GENDER)
class Gender extends HiveObject with KeyValueExt {
  Gender({this.id, this.name, this.key});

  @HiveField(0)
  String? id;
  @HiveField(1)
  String? name;
  String? key;

  factory Gender.fromJson(Map<String, dynamic> json) => Gender(
        id: json["id"],
        name: json["name"] ?? "",
        key: json["key"],
      );

  Map<String, dynamic> toJson() => {"id": id, "name": name ?? "", "key": key};

  static String encodeGender(List<Gender> gender) => json.encode(
        gender.map<Map<String, dynamic>>((gender) => gender.toJson()).toList(),
      );

  static List<Gender> decodeGender(String gender) =>
      (json.decode(gender) as List<dynamic>)
          .map<Gender>((item) => Gender.fromJson(item))
          .toList();

  @override
  String? getItemName() {
    return name;
  }
}
