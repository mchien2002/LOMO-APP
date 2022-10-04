import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/city.dart';
import 'package:lomo/res/colors.dart';
import 'package:lomo/res/theme/text_theme.dart';

class CitiesTitle extends StatelessWidget {
  final City item;

  const CitiesTitle({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 23, right: 23),
      height: 30,
      child: Align(
        alignment: Alignment.centerLeft,
        child:
            Text(item.name, style: textTheme(context).subText.bold.colorDart),
      ),
      color: DColors.greyf3DColor,
    );
  }
}
