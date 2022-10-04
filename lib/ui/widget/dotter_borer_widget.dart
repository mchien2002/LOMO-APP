import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lomo/res/colors.dart';
import 'package:lomo/res/icons.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';

class DotterBoderWidget extends StatelessWidget {
  final Function onPress;
  final String data;
  const DotterBoderWidget({Key? key, required this.onPress, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPress();
      },
      child: Container(
          width: double.infinity,
          child: DottedBorder(
            borderType: BorderType.RRect,
            color: getColor().colorPrimary,
            strokeWidth: 1,
            dashPattern: [6, 2],
            radius: new Radius.circular(12),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: getColor().colorPrimary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 12, bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 9,
                      child: Text(
                        "$data",
                        style: textTheme(context).text15.bold.colorPrimary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 20,
                        width: 20,
                        child: SvgPicture.asset(
                          DIcons.copy,
                          color: DColors.primaryColor,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
