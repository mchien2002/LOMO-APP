import 'package:flutter/material.dart';
import 'package:lomo/res/colors.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/ui/widget/super_tooltip_widget.dart';

class TargetWidget extends StatefulWidget {
  const TargetWidget({Key? key}) : super(key: key);

  @override
  _TargetWidgetState createState() => new _TargetWidgetState();
}

class _TargetWidgetState extends State<TargetWidget> {
  SuperTooltip? tooltip;

  Future<bool> _willPopCallback() async {
    if (tooltip!.isOpen) {
      tooltip!.close();
      return false;
    }
    return true;
  }

  void onTap() {
    if (tooltip != null && tooltip!.isOpen) {
      tooltip!.close();
      return;
    }

    tooltip = SuperTooltip(
      backgroundColor: DColors.fadbe2Color,
      popupDirection: TooltipDirection.down,
      shadowColor: DColors.a000000Color,
      minimumOutSidePadding: 30,
      arrowTipDistance: 10.0,
      arrowLength: 10.0,
      shadowBlurRadius: 15,
      borderColor: DColors.fadbe2Color,
      hasShadow: false,
      content: new Material(
          color: DColors.fadbe2Color,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            child: Text(
              Strings.change_information.localize(context),
              style: textTheme(context).text13.ff261744Color,
              softWrap: true,
            ),
          )),
    );

    tooltip!.show(context);
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _willPopCallback,
      child: new GestureDetector(
        onTap: onTap,
        child: Container(
          width: 28,
          height: 28,
          child: Image.asset(
            DImages.informationWarning,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
