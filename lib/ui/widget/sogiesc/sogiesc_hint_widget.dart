import 'package:flutter/material.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';

class SogiescHintWidget extends StatefulWidget {
  final List<String> data;
  final Function? selectedAdd;
  final Function? closeWidget;
  SogiescHintWidget(this.data, {this.selectedAdd, this.closeWidget});
  @override
  _SogiescHintWidgetState createState() => _SogiescHintWidgetState();
}

class _SogiescHintWidgetState extends State<SogiescHintWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: getColor().colorVioletEB,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: Text(
                  Strings.resultOfSogiesTest.localize(context),
                  style: textTheme(context).text12.bold.colorDart,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  if (widget.closeWidget != null) widget.closeWidget!();
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 5.0),
                  child: Image.asset(
                    DImages.iconCloseSogiesc,
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.data.isNotEmpty == true)
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: widget.data.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 2.0),
                              child: Text(
                                widget.data[index],
                                style: textTheme(context).text16.colorDart,
                              ),
                            );
                          },
                        ),
                      SizedBox(
                        height: 8,
                      ),
                      _addClick(),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.asset(
                    DImages.logoGift,
                    width: 130,
                    height: 90,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _addClick() {
    return InkWell(
      onTap: () {
        if (widget.selectedAdd != null) widget.selectedAdd!();
      },
      child: Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(5),
        child: Padding(
          padding: EdgeInsets.all(6.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                Strings.addNow.localize(context),
                style: textTheme(context).text14Normal.colorViolet,
              ),
              SizedBox(
                width: 5,
              ),
              Image.asset(
                DImages.addViolet,
                width: 16,
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
