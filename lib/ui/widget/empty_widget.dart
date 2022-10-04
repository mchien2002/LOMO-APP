import 'package:flutter/material.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';

class EmptyWidget extends StatelessWidget {
  final String? message;

  EmptyWidget({this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, -0.25),
      child: Text(message ?? Strings.noData.localize(context),
          style: textTheme(context).body.colorDart),
    );
  }
}
