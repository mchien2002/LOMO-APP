import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TextHeaderButton extends StatefulWidget {
  final Color? color;
  final String? text;
  final VoidCallback? onPressed;
  final EdgeInsets? padding;
  final TextStyle? textStyle;
  final TextStyle? textStyleDisable;
  final ValueNotifier<bool>? enable;

  TextHeaderButton(
      {this.color,
      this.text,
      this.onPressed,
      this.textStyle,
      this.textStyleDisable,
      this.padding,
      this.enable});

  @override
  State<StatefulWidget> createState() => TextHeaderButtonState();
}

class TextHeaderButtonState extends State<TextHeaderButton> {
  late ValueNotifier<bool> enable;

  @override
  void initState() {
    super.initState();
    enable = widget.enable ?? ValueNotifier(true);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableProvider.value(
      value: enable,
      child: Consumer<bool>(
        builder: (context, enable, child) => FlatButton(
          padding: widget.padding,
          splashColor: Colors.transparent,
          onPressed: enable ? widget.onPressed ?? () {} : () {},
          color: widget.color,
          child: Text(widget.text ?? "",
              style: enable ? widget.textStyle : widget.textStyleDisable),
        ),
      ),
    );
  }
}
