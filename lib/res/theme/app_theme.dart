import 'package:flutter/material.dart';
import 'package:lomo/res/theme/theme_manager.dart';

import '../colors.dart';
import 'text_theme.dart';

ThemeData createTheme() {
  final textTheme = createTextTheme();
  return ThemeData(
      primaryColor: getColor().primary,
      primaryColorDark: getColor().secondary,
      backgroundColor: DColors.whiteColor,
      scaffoldBackgroundColor: DColors.whiteColor,
      dividerColor: DColors.grayF0CColor,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
          color: DColors.whiteColor,
          elevation: 0.0,
          iconTheme: IconThemeData(
            color: DColors.primaryColor,
          )),
      tabBarTheme: TabBarTheme(
          indicator: BoxDecoration(color: Colors.transparent),
          labelColor: DColors.primaryColor,
          unselectedLabelColor: DColors.inActiveColor), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: DColors.accentColor));
}
