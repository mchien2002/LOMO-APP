import 'dart:convert';

import 'discovery_item_type.dart';

class DiscoveryItem {
  DiscoveryItem(
      {this.key,
      this.isHide,
      this.priority,
      this.name,
      this.title,
      this.id,
      this.type,
      this.isAuto = false});

  String? key;
  bool? isHide;
  int? priority;
  String? name;
  String? title;
  String get displayName => name ?? title ?? "";
  String? id;
  bool isAuto = false;
  DiscoveryItemType? type;

  factory DiscoveryItem.fromJson(Map<String, dynamic> json) => DiscoveryItem(
        key: json["key"],
        isHide: json["isHide"] ?? false,
        priority: json["priority"] ?? 1,
        name: json["name"],
        title: json["title"],
        id: json["id"],
        isAuto: json["isAuto"] ?? false,
        type: json["type"] != null
            ? DiscoveryItemType.fromJson(json["type"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "isHide": isHide,
        "priority": priority,
        "name": name,
        "title": title,
        "id": id,
        "isAuto": isAuto,
        "type": type?.toJson(),
      };

  static String encodeGender(List<DiscoveryItem> items) => json.encode(
        items.map<Map<String, dynamic>>((item) => item.toJson()).toList(),
      );

  static List<DiscoveryItem> decodeGender(String items) =>
      (json.decode(items) as List<dynamic>)
          .map<DiscoveryItem>((item) => DiscoveryItem.fromJson(item))
          .toList();
}
