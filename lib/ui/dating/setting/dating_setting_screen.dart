import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lomo/data/api/models/constant_list.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/base/base_model.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/dating/setting/dating_setting_model.dart';
import 'package:lomo/ui/settings/privacy/privacy_item_widget.dart';
import 'package:lomo/ui/widget/button_widgets.dart';
import 'package:lomo/ui/widget/dialog_widget.dart';
import 'package:lomo/util/constants.dart';

class DatingSettingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DatingSettingScreenState();
}

class _DatingSettingScreenState
    extends BaseState<DatingSettingModel, DatingSettingScreen> {
  late Timer _timer;
  int _startTime = 3;

  @override
  void initState() {
    super.initState();
    model.initData();
  }

  @override
  Widget buildContentView(BuildContext context, DatingSettingModel model) {
    return Scaffold(
        appBar: _privacyAppbar(),
        body: Stack(
          children: [
            _buildContent(),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: _buildFinishButton(),
        ));
  }

  AppBar _privacyAppbar() {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      automaticallyImplyLeading: false,
      backgroundColor: getColor().white,
      elevation: Dimens.spacing2,
      leading: InkWell(
        onTap: () async {
          Navigator.pop(context);
        },
        child: Icon(
          Icons.arrow_back_ios,
          size: Dimens.size24,
          color: getColor().colorDart,
        ),
      ),
      title: Text(
        Strings.datingViewSetting.localize(context),
        style: textTheme(context).text18.bold.colorDart,
      ),
      centerTitle: true,
    );
  }

  Widget _buildContent() {
    return ListView(
      padding: EdgeInsets.only(
          left: Dimens.spacing30, right: Dimens.spacing30, top: Dimens.size30),
      children: [
        _buildNameDatingSetting(UserDatingFieldDisabled.datingTitle),
        _buildRoleDatingSetting(UserDatingFieldDisabled.datingRole),
        _buildZodiacDatingSetting(UserDatingFieldDisabled.datingZodiac),
        _buildHeightAndWidthPrivacy(UserDatingFieldDisabled.datingHeightWeight),
        _buildProvincePrivacy(UserDatingFieldDisabled.datingProvince),
        _buildLiteracyPrivacy(UserDatingFieldDisabled.datingLiteracy),
        _buildCareerPrivacy(UserDatingFieldDisabled.datingCareers),
        _buildHobbyPrivacy(UserDatingFieldDisabled.datingHobbies),
      ],
    );
  }

  Widget _buildNameDatingSetting(String keyName) {
    return PrivacyItemWidget(
      Strings.titleName.localize(context),
      DImages.nameDart,
      [model.user.title],
      model.user.fieldDisabled!.contains(keyName) ? false : true,
      (value) {
        if (value == false) {
          if (!model.user.fieldDisabled!.contains(keyName)) {
            model.user.fieldDisabled!.add(keyName);
            model.isValidateData();
          }
        } else {
          model.user.fieldDisabled!
              .removeWhere((element) => element == keyName);
          model.isValidateData();
        }
      },
    );
  }

  Widget _buildRoleDatingSetting(String keyName) {
    return PrivacyItemWidget(
      Strings.role.localize(context),
      DImages.roleDart,
      [model.user.role],
      model.user.fieldDisabled!.contains(keyName) ? false : true,
      (value) {
        if (value == false) {
          if (!model.user.fieldDisabled!.contains(keyName)) {
            model.user.fieldDisabled!.add(keyName);
            model.isValidateData();
          }
        } else {
          model.user.fieldDisabled!
              .removeWhere((element) => element == keyName);
          model.isValidateData();
        }
      },
    );
  }

  Widget _buildZodiacDatingSetting(String keyName) {
    return PrivacyItemWidget(
      Strings.zodiac.localize(context),
      DImages.zodiacDart,
      [model.user.zodiac],
      model.user.fieldDisabled!.contains(keyName) ? false : true,
      (value) {
        if (value == false) {
          if (!model.user.fieldDisabled!.contains(keyName)) {
            model.user.fieldDisabled!.add(keyName);
            model.isValidateData();
          }
        } else {
          model.user.fieldDisabled!
              .removeWhere((element) => element == keyName);
          model.isValidateData();
        }
      },
    );
  }

  Widget _buildHeightAndWidthPrivacy(String keyName) {
    KeyValue? keyValue;
    if (model.user.height! > 0 && model.user.weight! > 0) {
      keyValue = KeyValue();
      keyValue.id = 'heightAndWidth';
      keyValue.name = "${model.user.height!} cm, "
              "" +
          model.user.weight!.toString() +
          "kg";
    }

    return PrivacyItemWidget(
      Strings.heightAndWeight.localize(context),
      DImages.handwDart,
      [keyValue],
      model.user.fieldDisabled!.contains(keyName) ? false : true,
      (value) {
        if (value == false) {
          if (!model.user.fieldDisabled!.contains(keyName)) {
            model.user.fieldDisabled!.add(keyName);
            model.isValidateData();
          }
        } else {
          model.user.fieldDisabled!
              .removeWhere((element) => element == keyName);
          model.isValidateData();
        }
      },
    );
  }

  Widget _buildProvincePrivacy(String keyName) {
    return PrivacyItemWidget(
      Strings.city.localize(context),
      DImages.cityDart,
      [model.user.province],
      model.user.fieldDisabled!.contains(keyName) ? false : true,
      (value) {
        if (value == false) {
          if (!model.user.fieldDisabled!.contains(keyName)) {
            model.user.fieldDisabled!.add(keyName);
            model.isValidateData();
          }
        } else {
          model.user.fieldDisabled!
              .removeWhere((element) => element == keyName);
          model.isValidateData();
        }
      },
    );
  }

  Widget _buildLiteracyPrivacy(String keyName) {
    return PrivacyItemWidget(
      Strings.literacyFull.localize(context),
      DImages.educationDart,
      [model.user.literacy],
      model.user.fieldDisabled!.contains(keyName) ? false : true,
      (value) {
        if (value == false) {
          if (!model.user.fieldDisabled!.contains(keyName)) {
            model.user.fieldDisabled!.add(keyName);
            model.isValidateData();
          }
        } else {
          model.user.fieldDisabled!
              .removeWhere((element) => element == keyName);
          model.isValidateData();
        }
      },
    );
  }

  Widget _buildCareerPrivacy(String keyName) {
    return PrivacyItemWidget(
      Strings.career.localize(context),
      DImages.careerDart,
      model.user.careers,
      model.user.fieldDisabled!.contains(keyName) ? false : true,
      (value) {
        if (value == false) {
          if (!model.user.fieldDisabled!.contains(keyName)) {
            model.user.fieldDisabled!.add(keyName);
            model.isValidateData();
          }
        } else {
          model.user.fieldDisabled!
              .removeWhere((element) => element == keyName);
          model.isValidateData();
        }
      },
    );
  }

  Widget _buildHobbyPrivacy(String keyName) {
    return PrivacyItemWidget(
      Strings.hobby.localize(context),
      DImages.hobbyDart,
      model.user.hobbies,
      model.user.fieldDisabled!.contains(keyName) ? false : true,
      (value) {
        if (value == false) {
          if (!model.user.fieldDisabled!.contains(keyName)) {
            model.user.fieldDisabled!.add(keyName);
            model.isValidateData();
          }
        } else {
          model.user.fieldDisabled!
              .removeWhere((element) => element == keyName);
          model.isValidateData();
        }
      },
    );
  }

  Widget _buildFinishButton() {
    return Container(
      height: Dimens.size80,
      color: getColor().white,
      child: Padding(
        padding: const EdgeInsets.only(
            bottom: Dimens.size20,
            top: Dimens.spacing10,
            left: Dimens.size30,
            right: Dimens.size30),
        child: PrimaryButton(
          text: Strings.save.localize(context),
          textStyle: textTheme(context).text17.bold.colorWhite,
          enable: model.validateData,
          onPressed: () async {
            print(model.user.fieldDisabled.toString());
            showLoading();
            await model.updateProfile();
            if (model.progressState == ProgressState.success) {
              hideLoading();
              updateProfileSuccess();
            } else if (model.progressState == ProgressState.error) {
              hideLoading();
              showError(model.errorMessage?.localize(context) ?? "");
            }
          },
        ),
      ),
    );
  }

  updateProfileSuccess() {
    _startTime = 3;
    _timer = new Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (_startTime < 1) {
        timer.cancel();
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        _startTime = _startTime - 1;
      }
    });
    showDialog(
        context: context,
        builder: (context) => OneButtonDialogWidget(
              description: Strings.updateProfileSuccess.localize(context),
              textConfirm: Strings.close.localize(context),
              onConfirmed: () {
                _timer.cancel();
                Navigator.pop(context);
              },
            ),
        barrierDismissible: false);
  }
}
