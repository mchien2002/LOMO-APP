import 'package:flutter/cupertino.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/theme/text_theme.dart';

import 'bottom_sheet_widgets.dart';

class BottomSheetPickerWidget extends StatefulWidget {
  final String? titleDropdown;
  final String? titleContentPopUp;
  final DateTime? initialDateTime;
  final DateTime minDate;
  final DateTime maxDate;
  final ValueChanged<DateTime>? onDateSelected;

  BottomSheetPickerWidget(
      {this.titleContentPopUp,
      this.titleDropdown,
      this.initialDateTime,
      required this.minDate,
      required this.maxDate,
      this.onDateSelected});

  @override
  State<StatefulWidget> createState() => _BottomSheetPickerWidgetState();
}

class _BottomSheetPickerWidgetState extends State<BottomSheetPickerWidget> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDateTime ?? DateTime(1990, 01, 01);
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetPickerModel(
      height: 300,
      onDone: () {
        if (widget.onDateSelected != null) widget.onDateSelected!(selectedDate);
        // formatDate(selectedDate);
      },
      isFull: false,
      contentWidget: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimens.paddingBodyContent),
        child: CupertinoTheme(
          data: CupertinoThemeData(
            textTheme: CupertinoTextThemeData(
              dateTimePickerTextStyle:
                  textTheme(context).text14.colorPrimary.bold,
            ),
          ),
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
      title: widget.titleContentPopUp ?? "",
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
