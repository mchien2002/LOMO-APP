import 'dart:typed_data';

class DatingImage {
  String? link;
  bool isVerify = false;
  Uint8List? u8List;

  DatingImage({this.link, this.isVerify = false, this.u8List});

  factory DatingImage.fromJson(Map<String, dynamic> json) => DatingImage(
        link: json["link"] ?? "",
        isVerify: json["isVerify"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "link": link ?? "",
        "isVerify": isVerify,
      };

  @override
  String toString() {
    return 'DatingImage{link: $link, isVerify: $isVerify';
  }
}
