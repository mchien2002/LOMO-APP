import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/data/api/models/constant_list.dart';
import 'package:lomo/data/api/models/sogiesc.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/eventbus/close_suggestion_sogiesc_widget_event.dart';
import 'package:lomo/libraries/photo_manager/photo_manager.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/icons.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/base/base_model.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/update_information/update_info_non_require_model.dart';
import 'package:lomo/ui/update_information/update_info_require_screen.dart';
import 'package:lomo/ui/widget/button_widgets.dart';
import 'package:lomo/ui/widget/dialog_widget.dart';
import 'package:lomo/ui/widget/dropdown_api_widget.dart';
import 'package:lomo/ui/widget/dropdown_height_weight_widget.dart';
import 'package:lomo/ui/widget/information_user/literacy_widget.dart';
import 'package:lomo/ui/widget/sogiesc/sogiesc_hint_widget.dart';
import 'package:lomo/ui/widget/sogiesc/sogiesc_widget.dart';
import 'package:lomo/ui/widget/text_form_field_widget.dart';
import 'package:lomo/util/common_utils.dart';

class UpdateInfoNonRequireArguments {
  bool initProfile;
  User user;
  bool isUpdate;
  List<String> sogiescName;

  UpdateInfoNonRequireArguments(this.user,
      {this.isUpdate = false,
      this.initProfile = false,
      required this.sogiescName});
}

class UpdateInfoNonRequireScreen extends StatefulWidget {
  final UpdateInfoNonRequireArguments args;

  UpdateInfoNonRequireScreen(this.args);

  @override
  State<StatefulWidget> createState() => _UpdateInfoNonRequireScreenState();
}

class _UpdateInfoNonRequireScreenState
    extends BaseState<UpdateInfoNonRequireModel, UpdateInfoNonRequireScreen> {
  late Timer _timer;
  int _startTime = 3;

  @override
  void initState() {
    super.initState();
    model.init(widget.args.user);
    model.tecCaption.text = model.user.story ?? "";
    if (widget.args.sogiescName.isNotEmpty == true) {
      model.isShowTestSogiescSubject.sink.add(true);
    }
  }

  @override
  Widget buildContentView(
      BuildContext context, UpdateInfoNonRequireModel model) {
    return Listener(
      onPointerUp: (e) {
        final rb = context.findRenderObject() as RenderBox;
        final result = BoxHitTestResult();
        rb.hitTest(result, position: e.position);

        final hitTargetIsEditable =
            result.path.any((entry) => entry.target is SogiescSuggestion);

        if (!hitTargetIsEditable) {
          eventBus.fire(CloseSuggestSogiescWidgetEvent());
        }
      },
      child: Scaffold(
        backgroundColor: getColor().white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: getColor().white,
          elevation: 0,
          leading: InkWell(
            onTap: () async {
              Navigator.of(context).maybePop();
            },
            child: Icon(
              Icons.arrow_back_ios,
              size: 25,
              color: getColor().colorDart,
            ),
          ),
          actions: [
            if (widget.args.initProfile)
              Padding(
                padding: EdgeInsets.only(right: 12.0),
                child: InkWell(
                  onTap: () async {
                    if (widget.args.initProfile) {
                      showThanksPopup();
                    } else {
                      Navigator.of(context).maybePop();
                    }
                  },
                  child: Text(
                    Strings.ignore.localize(context),
                    style: textTheme(context).text14Normal.colorDart,
                  ),
                ),
              ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: Dimens.paddingBodyContent),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Text(
                      Strings.personalInformation.localize(context),
                      style: textTheme(context).text26.light.colorPrimary,
                    ),
                  ),
                  SizedBox(
                    height: Dimens.spacing34,
                  ),
                  _buildStory(),
                  SizedBox(
                    height: Dimens.spacing20,
                  ),
                  _buildHeightWeight(),
                  SizedBox(
                    height: Dimens.spacing20,
                  ),
                  _buildHobby(),
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
                  if (!widget.args.initProfile)
                    SizedBox(
                      height: Dimens.spacing20,
                    ),
                  if (!widget.args.initProfile)
                    UpdateToAnotherProfile(
                      content: Strings.wantUpdateAccount.localize(context),
                      isRequire: false,
                    ),
                  SizedBox(
                    height: 30,
                  ),
                  _buildFinishButton(),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
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
                  widget.args.sogiescName,
                  closeWidget: () {
                    model.isShowTestSogiescSubject.sink.add(false);
                  },
                  selectedAdd: () {
                    model.addNowSogiesc(widget.args.sogiescName, context);
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

  showImagePicker() async {
    try {
      final photo = await getImageUint8List(context);
      if (photo != null) model.avatar.value = photo.u8List;
      // isValidatedInfo();
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  Widget _buildlLiteracy() {
    return InkWell(
      child: DTextFromField(
        strokeColor: getColor().underlineClearTextField,
        leftTitle: Strings.literacy.localize(context),
        hintText: Strings.notChoose.localize(context),
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
        hintText: Strings.notChoose.localize(context),
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

  Widget _buildRelationship() {
    return InkWell(
      child: DTextFromField(
        strokeColor: getColor().underlineClearTextField,
        leftTitle: Strings.relationship.localize(context),
        hintText: Strings.notChoose.localize(context),
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

  Widget _buildSogiesc() {
    return StreamBuilder<List<Sogiesc>>(
        initialData: [],
        stream: model.sogiescValueSubject.stream,
        builder: (context, snapshot) {
          return new SogiescTagScreen<Sogiesc>(
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

  Widget _buildCareer() {
    return StreamBuilder<List<KeyValue>>(
        initialData: [],
        stream: model.careerValueSubject.stream,
        builder: (context, snapshot) {
          return new SogiescTagScreen<KeyValue>(
            snapshot.data!,
            model.careerController,
            model.listCareer,
            (value) {
              return value.name!;
            },
            leftTitle: Strings.career.localize(context),
            rightTitle: null,
            hintText: Strings.input.localize(context) +
                " " +
                Strings.career.localize(context).toLowerCase(),
            onDelete: (s) {
              model.careerValue.remove(s);
              model.careerValueSubject.sink.add(model.careerValue);
              model.careerController.clear();
              model.setTextCareer(model.careerValue);
            },
            onSelect: (value) {
              bool check = true;
              for (int i = 0; i < model.careerValue.length; i++) {
                if (value.name == model.careerValue[i].name) {
                  check = false;
                  break;
                }
              }
              if (!check) {
                showToast(Strings.alreadyExist.localize(context));
              } else {
                model.careerValue.add(value);
              }
              model.careerValueSubject.sink.add(model.careerValue);
              model.careerController.clear();
              model.setTextCareer(model.careerValue);
            },
          );
        });
  }

  Widget _buildHobby() {
    return StreamBuilder<List<Hobby>>(
        initialData: [],
        stream: model.hobbyValueSubject.stream,
        builder: (context, snapshot) {
          return new SogiescTagScreen<Hobby>(
            snapshot.data!,
            model.hobbyController,
            model.listHobby,
            (value) {
              return value.name!;
            },
            leftTitle: Strings.hobby.localize(context),
            rightTitle: null,
            hintText: Strings.input.localize(context) +
                " " +
                Strings.hobby.localize(context).toLowerCase(),
            onDelete: (s) {
              model.hobbyValue.remove(s);
              model.hobbyValueSubject.sink.add(model.hobbyValue);
              model.hobbyController.clear();
              model.setTextHobby(model.hobbyValue);
            },
            onSelect: (value) {
              bool check = true;
              for (int i = 0; i < model.hobbyValue.length; i++) {
                if (value.name == model.hobbyValue[i].name) {
                  check = false;
                  break;
                }
              }
              if (!check) {
                showToast(Strings.alreadyExist.localize(context));
              } else {
                model.hobbyValue.add(value);
              }
              model.hobbyValueSubject.sink.add(model.hobbyValue);
              model.hobbyController.clear();
              model.setTextHobby(model.hobbyValue);
            },
          );
        });
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

  Widget _buildFinishButton() {
    return PrimaryButton(
      text: Strings.complete.localize(context),
      // enable: model.validatedInfo,
      onPressed: () async {
        showLoading();
        await model.updateProfile(
            model.tecCaption.text,
            model.zodiacValue!,
            model.sogiescsValue,
            model.relationshipValue!,
            model.careerValue,
            model.literacyValue!,
            model.hobbyValue);
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
          padding: EdgeInsets.only(left: 15, right: 15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: getColor().backgroundSearch),
          child: TextField(
            controller: model.tecCaption,
            autofocus: false,
            style: textTheme(context).text14Normal.colorDart,
            keyboardType: TextInputType.multiline,
            maxLines: 2,
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
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
