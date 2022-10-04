import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lomo/data/api/api_constants.dart';
import 'package:lomo/data/api/models/sogiesc.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/libraries/photo_manager/photo_manager.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/icons.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/base/base_model.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/update_information/update_information_model.dart';
import 'package:lomo/ui/webview/webview_screen.dart';
import 'package:lomo/ui/widget/button_widgets.dart';
import 'package:lomo/ui/widget/checkbox_widget.dart';
import 'package:lomo/ui/widget/dialog_widget.dart';
import 'package:lomo/ui/widget/dropdown_api_widget.dart';
import 'package:lomo/ui/widget/dropdown_button_widget.dart';
import 'package:lomo/ui/widget/dropdown_city_widget.dart';
import 'package:lomo/ui/widget/dropdown_date_picker_widget.dart';
import 'package:lomo/ui/widget/dropdown_height_weight_widget.dart';
import 'package:lomo/ui/widget/image_widget.dart';
import 'package:lomo/ui/widget/information_user/career_widget.dart';
import 'package:lomo/ui/widget/information_user/literacy_widget.dart';
import 'package:lomo/ui/widget/sogiesc/sogiesc_hint_widget.dart';
import 'package:lomo/ui/widget/sogiesc/sogiesc_widget.dart';
import 'package:lomo/ui/widget/text_form_field_widget.dart';
import 'package:lomo/util/common_utils.dart';
import 'package:lomo/util/validate_utils.dart';
import 'package:provider/provider.dart';

class UpdateInformationArguments {
  bool initProfile;
  User user;
  bool isUpdate;
  List<String>? sogiescName;

  UpdateInformationArguments(this.user,
      {this.isUpdate = false, this.initProfile = false, this.sogiescName});
}

class UpdateInformationScreen extends StatefulWidget {
  final UpdateInformationArguments args;

  UpdateInformationScreen(this.args);

  @override
  State<StatefulWidget> createState() => _UpdateInformationScreenState();
}

class _UpdateInformationScreenState
    extends BaseState<UpdateInformationModel, UpdateInformationScreen> {
  late Timer _timer;
  int _startTime = 3;

  @override
  void initState() {
    super.initState();
    model.init(widget.args.user);
    model.tecUserName.text = model.user.name ?? "";
    model.tecCaption.text = model.user.story ?? "";
    model.tecEmail.text = model.user.email ?? "";
    if (widget.args.sogiescName?.isNotEmpty == true) {
      model.isShowTestSogiescSubject.sink.add(true);
    }
  }

  @override
  Widget buildContentView(BuildContext context, UpdateInformationModel model) {
    return Scaffold(
      backgroundColor: getColor().white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: Dimens.paddingBodyContent),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: Dimens.spacing32,
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () async {
                          if (widget.args.isUpdate) {
                            Navigator.of(context).maybePop();
                          } else {
                            await model.clearCurrentUser();
                          }
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 25,
                          color: getColor().violet,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        Strings.personalInformation.localize(context),
                        style: textTheme(context).text26.light.colorPrimary,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: Dimens.spacing20,
                ),
                Center(
                  child: _buildAvatar(),
                ),
                SizedBox(
                  height: Dimens.spacing34,
                ),
                _buildName(),
                _buildEmail(),
                SizedBox(
                  height: Dimens.spacing20,
                ),
                _buildGender(),
                SizedBox(
                  height: Dimens.spacing20,
                ),
                _buildDateOfBirth(),
                SizedBox(
                  height: Dimens.spacing20,
                ),
                _buildHeightWeight(),
                SizedBox(
                  height: Dimens.spacing20,
                ),
                _buildCity(),
                SizedBox(
                  height: Dimens.spacing20,
                ),
                if (!widget.args.initProfile) _buildStory(),
                if (!widget.args.initProfile)
                  SizedBox(
                    height: Dimens.spacing20,
                  ),
                _buildSogiesc(),
                SizedBox(
                  height: Dimens.spacing20,
                ),
                _buildTestSogiesc(),
                _buildZodiac(),
                SizedBox(
                  height: Dimens.spacing20,
                ),
                _buildRelationship(),
                SizedBox(
                  height: Dimens.spacing20,
                ),
                _buildlLiteracy(),
                SizedBox(
                  height: Dimens.spacing20,
                ),
                _buildCareer(),
                SizedBox(
                  height: Dimens.spacing20,
                ),
                if (widget.args.initProfile) _buildConfirmAge(),
                SizedBox(
                  height: Dimens.spacing30,
                ),
                _buildFinishButton(),
                SizedBox(
                  height: Dimens.spacing30,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTestSogiesc() {
    return StreamBuilder<bool>(
        initialData: false,
        stream: model.isShowTestSogiescSubject.stream,
        builder: (context, snapshot) {
          return Visibility(
            visible: snapshot.data!,
            child: Column(
              children: [
                SogiescHintWidget(
                  widget.args.sogiescName!,
                  closeWidget: () {
                    model.isShowTestSogiescSubject.sink.add(false);
                  },
                  selectedAdd: () {
                    model.addNowSogiesc(widget.args.sogiescName!, context);
                  },
                ),
                SizedBox(
                  height: 30,
                )
              ],
            ),
          );
        });
  }

  Widget _buildAvatar() {
    return Container(
      height: Dimens.avatarProfileSize,
      width: Dimens.avatarProfileSize,
      margin: const EdgeInsets.only(bottom: Dimens.spacing8),
      child: ValueListenableProvider.value(
        value: model.avatar,
        child: Consumer<File?>(
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

  showImagePicker() async {
    try {
      final photo = await getImageUint8List(context);
      if (photo != null) model.avatar.value = photo.u8List;
      // isValidatedInfo();
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  Future<void> retrieveLostData() async {
    // final LostData response = await picker.getLostData();
    // if (response == null) {
    //   return;
    // }
    // if (response.file != null) {
    //   model.avatarFile.value = File(response.file.path);
    // }
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
      rightTitle: Strings.required.localize(context),
      controller: model.tecUserName,
      maxLength: 30,
    );
  }

  Widget _buildEmail() {
    return ClearTextField(
      hint: Strings.enterEmail.localize(context),
      leftTitle: Strings.email.localize(context),
      rightTitle: Strings.required.localize(context),
      controller: model.tecEmail,
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildCareer() {
    return InkWell(
      child: DTextFromField(
        strokeColor: getColor().underlineClearTextField,
        leftTitle: Strings.career.localize(context),
        hintText: Strings.career.localize(context),
        controller: model.careerController,
        enabled: false,
        suffixIcon: SvgPicture.asset(
          DIcons.expand,
          height: 24,
          width: 24,
          color: getColor().colorPrimary,
        ),
        textStyle: textTheme(context).subText.colorPrimary,
      ),
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (_) => DropdownCareerWidget(
                  getDropdown: model.commonRepository.getListCareer,
                  items: model.listCareer,
                  titleContentPopUp: Strings.career.localize(context),
                  onSelected: (value) {
                    model.careerController.text = value.name!;
                    model.careerValue = value;
                  },
                  initValue: model.careerController.text,
                ),
            backgroundColor: Colors.transparent,
            isScrollControlled: true);
      },
    );
  }

  Widget _buildlLiteracy() {
    return InkWell(
      child: DTextFromField(
        strokeColor: getColor().underlineClearTextField,
        leftTitle: Strings.literacy.localize(context),
        hintText: Strings.literacy.localize(context),
        controller: model.literacyController,
        enabled: false,
        suffixIcon: SvgPicture.asset(
          DIcons.expand,
          height: 24,
          width: 24,
          color: getColor().colorPrimary,
        ),
        textStyle: textTheme(context).subText.colorPrimary,
      ),
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (_) => DropdownLiteracyWidget(
                  getDropdown: model.commonRepository.getListLiteracy,
                  items: model.listLiteracy,
                  titleContentPopUp: Strings.literacy.localize(context),
                  onSelected: (value) {
                    model.literacyController.text = value.name!;
                    model.literacyValue = value;
                  },
                  initValue: model.literacyController.text,
                ),
            backgroundColor: Colors.transparent,
            isScrollControlled: true);
      },
    );
  }

  Widget _buildZodiac() {
    return InkWell(
      child: DTextFromField(
        strokeColor: getColor().underlineClearTextField,
        leftTitle: Strings.zodiac.localize(context),
        hintText: Strings.zodiac.localize(context),
        controller: model.zodiacController,
        enabled: false,
        suffixIcon: SvgPicture.asset(
          DIcons.expand,
          height: 24,
          width: 24,
          color: getColor().colorPrimary,
        ),
        textStyle: textTheme(context).subText.colorPrimary,
      ),
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (_) => DropdownZodiacWidget(
                  getDropdown: model.commonRepository.getZodiac,
                  items: model.listItems,
                  titleContentPopUp: Strings.zodiac.localize(context),
                  onSelected: (value) {
                    model.zodiacController.text = value.name!;
                    model.zodiacValue = value;
                  },
                  initValue: model.zodiacController.text,
                ),
            backgroundColor: Colors.transparent,
            isScrollControlled: true);
      },
    );
  }

  Widget _buildSogiesc() {
    return StreamBuilder<List<Sogiesc>>(
        initialData: [],
        stream: model.sogiescValueSubject.stream,
        builder: (context, snapshot) {
          return SogiescTagScreen<Sogiesc>(
            snapshot.data!,
            model.sogiescController,
            model.listSogiesc,
            (value) {
              return value.name!;
            },
            leftTitle: Strings.sogiesc.localize(context),
            rightTitle: null,
            hintText: Strings.input.localize(context) +
                " " +
                Strings.sogiescCap.localize(context),
            onDelete: (s) {
              model.sogiescsValue.remove(s);
              model.sogiescValueSubject.sink.add(model.sogiescsValue);
              model.sogiescController.clear();
              model.setTextSogiescs(model.sogiescsValue);
            },
            onSelect: (value) {
              bool check = true;
              for (int i = 0; i < model.sogiescsValue.length; i++) {
                if (value.name == model.sogiescsValue[i].name) {
                  check = false;
                  break;
                }
              }
              if (!check) {
                showToast(Strings.alreadyExist.localize(context));
              } else {
                model.sogiescsValue.add(value);
              }
              model.sogiescValueSubject.sink.add(model.sogiescsValue);
              model.sogiescController.clear();
              model.setTextSogiescs(model.sogiescsValue);
            },
          );
        });
  }

  // Widget _buildSogiesc() {
  //   return InkWell(
  //     child: StreamBuilder<List<String>>(
  //         initialData: [],
  //         stream: model.sogiescSubject.stream,
  //         builder: (context, snapshot) {
  //           return BuildSogiescScreen(
  //             snapshot.data,
  //             textController: model.sogiescController,
  //             leftTitle: Strings.sogiesc.localize(context),
  //             rightTitle: null,
  //             hintText: Strings.sogiesc.localize(context),
  //           );
  //         }),
  //     onTap: () {
  //       showModalBottomSheet(
  //           context: context,
  //           builder: (_) => DropdownSogiescWidget(
  //                 getDropdown: model.commonRepository.getSogiesc,
  //                 items: model.listSogiesc,
  //                 titleContentPopUp: Strings.sogiesc.localize(context),
  //                 onSelected: (value) {
  //                   model.sogiescsValue = value;
  //                   model.sogiescController.clear();
  //                   model.setTextSogiescs(model.sogiescsValue);
  //                 },
  //                 initItems: model.sogiescsValue,
  //               ),
  //           backgroundColor: Colors.transparent,
  //           isScrollControlled: true);
  //     },
  //   );
  // }

  Widget _buildRelationship() {
    return InkWell(
      child: DTextFromField(
        strokeColor: getColor().underlineClearTextField,
        leftTitle: Strings.relationship.localize(context),
        hintText: Strings.relationship.localize(context),
        controller: model.relationshipController,
        enabled: false,
        suffixIcon: SvgPicture.asset(
          DIcons.expand,
          height: 24,
          width: 24,
          color: getColor().colorPrimary,
        ),
        textStyle: textTheme(context).subText.colorPrimary,
      ),
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (_) => DropdownRelationshipWidget(
                  getDropdown: model.commonRepository.getRelationship,
                  items: model.listRelationship,
                  titleContentPopUp: Strings.status.localize(context),
                  onSelected: (value) {
                    model.relationshipController.text = value.name!;
                    model.relationshipValue = value;
                  },
                  initValue: model.relationshipController.text,
                ),
            backgroundColor: Colors.transparent,
            isScrollControlled: true);
      },
    );
  }

  Widget _buildGender() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: DropDownListWidget(
            titleDropdown: Strings.gender.localize(context),
            titleContentPopUp: Strings.gender.localize(context),
            initValue: model.user.gender?.name?.localize(context) ?? "",
            items: model.genders.map((e) => e.name!.localize(context)).toList(),
            onSelected: (index) {
              model.user.gender = model.genders[index];
              //    isValidatedInfo();
            },
          ),
        ),
        SizedBox(
          width: 40,
        ),
        Expanded(
          child: DropDownListWidget(
            titleDropdown: Strings.find.localize(context),
            titleContentPopUp: Strings.gender.localize(context),
            initValue: model.user.followGenders!.length == 2
                ? Strings.both.localize(context)
                : model.user.followGenders![0].name!.localize(context),
            items: model.lookingForGenders
                .map((e) => e.length == 2
                    ? Strings.both.localize(context)
                    : e[0].name!.localize(context))
                .toList(),
            onSelected: (index) {
              model.user.followGenders = model.lookingForGenders[index];
              //  isValidatedInfo();
            },
          ),
        )
      ],
    );
  }

  Widget _buildCity() {
    return DropDownCityWidget(
      initCity: model.user.province,
      onItemSelected: (city) {
        model.user.province = city;
        // isValidatedInfo();
      },
    );
  }

  Widget _buildHeightWeight() {
    return DropDownHeightWeightWidget(
      initHeight: model.user.height!,
      initWeight: model.user.weight!,
      onSelected: (height, weight) {
        model.user.height = height;
        model.user.weight = weight;
      },
    );
  }

  Widget _buildDateOfBirth() {
    DateTime now = DateTime.now();
    return DropdownDatePickerWidget(
      titleContentPopUp: Strings.dateOfBirth.localize(context),
      titleDropdown: Strings.dateOfBirth.localize(context),
      onDateSelected: (date) {
        model.user.birthday = date;
        //   isValidatedInfo();
      },
      minDate: minDate,
      maxDate: DateTime(now.year - MIN_YEAR_OLD_USED_APP, now.month, now.day,
          now.hour, now.minute, now.second),
      initialDateTime: model.user.birthday,
    );
  }

  Widget _buildConfirmAge() {
    return Row(
      children: [
        CheckBoxWidget(
          onCheckChanged: (checked) {
            model.isCheckPolicy = checked;
            // isValidatedInfo();
          },
        ),
        SizedBox(
          width: 10,
        ),
        _buildConfirm(),
      ],
    );
  }

  Widget _buildConfirm() {
    return Expanded(
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
                text: Strings.confirmLomoPolicy.localize(context),
                style: textTheme(context).text14Normal.colorDart),
            WidgetSpan(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, Routes.webView,
                      arguments: WebViewArguments(
                          url: Strings.termLink.localize(context)));
                },
                child: Text(
                  Strings.lomoPolicy.localize(context),
                  style: textTheme(context).text14Normal.semiBold.colorDart,
                ),
              ),
            ),
            TextSpan(
                text: Strings.LOMO.localize(context),
                style: textTheme(context).text14Normal.colorDart),
          ],
        ),
        textAlign: TextAlign.start,
      ),
    );
  }

  bool isValidatedInfo() {
    if ((model.user.avatar == null || model.user.avatar == "") &&
        model.avatar.value == null) {
      showError(Strings.pleaseChooseAvatar.localize(context));
      return false;
    }
    if (model.tecUserName.text == "") {
      showError(Strings.pleaseEnterName.localize(context));
      return false;
    }

    if (model.tecEmail.text == "") {
      showError(Strings.pleaseEnterEmail.localize(context));
      return false;
    }

    if (model.tecEmail.text.trim() != "" &&
        !validateEmail(model.tecEmail.text.trim())) {
      showError(Strings.invalidEmail.localize(context));
      return false;
    }

    if (model.user.birthday == null) {
      showError(Strings.pleaseChooseBirthDate.localize(context));
      return false;
    }

    if (model.user.province == null) {
      showError(Strings.pleaseChooseProvince.localize(context));
      return false;
    }

    if (widget.args.initProfile && !model.isCheckPolicy) {
      showError(Strings.pleaseConfirmPolicy.localize(context));
      return false;
    }
    // model.validatedInfo.value =
    //     ((model.user?.avatar != null && model?.user?.avatar != "") ||
    //             model.avatar.value != null) &&
    //         model.tecUserName.text != "" &&
    //         model.user?.gender != null &&
    //         model.user?.followGenders != null &&
    //         (model.isCheckPolicy || widget.args.initProfile == false);
    return true;
  }

  Widget _buildFinishButton() {
    return PrimaryButton(
      text: Strings.complete.localize(context),
      // enable: model.validatedInfo,
      onPressed: () async {
        if (isValidatedInfo()) {
          showLoading();
          await model.updateProfile(
              model.tecUserName.text,
              model.tecEmail.text.trim(),
              model.tecCaption.text,
              model.zodiacValue!,
              model.sogiescsValue,
              model.relationshipValue!,
              [model.careerValue!],
              model.literacyValue!);
          if (model.progressState == ProgressState.success) {
            if (widget.args.initProfile) {
              hideLoading();
              showThanksPopup();
            } else {
              updateProfileSuccess();
            }
          } else if (model.progressState == ProgressState.error) {
            hideLoading();
            showError(model.errorMessage!.localize(context));
          }
        }
      },
    );
  }

  updateProfileSuccess() {
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
  }

  showThanksPopup() async {
    showDialog(
        context: context,
        builder: (context) => LoadingDialogWidget(
              title: Strings.thanksForRegisterLomo.localize(context),
              description: Strings.connectFriendAndFindOther.localize(context),
            ),
        barrierDismissible: false);
    _startTime = 3;
    _timer = new Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (_startTime < 1) {
        timer.cancel();
        Navigator.pop(context);
        model.updateProfileSuccess();
      } else {
        _startTime = _startTime - 1;
      }
    });
  }

  Widget _buildStory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          Strings.story.localize(context),
          style: textTheme(context).caption!.bold.colorDart,
        ),
        SizedBox(
          height: 12,
        ),
        Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: getColor().backgroundSearch),
          child: TextField(
            controller: model.tecCaption,
            autofocus: false,
            style: textTheme(context).caption!.captionNormal.colorDart,
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: Strings.introduceYourself.localize(context),
            ),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    // _timer.cancel();
    super.dispose();
  }
}
