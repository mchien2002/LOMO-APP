import 'package:hive/hive.dart';
import 'package:lomo/data/database/db_type.dart';
import 'package:lomo/res/constant.dart';

part 'photo_model.g.dart';

@HiveType(typeId: PHOTO)
class PhotoModel extends HiveObject {
  @HiveField(0)
  String? link;
  @HiveField(1)
  bool isVertical;
  @HiveField(2)
  double? ratio;
  @HiveField(3)
  String? type;
  @HiveField(4)
  String? thumb;
  int? duration;
  PhotoModel(this.link,
      {this.isVertical = true,
      this.ratio = 1,
      this.type = Constants.TYPE_IMAGE,
      this.thumb,
      this.duration = 0});

  factory PhotoModel.fromJson(Map<String, dynamic> json) => PhotoModel(
        json["link"],
        isVertical: json["isVertical"],
        ratio: json["ratio"] != null ? json["ratio"].toDouble() : 1,
        type: json["type"] != null ? json["type"] : Constants.TYPE_IMAGE,
        thumb: json["thumb"],
        duration: json["duration"],
      );

  Map<String, dynamic> toJson() => {
        "link": link ?? "",
        "isVertical": isVertical,
        "ratio": ratio,
        "type": type,
        "thumb": thumb,
        "duration": duration,
      };
}

enum ImageDirection { HORIZONTAL, SQUARE, VERTICAL }

extension ImageDirectionExtension on ImageDirection {
  ImageDirection getImgDirection(int direction) {
    switch (direction) {
      case -1:
        return ImageDirection.HORIZONTAL;
      case 0:
        return ImageDirection.SQUARE;
      case 1:
        return ImageDirection.VERTICAL;
      default:
        return ImageDirection.VERTICAL;
    }
  }
}
