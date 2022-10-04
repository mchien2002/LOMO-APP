import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';

class BottomSheetModal extends StatefulWidget {
  final String? title;
  final Widget? subTitle;
  final Widget? left;
  final Widget? right;
  final Color? appbarColor;
  final bool isFull;
  final Widget contentWidget;
  final double? height;
  final bool isRadius;
  final TextStyle? titleStyle;
  final double appbarHeight;

  const BottomSheetModal(
      {required this.isFull,
      required this.contentWidget,
      this.title,
      this.subTitle,
      this.left,
      this.right,
      this.height,
      this.appbarColor,
      this.titleStyle,
      this.isRadius = false,
      this.appbarHeight = 54});

  @override
  _BottomSheetModalState createState() => _BottomSheetModalState();
}

class _BottomSheetModalState extends State<BottomSheetModal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: widget.isFull ? 100 : 30),
      height: widget.isFull
          ? (MediaQuery.of(context).size.height - 100)
          : widget.height ?? 280,
      decoration: BoxDecoration(
        borderRadius: widget.isRadius
            ? BorderRadius.vertical(top: Radius.circular(15))
            : null,
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: widget.isRadius
                  ? BorderRadius.vertical(top: Radius.circular(15))
                  : null,
              color: widget.appbarColor ?? getColor().colorPrimary,
            ),
            alignment: Alignment.center,
            height: widget.appbarHeight,
            padding: EdgeInsets.only(
                left: Dimens.spacing16, right: Dimens.spacing16),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                if (widget.left != null)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: widget.left,
                  ),
                if (widget.title != null)
                  Center(
                    child: Text(widget.title!,
                        style: widget.titleStyle ??
                            textTheme(context).text18.bold.colorWhite),
                  ),
                if (widget.subTitle != null)
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: widget.subTitle),
                if (widget.right != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: widget.right,
                  ),
              ],
            ),
          ),
          Expanded(
            child: widget.contentWidget,
          ),
        ],
      ),
    );
  }
}

class BottomSheetPickerModel extends StatelessWidget {
  final bool isFull;
  final Widget contentWidget;
  final double? height;
  final String? title;
  final Function? onDone;
  final bool isHideRightWidget;

  BottomSheetPickerModel(
      {this.title,
      required this.contentWidget,
      this.height,
      this.isFull = false,
      this.onDone,
      this.isHideRightWidget = false});

  @override
  Widget build(BuildContext context) {
    return BottomSheetModal(
      title: title,
      isFull: isFull,
      left: _leftWidget(context),
      right: isHideRightWidget ? Container() : _rightWidget(context),
      contentWidget: contentWidget,
      height: height,
    );
  }

  Widget _rightWidget(BuildContext context) {
    return InkWell(
      child: Text(
        Strings.choose.localize(context),
        style: textTheme(context).text14Bold.colorWhite,
      ),
      onTap: () {
        if (onDone != null) onDone!();
        Navigator.of(context).pop();
      },
    );
  }

  Widget _leftWidget(BuildContext context) {
    return InkWell(
      child: Icon(
        Icons.close,
        size: 25,
        color: getColor().white,
      ),
      onTap: () {
        Navigator.of(context).pop();
      },
    );
  }
}

class DatePickerSheet extends StatefulWidget {
  final String title;
  final Widget? left;
  final Widget? right;
  final DateTime? initialDateTime;
  final DateTime? minDate;
  final DateTime? maxDate;
  final ValueChanged<DateTime>? onDateSelected;

  DatePickerSheet(
      {this.title = "",
      this.left,
      this.right,
      this.initialDateTime,
      this.minDate,
      this.maxDate,
      this.onDateSelected});

  @override
  _DatePickerSheetState createState() => _DatePickerSheetState();
}

class _DatePickerSheetState extends State<DatePickerSheet> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDateTime ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetModal(
      isFull: false,
      title: widget.title,
      left: _leftWidget(),
      right: _rightWidget(),
      contentWidget: _content(),
    );
  }

  _content() {
    return Container(
      color: Colors.white,
      child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          onDateTimeChanged: (date) {
            selectedDate = date;
          },
          initialDateTime: widget.initialDateTime,
          minimumDate: widget.minDate,
          maximumDate: widget.maxDate),
    );
  }

  _leftWidget() {
    return InkWell(
      child: widget.left ?? Container(),
      onTap: () {
        Navigator.of(context).pop();
      },
    );
  }

  _rightWidget() {
    return InkWell(
      child: widget.right ?? Container(),
      onTap: () {
        if (widget.onDateSelected != null) widget.onDateSelected!(selectedDate);
        Navigator.of(context).pop();
      },
    );
  }
}

class BottomSheetMenuWidget extends StatelessWidget {
  final Widget child;
  final List<String> items;
  final Function(int index) onItemClicked;

  BottomSheetMenuWidget(
      {required this.child, required this.items, required this.onItemClicked});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: child,
      onTap: () {
        showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (context) => Container(
                  decoration: BoxDecoration(
                    color: getColor().white,
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(Dimens.cornerRadius20)),
                  ),
                  child: SafeArea(
                    child: SizedBox(
                      height: items.length < 7 ? items.length * 50.0 : 350.0,
                      child: ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) => InkWell(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      height: 50,
                                      child: Text(
                                        items[index].localize(context),
                                        style: textTheme(context)
                                            .subText
                                            .colorDart,
                                      ),
                                    ),
                                    if (index != items.length - 1)
                                      Divider(
                                        height: 1,
                                        color: getColor().colorDivider,
                                      )
                                  ],
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  onItemClicked(index);
                                },
                              )),
                    ),
                  ),
                ));
      },
    );
  }
}
