import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/data/eventbus/refresh_dating_user_detail_event.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/dating/verify_dating_image/verify_dating_image_model.dart';
import 'package:lomo/ui/widget/bottom_shadow_button_widget.dart';
import 'package:lomo/ui/widget/dialog_widget.dart';
import 'package:provider/provider.dart';

class VerifyDatingImageScreen extends StatefulWidget {
  final Function()? onSendVerifySuccess;

  VerifyDatingImageScreen({this.onSendVerifySuccess});

  @override
  State<StatefulWidget> createState() => _VerifyDatingImageScreenState();
}

class _VerifyDatingImageScreenState
    extends BaseState<VerifyDatingImageModel, VerifyDatingImageScreen> {
  final picker = ImagePicker();

  @override
  Widget buildContentView(BuildContext context, VerifyDatingImageModel model) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(Dimens.cornerRadius20)),
          color: getColor().white),
      height: MediaQuery.of(context).size.height - 57,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                _buildAppBar(),
                SizedBox(
                  height: 17,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    Strings.verifyImageDatingHint.localize(context),
                    style: textTheme(context).text15.colorGray77,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                _buildVerifyImage(0),
                SizedBox(
                  height: 25,
                ),
                _buildVerifyImage(1),
                SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomOneButton(
              text: Strings.sendRequestVerify.localize(context),
              enable: model.enableButtonSend,
              onPressed: () {
                callApi(
                  callApiTask: model.sendVerifyRequest,
                  onSuccess: () {
                    eventBus.fire(RefreshDatingUserDetail());
                    showDialog(
                      context: context,
                      builder: (context) => TwoButtonDialogWidget(
                        title: Strings.sendRequestSuccess.localize(context),
                        description: Strings.pleaseWaitVerifyDatingImage
                            .localize(context),
                        textConfirm: Strings.datingNow.localize(context),
                        textCancel: Strings.close.localize(context),
                        onConfirmed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SizedBox(
      height: 32,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: InkWell(
              child: Icon(
                Icons.close,
                size: 32,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              Strings.verifyDatingProfile.localize(context),
              style: textTheme(context).text19.bold.colorDart,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildVerifyImage(int imageIndex) {
    return Container(
      height: 204,
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildDefautImage(imageIndex, 123, 95),
          InkWell(
            splashColor: Colors.transparent,
            onTap: () {
              imageIndex == 0
                  ? model.sampleImage1.value = model.getRandomSampleImage()
                  : model.sampleImage2.value = model.getRandomSampleImage();
            },
            child: Image.asset(
              DImages.convert,
              height: 32,
              width: 32,
            ),
          ),
          model.verifyImages[imageIndex].u8List != null
              ? _buildLocalImage(imageIndex, 204, 158)
              : _buildNoImage(imageIndex)
        ],
      ),
    );
  }

  Widget _buildNoImage(int index) {
    return Container(
      height: 204,
      width: 158,
      child: DottedBorder(
        color: getColor().colorPrimary,
        strokeWidth: 1,
        borderType: BorderType.RRect,
        strokeCap: StrokeCap.butt,
        dashPattern: [6, 3],
        radius: Radius.circular(Dimens.cornerRadius6),
        child: InkWell(
            onTap: () async {
              final pickedFile = await picker.getImage(
                  source: ImageSource.camera,
                  preferredCameraDevice: CameraDevice.front);
              if (pickedFile != null) {
                model.verifyImages[index].u8List =
                    File(pickedFile.path).readAsBytesSync();
                model.updateImages();
              }
              model.isValidateData();
            },
            child: Container(
              height: double.infinity,
              width: double.infinity,
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 32,
                    color: getColor().colorPrimary,
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    Strings.portraitImage.localize(context),
                    style: textTheme(context).text13.colorPrimary,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Widget _buildDefautImage(int index, double height, double width) {
    return ClipRRect(
      borderRadius: BorderRadius.all(
        Radius.circular(Dimens.cornerRadius10),
      ),
      child: ValueListenableProvider.value(
        value: index == 0 ? model.sampleImage1 : model.sampleImage2,
        child: Consumer<String>(
          builder: (context, imageResource, child) => Image.asset(
            imageResource,
            height: height,
            width: width,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildLocalImage(int imageIndex, double height, double width) {
    final u8List = model.verifyImages[imageIndex].u8List;
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(Dimens.cornerRadius10),
          ),
          child: Image.memory(
            u8List!,
            height: height,
            width: width,
            fit: BoxFit.cover,
          ),
        ),
        _buildDeleteImageButton(imageIndex)
      ],
    );
  }

  Widget _buildDeleteImageButton(int imageIndex) {
    return Positioned(
      top: 8,
      right: 8,
      child: InkWell(
        onTap: () {
          model.verifyImages[imageIndex].u8List = null;
          model.updateImages();
          model.isValidateData();
        },
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16), color: getColor().white),
          child: Icon(
            Icons.close,
            size: 25,
            color: getColor().pin88Color,
          ),
        ),
      ),
    );
  }
}
