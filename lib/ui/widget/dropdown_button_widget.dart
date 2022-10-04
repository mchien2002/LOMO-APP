import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/icons.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';

import 'bottom_sheet_widgets.dart';
import 'text_form_field_widget.dart';
import 'wheel_list_picker_widget.dart';

class DropDownButtonWidget extends StatefulWidget {
  final String? leftTitle;
  final String? rightTitle;
  final String? hint;
  final String? initValue;
  final Widget content;
  final Widget? suffixIcon;
  final bool isFullScreenPopUp;
  final TextEditingController? controller;
  DropDownButtonWidget(
      {required this.content,
      this.leftTitle,
      this.rightTitle,
      this.hint,
      this.initValue,
      this.suffixIcon,
      this.isFullScreenPopUp = false,
      this.controller});
  @override
  State<StatefulWidget> createState() => _DropDownButtonWidgetState();
}

class _DropDownButtonWidgetState extends State<DropDownButtonWidget> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? TextEditingController();
    controller.text = widget.initValue ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: DTextFromField(
        strokeColor: getColor().underlineClearTextField,
        leftTitle: widget.leftTitle,
        rightTitle: widget.rightTitle,
        controller: controller,
        enabled: false,
        hintText: widget.hint,
        suffixIcon: widget.suffixIcon ??
            SvgPicture.asset(
              DIcons.expand,
              height: 24,
              width: 24,
              color: getColor().grayBorder,
            ),
        textStyle: textTheme(context).text19.light.colorDart,
      ),
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (_) => widget.content,
            backgroundColor: Colors.transparent,
            isScrollControlled: widget.isFullScreenPopUp);
      },
    );
  }

  @override
  void dispose() {
    widget.controller?.dispose();
    super.dispose();
  }
}

class DropDownListWidget extends StatefulWidget {
  final List<String> items;
  final Function(int)? onSelected;
  final String? initValue;
  final String? titleDropdown;
  final String? titleContentPopUp;
  DropDownListWidget(
      {required this.items,
      this.initValue,
      this.onSelected,
      this.titleContentPopUp,
      this.titleDropdown});
  @override
  State<StatefulWidget> createState() => _DropDownListWidgetState();
}

class _DropDownListWidgetState extends State<DropDownListWidget> {
  TextEditingController _controller = TextEditingController();
  late int selectedIndex; // 160 cm

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initValue != null
        ? widget.items.indexOf(widget.initValue!)
        : widget.items.length ~/ 2;
  }

  @override
  Widget build(BuildContext context) {
    return DropDownButtonWidget(
      leftTitle: widget.titleDropdown ?? "",
      hint: Strings.notChoose.localize(context),
      controller: _controller,
      initValue: widget.initValue,
      content: BottomSheetPickerModel(
        height: 300,
        onDone: () {
          if (widget.onSelected != null) widget.onSelected!(selectedIndex);
          _controller.text = widget.items[selectedIndex];
        },
        isFull: false,
        contentWidget: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimens.paddingBodyContent),
          child: WheelListPickerWidget(
            initItemIndex: selectedIndex,
            items: widget.items,
            onSelectedItemChanged: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
        ),
        title: widget.titleContentPopUp,
      ),
      isFullScreenPopUp: false,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
