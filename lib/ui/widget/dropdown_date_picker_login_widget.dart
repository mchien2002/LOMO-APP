// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:lomo/res/dimens.dart';
// import 'package:lomo/res/icons.dart';
// import 'package:lomo/res/strings.dart';
// import 'package:lomo/res/theme/text_theme.dart';
// import 'package:lomo/res/theme/theme_manager.dart';
// import 'package:lomo/ui/widget/text_form_field_widget.dart';
// import 'package:lomo/util/date_time_utils.dart';
//
// import 'bottom_sheet_widgets.dart';
//
// class DropdownDatePickerLoginWidget extends StatefulWidget {
//   final String titleDropdown;
//   final String titleContentPopUp;
//   final DateTime initialDateTime;
//   final DateTime minDate;
//   final DateTime maxDate;
//   final ValueChanged<DateTime> onDateSelected;
//   DropdownDatePickerLoginWidget(
//       {this.titleContentPopUp,
//       this.titleDropdown,
//       this.initialDateTime,
//       @required this.minDate,
//       @required this.maxDate,
//       this.onDateSelected});
//   @override
//   State<StatefulWidget> createState() => _DropdownDatePickerLoginWidgetState();
// }
//
// class _DropdownDatePickerLoginWidgetState
//     extends State<DropdownDatePickerLoginWidget> {
//   TextEditingController _controller = TextEditingController();
//   DateTime selectedDate;
//
//   @override
//   void initState() {
//     super.initState();
//     selectedDate = widget.initialDateTime ?? DateTime(1990, 01, 01);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return DropDownButtonLoginWidget(
//       leftTitle: widget.titleDropdown ?? "",
//       hint: Strings.notChoose.localize(context),
//       rightTitle: Strings.required.localize(context),
//       controller: _controller,
//       initValue: widget.initialDateTime != null
//           ? formatDate(widget.initialDateTime)
//           : "",
//       content: BottomSheetPickerModel(
//         height: 300,
//         onDone: () {
//           if (widget.onDateSelected != null)
//             widget.onDateSelected(selectedDate);
//           _controller.text = formatDate(selectedDate);
//         },
//         isFull: false,
//         contentWidget: Padding(
//           padding: EdgeInsets.symmetric(horizontal: Dimens.paddingBodyContent),
//           child: CupertinoDatePicker(
//               mode: CupertinoDatePickerMode.date,
//               onDateTimeChanged: (date) {
//                 setState(() {
//                   selectedDate = date;
//                 });
//               },
//               initialDateTime: selectedDate,
//               minimumDate: widget.minDate,
//               maximumDate: widget.maxDate),
//         ),
//         title: widget.titleContentPopUp,
//       ),
//       suffixIcon: SvgPicture.asset(
//         DIcons.calendar,
//         height: 24,
//         width: 24,
//         color: getColor().colorPrimary,
//       ),
//       isFullScreenPopUp: false,
//     );
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
// }
//
// class DropDownButtonLoginWidget extends StatefulWidget {
//   final String leftTitle;
//   final String rightTitle;
//   final String hint;
//   final String initValue;
//   final Widget content;
//   final Widget suffixIcon;
//   final bool isFullScreenPopUp;
//   final TextEditingController controller;
//   DropDownButtonLoginWidget(
//       {@required this.content,
//       this.leftTitle,
//       this.rightTitle,
//       this.hint,
//       this.initValue,
//       this.suffixIcon,
//       this.isFullScreenPopUp = false,
//       this.controller});
//   @override
//   State<StatefulWidget> createState() => _DropDownButtonLoginWidgetState();
// }
//
// class _DropDownButtonLoginWidgetState extends State<DropDownButtonLoginWidget> {
//   TextEditingController controller = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     controller = widget.controller ?? TextEditingController();
//     controller.text = widget.initValue ?? "";
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       child: Column(
//         children: [Text()],
//       ),
//       onTap: () {
//         showModalBottomSheet(
//             context: context,
//             builder: (_) => widget.content,
//             backgroundColor: Colors.transparent,
//             isScrollControlled: widget.isFullScreenPopUp);
//       },
//     );
//   }
//
//   @override
//   void dispose() {
//     widget.controller.dispose();
//     super.dispose();
//   }
// }
