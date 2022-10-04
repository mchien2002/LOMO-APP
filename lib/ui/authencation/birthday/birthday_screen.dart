import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lomo/data/api/api_constants.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/tracking/tracking_manager.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/widget/bottom_shadow_button_widget.dart';
import 'package:lomo/ui/widget/bottom_sheet_picker.dart';
import 'package:lomo/ui/widget/date_authen_widget.dart';
import 'package:lomo/ui/widget/step_widget.dart';
import 'package:lomo/util/date_time_utils.dart';
import 'package:provider/provider.dart';

import 'birthday_model.dart';

class BirthdayScreen extends StatefulWidget {
  final User user;

  BirthdayScreen(this.user);

  @override
  _BirthdayScreenState createState() => _BirthdayScreenState();
}

class _BirthdayScreenState extends BaseState<BirthdayModel, BirthdayScreen> {
  Widget _buildBirth() {
    DateTime now = DateTime.now();

    return BottomSheetPickerWidget(
      titleContentPopUp: Strings.dateOfBirth.localize(context),
      titleDropdown: Strings.dateOfBirth.localize(context),
      onDateSelected: (date) {
        model.confirmDate.value = date;
        isValidatedInfo();
      },
      minDate: minDate,
      maxDate: DateTime(now.year - MIN_YEAR_OLD_USED_APP, now.month, now.day,
          now.hour, now.minute, now.second),
      initialDateTime: model.user.birthday,
    );
  }

  @override
  void initState() {
    super.initState();
    model.init(widget.user);
  }

  @override
  Widget buildContentView(BuildContext context, BirthdayModel model) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: getColor().white,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leading: Padding(
          padding: const EdgeInsets.only(left: Dimens.size16),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset(
              DImages.backBlack,
              height: Dimens.size32,
              width: Dimens.size32,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: SingleChildScrollView(
                child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimens.size30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      StepWidget(
                        currentStep: 2,
                        totalStep: 5,
                      ),
                      SizedBox(
                        height: Dimens.spacing20,
                      ),
                      Image.asset(
                        DImages.giftAuthen,
                        width: 200,
                        height: 120,
                      ),
                      SizedBox(
                        height: Dimens.spacing15,
                      ),
                      Text(
                        Strings.your_birthday.localize(context),
                        style: textTheme(context).text22.bold.colorDart,
                      ),
                      SizedBox(
                        height: Dimens.spacing10,
                      ),
                      Text(
                        Strings.make_sure_old.localize(context),
                        style: textTheme(context).text15.colorGray77,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: Dimens.spacing5,
                      ),
                      Text(
                        Strings.date_month_year.localize(context),
                        style: textTheme(context).text15.colorGray77,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: Dimens.spacing40,
                      ),
                      _buildDateOfBirth(),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ],
            )),
          ),
          BottomOneButton(
            text: Strings.next.localize(context),
            enable: model.confirmEnable,
            onPressed: () {
              model.user.birthday = model.confirmDate.value;
              Navigator.of(context).pushNamed(
                Routes.gender,
                arguments: model.user,
              );
              locator<TrackingManager>().trackRegisterBirthDay();
            },
          )
        ],
      ),
    );
  }

  Widget _buildFlashWidget(bool isShowDate) {
    return Expanded(
      flex: 1,
      child: Center(
        child: Text('/',
            style: isShowDate
                ? textTheme(context).text24.light.colorDart
                : textTheme(context).text24.light.colorgray6CB),
      ),
    );
  }

  Widget _buildDateItem(String? dateFormatted, int itemIndex) {
    Widget result;
    if (dateFormatted?.isNotEmpty == true) {
      final length = dateFormatted!.length;
      result = length > itemIndex
          ? DateAuthenWidget(textName: dateFormatted[itemIndex])
          : DateAuthenNotChooseWidget(textName: "");
    } else {
      result = DateAuthenNotChooseWidget(textName: "");
    }
    return result;
  }

  Widget _buildDateOfBirth() {
    return ValueListenableProvider.value(
        value: model.confirmDate,
        child: Consumer<DateTime?>(
          builder: (context, confirmDate, child) {
            String? dateFormatted = formatDate(confirmDate);
            return InkWell(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: false,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return _buildBirth();
                    });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildDateItem(dateFormatted, 0),
                      SizedBox(
                        width: Dimens.spacing10,
                      ),
                      _buildDateItem(dateFormatted, 1),
                      SizedBox(
                        width: Dimens.spacing24,
                      ),
                      _buildFlashWidget(dateFormatted?.isNotEmpty == true),
                      SizedBox(
                        width: Dimens.spacing20,
                      ),
                      _buildDateItem(dateFormatted, 3),
                      SizedBox(
                        width: Dimens.spacing10,
                      ),
                      _buildDateItem(dateFormatted, 4),
                      SizedBox(
                        width: Dimens.spacing24,
                      ),
                      _buildFlashWidget(dateFormatted?.isNotEmpty == true),
                      SizedBox(
                        width: Dimens.spacing20,
                      ),
                      _buildDateItem(dateFormatted, 6),
                      SizedBox(
                        width: Dimens.spacing10,
                      ),
                      _buildDateItem(dateFormatted, 7),
                      SizedBox(
                        width: Dimens.spacing10,
                      ),
                      _buildDateItem(dateFormatted, 8),
                      SizedBox(
                        width: Dimens.spacing10,
                      ),
                      _buildDateItem(dateFormatted, 9),
                    ],
                  ),
                ],
              ),
            );
          },
        ));
  }

  isValidatedInfo() {
    model.confirmEnable.value = model.confirmDate.value != null;
  }
}
