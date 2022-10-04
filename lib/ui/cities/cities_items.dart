import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/city.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';

class CitiesItem extends StatefulWidget {
  final City item;
  final City? initItem;
  final Function(City) onPressed;

  const CitiesItem(
      {required this.item, required this.onPressed, this.initItem});

  @override
  _CitiesItemState createState() => _CitiesItemState();
}

class _CitiesItemState extends State<CitiesItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onPressed(widget.item);
      },
      child: Container(
          color: widget.initItem != null &&
                  widget.item.name == widget.initItem!.name
              ? getColor().pinke6fa
              : getColor().white,
          height: 50,
          padding: EdgeInsets.only(left: 23, right: 23),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(widget.item.name,
                    style: textTheme(context).text15.colorDart),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 0.8,
                  color: getColor().colorDivider,
                ),
              ),
            ],
          )),
    );
  }
}
