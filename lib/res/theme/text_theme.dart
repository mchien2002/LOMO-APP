import 'package:flutter/material.dart';

import '../colors.dart';
import 'theme_manager.dart';

const FontFamily = "Google Sans";

class TextSizes {
  static const small = 11.0;
  static const caption = 12.0;
  static const subText = 14.0;
  static const body = 17.0;
  static const heading4 = 15.0;
  static const heading3 = 17.0;
  static const heading2 = 22.0;
  static const heading1 = 34.0;
  static const heading5 = 24.0;
  static const text10 = 10.0;
  static const text11 = 11.0;
  static const text12 = 12.0;
  static const text13 = 13.0;
  static const text14 = 14.0;
  static const text15 = 15.0;
  static const text16 = 16.0;
  static const text17 = 17.0;
  static const text18 = 18.0;
  static const text19 = 19.0;
  static const text20 = 20.0;
  static const text21 = 21.0;
  static const text22 = 22.0;
  static const text23 = 23.0;
  static const text24 = 24.0;
  static const text25 = 25.0;
  static const text26 = 26.0;
  static const text27 = 27.0;
  static const text28 = 28.0;
  static const text29 = 29.0;
  static const text30 = 30.0;
  static const text32 = 32.0;
  static const heading6 = 20.0;
  static const primaryButton = 18.0;
}

extension TextThemeExt on TextTheme {
  TextStyle get small =>
      TextStyle(fontSize: TextSizes.small, fontWeight: FontWeight.normal);

  TextStyle get text12withUnderline => TextStyle(
      fontSize: TextSizes.text12,
      fontWeight: FontWeight.normal,
      decoration: TextDecoration.underline);

  TextStyle get heading3 =>
      TextStyle(fontSize: TextSizes.heading3, fontWeight: FontWeight.normal);

  TextStyle get heading4 =>
      TextStyle(fontSize: TextSizes.heading4, fontWeight: FontWeight.normal);

  TextStyle get screenTitle =>
      TextStyle(fontSize: TextSizes.text18, fontWeight: FontWeight.normal);

  TextStyle get text10 =>
      TextStyle(fontSize: TextSizes.text10, fontWeight: FontWeight.normal);

  TextStyle get text11 =>
      TextStyle(fontSize: TextSizes.text11, fontWeight: FontWeight.normal);

  TextStyle get text12 =>
      TextStyle(fontSize: TextSizes.text12, fontWeight: FontWeight.normal);

  TextStyle get text13 =>
      TextStyle(fontSize: TextSizes.text13, fontWeight: FontWeight.normal);

  TextStyle get text14 =>
      TextStyle(fontSize: TextSizes.text14, fontWeight: FontWeight.normal);

  TextStyle get text14Normal =>
      TextStyle(fontSize: TextSizes.text14, fontWeight: FontWeight.normal);

  TextStyle get text14Bold =>
      TextStyle(fontSize: TextSizes.text14, fontWeight: FontWeight.bold);

  TextStyle get text15 =>
      TextStyle(fontSize: TextSizes.text15, fontWeight: FontWeight.normal);

  TextStyle get text16 =>
      TextStyle(fontSize: TextSizes.text16, fontWeight: FontWeight.normal);

  TextStyle get text16Bold =>
      TextStyle(fontSize: TextSizes.text16, fontWeight: FontWeight.bold);

  TextStyle get text17 =>
      TextStyle(fontSize: TextSizes.text17, fontWeight: FontWeight.normal);

  TextStyle get text18Bold =>
      TextStyle(fontSize: TextSizes.text18, fontWeight: FontWeight.bold);

  TextStyle get text18 =>
      TextStyle(fontSize: TextSizes.text18, fontWeight: FontWeight.normal);

  TextStyle get text19 =>
      TextStyle(fontSize: TextSizes.text19, fontWeight: FontWeight.normal);

  TextStyle get text20 =>
      TextStyle(fontSize: TextSizes.text20, fontWeight: FontWeight.normal);

  TextStyle get text21 =>
      TextStyle(fontSize: TextSizes.text21, fontWeight: FontWeight.normal);

  TextStyle get text22 =>
      TextStyle(fontSize: TextSizes.text22, fontWeight: FontWeight.normal);

  TextStyle get text24 =>
      TextStyle(fontSize: TextSizes.text24, fontWeight: FontWeight.normal);

  TextStyle get text26 =>
      TextStyle(fontSize: TextSizes.text26, fontWeight: FontWeight.normal);

  TextStyle get text28Normal =>
      TextStyle(fontSize: TextSizes.text28, fontWeight: FontWeight.normal);

  TextStyle get text28Bold =>
      TextStyle(fontSize: TextSizes.text28, fontWeight: FontWeight.bold);

  TextStyle get text32 =>
      TextStyle(fontSize: TextSizes.text32, fontWeight: FontWeight.normal);

  TextStyle get body => this.bodyText1!;

  TextStyle get subText => this.subtitle1!;

  TextStyle get buttonSmall => this.headline4!;

  TextStyle get buttonLarge => this.headline3!;
}

extension TextStyleExt on TextStyle {
  TextStyle get light => this.copyWith(fontWeight: FontWeight.w300);

  TextStyle get underline =>
      this.copyWith(decoration: TextDecoration.underline);

  TextStyle get bold => this.copyWith(fontWeight: FontWeight.w700);

  TextStyle get medium => this.copyWith(fontWeight: FontWeight.w500);

  TextStyle get semiBold => this.copyWith(fontWeight: FontWeight.w600);

  TextStyle get captionNormal => this.copyWith(fontWeight: FontWeight.normal);

  //height style
  TextStyle get height30Per => this.copyWith(height: 1.3);

  TextStyle get height20Per => this.copyWith(height: 1.2);
  TextStyle get height50Per => this.copyWith(height: 1.5);

  // colors
  TextStyle get colorPrimary => this.copyWith(color: getColor().colorPrimary);
  TextStyle get gray2eaColor =>
      this.copyWith(color: getColor().textGray2eaColor);

  TextStyle get colorDart => this.copyWith(color: getColor().textDart);

  TextStyle get colorGrayBorder => this.copyWith(color: getColor().grayBorder);

  TextStyle get colorGray77 => this.copyWith(color: getColor().colorGray77);

  TextStyle get colorff6d6e79 => this.copyWith(color: getColor().ff6d6e79);

  TextStyle get ff85889c => this.copyWith(color: getColor().ff85889c);

  TextStyle get b6b6cbColor => this.copyWith(color: getColor().b6b6cbColor);

  TextStyle get colorPink88 => this.copyWith(color: getColor().pin88Color);

  TextStyle get colorblack3dD => this.copyWith(color: getColor().colorblack3dD);

  TextStyle get ff261744Color => this.copyWith(color: getColor().ff261744Color);

  TextStyle get babbceColor => this.copyWith(color: getColor().ff261744Color);

  TextStyle get colorblack7cD => this.copyWith(color: getColor().colorblack7cD);

  TextStyle get colorBlack00 => this.copyWith(color: getColor().colorDart);

  TextStyle get colorGray => this.copyWith(color: getColor().textGray);

  TextStyle get colorHint => this.copyWith(color: getColor().textHint);

  TextStyle get colorDivider => this.copyWith(color: getColor().colorDivider);

  TextStyle get colorGrayTime => this.copyWith(color: getColor().textTime);

  TextStyle get colorback95FB => this.copyWith(color: getColor().back95FBColor);

  TextStyle get colorWhite => this.copyWith(color: getColor().white);
  TextStyle get yellowffDcolor =>
      this.copyWith(color: getColor().yellowffDcolor);
  TextStyle get colorText2cd1c6 =>
      this.copyWith(color: getColor().colorBlue2cd1);

  TextStyle get text9094abColor =>
      this.copyWith(color: getColor().text9094abColor);

  TextStyle get colorViolet => this.copyWith(color: getColor().violet);

  TextStyle get colorVioletFB => this.copyWith(color: getColor().violetFBColor);

  TextStyle get colorgrayF1 => this.copyWith(color: getColor().grayF1Color);

  TextStyle get colorgray6CB => this.copyWith(color: getColor().textColor6cb);

  TextStyle get colorBlueECFC => this.copyWith(color: getColor().colorBlueECFC);

  TextStyle get colorBlue7FF7 => this.copyWith(color: getColor().colorBlue7FF7);

  TextStyle get colorBlack4B => this.copyWith(color: getColor().black4B);

  TextStyle get colorGray99 =>
      this.copyWith(color: getColor().unSelectedTabBar);

  TextStyle get colorButtonSmall =>
      this.copyWith(color: getColor().buttonSmallText);

  TextStyle get colorSuccess => this.copyWith(color: getColor().success);

  TextStyle get colorError => this.copyWith(color: getColor().error);

  TextStyle get fontGoogleSans => this.copyWith(fontFamily: "Google Sans");

  TextStyle get darkTextColor => this.copyWith(color: getColor().darkTextColor);

  TextStyle get textAppbarGreyColor =>
      this.copyWith(color: getColor().textAppbarGreyColor);

  TextStyle get gray77 => this.copyWith(color: getColor().gray77);

  TextStyle get text757788Color =>
      this.copyWith(color: getColor().text757788Color);

  TextStyle get colorRedFf6388 =>
      this.copyWith(color: getColor().colorRedFf6388);

  TextStyle get colorRed => this.copyWith(color: getColor().redColor);

  TextStyle get f49349Color => this.copyWith(color: getColor().f49349Color);

  TextStyle get f2cd1c6Color => this.copyWith(color: getColor().f2cd1c6Color);

  TextStyle get ff514569Color => this.copyWith(color: getColor().ff514569Color);

  TextStyle get cc261744Color => this.copyWith(color: getColor().cc261744Color);

  TextStyle get colorTran => this.copyWith(color: getColor().transparent);
  TextStyle get f5425a7Color => this.copyWith(color: getColor().f5425a7Color);
}

TextTheme createTextTheme() => TextTheme(
    subtitle1: TextStyle(
        fontFamily: FontFamily,
        fontWeight: FontWeight.normal,
        fontSize: TextSizes.subText),
    subtitle2: TextStyle(
        fontFamily: FontFamily,
        fontWeight: FontWeight.bold,
        fontSize: TextSizes.subText),
    caption: TextStyle(
        fontFamily: FontFamily,
        fontWeight: FontWeight.bold,
        fontSize: TextSizes.caption),
    bodyText1: TextStyle(
        fontFamily: FontFamily,
        fontWeight: FontWeight.normal,
        fontSize: TextSizes.body),
    bodyText2: TextStyle(
        fontFamily: FontFamily,
        fontWeight: FontWeight.bold,
        fontSize: TextSizes.body),
    headline6: TextStyle(
        fontFamily: FontFamily,
        fontWeight: FontWeight.normal,
        fontSize: TextSizes.heading2),
    headline5: TextStyle(
        fontFamily: FontFamily,
        fontWeight: FontWeight.bold,
        fontSize: TextSizes.heading5),
    headline4: TextStyle(
        fontFamily: FontFamily,
        fontWeight: FontWeight.bold,
        fontSize: TextSizes.heading4),
    headline3: TextStyle(
        fontFamily: FontFamily,
        fontWeight: FontWeight.w600,
        fontSize: TextSizes.heading3),
    headline2: TextStyle(
        fontFamily: FontFamily,
        fontWeight: FontWeight.w600,
        fontSize: TextSizes.heading2),
    headline1: TextStyle(
        fontFamily: FontFamily,
        fontWeight: FontWeight.bold,
        fontSize: TextSizes.heading1));

TextTheme createPrimaryTextTheme() =>
    createTextTheme().apply(bodyColor: DColors.whiteColor);

TextTheme createAccentTextTheme() =>
    createTextTheme().apply(bodyColor: DColors.whiteColor);

TextTheme textTheme(BuildContext context) {
  return Theme.of(context).textTheme;
}

TextTheme primaryTextTheme(BuildContext context) {
  return Theme.of(context).primaryTextTheme;
}
