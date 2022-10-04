import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/dating/verify_dating_image/verify_dating_image_screen.dart';
import 'package:lomo/ui/widget/image_widget.dart';
import 'package:lomo/ui/widget/line_indicator_widget.dart';
import 'package:lomo/ui/widget/photos_view_page.dart';
import 'package:lomo/ui/widget/say_hi_button.dart';
import 'package:lomo/ui/widget/user_info_widget.dart';
import 'package:lomo/ui/widget/who_suits_me_button.dart';
import 'package:lomo/util/constants.dart';
import 'package:provider/provider.dart';

import '../../base/base_model.dart';
import '../../widget/dialog_widget.dart';
import '../user_dating_basic_info_widget.dart';
import 'dating_user_detail_model.dart';

class DatingUserDetailScreen extends StatefulWidget {
  final User user;

  DatingUserDetailScreen(this.user);

  @override
  State<StatefulWidget> createState() => _DatingUserDetailScreenState();
}

class _DatingUserDetailScreenState
    extends BaseState<DatingUserDetailModel, DatingUserDetailScreen> {
  late double widthOwnerImageItem;
  final ratioOwnerImageItem = 390.0 / 300.0;
  final ratioGuestImageItem = 500.0 / 375.0;

  @override
  void initState() {
    super.initState();
    model.init(widget.user);
    getUserDetail();
  }

  getUserDetail() async {
    try {
      await model.getUserDetail();
      if (model.progressState == ProgressState.error) {
        if (model.apiErrorCod == ApiCodType.userNotFound) {
          model.setUserToDeleted(context);
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (_) => WillPopScope(
              onWillPop: () async => false,
              child: OneButtonDialogWidget(
                description: model.errorMessage?.localize(context),
                onConfirmed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          );
        } else {
          showError(model.errorMessage!.localize(context));
        }
      }
    } catch (e) {}
  }

  @override
  Widget buildContentView(BuildContext context, DatingUserDetailModel model) {
    widthOwnerImageItem = MediaQuery.of(context).size.width * 300 / 375.0;
    return model.user.isMe
        ? Scaffold(
            appBar: _buildOwnerAppBar(),
            body: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildOwnerHeader(),
                  SizedBox(
                    height: 20,
                  ),
                  _buildBodyContent(),
                ],
              ),
            ),
          )
        : Scaffold(
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildGuestHeader(),
                      SizedBox(
                        height: 20,
                      ),
                      _buildBodyContent(),
                    ],
                  ),
                ),
                _buildGuestAppBar()
              ],
            ),
          );
  }

  Widget _buildBodyContent() {
    return Padding(
      padding: EdgeInsets.only(left: 15, bottom: 20, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserDatingBasicInfoWidget(
            model.user,
            isShowMenuButton: !model.user.isMe,
            onUserInfoClicked: (user) {
              if (!user.isMe)
                Navigator.pushNamed(context, Routes.profile,
                    arguments: UserInfoAgrument(user));
            },
          ),
          SizedBox(
            height: 15,
          ),
          _buildSogiesc(model.user),
          SizedBox(
            height: 10,
          ),
          Text(
            model.user.quote ?? "",
            style: textTheme(context).text13.colorDart,
          ),
          SizedBox(
            height: 8,
          ),
          if (!model.user.fieldDisabled!
              .contains(UserDatingFieldDisabled.datingTitle))
            _buildInformationItem(DImages.nameDart,
                Strings.titleName.localize(context), model.user.title?.name),
          if (!model.user.fieldDisabled!
              .contains(UserDatingFieldDisabled.datingRole))
            _buildInformationItem(DImages.roleDart,
                Strings.role.localize(context), model.user.role?.name),
          if (!model.user.fieldDisabled!
              .contains(UserDatingFieldDisabled.datingZodiac))
            _buildInformationItem(DImages.zodiacDart,
                Strings.zodiac.localize(context), model.user.zodiac?.name),
          if (!model.user.fieldDisabled!
              .contains(UserDatingFieldDisabled.datingHeightWeight))
            _buildInformationItem(
                DImages.handwGrey,
                Strings.heightWeight.localize(context),
                model.user.height != 0 && model.user.weight != 0
                    ? "${model.user.height} cm, ${model.user.weight} kg"
                    : null),
          if (!model.user.fieldDisabled!
              .contains(UserDatingFieldDisabled.datingLiteracy))
            _buildInformationItem(DImages.educationDart,
                Strings.literacy.localize(context), model.user.literacy?.name),
          if (!model.user.fieldDisabled!
              .contains(UserDatingFieldDisabled.datingCareers))
            _buildInformationItem(
                DImages.careerDart, Strings.career.localize(context), null,
                itemList: model.user.careers?.map((e) => e.name!).toList()),
          if (!model.user.fieldDisabled!
              .contains(UserDatingFieldDisabled.datingHobbies))
            _buildInformationItem(
                DImages.hobbyDart, Strings.hobby.localize(context), null,
                itemList: model.user.hobbies?.map((e) => e.name!).toList()),
          SizedBox(
            height: 30,
          ),
          if (!model.user.isMe) _buildBottomButton(model.user),
        ],
      ),
    );
  }

  Widget _buildOwnerHeader() {
    return Column(
      children: [
        if (model.user.datingStatus?.id == DatingStatusId.waiting)
          _buildWaitingVerifyButton()
        else if (model.user.datingStatus?.id != DatingStatusId.approved)
          _buildValidateButton(),
        _buildOwnerImages(model.user),
      ],
    );
  }

  Widget _buildGuestHeader() {
    final height = MediaQuery.of(context).size.width * ratioGuestImageItem;
    return SizedBox(
      child: CarouselSlider(
        options: CarouselOptions(
          height: height,
          enableInfiniteScroll: false,
          viewportFraction: 1,
          autoPlay: true,
          aspectRatio: ratioGuestImageItem,
          onPageChanged: (page, reason) {
            model.indicatorStep.value = page;
          },
        ),
        items: model.user.datingImages?.map((image) {
          return Builder(
            builder: (BuildContext context) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PhotosViewPage(
                        images: model.user.datingImages!
                            .map((e) => e.link!)
                            .toList(),
                        firstPage: model.indicatorStep.value,
                        isDating: true,
                        accessToken: model.accessToken,
                        user: model.user,
                      ),
                    ),
                  );
                },
                child: RoundNetworkImage(
                  url: image.link,
                  height: height,
                  width: double.infinity,
                ),
              );
            },
          );
        }).toList(),
      ),
      height: height,
    );
  }

  Widget _buildGuestAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SafeArea(
          child: SizedBox(
        height: 48,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () async {
                Navigator.of(context).maybePop();
              },
              child: Icon(
                Icons.close,
                size: 32,
                color: getColor().white,
              ),
            ),
            LineIndicatorWidget(
                model.user.datingImages?.length ?? 0, model.indicatorStep),
            ValueListenableProvider.value(
              value: model.indicatorStep,
              child: Consumer<int>(
                builder: (context, indicatorStep, child) =>
                    model.user.datingImages?[indicatorStep].isVerify == true
                        ? Image.asset(
                            DImages.datingCheck,
                            height: 32,
                            width: 32,
                          )
                        : SizedBox(
                            width: 32,
                            height: 32,
                          ),
              ),
            )
          ],
        ),
      )),
    );
  }

  AppBar _buildOwnerAppBar() {
    return AppBar(
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
      centerTitle: true,
      title: Text(
        Strings.datingProfile.localize(context),
        style: textTheme(context).text19.colorDart,
      ),
      actions: [
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(right: 15),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: InkWell(
            onTap: () async {
              Navigator.pushNamed(
                  context, Routes.reviewInformationCreateDatingProfile);
            },
            child: Text(
              Strings.edit.localize(context),
              style: textTheme(context).text15.colorViolet,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildValidateButton() {
    return Container(
      margin: EdgeInsets.only(left: 35, right: 50, bottom: 20),
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: getColor().colorBlueECFC),
      child: InkWell(
        splashColor: Colors.transparent,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              DImages.datingCheck,
              height: 36,
              width: 36,
            ),
            Text(
              Strings.verifyDatingProfile.localize(context),
              style: textTheme(context).text15.bold.colorBlue7FF7,
            ),
          ],
        ),
        onTap: () {
          showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (context) => VerifyDatingImageScreen(),
              isScrollControlled: true);
        },
      ),
    );
  }

  Widget _buildWaitingVerifyButton() {
    return Container(
      margin: EdgeInsets.only(left: 35, right: 50, bottom: 20),
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: getColor().gray2eaColor),
      child: Text(
        Strings.waitingVerifyProfileDating.localize(context),
        style: textTheme(context).text15.bold.text9094abColor,
      ),
    );
  }

  Widget _buildOwnerImages(User user) {
    return SizedBox(
      height: widthOwnerImageItem * ratioOwnerImageItem,
      child: ListView.separated(
        physics: AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: user.datingImages?.length ?? 0,
        itemBuilder: (context, imageIndex) => InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PhotosViewPage(
                  images: user.datingImages?.map((e) => e.link!).toList(),
                  firstPage: imageIndex,
                  isDating: true,
                  accessToken: model.accessToken,
                  user: user,
                ),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.only(
                left: 15,
                right: imageIndex == user.datingImages!.length - 1 ? 15 : 0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimens.cornerRadius10)),
            child: Stack(
              children: [
                user.datingImages?[imageIndex].u8List?.isNotEmpty == true
                    ? _buildLocalImage(user, imageIndex)
                    : _buildRemoteImage(user, imageIndex),
                if (user.datingImages?[imageIndex].isVerify == true)
                  Positioned(
                      top: 10,
                      right: 10,
                      child: Image.asset(
                        DImages.datingCheck,
                        height: 36,
                        width: 36,
                      ))
              ],
            ),
          ),
        ),
        separatorBuilder: (BuildContext context, int index) => SizedBox(
          width: 0,
        ),
      ),
    );
  }

  Widget _buildRemoteImage(User user, int imageIndex) {
    return RoundNetworkImage(
      height: widthOwnerImageItem * ratioOwnerImageItem,
      width: widthOwnerImageItem,
      radius: Dimens.cornerRadius10,
      url: user.datingImages?[imageIndex].link ?? "",
    );
  }

  Widget _buildLocalImage(User user, int imageIndex) {
    final u8List = user.datingImages?[imageIndex].u8List;
    return ClipRRect(
      borderRadius: BorderRadius.all(
        Radius.circular(Dimens.cornerRadius10),
      ),
      child: Image.memory(
        u8List!,
        height: widthOwnerImageItem * ratioOwnerImageItem,
        width: widthOwnerImageItem,
      ),
    );
  }

  Widget _buildSogiesc(User user) {
    List<Widget> sogiescWigets = [
      Image.asset(
        DImages.sogiescList,
        height: 24,
        width: 24,
      )
    ];

    user.sogiescs?.forEach((element) {
      sogiescWigets.add(
        Text(
          user.sogiescs?.indexOf(element) != 0
              ? ", ${element.name}"
              : element.name ?? "",
          style: textTheme(context).text13.colorDart.medium,
        ),
      );
    });

    return Wrap(
      children: sogiescWigets,
      crossAxisAlignment: WrapCrossAlignment.center,
    );
  }

  Widget _buildInformationItem(String image, String title, String? content,
      {List<String>? itemList}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Image.asset(
            image,
            height: 24,
            width: 24,
            color: getColor().textColor6cb,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 9),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: title.localize(context),
                    style: textTheme(context).text13.colorDart,
                  ),
                  TextSpan(
                    text: itemList?.isNotEmpty == true
                        ? _buildInformationItemString(itemList!)
                        : content?.isNotEmpty == true
                            ? " $content"
                            : " ${Strings.notYet.localize(context)}",
                    style: textTheme(context).text13.medium.colorDart,
                  ),
                ],
              ),
              textAlign: TextAlign.start,
            ),
          ),
        )
      ],
    );
  }

  String _buildInformationItemString(List<String> items) {
    String result = " ";
    items.forEach((item) {
      if (items.indexOf(item) != items.length - 1) {
        result = result + "$item, ";
      } else {
        result = result + item;
      }
    });
    return result;
  }

  Widget _buildBottomButton(User user) {
    return Row(
      children: [
        Expanded(child: SayHiButton(user)),
        SizedBox(
          width: 15,
        ),
        Expanded(
          child: WhoSuitsMeButton(user),
        ),
      ],
    );
  }
}
