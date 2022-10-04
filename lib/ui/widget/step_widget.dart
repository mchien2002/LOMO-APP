import 'package:flutter/material.dart';
import 'package:lomo/res/theme/theme_manager.dart';

class StepWidget extends StatelessWidget {
  final double? totalStep;
  final double? currentStep;
  final bool isShowButton;
  final double width;
  final double height;

  const StepWidget(
      {Key? key,
      this.totalStep,
      this.currentStep,
      this.isShowButton = true,
      this.width = 100,
      this.height = 8})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  4,
                ),
                color: getColor().colorGrayEAF2),
          ),
          Container(
            height: height,
            width: width * currentStep! / totalStep!,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  4,
                ),
                color: getColor().colorPrimary),
          )
        ],
      ),
    );
  }
}
