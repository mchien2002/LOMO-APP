import 'package:flutter/material.dart';
import 'package:lomo/res/theme/text_theme.dart';

class IconNameItem extends StatelessWidget {
  final Function? onPressed;
  final Widget? imageWidget;
  final String? textName;
  final Widget? widget;
  const IconNameItem(
      {this.onPressed, this.imageWidget, this.textName, this.widget});
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 10,
        ),
        Container(
          child: imageWidget,
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
            child: Text(
          textName ?? "",
          style: textTheme(context).text16.colorDart,
        )),
        Container(
          child: widget,
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }
}
