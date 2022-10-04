import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/icons.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';

class DTextFromField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? onValidated; // handle error here
  final Function(String?)? onSaved;
  final TextStyle? textStyle;
  final TextStyle? errorStyle;
  final String? hintText;
  final Color? strokeColor;
  final Widget? prefixIcon;
  final double? prefixPadding;
  final Widget? suffixIcon;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final String? leftTitle;
  final String? rightTitle;
  final String? errorText;
  final BoxConstraints? prefixConstraints;
  final BoxConstraints? iconContraints;
  final bool autoFocus;
  final EdgeInsetsGeometry? contentPadding;
  final TextInputAction? textInputAction;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChangedHandler;

  DTextFromField(
      {this.controller,
      this.errorStyle,
      this.onValidated,
      this.onSaved,
      this.hintText,
      this.textStyle,
      this.strokeColor,
      this.obscureText,
      this.prefixIcon,
      this.keyboardType,
      this.suffixIcon,
      this.inputFormatters,
      this.maxLines = 1,
      this.maxLength,
      this.enabled = true,
      this.leftTitle,
      this.rightTitle,
      this.errorText,
      this.autoFocus = false,
      this.textInputAction,
      this.onFieldSubmitted,
      this.prefixPadding,
      this.prefixConstraints =
          const BoxConstraints(maxHeight: 36, minHeight: 36),
      this.iconContraints =
          const BoxConstraints(maxWidth: 24, maxHeight: 24, minHeight: 24),
      this.contentPadding = const EdgeInsets.symmetric(
          vertical: Dimens.spacing7, horizontal: 0.0),
      this.onChangedHandler});

  UnderlineInputBorder _underlineInputBorder(
      Color? strokeColor, BuildContext context) {
    return UnderlineInputBorder(
        borderSide:
            BorderSide(color: strokeColor ?? getColor().bottomLineTextField));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (leftTitle != null || rightTitle != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                leftTitle ?? "",
                style: textTheme(context).text13.bold.colorDart,
              ),
              Text(
                rightTitle ?? "",
                style: textTheme(context).caption?.colorDart,
              )
            ],
          ),
        TextFormField(
          enableInteractiveSelection: true,
          maxLength: maxLength,
          enabled: enabled,
          autofocus: autoFocus,
          obscureText: obscureText ?? false,
          maxLines: maxLines,
          controller: controller,
          keyboardType: keyboardType ?? TextInputType.text,
          validator: onValidated,
          onSaved: onSaved,
          textAlignVertical: TextAlignVertical.center,
          style: textStyle ?? textTheme(context).text18.colorDart,
          inputFormatters: inputFormatters,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
          onChanged: onChangedHandler,
          decoration: InputDecoration(
            errorText: errorText,
            hintText: hintText ?? "",
            hintStyle: textStyle?.copyWith(color: getColor().textHint) ??
                textTheme(context).text19.light.b6b6cbColor,
            prefixIconConstraints: prefixConstraints,
            prefixIcon: prefixIcon != null
                ? Padding(
                    child: prefixIcon,
                    padding: EdgeInsets.only(
                        left: prefixPadding != null
                            ? prefixPadding!
                            : Dimens.padding,
                        right: prefixPadding != null
                            ? prefixPadding!
                            : Dimens.padding),
                  )
                : null,
            suffixIconConstraints: iconContraints,
            suffixIcon: suffixIcon,
            isDense: true,
            errorStyle: errorStyle ?? textTheme(context).small.colorError,
            contentPadding: contentPadding,
            enabledBorder: _underlineInputBorder(strokeColor, context),
            focusedBorder: _underlineInputBorder(strokeColor, context),
            border: _underlineInputBorder(strokeColor, context),
            disabledBorder: _underlineInputBorder(strokeColor, context),
            focusedErrorBorder:
                _underlineInputBorder(getColor().colorError, context),
            errorBorder: _underlineInputBorder(getColor().colorError, context),
          ),
        )
      ],
    );
  }
}

class ClearTextField extends StatefulWidget {
  final TextInputType? keyboardType;
  final String? leftTitle;
  final String? rightTitle;
  final Widget? prefixIcon;
  final String? hint;
  final TextStyle? textStyle;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final Color? underlineColor;
  final int? maxLength;
  final String? Function(String?)? onValidated;
  final String? errorText;
  final TextStyle? errorStyle;
  final Function(String)? onChangedHandler;

  ClearTextField(
      {this.hint,
      this.inputFormatters,
      this.maxLength,
      this.controller,
      this.prefixIcon,
      this.leftTitle,
      this.rightTitle,
      this.textStyle,
      this.keyboardType,
      this.underlineColor,
      this.onValidated,
      this.errorText,
      this.errorStyle,
      this.onChangedHandler});

  @override
  State<StatefulWidget> createState() => _ClearTextFieldState();
}

class _ClearTextFieldState extends State<ClearTextField> {
  TextEditingController? controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? TextEditingController();
    controller?.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return DTextFromField(
      inputFormatters: widget.inputFormatters,
      keyboardType: widget.keyboardType,
      textStyle: widget.textStyle,
      strokeColor: widget.underlineColor ?? getColor().underlineClearTextField,
      controller: controller,
      hintText: widget.hint,
      maxLength: widget.maxLength,
      prefixIcon: widget.prefixIcon,
      leftTitle: widget.leftTitle,
      rightTitle: widget.rightTitle,
      onValidated: widget.onValidated,
      errorText: widget.errorText,
      errorStyle: widget.errorStyle,
      onChangedHandler: widget.onChangedHandler,
      iconContraints:
          const BoxConstraints(maxWidth: 30, maxHeight: 30, minHeight: 30),
      suffixIcon: controller?.text != ""
          ? MaterialButton(
              height: 24,
              minWidth: 24,
              padding: EdgeInsets.all(0),
              onPressed: () => controller?.clear(),
              child: SvgPicture.asset(
                DIcons.clearText,
                color: getColor().bottomLineTextField,
              ),
              shape: CircleBorder(),
            )
          : null,
    );
  }
}

class LowerCaseTxt extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(text: newValue.text.toLowerCase());
  }
}
