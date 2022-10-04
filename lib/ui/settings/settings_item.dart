import 'package:flutter/material.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';

class SettingWidget extends StatelessWidget {
  final Widget leading;
  final String tittle;
  final String? subTittle;
  final Widget? icon;
  final TextStyle? textStyle;
  final Function()? onPressed;
  final int? number;

  const SettingWidget(
      {Key? key,
      required this.leading,
      required this.tittle,
      this.subTittle,
      this.onPressed,
      this.textStyle,
      this.number,
      this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        color: getColor().transparent00Color,
        height: 50,
        child: Row(
          children: [
            SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 28,
              height: 28,
              child: leading,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: Text(tittle,
                    style: textTheme(context).text15.colorblack3dD),
              ),
            ),
            Expanded(
              flex: number ?? 0,
              child: Container(
                child: Text(
                  subTittle ?? "",
                  style: textTheme(context).text14Normal.colorblack7cD,
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Container(
              width: 24,
              height: 24,
              child: Image.asset(
                DImages.next,
              ),
            ),
            SizedBox(
              width: 15,
            ),
          ],
        ),
      ),
    );
  }
}
