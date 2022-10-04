import 'package:flutter/material.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';

class CheckBoxVQMMWidget extends StatefulWidget {
  const CheckBoxVQMMWidget({
    Key? key,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
    required this.value,
    this.duration = const Duration(milliseconds: 200),
    this.activeToggleColor,
    this.inactiveToggleColor,
    this.width = 20,
    this.height = 20,
    this.toggleSize = 20.0,
    this.borderRadius = 3,
    this.disabled = false,
    this.padding = 1,
    this.activeIcon,
    this.inactiveIcon,
    required this.onToggle,
  }) : super(key: key);
  final bool value;
  final Color? activeToggleColor;
  final Color? inactiveToggleColor;
  final Color? activeColor;
  final Color? inactiveColor;
  final double width;
  final double toggleSize;
  final bool disabled;
  final double height;
  final double padding;
  final double borderRadius;
  final Widget? activeIcon;
  final Widget? inactiveIcon;
  final ValueChanged<bool> onToggle;
  final Duration duration;

  @override
  _CheckBoxVQMMWidgetState createState() => _CheckBoxVQMMWidgetState();
}

class _CheckBoxVQMMWidgetState extends State<CheckBoxVQMMWidget>
    with SingleTickerProviderStateMixin {
  late final Animation _toggleAnimation;
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      value: widget.value ? 1.0 : 0.0,
      duration: widget.duration,
    );
    _toggleAnimation = AlignmentTween(
      begin: Alignment.centerLeft,
      end: Alignment.centerLeft,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CheckBoxVQMMWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value == widget.value) return;

    if (widget.value)
      _animationController.forward();
    else
      _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    Color _toggleColor = Colors.white;
    Color _switchColor = Colors.white;

    if (widget.value) {
      _switchColor = widget.activeColor ?? getColor().colorPrimary;
    } else {
      _switchColor = widget.inactiveColor ?? Colors.grey;
    }
    return Row(
      children: [
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Container(
              width: widget.width,
              child: Align(
                  child: GestureDetector(
                onTap: () {
                  if (!widget.disabled) {
                    if (widget.value)
                      _animationController.forward();
                    else
                      _animationController.reverse();

                    widget.onToggle(!widget.value);
                  }
                },
                child: Opacity(
                  opacity: widget.disabled ? 0.6 : 1,
                  child: Container(
                    width: widget.width,
                    height: widget.height,
                    padding: EdgeInsets.all(widget.padding),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      color: _switchColor,
                    ),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          child: Align(
                            alignment: _toggleAnimation.value,
                            child: Container(
                              padding: EdgeInsets.all(1.0),
                              decoration: BoxDecoration(
                                color: _toggleColor,
                              ),
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Container(
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: AnimatedOpacity(
                                          opacity: widget.value ? 1.0 : 0.0,
                                          duration: widget.duration,
                                          child: widget.activeIcon,
                                        ),
                                      ),
                                      Center(
                                        child: AnimatedOpacity(
                                          opacity: !widget.value ? 1.0 : 0.0,
                                          duration: widget.duration,
                                          child: widget.inactiveIcon,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
            );
          },
        ),
        SizedBox(
          width: 8,
        ),
        Text(
          Strings.dontShowAgian.localize(context),
          style: textTheme(context).text12.medium.colorWhite,
        ),
      ],
    );
  }
}
