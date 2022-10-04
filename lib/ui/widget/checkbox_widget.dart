import 'package:flutter/material.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/theme/theme_manager.dart';

class CheckBoxWidget extends StatefulWidget {
  final height;
  final width;
  final Widget? checkedIcon; // use svg resource
  final Widget? unCheckedIcon; // use svg resource
  final Function(bool)? onCheckChanged;
  bool? initValue;
  final bool? isDisable;

  CheckBoxWidget(
      {this.onCheckChanged,
      this.height = 24.0,
      this.width = 24.0,
      this.checkedIcon,
      this.unCheckedIcon,
      this.initValue = false,
      this.isDisable = false});

  @override
  State<StatefulWidget> createState() => _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends State<CheckBoxWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () async {
        if (!widget.isDisable!)
          setState(() {
            widget.initValue = !widget.initValue!;
            if (widget.onCheckChanged != null)
              widget.onCheckChanged!(widget.initValue!);
          });
      },
      child: widget.initValue!
          ? widget.checkedIcon ??
              Container(
                height: widget.height,
                width: widget.height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  border: Border.all(width: 1, color: getColor().black4B),
                ),
                child: Image.asset(
                  DImages.check,
                  width: widget.width,
                  height: widget.height,
                  color: getColor().colorPrimary,
                ),
              )
          : widget.unCheckedIcon ??
              Container(
                height: widget.height,
                width: widget.height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  border: Border.all(width: 1, color: getColor().black4B),
                ),
              ),
    );
  }
}
