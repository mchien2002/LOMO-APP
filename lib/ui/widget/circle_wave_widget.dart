import 'package:flutter/material.dart';
import 'package:lomo/res/theme/text_theme.dart';

class CircleWaveWidget extends StatelessWidget {
  final Color color;
  final String? text;
  final TextStyle? textStyle;
  final double size;
  CircleWaveWidget(
      {required this.color, required this.size, this.text, this.textStyle});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size / 2),
          color: color.withOpacity(0.1)),
      alignment: Alignment.center,
      child: Container(
        height: size - 46,
        width: size - 46,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular((size - 46) / 2),
            color: color.withOpacity(0.3)),
        alignment: Alignment.center,
        child: Container(
          height: size - 74,
          width: size - 74,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular((size - 74) / 2),
              color: color),
          alignment: Alignment.center,
          child: Text(
            text ?? "",
            style: textStyle ?? textTheme(context).text32.bold.colorWhite,
          ),
        ),
      ),
    );
  }
}
