import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lomo/app/app_model.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/api/api_constants.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/libraries/photo_manager/photo_manager.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/base/base_form_state.dart';
import 'package:lomo/ui/base/base_model.dart';
import 'package:lomo/ui/update_information/update_info_non_require_screen.dart';
import 'package:lomo/ui/update_information/update_info_require_model.dart';
import 'package:lomo/ui/widget/bottom_shadow_button_widget.dart';
import 'package:lomo/ui/widget/dialog_widget.dart';
import 'package:lomo/ui/widget/dropdown_date_picker_widget.dart';
import 'package:lomo/ui/widget/image_widget.dart';
import 'package:lomo/ui/widget/text_form_field_widget.dart';
import 'package:lomo/util/validate_utils.dart';
import 'package:provider/provider.dart';

class UpdateInfoRequireArguments {
  bool initProfile;
  User user;
  bool isUpdate;

  UpdateInfoRequireArguments(
    this.user, {
    this.isUpdate = false,
    this.initProfile = false,
  });
}

class UpdateInfoRequireScreen extends StatefulWidget {
  final UpdateInfoRequireArguments args;

  UpdateInfoRequireScreen(this.args);

  @override
  _UpdateInfoRequireScreenState createState() =>
      _UpdateInfoRequireScreenState();
}

class _UpdateInfoRequireScreenState
    extends BaseFormState<UpdateInfoRequireModel, UpdateInfoRequireScreen> {
  final formGlobalKey = GlobalKey<FormState>();

  late Timer _timer;
  int _startTime = 3;

  @override
  Widget build(BuildContext context) {
    return buildContent();
  }

  @override
  void initState() {
    super.initState();
    model.init();

    model.tecUserName.addListener(() {
      model.isValidateData();
    });
    model.tecCaption.addListener(() {
      model.isValidateData();
    });
    model.tecEmail.addListener(() {
      model.isValidateData();
    });
    model.textLomoId.addListener(() {
      model.isValidateData();
    });
  }

  showImagePicker() async {
    try {
      final photo = await getImageUint8List(context);
      if (photo != null) model.avatar.value = photo.u8List;
      model.isValidateData();

      // isValidatedInfo();
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  Widget _buildLocalImage() {
    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(Dimens.avatarRadius)),
        child: Image.memory(
          model.avatar.value!,
          width: 200,
          height: 200,
          fit: BoxFit.cover,
        ));
  }

  Widget _buildRemoteImage() {
    return CircleNetworkImage(
      size: Dimens.avatarProfileSize,
      url: model.user.avatar,
      placeholder: Image.asset(
        DImages.avatarDefault,
        height: Dimens.avatarProfileSize,
        width: Dimens.avatarProfileSize,
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      height: Dimens.avatarProfileSize,
      width: Dimens.avatarProfileSize,
      margin: const EdgeInsets.only(bottom: Dimens.spacing8),
      child: ValueListenableProvider.value(
        value: model.avatar,
        child: Consumer<Uint8List?>(
          builder: (context, avatar, child) => GestureDetector(
            onTap: () async {
              showImagePicker();
            },
            child: Stack(
              children: <Widget>[
                avatar != null ? _buildLocalImage() : _buildRemoteImage(),
                _buildEditAvatar()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditAvatar() {
    return Positioned(
      right: 0,
      bottom: 0,
      child: Container(
        alignment: Alignment.center,
        height: 32,
        width: 32,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(16))),
        child: Image.asset(
          DImages.camera,
          height: 24,
          width: 24,
          color: getColor().white,
        ),
      ),
    );
  }

  Widget _buildName() {
    return ClearTextField(
        hint: Strings.enterUserName.localize(context),
        leftTitle: Strings.visibleName.localize(context),
        // rightTitle: Strings.required.localize(context),
        controller: model.tecUserName,
        textStyle: textTheme(context).text19.light.colorDart,
        maxLength: 30,
        errorStyle: textTheme(context).text14.colorPink88,
        onValidated: (text) => model.validateName(text!, context));
  }

  Widget _buildLomoId() {
    return ClearTextField(
      inputFormatters: [LowerCaseTxt()],
      hint: Strings.enterLOMOId.localize(context),
      leftTitle: Strings.lomoId.localize(context),
      // rightTitle: Strings.required.localize(context),
      controller: model.textLomoId,
      textStyle: textTheme(context).text19.light.colorDart,
      maxLength: 30,
      errorStyle: textTheme(context).text14.colorPink88,
      onValidated: (text) => model.validateLomoId(text!, context),
    );
  }

  Widget _buildEmail() {
    return ClearTextField(
      hint: Strings.enterEmail.localize(context),
      leftTitle: Strings.email.localize(context),
      // rightTitle: Strings.required.localize(context),
      controller: model.tecEmail,
      keyboardType: TextInputType.emailAddress,
      textStyle: textTheme(context).text19.light.colorDart,
      errorStyle: textTheme(context).text14.colorPink88,
      onValidated: (text) => !validateEmail(text!.trim())
          ? Strings.invalidEmail.localize(context)
          : null,
    );
  }

  bool isValidatedInfo() {
    if ((model.user.avatar == null || model.user.avatar == "") &&
        model.avatar.value == null) {
      showError(Strings.pleaseChooseAvatar.localize(context));
      return false;
    }
    if (model.user.birthday == null) {
      showError(Strings.pleaseChooseBirthDate.localize(context));
      return false;
    }

    return true;
  }

  Widget _buildPhone() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.phoneNumber.localize(context),
          style: textTheme(context).text13.bold.colorDart,
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              model.user.phone!,
              style: textTheme(context).text19.light.colorDart,
            ),
            Image.asset(
              DImages.lockGray,
              height: 28,
              width: 28,
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Divider(
          height: 2,
          color: getColor().grayBorder,
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget _buildDateOfBirth() {
    DateTime now = DateTime.now();
    return DropdownDatePickerWidget(
      titleContentPopUp: Strings.dateOfBirth.localize(context),
      titleDropdown: Strings.dateOfBirth.localize(context),
      onDateSelected: (date) {
        model.user.birthday = date;
        model.isValidateData();
        //   isValidatedInfo();
      },
      minDate: minDate,
      maxDate: DateTime(now.year - MIN_YEAR_OLD_USED_APP, now.month, now.day,
          now.hour, now.minute, now.second),
      initialDateTime: model.user.birthday,
    );
  }

  Widget _buildFinishButton() {
    return BottomOneButton(
      text: widget.args.isUpdate
          ? Strings.save.localize(context)
          : Strings.next.localize(context),
      // enable: model.validatedInfo,
      onPressed: _warningEditProfile,
      enable: model.validateData,
    );
  }

  saveProfile() async {
    showLoading();
    await model.updateProfile(model.tecUserName.text, model.textLomoId.text,
        model.tecEmail.text.trim());
    if (model.progressState == ProgressState.success) {
      if (widget.args.initProfile) {
        hideLoading();
        Navigator.pushNamed(context, Routes.updateNonRequireProfile,
            arguments: UpdateInfoNonRequireArguments(locator<UserModel>().user!,
                initProfile: widget.args.initProfile,
                isUpdate: widget.args.isUpdate,
                sogiescName: []));
      } else {
        updateProfileSuccess();
      }
    } else if (model.progressState == ProgressState.error) {
      hideLoading();
      showError(model.errorMessage!.localize(context));
    }
  }

  _warningEditProfile() {
    if (formGlobalKey.currentState!.validate()) {
      if (isValidatedInfo()) {
        showDialog(
          context: context,
          builder: (context) => TwoButtonDialogWidget(
            title: Strings.notice.localize(context),
            description: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                      text: Strings.warningUpdateProfile.localize(context),
                      style: textTheme(context).text15.colorDart),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            textConfirm: Strings.btnContinue.localize(context),
            textCancel: Strings.cancel.localize(context),
            onCanceled: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            onConfirmed: () {
              FocusScope.of(context).requestFocus(new FocusNode());
              saveProfile();
            },
            image: DImages.bearLogo,
          ),
        );
      }
    }
  }

  updateProfileSuccess() {
    _startTime = 3;
    _timer = new Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (_startTime < 1) {
        _timer.cancel();
        timer.cancel();
        Navigator.pop(context);
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
                Navigator.pop(context);
              },
            ),
        barrierDismissible: false);
  }

  @override
  Widget buildContentForm(BuildContext context, UpdateInfoRequireModel model) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: getColor().white,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset(
              DImages.backBlack,
              height: 32,
              width: 32,
            ),
          ),
        ),
        elevation: 0,
        title: Text(
          Strings.accountManagement.localize(context),
          style: textTheme(context).text18.bold.colorDart,
        ),
        centerTitle: true,
      ),
      backgroundColor: getColor().white,
      body: Form(
        key: formGlobalKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimens.paddingBodyContent),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: Dimens.spacing30,
                      ),
                      Center(
                        child: _buildAvatar(),
                      ),
                      SizedBox(
                        height: Dimens.spacing34,
                      ),
                      _buildName(),
                      SizedBox(
                        height: Dimens.spacing10,
                      ),
                      _buildLomoId(),
                      SizedBox(
                        height: Dimens.spacing10,
                      ),
                      _buildPhone(),
                      SizedBox(
                        height: Dimens.spacing10,
                      ),
                      _buildEmail(),
                      SizedBox(
                        height: Dimens.spacing20,
                      ),
                      _buildDateOfBirth(),
                      SizedBox(
                        height: Dimens.spacing20,
                      ),
                      if (locator<AppModel>().appConfig?.isDeleteAccount ==
                          true)
                        _buildDeleteAccount(),
                      SizedBox(
                        height: Dimens.spacing40,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _buildFinishButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteAccount() {
    return Row(
      children: [
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, Routes.deleteAccount);
          },
          child: Text(
            Strings.deleteAccount.localize(context),
            style: textTheme(context).text16.colorRed,
          ),
        ),
      ],
    );
  }
}

class UpdateToAnotherProfile extends StatefulWidget {
  final String content;
  final bool isRequire;

  UpdateToAnotherProfile({this.content = "", this.isRequire = true});

  @override
  _UpdateToAnotherProfileState createState() => _UpdateToAnotherProfileState();
}

class _UpdateToAnotherProfileState extends State<UpdateToAnotherProfile> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      shadowColor: getColor().white,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: getColor().colorVioletEB,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(Dimens.size10),
        child: InkWell(
          onTap: () {
            if (widget.isRequire) {
              Navigator.pushReplacementNamed(
                  context, Routes.updateNonRequireProfile,
                  arguments: UpdateInfoNonRequireArguments(
                      locator<UserModel>().user!,
                      initProfile: false,
                      isUpdate: true,
                      sogiescName: []));
            } else {
              Navigator.pushReplacementNamed(
                  context, Routes.updateRequireProfile,
                  arguments: UpdateInfoRequireArguments(
                      locator<UserModel>().user!,
                      initProfile: false,
                      isUpdate: true));
            }
          },
          child: Row(
            children: [
              Image.asset(
                DImages.editToProfile,
                width: 40,
                height: 40,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  widget.content,
                  style: textTheme(context).text14Normal.colorDart,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
