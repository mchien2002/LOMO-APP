import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lomo/data/repositories/common_repository.dart';
import 'package:lomo/di/locator.dart';

import '../colors.dart';
import 'text_theme.dart';

enum AppTheme { White, Dark }

/// Returns enum value name without enum class name.
String enumName(AppTheme anyEnum) {
  return anyEnum.toString().split('.')[1];
}

final appThemeData = {
  AppTheme.White: ThemeData(
      primaryColor: DColors.primaryColor,
      primaryColorDark: DColors.primaryColorDark,
      backgroundColor: DColors.whiteColor,
      scaffoldBackgroundColor: DColors.whiteColor,
      textTheme: createTextTheme(),
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      fontFamily: FontFamily,
      brightness: Brightness.light,
      appBarTheme: AppBarTheme(
        color: Colors.transparent, // status bar color
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      colorScheme:
          ColorScheme.fromSwatch().copyWith(secondary: DColors.accentColor)),
  AppTheme.Dark: ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.black,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      fontFamily: FontFamily,
      appBarTheme: AppBarTheme(
        color: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      )),
};

class ThemeManager with ChangeNotifier {
  ThemeData? _themeData;

  init() async {
    // We load theme at the start
    _loadTheme();
  }

  /// Use this method on UI to get selected theme.
  ThemeData get themeData {
    if (_themeData == null) {
      _themeData = appThemeData[AppTheme.White];
    }
    return _themeData!;
  }

  void _loadTheme() async {
    final preferredTheme = await locator<CommonRepository>().getTheme();
    currentAppTheme = AppTheme.values[preferredTheme];
    _themeData = appThemeData[currentAppTheme];
    // Once theme is loaded - notify listeners to update UI
    notifyListeners();
  }

  /// Sets theme and notifies listeners about change.
  setTheme(AppTheme theme) async {
    currentAppTheme = theme;
    _themeData = appThemeData[theme];

    // Here we notify listeners that theme changed
    // so UI have to be rebuild
    notifyListeners();
    await locator<CommonRepository>().setTheme(AppTheme.values.indexOf(theme));
  }
}

AppTheme currentAppTheme = AppTheme.White;

ColorScheme getColor() => locator<ThemeManager>().themeData.colorScheme;

extension MyColorScheme on ColorScheme {
  Color getColorTheme(Color colorThemeWhite, Color colorThemeDark) {
    switch (currentAppTheme) {
      case AppTheme.White:
        return colorThemeWhite;
      case AppTheme.Dark:
        return colorThemeDark;
      default:
        return colorThemeWhite;
    }
  }

  Color get colorPrimary =>
      getColorTheme(DColors.primaryColor, DColors.primaryColor);

  Color get success => getColorTheme(DColors.blueLight, DColors.yellowffDcolor);

  Color get black => getColorTheme(DColors.black, DColors.black);

  Color get colorError => getColorTheme(DColors.errorColor, DColors.errorColor);

  Color get notification => getColorTheme(DColors.redColor, DColors.redColor);

  Color get redColor => getColorTheme(DColors.redColor, DColors.redColor);

  Color get shadowMainTabBar =>
      getColorTheme(DColors.shadowColor, DColors.shadowColor);

  Color get buttonSmallText => getColorTheme(Colors.white, Colors.black);

  Color get backGroundGrayIcon =>
      getColorTheme(DColors.gray8DColor, DColors.gray8DColor);

  Color get grayBorder => getColorTheme(DColors.grayBorder, DColors.grayBorder);

  Color get gray2eaColor =>
      getColorTheme(DColors.gray2eaColor, DColors.gray2eaColor);

  Color get backgroundSearch =>
      getColorTheme(DColors.grayF0Color, DColors.grayF0Color);

  Color get colorf0f1f5 => getColorTheme(DColors.f0f1f5, DColors.f0f1f5);

  Color get f8f8faColor =>
      getColorTheme(DColors.f8f8faColor, DColors.f8f8faColor);

  Color get backgroundCancel =>
      getColorTheme(DColors.grayEDColor, DColors.grayEDColor);

  Color get colorGrayC1 =>
      getColorTheme(DColors.grayC1Color, DColors.grayC1Color);

  Color get colorGrayEAF2 =>
      getColorTheme(DColors.grayEAF2Color, DColors.grayEAF2Color);

  Color get grayBDBEColor =>
      getColorTheme(DColors.grayBDBEColor, DColors.grayBDBEColor);

  Color get buttonInActive =>
      getColorTheme(DColors.inActiveColor, DColors.inActiveColor);

  Color get transparent =>
      getColorTheme(DColors.transparentColor, DColors.transparentColor);

  Color get transparent00Color =>
      getColorTheme(DColors.transparent00Color, DColors.transparent00Color);

  Color get bottomLineTextField =>
      getColorTheme(DColors.d2d2d9, DColors.d2d2d9);

  Color get colorDart => getColorTheme(DColors.blackColor, DColors.blackColor);

  Color get colorBlackBg => getColorTheme(DColors.blackSDT, DColors.blackSDT);

  Color get blackB3 => getColorTheme(DColors.blackB3, DColors.blackB3);

  Color get colorBlack99 =>
      getColorTheme(DColors.black99Color, DColors.black99Color);

  Color get colorGray =>
      getColorTheme(DColors.gray8DColor, DColors.gray8DColor);

  Color get colorGrayOpacity =>
      getColorTheme(DColors.gray6ebColor, DColors.gray6ebColor);

  Color get colorGrayE8 =>
      getColorTheme(DColors.grayE8Color, DColors.grayE8Color);

  Color get ff261744Color =>
      getColorTheme(DColors.ff261744Color, DColors.ff261744Color);

  Color get colorShadow88 =>
      getColorTheme(DColors.shadowColor88, DColors.shadowColor88);

  Color get colorGray77 =>
      getColorTheme(DColors.gray77Color, DColors.gray77Color);

  Color get babbceColor =>
      getColorTheme(DColors.babbceColor, DColors.ff261744Color);

  Color get ff6d6e79 => getColorTheme(DColors.ff6d6e79, DColors.ff6d6e79);

  Color get ff85889c => getColorTheme(DColors.ff85889c, DColors.ff85889c);

  Color get colorBackGroundGrayUseItem =>
      getColorTheme(DColors.grayDCColor, DColors.grayDCColor);

  Color get white => getColorTheme(Colors.white, Colors.black);

  Color get yellowffDcolor =>
      getColorTheme(DColors.yellowffDcolor, Colors.black);

  Color get blue37DColor => getColorTheme(DColors.blue37DColor, Colors.black);

  Color get f3eefcColor => getColorTheme(DColors.f3eefcColor, Colors.black);

  Color get gray6ebColor => getColorTheme(DColors.gray6ebColor, Colors.black);

  Color get violet => getColorTheme(DColors.violetColor, DColors.violetColor);

  Color get violetFBColor =>
      getColorTheme(DColors.violetFBColor, DColors.violetFBColor);

  Color get pinkF2F5Color => getColorTheme(DColors.pinkF2F5, DColors.pinkF2F5);

  Color get grayF1Color =>
      getColorTheme(DColors.grayF1Color, DColors.grayF1Color);

  Color get back95FBColor =>
      getColorTheme(DColors.back95FBColor, DColors.back95FBColor);

  Color get blackBackgroundColor =>
      getColorTheme(DColors.blackBackground, DColors.blackBackground);

  Color get btnBackgroundColor =>
      getColorTheme(DColors.btnBackground, DColors.btnBackground);

  Color get pink => getColorTheme(Colors.pink, Colors.pink);

  Color get pinkF0 => getColorTheme(DColors.pinkF0Color, DColors.pinkF0Color);

  Color get primaryColor =>
      getColorTheme(DColors.primaryColor, DColors.primaryColor);

  Color get violet008 =>
      getColorTheme(DColors.violet008Color, DColors.violet008Color);

  Color get black4B =>
      getColorTheme(DColors.black4BColor, DColors.black4BColor);

  Color get colorDivider =>
      getColorTheme(DColors.grayD9Color, DColors.grayD9Color);

  Color get colorviolet6FB =>
      getColorTheme(DColors.violet6FBColor, DColors.violet6FBColor);

  Color get colorblack3dD =>
      getColorTheme(DColors.black3dDColor, DColors.black3dDColor);

  Color get colorblack7cD =>
      getColorTheme(DColors.black7cDColor, DColors.black7cDColor);

  Color get colorVioletEB =>
      getColorTheme(DColors.violetEBColor, DColors.violetEBColor);

  Color get unSelectedTabBar =>
      getColorTheme(DColors.gray99Color, DColors.gray99Color);

  Color get b6b6cbColor =>
      getColorTheme(DColors.b6b6cbColor, DColors.b6b6cbColor);

  Color get colorBlueECFC => getColorTheme(DColors.blueECFC, DColors.blueECFC);

  Color get colorBlue7FF7 => getColorTheme(DColors.blue7FF7, DColors.blue7FF7);

  //text
  Color get underlineClearTextField =>
      getColorTheme(DColors.grayD9Color, DColors.grayD9Color);

  Color get textTime => getColorTheme(DColors.gray66Color, DColors.gray66Color);

  Color get textGray => getColorTheme(DColors.gray8DColor, DColors.gray8DColor);

  Color get textHint => getColorTheme(DColors.gray99Color, DColors.gray99Color);
  Color get textGray2eaColor =>
      getColorTheme(DColors.gray2eaColor, DColors.gray2eaColor);

  Color get textDart =>
      getColorTheme(DColors.darkTextColor, DColors.darkTextColor);

  Color get ff514569Color =>
      getColorTheme(DColors.ff514569Color, DColors.ff514569Color);

  Color get text9094abColor =>
      getColorTheme(DColors.text9094abColor, DColors.text9094abColor);

  Color get darkTextColor =>
      getColorTheme(DColors.darkTextColor, DColors.darkTextColor);

  Color get gray77 => getColorTheme(DColors.gray77, DColors.darkTextColor);

  Color get text757788Color =>
      getColorTheme(DColors.text757788Color, DColors.text757788Color);

  Color get textGray77 =>
      getColorTheme(DColors.gray77Color, DColors.gray77Color);

  Color get pinkf3eefc =>
      getColorTheme(DColors.f3eefcColor, DColors.f3eefcColor);

  Color get pinkColor => getColorTheme(DColors.pinkColor, DColors.pinkColor);

  Color get pin88Color =>
      getColorTheme(DColors.pinkColor88, DColors.pinkColor88);

  Color get orangeColor =>
      getColorTheme(DColors.f49349Color, DColors.f49349Color);

  Color get greenColor => getColorTheme(DColors.cd1c6Color, DColors.cd1c6Color);

  Color get pinke6fa => getColorTheme(DColors.pinke6fa, DColors.pinke6fa);

  Color get textColor6cb =>
      getColorTheme(DColors.gray6cbColor, DColors.gray6cbColor);

  Color get colorBlueEff =>
      getColorTheme(DColors.blueEffffeColor, DColors.blueEffffeColor);

  Color get colorBlue2cd1 =>
      getColorTheme(DColors.blue2cd1c6Color, DColors.blue2cd1c6Color);

  Color get colorBlue28bb =>
      getColorTheme(DColors.blue28bbb2Color, DColors.blue28bbb2Color);

  Color get colorRedFf6388 =>
      getColorTheme(DColors.redFf6388Color, DColors.redFf6388Color);

  Color get colorRedE5597a =>
      getColorTheme(DColors.redE5597aColor, DColors.redE5597aColor);

  Color get textAppbarGreyColor =>
      getColorTheme(DColors.textAppbarGreyColor, DColors.textAppbarGreyColor);

  Color get f49349Color =>
      getColorTheme(DColors.f49349Color, DColors.f49349Color);

  Color get f2cd1c6Color =>
      getColorTheme(DColors.f2cd1c6Color, DColors.f2cd1c6Color);

  Color get cc261744Color =>
      getColorTheme(DColors.cc261744Color, DColors.cc261744Color);

  Color get grayF8bColor =>
      getColorTheme(DColors.grayf8f8faColor, Colors.black);

  Color get grayf1f6aColor =>
      getColorTheme(DColors.grayf1f6aColor, DColors.grayf1f6aColor);

  Color get pink693Color => getColorTheme(DColors.pinke6933, DColors.pinke6933);
  Color get f5425a7Color =>
      getColorTheme(DColors.primaryColor, DColors.primaryColor);
  Color get e8dbffColor => getColorTheme(DColors.e8dbff, DColors.e8dbff);

  Color get shimmerBaseColor =>
      getColorTheme(DColors.shimmerBaseColor, DColors.shimmerBaseColor);

  Color get shimmerHighlightColor => getColorTheme(
      DColors.shimmerHighlightColor, DColors.shimmerHighlightColor);
}
