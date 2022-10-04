import 'package:flutter/material.dart';
import 'package:lomo/res/theme/theme_manager.dart';

class CustomSwitchPrivacyWidget extends StatefulWidget {
  const CustomSwitchPrivacyWidget({
    Key? key,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
    this.toggleColor = Colors.white,
    required this.value,
    this.duration = const Duration(milliseconds: 200),
    this.activeToggleColor,
    this.inactiveToggleColor,
    this.activeSwitchBorder,
    this.inactiveSwitchBorder,
    this.toggleBorder,
    this.switchBorder,
    this.activeToggleBorder,
    this.inactiveToggleBorder,
    this.width = 44.0,
    this.height = 24.0,
    this.toggleSize = 18.0,
    this.borderRadius = 12.0,
    this.disabled = false,
    this.padding = 2.0,
    this.activeIcon,
    this.inactiveIcon,
    required this.onToggle,
  }) : super(key: key);

  final bool value;
  final Color? activeToggleColor;
  final Color? inactiveToggleColor;
  final Color? activeColor;
  final Color? inactiveColor;
  final BoxBorder? activeSwitchBorder;
  final BoxBorder? inactiveSwitchBorder;
  final BoxBorder? toggleBorder;
  final Color toggleColor;
  final BoxBorder? switchBorder;
  final BoxBorder? activeToggleBorder;
  final BoxBorder? inactiveToggleBorder;
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
  _CustomSwitchPrivacyWidgetState createState() =>
      _CustomSwitchPrivacyWidgetState();
}

class _CustomSwitchPrivacyWidgetState extends State<CustomSwitchPrivacyWidget>
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
      end: Alignment.centerRight,
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
  void didUpdateWidget(CustomSwitchPrivacyWidget oldWidget) {
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
    Border? _switchBorder;
    Border? _toggleBorder;

    if (widget.value) {
      _toggleColor = widget.activeToggleColor ?? widget.toggleColor;
      _switchColor = widget.activeColor ?? getColor().colorPrimary;
      _switchBorder = widget.activeSwitchBorder as Border? ??
          widget.switchBorder as Border?;
      _toggleBorder = widget.activeToggleBorder as Border? ??
          widget.toggleBorder as Border?;
    } else {
      _toggleColor = widget.inactiveToggleColor ?? widget.toggleColor;
      _switchColor = widget.inactiveColor ?? Colors.grey;
      _switchBorder = widget.inactiveSwitchBorder as Border? ??
          widget.switchBorder as Border?;
      _toggleBorder = widget.inactiveToggleBorder as Border? ??
          widget.toggleBorder as Border?;
    }

    return AnimatedBuilder(
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
                  border: _switchBorder,
                ),
                child: Stack(
                  children: <Widget>[
                    Container(
                      child: Align(
                        alignment: _toggleAnimation.value,
                        child: Container(
                          width: widget.toggleSize,
                          height: widget.toggleSize,
                          padding: EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _toggleColor,
                            border: _toggleBorder,
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
    );
  }
}
