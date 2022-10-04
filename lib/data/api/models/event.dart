import 'package:lomo/util/constants.dart';

class Event extends DiscoveryItemGroup {
  Event({
    this.id,
    this.title,
    this.image,
    this.link,
    this.expiryDate,
  });

  String? id;
  String? title;
  String? image;
  String? link;
  int? expiryDate;

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json["id"],
        title: json["title"] ?? "",
        image: json["image"] ?? "",
        link: json["link"] ?? "",
        expiryDate: json["expiryDate"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title ?? "",
        "image": image ?? "",
        "link": link ?? "",
        "expiryDate": expiryDate,
      };
}
