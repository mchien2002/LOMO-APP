import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lomo/res/icons.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/util/date_time_utils.dart';

import 'bottom_sheet_widgets.dart';
import 'dropdown_button_widget.dart';

class DropdownDatePickerWidget extends StatefulWidget {
  final String? titleDropdown;
  final String? titleContentPopUp;
  final DateTime? initialDateTime;
  final DateTime minDate;
  final DateTime maxDate;
  final ValueChanged<DateTime>? onDateSelected;

  DropdownDatePickerWidget(
      {this.titleContentPopUp,
      this.titleDropdown,
      this.initialDateTime,
      required this.minDate,
      required this.maxDate,
      this.onDateSelected});

  @override
  State<StatefulWidget> createState() => _DropdownDatePickerWidgetState();
}

class _DropdownDatePickerWidgetState extends State<DropdownDatePickerWidget> {
  TextEditingController _controller = TextEditingController();
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDateTime ?? DateTime(1990, 01, 01);
  }

  @override
  Widget build(BuildContext context) {
    return DropDownButtonWidget(
      leftTitle: widget.titleDropdown ?? "",
      hint: Strings.notChoose.localize(context),
      controller: _controller,
      initValue: widget.initialDateTime != null
          ? formatDate(widget.initialDateTime)
          : "",
      content: BottomSheetPickerModel(
        height: 300,
        onDone: () {
          if (widget.onDateSelected != null)
            widget.onDateSelected!(selectedDate);
          _controller.text = formatDate(selectedDate) ?? "";
        },
        isFull: false,
        contentWidget: Container(
          height: 200,
          color: Colors.white,
          child: CupertinoTheme(
            data: CupertinoThemeData(
                textTheme: CupertinoTextThemeData(
                    dateTimePickerTextStyle:
                        textTheme(context).text14.colorPrimary.bold)),
            child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (date) {
                  setState(() {
                    selectedDate = date;
                  });
                },
                initialDateTime: selectedDate,
                minimumDate: widget.minDate,
                maximumDate: widget.maxDate),
          ),
        ),
        title: widget.titleContentPopUp,
      ),
      suffixIcon: SvgPicture.asset(
        DIcons.calendar,
        height: 24,
        width: 24,
        color: getColor().grayBorder,
      ),
      isFullScreenPopUp: false,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
