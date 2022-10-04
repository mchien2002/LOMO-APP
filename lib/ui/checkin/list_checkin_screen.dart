import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/checkin.dart';
import 'package:lomo/data/tracking/tracking_manager.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/colors.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/base/base_grid_state.dart';
import 'package:lomo/ui/base/base_model.dart';
import 'package:lomo/ui/checkin/list_checkin_model.dart';
import 'package:lomo/ui/gift/attendance_every_day/attendance_every_day_screen.dart';
import 'package:lomo/ui/widget/button_widgets.dart';
import 'package:lomo/ui/widget/dialog_widget.dart';

import '../../res/values.dart';

class ListCheckinScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ListCheckinScreenState();
}

class _ListCheckinScreenState
    extends BaseGridState<Checkin, ListCheckinModel, ListCheckinScreen> {
  late double itemWidth;
  late double itemHeight;

  @override
  bool get shrinkWrap => true;

  @override
  ScrollPhysics get scrollPhysics => NeverScrollableScrollPhysics();

  @override
  void initState() {
    super.initState();
    loadDataDelay();
  }

  loadDataDelay() async {
    await Future.delayed(Duration(milliseconds: 300));
    model.loadData();
  }

  @override
  bool get autoLoadData => false;

  @override
  EdgeInsets get paddingGrid =>
      EdgeInsets.only(left: 40, right: 40, bottom: 10, top: 20);

  @override
  Widget build(BuildContext context) {
    crossAxisCount = 4;
    itemWidth = (MediaQuery.of(context).size.width - 3 * Dimens.spacing15) / 4;
    itemHeight = itemWidth * 3 / 2;
    childAspectRatio = itemWidth / itemHeight;
    print(itemHeight - itemWidth);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: Dimens.spacing8,
        ),
        Container(
          height: 44,
          margin: EdgeInsets.only(
              left: Dimens.padding_left_right,
              right: Dimens.padding_left_right),
          child: Row(
            children: <Widget>[
              Container(
                width: 44,
                height: 44,
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: getColor().pink.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Image.asset(
                  DImages.checkin,
                  height: 32,
                  width: 32,
                ),
                alignment: Alignment.center,
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: Text(
                  Strings.checkin.localize(context),
                  style: textTheme(context).text16Bold.colorDart,
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 2, bottom: 2, left: 10, right: 5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: getColor().backgroundSearch,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) {
                          return AttendanceEveryDayScreen();
                        });
                  },
                  child: Row(
                    children: [
                      Text(
                        Strings.detail.localize(context),
                        style: textTheme(context).text12.bold.colorGrayTime,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: getColor().textHint,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
            height: itemHeight * 2 + mainAxisSpacing,
            child: super.build(context)),
        Container(
          height: 50,
          margin: EdgeInsets.only(left: 40, right: 40),
          child: PrimaryButton(
            text: Strings.btncheckin.localize(context),
            enable: model.checkinEnable,
            textUpperCase: false,
            onPressed: () async {
              var item = await model.checkin();
              _checkinResponseState(item!);
              locator<TrackingManager>().trackCheckIn();
            },
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          height: 50,
          margin: EdgeInsets.only(left: 40, right: 40),
          child: RoundedButton(
            text: Strings.invite_friends.localize(context),
            radius: Dimens.cornerPrimaryRadius,
            suffixIcon: Image.asset(
              DImages.inviteFr,
              height: 24,
              width: 24,
              color: getColor().primaryColor,
            ),
            color: getColor().e8dbffColor,
            textStyle: textTheme(context).text17.bold.colorPrimary,
            onPressed: () {
              Navigator.of(context).pushNamed(Routes.inviteFriend);
            },
          ),
        ),
        SizedBox(
          height: 25,
        ),
      ],
    );
  }

  @override
  Widget buildItem(BuildContext context, Checkin item, int index) {
    return item.check == 1
        ? _candyActive(item, index)
        : _candyDefault(item, index);
  }

  Widget _candyActive(Checkin item, int index) {
    return Container(
      width: itemWidth,
      height: itemHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                Strings.day.localize(context) + " " + (index + 1).toString(),
                style: textTheme(context).text12.colorGray,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 30,
                height: 30,
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: DColors.whiteColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Image.asset(
                  DImages.candyActive,
                  height: 24,
                  width: 24,
                ),
                alignment: Alignment.center,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                  item.candy.toString() + " " + Strings.candy.localize(context),
                  style: textTheme(context).text14Normal.semiBold),
            ],
          )
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: DColors.candyActiveColor,
      ),
    );
  }

  Widget _candyDefault(Checkin item, int index) {
    return Container(
      height: itemHeight,
      width: itemWidth,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                Strings.day.localize(context) + " " + (index + 1).toString(),
                style: textTheme(context).text12.colorGray,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 30,
                height: 30,
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: DColors.violetColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Image.asset(
                  DImages.candy,
                  height: 24,
                  width: 24,
                ),
                alignment: Alignment.center,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                  item.candy.toString() + " " + Strings.candy.localize(context),
                  style: textTheme(context).text14Normal.semiBold),
            ],
          )
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: DColors.whiteColor,
        boxShadow: [
          BoxShadow(color: model.getBorderColor(item.check!), spreadRadius: 1),
        ],
      ),
    );
  }

  _checkinResponseState(Checkin item) {
    if (model.progressState == ProgressState.success) {
      showDialog(
        context: context,
        builder: (context) => OneButtonDialogWidget(
          title: Strings.checkinSuccess.localize(context),
          description: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                    text: Strings.youReceived.localize(context),
                    style: textTheme(context).text16.colorDart),
                TextSpan(
                    text:
                        "${item.candy} ${Strings.candyLower.localize(context)}",
                    style: textTheme(context).text16.bold.colorDart),
                TextSpan(
                    text: Strings.forThisCheckIn.localize(context),
                    style: textTheme(context).text16.colorDart),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          textConfirm: Strings.confirm.localize(context),
        ),
      );
    } else {
      showError(model.errorMessage!.localize(context));
    }
  }

  double get mainAxisSpacing => Dimens.spacing15;

  double get crossAxisSpacing => Dimens.spacing15;

  EdgeInsets get padding =>
      const EdgeInsets.symmetric(horizontal: Dimens.spacing15);
}
