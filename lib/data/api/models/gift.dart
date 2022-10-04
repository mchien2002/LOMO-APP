import 'package:lomo/util/constants.dart';

import 'gift_type.dart';

class Gift extends DiscoveryItemGroup {
  Gift(
      {this.id,
      this.title,
      this.image,
      this.description,
      this.price,
      this.promotion,
      this.voucherDescription,
      this.expiryDate,
      this.type});

  String? id;
  String? title;
  String? image;
  String? description;
  String? voucherDescription;
  int? price;
  int? promotion;
  int? expiryDate;
  GiftType? type;

  factory Gift.fromJson(Map<String, dynamic> json) => Gift(
      id: json["id"],
      title: json["title"] ?? "",
      image: json["image"],
      description: json["description"] ?? "",
      price: json["price"],
      voucherDescription: json["voucherDescription"],
      promotion: json["promotion"],
      expiryDate: json["expiryDate"],
      type: json["type"] != null ? GiftType.fromJson(json["type"]) : null);

  String? get infoVoucher => voucherDescription ?? description;

  Map<String, dynamic> toJson() => {
        "id": id ?? null,
        "title": title ?? "",
        "image": image,
        "voucherDescription": voucherDescription,
        "description": description ?? "",
        "price": price,
        "promotion": promotion,
        "expiryDate": expiryDate,
        "type": type?.toJson()
      };
}
