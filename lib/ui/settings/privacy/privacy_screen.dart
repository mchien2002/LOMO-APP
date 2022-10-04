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
import 'package:lomo/ui/settings/privacy/privacy_item_widget.dart';
import 'package:lomo/ui/settings/privacy/privacy_model.dart';
import 'package:lomo/ui/widget/bottom_shadow_button_widget.dart';
import 'package:lomo/ui/widget/dialog_widget.dart';
import 'package:lomo/util/constants.dart';
import 'package:lomo/util/date_time_utils.dart';

class PrivacyScreen extends StatefulWidget {
  @override
  _PrivacyScreenState createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends BaseState<PrivacyModel, PrivacyScreen> {
  late Timer _timer;
  int _startTime = 3;

  @override
  void initState() {
    super.initState();
    model.initData();
  }

  @override
  Widget buildContentView(BuildContext context, PrivacyModel model) {
    return Scaffold(
      appBar: _privacyAppbar(),
      body: _buildContent(),
    );
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
        Strings.settingProfileDisplay.localize(context),
        style: textTheme(context).text18.bold.colorDart,
      ),
      centerTitle: true,
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
            child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                left: Dimens.spacing30,
                right: Dimens.spacing30,
                top: Dimens.size30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildText(Strings.detail.localize(context)),
                _buildAge(UserFieldDisabled.age),
                _buildBirthDay(UserFieldDisabled.birthday),
                _buildEmailPrivacy(UserFieldDisabled.email),
                _buildZodiacPrivacy(UserFieldDisabled.zodiac),
                _buildHeightAndWidthPrivacy(UserFieldDisabled.weight),
                _buildProvincePrivacy(UserFieldDisabled.province),
                _buildLiteracyPrivacy(UserFieldDisabled.literacy),
                _buildCareerPrivacy(UserFieldDisabled.careers),
                _buildHobbyPrivacy(UserFieldDisabled.hobbies),
                _buildRelationshipPrivacy(UserFieldDisabled.relationship),
                SizedBox(
                  height: Dimens.size10,
                ),
                _buildText(Strings.aboutGender.localize(context)),
                _buildNamePrivacy(UserFieldDisabled.title),
                _buildGenderPrivacy(UserFieldDisabled.gender),
                _buildSogiescPrivacy(UserFieldDisabled.sogiescs),
                //_buildRolePrivacy(UserFieldDisabled.role),
                SizedBox(
                  height: Dimens.size20,
                ),
              ],
            ),
          ),
        )),
        _buildFinishButton(),
      ],
    );
  }

  Widget _buildText(String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimens.size15),
      child: Text(
        content,
        style: textTheme(context).text13.bold.colorPrimary,
      ),
    );
  }

  Widget _buildAge(String keyAge) {
    KeyValue? keyValue;
    if (model.user.birthday != null) {
      keyValue = KeyValue();
      keyValue.id = keyAge;
      keyValue.name = "${getAgeFromDateTime(model.user.birthday!)}";
    }

    return PrivacyItemWidget(
      Strings.age.localize(context),
      DImages.birthDayGray,
      [keyValue],
      model.user.fieldDisabled!.contains(keyAge) ? false : true,
      (value) {
        if (value == false) {
          if (!model.user.fieldDisabled!.contains(keyAge)) {
            model.user.fieldDisabled!.add(keyAge);
            model.isValidateData();
          }
        } else {
          model.user.fieldDisabled!.removeWhere((element) => element == keyAge);
          model.isValidateData();
        }
      },
    );
  }

  Widget _buildBirthDay(String keyBirthDay) {
    KeyValue? keyValue;
    if (model.user.birthday != null) {
      keyValue = KeyValue();
      keyValue.id = keyBirthDay;
      keyValue.name = "${formatDate(model.user.birthday, "dd/MM")}";
    }

    return PrivacyItemWidget(
      Strings.dateOfBirth.localize(context),
      DImages.birthDayGray,
      [keyValue],
      model.user.fieldDisabled!.contains(keyBirthDay) ? false : true,
      (value) {
        if (value == false) {
          if (!model.user.fieldDisabled!.contains(keyBirthDay)) {
            model.user.fieldDisabled!.add(keyBirthDay);
            model.isValidateData();
          }
        } else {
          model.user.fieldDisabled!
              .removeWhere((element) => element == keyBirthDay);
          model.isValidateData();
        }
      },
    );
  }

  Widget _buildEmailPrivacy(String keyEmail) {
    KeyValue keyValue = KeyValue();
    keyValue.id = keyEmail;
    keyValue.name = model.user.email?.isNotEmpty == true
        ? model.user.email
        : Strings.notYet.localize(context);
    return PrivacyItemWidget(
      Strings.email.localize(context),
      DImages.messageDart,
      [keyValue],
      model.user.fieldDisabled!.contains(keyEmail) ? false : true,
      (value) {
        if (value == false) {
          if (!model.user.fieldDisabled!.contains(keyEmail)) {
            model.user.fieldDisabled!.add(keyEmail);
            model.isValidateData();
          }
        } else {
          model.user.fieldDisabled!
              .removeWhere((element) => element == keyEmail);
          model.isValidateData();
        }
      },
    );
  }

  Widget _buildZodiacPrivacy(String keyZodiac) {
    return PrivacyItemWidget(
      Strings.zodiac.localize(context),
      DImages.zodiacDart,
      [model.user.zodiac],
      model.user.fieldDisabled!.contains(keyZodiac) ? false : true,
      (value) {
        if (value == false) {
          if (!model.user.fieldDisabled!.contains(keyZodiac)) {
            model.user.fieldDisabled!.add(keyZodiac);
            model.isValidateData();
          }
        } else {
          model.user.fieldDisabled!
              .removeWhere((element) => element == keyZodiac);
          model.isValidateData();
        }
      },
    );
  }

  Widget _buildHeightAndWidthPrivacy(String keyHeightAndWidth) {
    KeyValue keyValue = KeyValue();
    keyValue.id = 'heightAndWidth';
    if (model.user.weight! > 0 && model.user.height! > 0)
      keyValue.name = "${model.user.height} cm, "
              "" +
          model.user.weight!.toString() +
          "kg";

    return PrivacyItemWidget(
      Strings.heightAndWeight.localize(context),
      DImages.handwDart,
      [keyValue],
      model.user.fieldDisabled!.contains(keyHeightAndWidth) ? false : true,
      (value) {
        if (value == false) {
          if (!model.user.fieldDisabled!.contains(keyHeightAndWidth)) {
            model.user.fieldDisabled!.add(keyHeightAndWidth);
            model.isValidateData();
          }
        } else {
          model.user.fieldDisabled!
              .removeWhere((element) => element == keyHeightAndWidth);
          model.isValidateData();
        }
      },
    );
  }

  Widget _buildProvincePrivacy(String keyProvince) {
    return PrivacyItemWidget(
      Strings.city.localize(context),
      DImages.cityDart,
      [model.user.province],
      model.user.fieldDisabled!.contains(keyProvince) ? false : true,
      (value) {
        if (value == false) {
          if (!model.user.fieldDisabled!.contains(keyProvince)) {
            model.user.fieldDisabled!.add(keyProvince);
            model.isValidateData();
          }
        } else {
          model.user.fieldDisabled!
              .removeWhere((element) => element == keyProvince);
          model.isValidateData();
        }
      },
    );
  }

  Widget _buildLiteracyPrivacy(String keyLiteracy) {
    return PrivacyItemWidget(
      Strings.literacyFull.localize(context),
      DImages.educationDart,
      [model.user.literacy],
      model.user.fieldDisabled!.contains(keyLiteracy) ? false : true,
      (value) {
        if (value == false) {
          if (!model.user.fieldDisabled!.contains(keyLiteracy)) {
            model.user.fieldDisabled!.add(keyLiteracy);
            model.isValidateData();
          }
        } else {
          model.user.fieldDisabled!
              .removeWhere((element) => element == keyLiteracy);
          model.isValidateData();
        }
      },
    );
  }

  Widget _buildCareerPrivacy(String keyCareer) {
    return PrivacyItemWidget(
      Strings.career.localize(context),
      DImages.careerDart,
      model.user.careers,
      model.user.fieldDisabled!.contains(keyCareer) ? false : true,
      (value) {
        if (value == false) {
          if (!model.user.fieldDisabled!.contains(keyCareer)) {
            model.user.fieldDisabled!.add(keyCareer);
            model.isValidateData();
          }
        } else {
          model.user.fieldDisabled!
              .removeWhere((element) => element == keyCareer);
          model.isValidateData();
        }
      },
    );
  }

  Widget _buildHobbyPrivacy(String keyHobby) {
    return PrivacyItemWidget(
      Strings.hobby.localize(context),
      DImages.hobbyDart,
      model.user.hobbies,
      model.user.fieldDisabled!.contains(keyHobby) ? false : true,
      (value) {
        if (value == false) {
          if (!model.user.fieldDisabled!.contains(keyHobby)) {
            model.user.fieldDisabled!.add(keyHobby);
            model.isValidateData();
          }
        } else {
          model.user.fieldDisabled!
              .removeWhere((element) => element == keyHobby);
          model.isValidateData();
        }
      },
    );
  }

  Widget _buildRelationshipPrivacy(String keyRelationship) {
    return PrivacyItemWidget(
      Strings.relationship.localize(context),
      DImages.enableHeart,
      [model.user.relationship],
      model.user.fieldDisabled!.contains(keyRelationship) ? false : true,
      (value) {
        if (value == false) {
          if (!model.user.fieldDisabled!.contains(keyRelationship)) {
            model.user.fieldDisabled!.add(keyRelationship);
            model.isValidateData();
          }
        } else {
          model.user.fieldDisabled!
              .removeWhere((element) => element == keyRelationship);
          model.isValidateData();
        }
      },
    );
  }

  Widget _buildNamePrivacy(String keyName) {
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

  Widget _buildGenderPrivacy(String keyGender) {
    return PrivacyItemWidget(
      Strings.gender.localize(context),
      DImages.genderDart,
      [model.user.gender],
      model.user.fieldDisabled!.contains(keyGender) ? false : true,
      (value) {
        if (value == false) {
          if (!model.user.fieldDisabled!.contains(keyGender)) {
            model.user.fieldDisabled!.add(keyGender);
            model.isValidateData();
          }
        } else {
          model.user.fieldDisabled!
              .removeWhere((element) => element == keyGender);
          model.isValidateData();
        }
      },
    );
  }

  Widget _buildSogiescPrivacy(String keyGender) {
    return PrivacyItemWidget(
      Strings.sogiescLabel.localize(context),
      DImages.sogiescDart,
      model.user.sogiescs,
      model.user.fieldDisabled!.contains(keyGender) ? false : true,
      (value) {
        if (value == false) {
          if (!model.user.fieldDisabled!.contains(keyGender)) {
            model.user.fieldDisabled!.add(keyGender);
            model.isValidateData();
          }
        } else {
          model.user.fieldDisabled!
              .removeWhere((element) => element == keyGender);
          model.isValidateData();
        }
      },
    );
  }

  Widget _buildFinishButton() {
    return BottomOneButton(
      text: Strings.save.localize(context),
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
