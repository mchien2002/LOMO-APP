import 'package:flutter/material.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/theme/theme_manager.dart';

class StepAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double? totalStep;
  final double? currentStep;
  final bool isShowButton;
  final double width;
  final double height;

  const StepAppBar(
      {Key? key,
      this.totalStep,
      this.currentStep,
      this.isShowButton = true,
      this.width = 100,
      this.height = 8})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: Theme(
        data: ThemeData(splashColor: Colors.transparent),
        child: Container(
          margin: EdgeInsets.only(top: Dimens.size40),
          child: Stack(
            children: [
              isShowButton
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 16),
                          width: Dimens.size32,
                          height: Dimens.size32,
                          child: Image.asset(
                            DImages.backBlack,
                          ),
                        ),
                      ),
                    )
                  : Container(),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(60);
}
