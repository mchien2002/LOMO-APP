import 'package:flutter/material.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';

class GradientAppBar extends StatelessWidget {
  final String title;
  final double barHeight = 50.0;
  final Widget? rightItem;

  GradientAppBar(this.title, {this.rightItem});

  @override
  Widget build(BuildContext context) {
    final double statusbarHeight = MediaQuery.of(context).padding.top;
    return new Container(
        padding: EdgeInsets.only(top: statusbarHeight, left: 10, right: 12),
        height: statusbarHeight + barHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              child: Image.asset(
                DImages.backWhite,
                width: 36,
                height: 36,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Text(
              title,
              style: textTheme(context).text18.colorWhite.semiBold,
            ),
            rightItem ??
                Container(
                  width: 50,
                  height: 50,
                ),
          ],
        ));
  }
}

class GradientAppBarColor extends StatelessWidget {
  final String title;
  final double barHeight = 50.0;
  final Widget? rightItem;

  GradientAppBarColor(this.title, {this.rightItem});

  @override
  Widget build(BuildContext context) {
    final double statusbarHeight = MediaQuery.of(context).padding.top;
    return new Container(
        padding: EdgeInsets.only(top: statusbarHeight, left: 10, right: 10),
        height: statusbarHeight + barHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [getColor().violet, getColor().pinkColor],
            begin: Alignment.centerLeft,
            end: Alignment.bottomRight,
            tileMode: TileMode.clamp,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              child: Image.asset(
                DImages.backWhite,
                width: 50,
                height: 50,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Text(
              title,
              style: textTheme(context).text18.colorWhite.semiBold,
            ),
            rightItem ??
                Container(
                  width: 32,
                  height: 32,
                ),
          ],
        ));
  }
}
