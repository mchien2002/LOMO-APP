import 'package:flutter/material.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/widget/image_widget.dart';

import 'check_box_vqmm_widget.dart';

class DialogImageOneAndCheckDisplayWidget extends StatefulWidget {
  const DialogImageOneAndCheckDisplayWidget(
      {required this.imagePath,
      required this.width,
      required this.height,
      this.onPressed,
      this.onCancel,
      required this.selectedCheckBox});

  final String? imagePath;
  final double width;
  final double height;
  final Function? onPressed;
  final Function(bool)? onCancel;
  final Function(bool) selectedCheckBox;

  @override
  _DialogImageOneAndCheckDisplayWidgetState createState() =>
      _DialogImageOneAndCheckDisplayWidgetState();
}

class _DialogImageOneAndCheckDisplayWidgetState
    extends State<DialogImageOneAndCheckDisplayWidget> {
  bool initValue = false;

  @override
  void initState() {
    super.initState();
    initValue = false;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.transparent,
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  child: RoundNetworkImage(
                    url: widget.imagePath ?? "",
                    width: widget.width,
                    height: widget.height - 50,
                    boxFit: BoxFit.cover,
                    radius: 12,
                  ),
                  onTap: () {
                    if (widget.onPressed != null) {
                      widget.onPressed!();
                    }
                  },
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: InkWell(
                    child: Image.asset(
                      DImages.closeCircle,
                      height: 25,
                      width: 25,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      if (widget.onCancel != null) {
                        widget.onCancel!(initValue);
                      }
                    }),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          CheckBoxVQMMWidget(
            value: initValue,
            activeColor: getColor().white,
            inactiveColor: getColor().white,
            activeIcon: Image.asset(
              DImages.checkRightQuiz,
              width: Dimens.size25,
              height: Dimens.size25,
              color: getColor().colorPrimary,
            ),
            onToggle: (val) {
              setState(() {
                initValue = val;
                print("Check Box -- $val");
              });
            },
          ),
        ],
      ),
    );
  }

  Widget buildBottomButton(BuildContext context) {
    return Container();
  }
}
