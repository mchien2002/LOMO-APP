import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lomo/res/colors.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:provider/provider.dart';

class RoundedButton extends StatefulWidget {
  final Color? color;
  final double? width;
  final double? height;
  final Color? borderColor;
  final Color? disableColor;
  final String? text;
  final VoidCallback? onPressed;
  final double? radius;
  final EdgeInsets? padding;
  final TextStyle? textStyle;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final ValueNotifier<bool>? enable;

  RoundedButton(
      {this.color,
      this.disableColor,
      this.width,
      this.height = Dimens.buttonHeight,
      this.borderColor,
      this.text,
      this.onPressed,
      this.textStyle,
      this.radius,
      this.padding,
      this.suffixIcon,
      this.prefixIcon,
      this.enable});

  @override
  State<StatefulWidget> createState() => RoundedButtonState();
}

class RoundedButtonState extends State<RoundedButton> {
  late ValueNotifier<bool> enable;
  bool enablePress = true;

  @override
  void initState() {
    super.initState();
    enable = widget.enable ?? ValueNotifier(true);
  }

  @override
  void dispose() {
    //enable?.dispose();
    super.dispose();
  }

  disableFastClick() async {
    enablePress = false;
    await Future.delayed(Duration(milliseconds: 500));
    enablePress = true;
  }

  @override
  Widget build(BuildContext context) {
    double _radius = widget.radius ?? widget.height! / 2;
    return ValueListenableProvider.value(
      value: enable,
      child: Consumer<bool>(
        builder: (context, enable, child) => Container(
          height: widget.height,
          width: widget.width ?? double.infinity,
          decoration: enable && widget.color == null
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(_radius),
                  gradient: LinearGradient(
                    colors: [
                      DColors.primaryGradientColor1,
                      DColors.primaryGradientColor2,
                    ],
                    begin: const Alignment(0.0, 1.0),
                    end: const Alignment(1.0, 0.0),
                  ))
              : null,
          child: FlatButton(
            padding: widget.padding,
            splashColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_radius),
                side: widget.borderColor != null
                    ? BorderSide(color: widget.borderColor!)
                    : BorderSide.none),
            onPressed: () {
              if (enablePress && enable && widget.onPressed != null) {
                widget.onPressed!();
                disableFastClick();
              } else {
                print(" kduocclicknha");
              }
            },
            color: enable
                ? widget.color
                : widget.disableColor ?? getColor().grayBorder,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.suffixIcon != null) widget.suffixIcon!,
                if (widget.text != null && widget.suffixIcon != null)
                  SizedBox(
                    width: 5,
                  ),
                Text(widget.text ?? "",
                    style: widget.textStyle ??
                        defaultTextStyle(context).bold.colorButtonSmall),
                if (widget.text != null && widget.prefixIcon != null)
                  SizedBox(
                    width: 5,
                  ),
                if (widget.prefixIcon != null) widget.prefixIcon!,
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextStyle defaultTextStyle(BuildContext context) =>
      textTheme(context).body.colorDart;
}

class BorderButton extends RoundedButton {
  BorderButton(
      {String? text,
      double? width,
      double? height,
      EdgeInsets? padding,
      Color? color,
      Color? borderColor,
      TextStyle? textStyle,
      VoidCallback? onPressed,
      double? radius,
      ValueNotifier<bool>? enable,
      Widget? suffixIcon,
      Widget? prefixIcon})
      : super(
            text: text,
            width: width,
            height: height ?? Dimens.buttonHeight,
            padding: padding,
            onPressed: onPressed,
            disableColor: Colors.transparent,
            borderColor: borderColor ?? getColor().colorPrimary,
            color: color ?? Colors.transparent,
            radius: radius ?? Dimens.cornerRadius,
            suffixIcon: suffixIcon,
            textStyle: textStyle,
            enable: enable,
            prefixIcon: prefixIcon);
}

class SmallBorderButton extends BorderButton {
  SmallBorderButton(
      {double? width,
      ValueNotifier<bool>? enable,
      String? text,
      double? height,
      Color? color,
      Color? borderColor,
      TextStyle? textStyle,
      VoidCallback? onPressed,
      double? radius,
      Widget? suffixIcon,
      Widget? prefixIcon})
      : super(
            width: width,
            text: text,
            height: height ?? Dimens.smallButtonHeight,
            color: color,
            onPressed: onPressed,
            radius: radius ?? Dimens.cornerRadius24,
            borderColor: borderColor,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            textStyle: textStyle,
            enable: enable);

  @override
  TextStyle defaultTextStyle(BuildContext context) =>
      textTheme(context).subText.copyWith(color: borderColor);
}

class PrimaryButton extends RoundedButton {
  PrimaryButton(
      {String? text,
      double? width,
      EdgeInsets? padding,
      double? radius,
      ValueNotifier<bool>? enable,
      bool textUpperCase = false,
      TextStyle? textStyle,
      VoidCallback? onPressed,
      Widget? suffixIcon,
      Widget? prefixIcon})
      : super(
            text: textUpperCase ? text?.toUpperCase() : text,
            width: width,
            height: Dimens.buttonHeight,
            padding: padding,
            onPressed: onPressed,
            textStyle: textStyle,
            color: getColor().colorPrimary,
            radius: Dimens.cornerPrimaryRadius,
            enable: enable,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon);

  @override
  TextStyle defaultTextStyle(BuildContext context) =>
      textTheme(context).text17.colorWhite.bold;
}

class SmallButton extends RoundedButton {
  SmallButton(
      {String? text,
      double? width,
      EdgeInsets? padding,
      double? height,
      double? radius,
      ValueNotifier<bool>? enable,
      bool textUpperCase = false,
      TextStyle? textStyle,
      VoidCallback? onPressed,
      Widget? suffixIcon,
      Widget? prefixIcon})
      : super(
            text: textUpperCase ? text?.toUpperCase() : text,
            width: width,
            height: height ?? Dimens.smallButtonHeight,
            padding: padding,
            onPressed: onPressed,
            textStyle: textStyle,
            color: getColor().colorPrimary,
            radius: radius ?? Dimens.cornerRadius24,
            enable: enable,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon);

  @override
  TextStyle defaultTextStyle(BuildContext context) =>
      textTheme(context).subText.colorDart;
}

class SmallPrimaryButton extends SmallButton {
  SmallPrimaryButton(
      {String? text,
      double? width,
      EdgeInsets? padding,
      VoidCallback? onPressed,
      double? radius})
      : super(
            text: text,
            width: width,
            padding: padding,
            onPressed: onPressed,
            radius: radius);
}

class SmallSecondaryButton extends SmallButton {
  SmallSecondaryButton(
      {String? text,
      double? width,
      EdgeInsets? padding,
      VoidCallback? onPressed})
      : super(
            text: text,
            width: width,
            padding: padding,
            onPressed: onPressed,
            radius: Dimens.cornerRadius);
}

class CircleButton extends StatelessWidget {
  final double? size;
  final Color? color;
  final Color? iconColor;
  final VoidCallback? onPressed;
  final Widget? suffixIcon;
  final String? prefixIconSvgResource;

  CircleButton(
      {this.size = Dimens.buttonHeight,
      this.color,
      this.iconColor,
      this.onPressed,
      this.suffixIcon,
      this.prefixIconSvgResource});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: color ?? DColors.primaryColor,
        child: InkWell(
          child: SizedBox(
              width: size,
              height: size,
              child: suffixIcon != null
                  ? suffixIcon
                  : prefixIconSvgResource != null
                      ? Padding(
                          child: SvgPicture.asset(
                            prefixIconSvgResource!,
                            color: iconColor,
                          ),
                          padding: EdgeInsets.all(size! * 0.2),
                        )
                      : null),
          onTap: onPressed,
        ),
      ),
    );
  }
}
