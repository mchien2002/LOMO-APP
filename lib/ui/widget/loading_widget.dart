import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lomo/libraries/nuts_activity_indicator/nuts_activity_indicator.dart';
import 'package:lomo/res/colors.dart';

class LoadingWidget extends StatefulWidget {
  final double radius;
  final Color activeColor;
  final Color inactiveColor;

  const LoadingWidget(
      {Key? key,
      this.radius = 24,
      this.activeColor = DColors.primaryColor,
      this.inactiveColor = DColors.pink6597})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {
  @override
  Widget build(BuildContext context) {
    return NutsActivityIndicator(
      activeColor: widget.activeColor,
      inactiveColor: widget.inactiveColor,
      tickCount: 24,
      relativeWidth: 0.4,
      radius: widget.radius,
      startRatio: 0.6,
      animationDuration: Duration(milliseconds: 500),
    );
  }
}
