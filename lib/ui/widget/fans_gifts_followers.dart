import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/res/theme/text_theme.dart';

class FansGiftsFollowersComponent extends StatelessWidget {
  final int? number;
  final String? textTittle;
  final User user;
  FansGiftsFollowersComponent(
      {this.number, this.textTittle, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 43,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$number',
            style: textTheme(context).text16Bold.colorDart,
          ),
          SizedBox(
            height: 2,
          ),
          Text(
            textTittle ?? "",
            style: textTheme(context).text12.colorGrayTime,
          ),
        ],
      ),
    );
  }
}
