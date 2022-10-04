import 'package:flutter/material.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/widget/button_widgets.dart';

class BottomShadowButtonWidget extends StatelessWidget {
  final Widget child;
  final EdgeInsets? contentPadding;
  BottomShadowButtonWidget({required this.child, this.contentPadding});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: getColor().white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0c000000),
            offset: Offset(0, -5),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: contentPadding ??
              const EdgeInsets.only(bottom: 20, top: 10, left: 30, right: 30),
          child: child,
        ),
      ),
    );
  }
}

class BottomOneButton extends StatelessWidget {
  final String? text;
  final Function()? onPressed;
  final EdgeInsets? contentPadding;
  final ValueNotifier<bool>? enable;
  BottomOneButton(
      {this.text, this.onPressed, this.contentPadding, this.enable});
  @override
  Widget build(BuildContext context) {
    return BottomShadowButtonWidget(
      contentPadding: contentPadding,
      child: PrimaryButton(
        text: text,
        onPressed: onPressed,
        radius: Dimens.cornerRadius6,
        enable: enable,
      ),
    );
  }
}

class BottomTwoButton extends StatelessWidget {
  final String? textCancel;
  final String? textConfirm;
  final Function()? onConfirmed;
  final Function()? onCanceled;
  final EdgeInsets? contentPadding;
  BottomTwoButton(
      {this.textCancel,
      this.textConfirm,
      this.onCanceled,
      this.onConfirmed,
      this.contentPadding});
  @override
  Widget build(BuildContext context) {
    return BottomShadowButtonWidget(
      child: Row(
        children: [
          Expanded(
            child: BorderButton(
              text: Strings.edit.localize(context),
              radius: Dimens.cornerRadius6,
              color: getColor().white,
              borderColor: getColor().colorPrimary,
              textStyle: textTheme(context).text17.bold.colorPrimary,
              onPressed: onCanceled,
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: PrimaryButton(
              text: Strings.next.localize(context),
              radius: Dimens.cornerRadius6,
              textStyle: textTheme(context).text17.bold.colorWhite,
              onPressed: onConfirmed,
            ),
          ),
        ],
      ),
    );
  }
}
