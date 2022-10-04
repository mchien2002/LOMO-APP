import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/key_value_ext.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';

import 'custom_switch_privacy_widget.dart';

class PrivacyItemWidget extends StatefulWidget {
  final String title;
  final bool initSwitch;
  final Function(bool) selectedSwitch;
  final String icon;
  final List<KeyValueExt?>? listValue;

  PrivacyItemWidget(this.title, this.icon, this.listValue, this.initSwitch,
      this.selectedSwitch);

  @override
  _PrivacyItemWidgetState createState() => _PrivacyItemWidgetState();
}

class _PrivacyItemWidgetState extends State<PrivacyItemWidget> {
  bool initValue = true;
  bool status1 = false;

  @override
  void initState() {
    super.initState();
    initValue = widget.initSwitch;
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }

  Widget _buildContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: CircleAvatar(
            backgroundColor: getColor().colorGrayOpacity,
            radius: Dimens.size20,
            child: Image.asset(
              widget.icon,
              color: getColor().colorGray,
              width: Dimens.size25,
              height: Dimens.size25,
            ),
          ),
        ),
        Expanded(
          flex: 7,
          child: Padding(
            padding: const EdgeInsets.only(left: Dimens.size10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.title != null)
                  Text(
                    widget.title,
                    style: textTheme(context).text13.bold.colorGray,
                  ),
                SizedBox(
                  height: Dimens.spacing5,
                ),
                widget.listValue?.isNotEmpty == true &&
                        widget.listValue!.first != null
                    ? Wrap(
                        runSpacing: 5,
                        children:
                            List.generate(widget.listValue!.length, (index) {
                          return Text(
                            index != widget.listValue!.length - 1
                                ? "${widget.listValue![index]!.getItemName() ?? ""}, "
                                : "${widget.listValue![index]!.getItemName() ?? ""}",
                            style: textTheme(context).text15.colorDart.medium,
                          );
                        }),
                      )
                    : Text(
                        Strings.notYet.localize(context),
                        style: textTheme(context).text15.colorDart.medium,
                      ),
                SizedBox(
                  height: Dimens.size24,
                )
              ],
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(
                left: Dimens.spacing5, right: Dimens.spacing5, top: Dimens.spacing5),
            child: CustomSwitchPrivacyWidget(
              value: initValue,
              activeColor: getColor().primaryColor,
              inactiveColor: getColor().gray2eaColor,
              onToggle: (val) {
                setState(() {
                  initValue = val;
                });
                widget.selectedSwitch(val);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _itemWrapBuilderProfile<KeyValueExt>(List<KeyValueExt?>? listValue,
      String? title, String Function(KeyValueExt?) getName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(
            title,
            style: textTheme(context).text13.bold.colorGray,
          ),
        SizedBox(
          height: Dimens.spacing5,
        ),
        listValue?.isNotEmpty == true && listValue!.first != null
            ? Wrap(
                runSpacing: 5,
                children: List.generate(listValue.length, (index) {
                  return Text(
                    index != listValue.length - 1
                        ? "${getName(listValue[index]!)}, "
                        : "${getName(listValue[index]!)}",
                    style: textTheme(context).text15.colorDart.medium,
                  );
                }),
              )
            : Text(
                Strings.notYet.localize(context),
                style: textTheme(context).text15.colorDart.medium,
              ),
        SizedBox(
          height: Dimens.size24,
        )
      ],
    );
  }
}
