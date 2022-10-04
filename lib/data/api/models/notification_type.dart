import 'dart:convert';

class NotificationType {
  NotificationType({
    this.id,
    this.name,
  });

  String? id;
  String? name;

  factory NotificationType.fromJson(Map<String, dynamic> json) =>
      NotificationType(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id ?? null,
        "name": name ?? "",
      };

  static String encodeGender(List<NotificationType> zodiac) => json.encode(
        zodiac.map<Map<String, dynamic>>((item) => item.toJson()).toList(),
      );

  static List<NotificationType> decodeGender(String zodiac) =>
      (json.decode(zodiac) as List<dynamic>)
          .map<NotificationType>((item) => NotificationType.fromJson(item))
          .toList();
}
