import 'package:flutter/material.dart';
import 'package:lomo/res/colors.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/widget/bottom_sheet_widgets.dart';

class AttendanceEveryDayScreen extends StatefulWidget {
  @override
  _AttendanceEveryDayScreenState createState() =>
      _AttendanceEveryDayScreenState();
}

class _AttendanceEveryDayScreenState extends State<AttendanceEveryDayScreen> {
  @override
  Widget build(BuildContext context) {
    return BottomSheetModal(
      isFull: true,
      contentWidget: _content(context),
      right: _rightWidget(context),
      appbarColor: DColors.whiteColor,
      // height: (MediaQuery.of(context).size.height * 4 / 5),
      title: Strings.attendanceEveryDay.localize(context),
      titleStyle: textTheme(context).text18.bold.colorDart,
      isRadius: true,
    );
  }

  Widget _content(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
                image: DecorationImage(
                    // image: AssetImage(widget.image), fit: BoxFit.cover)
                    image: AssetImage(DImages.convertGift),
                    fit: BoxFit.cover)),
          ),
          SizedBox(
            height: Dimens.size20,
          ),
          Text(Strings.description.localize(context),
              style: textTheme(context).text16.bold.colorDart),
          SizedBox(
            height: Dimens.size10,
          ),
          Text(Strings.receiveCandy.localize(context),
              style: textTheme(context).text14Normal.colorDart),
          SizedBox(
            height: Dimens.size20,
          ),
          Text(Strings.note.localize(context),
              style: textTheme(context).text16.bold.colorDart),
          SizedBox(
            height: Dimens.size10,
          ),
          Text(Strings.noteOne.localize(context),
              style: textTheme(context).text14Normal.colorDart),
          SizedBox(
            height: Dimens.size10,
          ),
          Text(Strings.noteTwo.localize(context),
              style: textTheme(context).text14Normal.colorDart),
          SizedBox(
            height: Dimens.size10,
          ),
          Text(Strings.noteThree.localize(context),
              style: textTheme(context).text14Normal.colorDart),
        ],
      ),
    );
  }

  Widget _rightWidget(BuildContext context) {
    return InkWell(
      child: Icon(
        Icons.close,
        size: 25,
        color: getColor().colorDart,
      ),
      onTap: () {
        Navigator.of(context).pop();
      },
    );
  }
}
