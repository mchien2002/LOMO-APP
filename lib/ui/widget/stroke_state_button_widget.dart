import 'package:flutter/material.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:provider/provider.dart';

class StrokeStateButton extends StatefulWidget {
  final ValueNotifier<bool> enable;
  final String? text;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final Color? borderColor;
  final Color? disableBorderColor;
  final TextStyle? textStyle;
  final TextStyle? disableTextStyle;
  final VoidCallback? onPressed;
  final double? radius;

  StrokeStateButton(
      {required this.enable,
      this.text,
      this.textStyle,
      this.disableTextStyle,
      this.width,
      this.height = Dimens.buttonHeight,
      this.padding,
      this.borderColor,
      this.disableBorderColor,
      this.onPressed,
      this.radius = Dimens.cornerRadius});

  @override
  State<StatefulWidget> createState() => _StrokeStateButtonState();
}

class _StrokeStateButtonState extends State<StrokeStateButton> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableProvider.value(
        value: widget.enable,
        child: Consumer<bool>(
          builder: (context, enable, child) => FlatButton(
            padding: widget.padding,
            splashColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.radius!),
              side: BorderSide(
                  color: enable
                      ? widget.borderColor ?? getColor().colorDart
                      : widget.disableBorderColor ?? getColor().colorGray),
            ),
            onPressed: enable ? widget.onPressed ?? () {} : () {},
            child: Text(
              widget.text ?? "",
              style: enable
                  ? widget.textStyle ?? textTheme(context).subText.colorDart
                  : widget.disableTextStyle ??
                      textTheme(context).subText.colorGray,
            ),
          ),
        ));
  }
}

class ChangePhoneText extends StatefulWidget {
  final ValueNotifier<bool> enable;
  final String? text;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final TextStyle? disableTextStyle;
  final VoidCallback? onPressed;
  final EdgeInsets? padding;

  ChangePhoneText(
      {required this.enable,
      this.text,
      this.textStyle,
      this.disableTextStyle,
      this.width,
      this.height = Dimens.buttonHeight,
      this.onPressed,
      this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 6)});

  @override
  State<StatefulWidget> createState() => _ChangePhoneTextState();
}

class _ChangePhoneTextState extends State<ChangePhoneText> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableProvider.value(
        value: widget.enable,
        child: Consumer<bool>(
          builder: (context, enable, child) => InkWell(
            onTap: enable ? widget.onPressed ?? () {} : null,
            child: Container(
              padding: widget.padding,
              alignment: Alignment.center,
              child: Text(
                widget.text ?? "",
                style: enable
                    ? widget.textStyle ?? textTheme(context).subText.colorDart
                    : widget.disableTextStyle ??
                        textTheme(context).subText.colorGray,
              ),
            ),
          ),
        ));
  }
}
