import 'package:flutter/material.dart';
import 'package:lomo/res/colors.dart';
import 'package:lomo/res/theme/text_theme.dart';

class DateAuthenWidget extends StatefulWidget {
  final String? textName;
  const DateAuthenWidget({this.textName});

  @override
  _DateAuthenWidgetState createState() => _DateAuthenWidgetState();
}

class _DateAuthenWidgetState extends State<DateAuthenWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Column(
        children: [
          Text(widget.textName ?? "",
              style: textTheme(context).text24.light.colorPrimary),
          SizedBox(
            height: 9,
          ),
          Container(
            width: 24,
            height: 1,
            color: DColors.primaryColor,
          )
        ],
      ),
    );
  }
}

class DateAuthenNotChooseWidget extends StatefulWidget {
  final String? textName;
  const DateAuthenNotChooseWidget({this.textName});

  @override
  _DateAuthenNotChooseWidgetState createState() =>
      _DateAuthenNotChooseWidgetState();
}

class _DateAuthenNotChooseWidgetState extends State<DateAuthenNotChooseWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Column(
        children: [
          Text(widget.textName ?? "",
              style: textTheme(context).text24.light.colorgray6CB),
          SizedBox(
            height: 9,
          ),
          Container(
            width: 24,
            height: 1,
            color: DColors.gray6cbColor,
          )
        ],
      ),
    );
  }
}
