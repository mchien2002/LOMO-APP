
import 'package:flutter/material.dart';
import 'package:lomo/res/colors.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/widget/button_widgets.dart';

class DialogNewWidget extends StatelessWidget {
  final String? title;
  final dynamic description;
  final String? image;

  DialogNewWidget({this.title, this.description = "", this.image});

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            Container(
              padding: EdgeInsets.only(
                // top: Dimens.avatarRadius,
                bottom: Dimens.padding + 10,
                left: Dimens.padding,
                right: Dimens.padding,
              ),
              margin: EdgeInsets.only(top: Dimens.avatarRadius),
              decoration: new BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(Dimens.padding),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    height: 150,
                    child: image != null
                        ? Image.asset(image!)
                        : Image.asset(
                            "assets/images/img_logo_gift.png",
                            fit: BoxFit.cover,
                          ),
                  ),
                  if (title != null)
                    Center(
                        child: Text(
                      title!,
                      textAlign: TextAlign.center,
                      style: textTheme(context).text20.bold.colorViolet,
                    )),
                  if (title != null)
                    SizedBox(
                      height: 16.0,
                    ),
                  description is Widget
                      ? description
                      : Text(
                          description,
                          textAlign: TextAlign.center,
                          style: textTheme(context).text16.colorBlack4B,
                        ),
                  SizedBox(
                    height: 24.0,
                  ),
                  buildBottomButton(context),
                ],
              ),
            ),
            Positioned(
              top: 70,
              right: 12,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 32,
                  height: 32,
                  child: image != null
                      ? Image.asset(image!)
                      : Image.asset(
                          "assets/images/img_dialog_close.png",
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget buildBottomButton(BuildContext context) {
    return Container();
  }
}

class DialogImageOneButtonWidget extends StatelessWidget {
  final String? imagePath;
  final double? width;
  final double? height;
  final VoidCallback? onPressed;
  final VoidCallback? onCancel;

  DialogImageOneButtonWidget(
      {this.imagePath, this.width, this.height, this.onPressed, this.onCancel});

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
      width: width,
      height: height,
      child: Stack(
        children: [
          Container(
            decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(Dimens.padding),
            ),
            child: InkWell(
              child: Image.asset(
                imagePath ?? "",
                fit: BoxFit.cover,
                width: width,
                height: height,
              ),
              onTap: () {
                if (onPressed != null) {
                  onPressed!();
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
                  if (onCancel != null) {
                    onCancel!();
                  }
                }),
          )
        ],
      ),
    );
  }

  Widget buildBottomButton(BuildContext context) {
    return Container();
  }
}

class TwoButtonDialogNewWidget extends DialogNewWidget {
  final String? title;
  final dynamic description;
  final String? textConfirm;
  final Function? onConfirmed;
  final String? textCancel;
  final Function? onCanceled;

  TwoButtonDialogNewWidget(
      {this.title,
      this.description,
      this.textConfirm,
      this.onConfirmed,
      this.textCancel,
      this.onCanceled})
      : super(title: title, description: description);

  @override
  Widget buildBottomButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: RoundedButton(
            text: textCancel ?? Strings.cancel.localize(context),
            radius: Dimens.cornerRadius,
            height: 36,
            width: 125,
            color: getColor().backgroundCancel,
            textStyle: textTheme(context).text16Bold.colorBlack4B,
            onPressed: () {
              Navigator.pop(context);
              if (onCanceled != null) onCanceled!();
            },
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Expanded(
          child: RoundedButton(
            color: DColors.violetColor,
            text: textConfirm ?? Strings.confirm.localize(context),
            radius: Dimens.cornerRadius,
            textStyle: textTheme(context).text16Bold.colorWhite,
            height: 36,
            width: 125,
            onPressed: () {
              Navigator.pop(context);
              if (onConfirmed != null) onConfirmed!();
            },
          ),
        ),
      ],
    );
  }
}
