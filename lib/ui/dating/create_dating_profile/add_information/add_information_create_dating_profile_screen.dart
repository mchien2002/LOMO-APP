import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/dating_image.dart';
import 'package:lomo/libraries/photo_manager/photo_manager.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/widget/button_widgets.dart';
import 'package:lomo/ui/widget/dialog_widget.dart';
import 'package:lomo/ui/widget/gender_widget.dart';
import 'package:lomo/ui/widget/image_widget.dart';
import 'package:lomo/ui/widget/photos_view_page.dart';
import 'package:lomo/ui/widget/role_widget.dart';
import 'package:lomo/ui/widget/sogiesc_list_widget.dart';
import 'package:lomo/ui/widget/step_tabbar_widget.dart';
import 'package:lomo/ui/widget/target_widget.dart';
import 'package:provider/provider.dart';

import 'add_information_create_dating_profile_model.dart';

class AddInformationCreateDatingProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>
      _AddInformationCreateDatingProfileState();
}

class _AddInformationCreateDatingProfileState extends BaseState<
    AddInformationCreateDatingProfileModel,
    AddInformationCreateDatingProfileScreen> {
  double ratioImageItem = 95.0 / 123;
  double widthImageItem = 0;

  @override
  void initState() {
    super.initState();
    model.init();
  }

  @override
  Widget buildContentView(
      BuildContext context, AddInformationCreateDatingProfileModel model) {
    widthImageItem = (MediaQuery.of(context).size.width - 2 * 30 - 2 * 15) / 3;
    return Scaffold(
      appBar: StepAppBar(
        totalStep: 3,
        currentStep: 2,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      Strings.addInformation.localize(context),
                      style: textTheme(context).text22.colorDart.bold,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      Strings.addInformationHint.localize(context),
                      style: textTheme(context).text15.colorGray77,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    _buildImages(),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        Strings.min2PortraiImage.localize(context),
                        style: textTheme(context).text13.colorRedFf6388,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    _buildQuoteDating(),
                    SizedBox(
                      height: 13,
                    ),
                    _buildGender(),
                    SizedBox(
                      height: 13,
                    ),
                    _buildSogiesc(),
                    SizedBox(
                      height: 30,
                    ),
                    _buildRole(),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SafeArea(
                child: PrimaryButton(
                  text: Strings.next.localize(context),
                  enable: model.validateData,
                  onPressed: () async {
                    callApi(
                        callApiTask: model.uploadImages,
                        onSuccess: () {
                          Navigator.pushNamed(context,
                              Routes.findFriendCreateDatingProfileScreen,
                              arguments: model.getUserInfo());
                        });
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildImages() {
    return Container(
      child: ChangeNotifierProvider.value(
        value: model.datingImages,
        child: Consumer<ValueNotifier<List<DatingImage>>>(
          builder: (context, images, child) => GridView.count(
            padding: EdgeInsets.all(0),
            crossAxisCount: 3,
            physics: NeverScrollableScrollPhysics(),
            childAspectRatio: ratioImageItem,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            shrinkWrap: true,
            children: model.datingImages.value
                .map((item) => Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(1),
                      child: Stack(
                        children: [
                          item.u8List?.isNotEmpty == true ||
                                  item.link?.isNotEmpty == true
                              ? item.u8List?.isNotEmpty == true
                                  ? _buildImageLocal(item,
                                      model.datingImages.value.indexOf(item))
                                  : _buildImageRemote(item)
                              : _buildNoImage(
                                  item, model.datingImages.value.indexOf(item)),
                          if (item.u8List != null || item.link != null)
                            _buildDeleteImageButton(item)
                        ],
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteImageButton(DatingImage item) {
    return Positioned(
      top: 3,
      right: 3,
      child: InkWell(
        onTap: () {
          if (item.isVerify == true) {
            showDialog(
                context: context,
                builder: (context) => TwoButtonDialogWidget(
                      title: Strings.changeImage.localize(context),
                      description:
                          Strings.youMustSendVerifyAgain.localize(context),
                      textConfirm: Strings.confirm.localize(context),
                      onConfirmed: () async {
                        final photo = await getImageUint8List(context);
                        if (photo != null) {
                          item.isVerify = false;
                          item.u8List = photo.u8List;
                          model.updateImages();
                          model.isValidateData();
                        }
                      },
                    ));
          } else {
            item.isVerify = false;
            item.link = null;
            item.u8List = null;
            model.updateImages();
            model.isValidateData();
          }
        },
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color:
                  item.isVerify ? getColor().colorPrimary : getColor().white),
          child: item.isVerify
              ? Image.asset(
                  DImages.penWhite,
                  height: 17,
                  width: 17,
                )
              : Image.asset(
                  DImages.closeRed,
                  height: 18,
                  width: 18,
                ),
        ),
      ),
    );
  }

  Widget _buildNoImage(DatingImage image, int index) {
    return DottedBorder(
      color: index > 1 ? getColor().colorGrayE8 : getColor().colorPrimary,
      strokeWidth: 2,
      borderType: BorderType.RRect,
      strokeCap: StrokeCap.butt,
      dashPattern: [10, 4],
      radius: Radius.circular(Dimens.cornerRadius6),
      child: InkWell(
          onTap: () async {
            final photo = await getImageUint8List(context);
            if (photo != null) {
              image.u8List = photo.u8List;
              model.updateImages();
            }
            model.isValidateData();
          },
          child: Container(
            height: double.infinity,
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: index > 1
                ? Icon(
                    Icons.add,
                    size: 30,
                    color: getColor().b6b6cbColor,
                  )
                : Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        DImages.datingPerson,
                        width: 36,
                        height: 36,
                        color: getColor().colorPrimary,
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        Strings.portraitImage.localize(context),
                        style: textTheme(context).text13.medium.colorPrimary,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
          )),
    );
  }

  Widget _buildImageLocal(DatingImage image, int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Dimens.cornerRadius6),
      child: InkWell(
        onTap: () async {
          final imageEdit = await editPhoto(context, image.u8List!);
          if (imageEdit != null) {
            image.u8List = imageEdit;
            model.updateImages();
          }
        },
        child: Image.memory(
          image.u8List!,
          height: widthImageItem / ratioImageItem,
          width: widthImageItem,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildImageRemote(DatingImage image) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PhotosViewPage(
              images: [image.link!],
            ),
          ),
        );
      },
      child: RoundNetworkImage(
        width: widthImageItem,
        height: widthImageItem / ratioImageItem,
        radius: Dimens.cornerRadius6,
        url: image.link,
      ),
    );
  }

  Widget _buildQuoteDating() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          Strings.quoteDating.localize(context),
          style: textTheme(context).text13.bold.colorDart,
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: getColor().colorf0f1f5),
          child: TextField(
            controller: model.tecQuoteDating,
            autofocus: false,
            style: textTheme(context).text13.bold.colorDart,
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            maxLength: 100,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: Strings.enterPersonalIntroduce.localize(context),
              counterStyle: textTheme(context).text13.colorHint,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildGender() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Text(
                    Strings.yourGender.localize(context),
                    style: textTheme(context).text13.bold,
                  ),
                  TargetWidget(),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 6,
        ),
        GenderWidget(
          selectedGender: model.selectedGender.value,
          onGenderSelected: (gender) {
            model.selectedGender.value = gender;
            model.selectedSogiescList?.clear();
            model.isValidateData();
          },
        )
      ],
    );
  }

  // Widget _buildInformationWarning() {
  //   return InkWell(
  //     child: Image.asset(
  //       DImages.informationWarning,
  //       height: 20,
  //       width: 20,
  //     ),
  //   );
  // }

  Widget _buildSogiesc() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Text(
                    Strings.sogiescLabel.localize(context),
                    style: textTheme(context).text13.bold,
                  ),
                  TargetWidget(),
                ],
              ),
            ),
            // Row(
            //   children: [
            //     Text(
            //       Strings.show.localize(context),
            //       style: textTheme(context).text13.colorHint,
            //     ),
            //     SizedBox(
            //       width: 10,
            //     ),
            //     CheckBoxWidget(
            //       initValue: model.isShowSogiesc,
            //       onCheckChanged: (checked) {
            //         model.isShowSogiesc = checked;
            //         model.isValidateData();
            //       },
            //     ),
            //   ],
            // )
          ],
        ),
        SizedBox(
          height: 5,
        ),
        SogiescListWidget(
          model.selectedGender,
          maxItemSelected: 3,
          initSogiescSelected: model.selectedSogiescList,
          onSogiescSelected: (sogiesc) {
            model.selectedSogiescList = sogiesc;
            model.isValidateData();
          },
        ),
      ],
    );
  }

  Widget _buildRole() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                Strings.role.localize(context),
                style: textTheme(context).text13.bold,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 18,
        ),
        RoleWidget(
          selectedRole: model.selectedRole,
          onRoleSelected: (role) {
            model.selectedRole = role;
            model.isValidateData();
          },
        )
      ],
    );
  }
}
