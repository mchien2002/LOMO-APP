import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/libraries/photo_manager/photo_manager.dart';
import 'package:lomo/res/colors.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/base/base_model.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/webview/webview_screen.dart';
import 'package:lomo/ui/widget/bottom_shadow_button_widget.dart';
import 'package:lomo/ui/widget/checkbox_widget.dart';
import 'package:lomo/ui/widget/step_widget.dart';
import 'package:provider/provider.dart';

import 'image_model.dart';

class ImageScreen extends StatefulWidget {
  final User user;

  ImageScreen(this.user);

  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends BaseState<ProfileImageModel, ImageScreen> {
  @override
  void initState() {
    super.initState();
    model.init(widget.user);
  }

  Widget _buildAvatar() {
    return Container(
      height: Dimens.size180,
      width: Dimens.size180,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            Dimens.size90,
          ),
          gradient: LinearGradient(
            colors: [
              DColors.primaryGradientColor4,
              DColors.primaryGradientColor3,
            ],
            begin: const Alignment(0.0, 1.0),
            end: const Alignment(1.0, 0.0),
          )),
      margin: const EdgeInsets.only(bottom: Dimens.spacing8),
      child: ValueListenableProvider.value(
        value: model.avatar,
        child: Consumer<Uint8List?>(
          builder: (context, avatar, child) => GestureDetector(
            onTap: () async {
              showImagePicker();
            },
            child: Stack(
              children: [
                avatar != null ? _buildLocalImage() : _buildRemoteImage(),
                avatar != null ? _buildEditAvatar() : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showImagePicker() async {
    try {
      final photo = await getImageUint8List(context, isEdit: true);
      if (photo != null) model.avatar.value = photo.u8List;
    } on Exception catch (e) {
      print(e.toString());
    }
    isValidatedImage();
  }

  Widget _buildEditAvatar() {
    return Positioned(
      right: 10,
      bottom: 0,
      child: CircleAvatar(
        backgroundColor: DColors.whiteColor,
        child: Container(
          alignment: Alignment.center,
          height: 36,
          width: 36,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: DColors.backCEColor,
              borderRadius: BorderRadius.all(Radius.circular(18))),
          child: Image.asset(
            DImages.capture,
            height: 16,
            width: 16,
            color: getColor().white,
          ),
        ),
      ),
    );
  }

  Widget _buildLocalImage() {
    return Center(
      child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(Dimens.size85)),
          child: Image.memory(
            model.avatar.value!,
            width: Dimens.size170,
            height: Dimens.size170,
            fit: BoxFit.cover,
          )),
    );
  }

  Widget _buildRemoteImage() {
    return Image.asset(
      DImages.uploadAvatar,
      height: Dimens.size180,
      width: Dimens.size180,
    );
  }

  @override
  Widget buildContentView(BuildContext context, ProfileImageModel model) {
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
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: Dimens.paddingBodyContent),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    StepWidget(
                      currentStep: 4,
                      totalStep: 5,
                    ),
                    SizedBox(
                      height: Dimens.spacing30,
                    ),
                    Text(
                      Strings.profile_photo.localize(context),
                      style: textTheme(context).text22.bold.colorDart,
                    ),
                    SizedBox(
                      height: Dimens.spacing10,
                    ),
                    Text(
                      Strings.upload_profile.localize(context),
                      style: textTheme(context).text15.colorGray77,
                    ),
                    SizedBox(
                      height: Dimens.spacing34,
                    ),
                    _buildAvatar(),
                  ],
                ),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildConfirmAge(),
              SizedBox(
                height: 20,
              ),
              BottomOneButton(
                text: Strings.complete.localize(context),
                enable: model.confirmEnable,
                onPressed: () async {
                  showLoading();
                  await model.updateProfile();
                  if (model.progressState == ProgressState.success) {
                    hideLoading();
                    Navigator.of(context)
                        .pushNamed(Routes.enterReferralCode, arguments: true);
                  } else if (model.progressState == ProgressState.error) {
                    hideLoading();
                    showError(model.errorMessage!.localize(context));
                  }
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildConfirmAge() {
    return Row(
      children: [
        SizedBox(
          width: 30,
        ),
        CheckBoxWidget(
          height: 20.0,
          width: 20.0,
          onCheckChanged: (checked) {
            model.isCheckPolicy = checked;
            isValidatedImage();
          },
        ),
        SizedBox(
          width: Dimens.spacing10,
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
                  style: textTheme(context).text14.bold.colorDart,
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

  isValidatedImage() {
    model.confirmEnable.value = model.isCheckPolicy == true;
  }
}
