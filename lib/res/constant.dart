import 'package:lomo/data/api/models/feeling.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';

class Constants {
  static const heightUnit = "cm";
  static const weightUnit = "kg";
  static final feeling = [
    Feeling(iconData: DImages.happy, name: Strings.happy, parentFeeling: "yeu"),
    Feeling(iconData: DImages.lovely, name: Strings.love, parentFeeling: "yeu"),
    Feeling(
        iconData: DImages.happyFun,
        name: Strings.happyFun,
        parentFeeling: "yeu"),
    Feeling(iconData: DImages.great, name: Strings.great, parentFeeling: "yeu"),
    Feeling(
        iconData: DImages.confident,
        name: Strings.confident,
        parentFeeling: "yeu"),
    Feeling(
        iconData: DImages.comfortable,
        name: Strings.comfortable,
        parentFeeling: "yeu"),
    Feeling(
        iconData: DImages.protection,
        name: Strings.protection,
        parentFeeling: "yeu"),
    Feeling(
        iconData: DImages.strong, name: Strings.strong, parentFeeling: "yeu"),
    Feeling(
        iconData: DImages.sad, name: Strings.sad, parentFeeling: "canduocyeu"),
    Feeling(
        iconData: DImages.motivation,
        name: Strings.motivation,
        parentFeeling: "canduocyeu"),
    Feeling(
        iconData: DImages.inferiority,
        name: Strings.inferiority,
        parentFeeling: "canduocyeu"),
    Feeling(
        iconData: DImages.angry, name: "Giận dữ", parentFeeling: "canduocyeu"),
    Feeling(
        iconData: DImages.disappointed,
        name: Strings.disappointed,
        parentFeeling: "canduocyeu"),
    Feeling(
        iconData: DImages.lonely,
        name: Strings.lonely,
        parentFeeling: "canduocyeu"),
    Feeling(
        iconData: DImages.sulk,
        name: Strings.sulk,
        parentFeeling: "canduocyeu"),
    Feeling(
        iconData: DImages.tired,
        name: Strings.tired,
        parentFeeling: "canduocyeu"),
    Feeling(
        iconData: DImages.suprise,
        name: Strings.suprise,
        parentFeeling: "binhthuong"),
    Feeling(
        iconData: DImages.confused,
        name: Strings.confused,
        parentFeeling: "binhthuong"),
    Feeling(
        iconData: DImages.cold,
        name: Strings.cold,
        parentFeeling: "binhthuong"),
    Feeling(
        iconData: DImages.hot, name: Strings.hot, parentFeeling: "binhthuong"),
  ];

  static const minAge = 18.0;
  static const maxAge = 70.0;
  static const MAX_RANGE = 500.0;
  static const ID_VERIFY = "60a37f80fb2da21e0584e90f";
  static const TYPE_VIDEO = "video";
  static const TYPE_IMAGE = "image";
}
