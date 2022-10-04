import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/tracking/tracking_manager.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/libraries/photo_manager/photo_manager.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/base/base_model.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/home/highlight/timeline/item/timeline_item_view.dart';
import 'package:lomo/ui/profile/person/person_highlight_screen.dart';
import 'package:lomo/ui/profile/profile_model.dart';
import 'package:lomo/ui/widget/action_follow_avatar_widget.dart';
import 'package:lomo/ui/widget/button_widgets.dart';
import 'package:lomo/ui/widget/dialog_widget.dart';
import 'package:lomo/ui/widget/follow_user_check_box.dart';
import 'package:lomo/ui/widget/html_view_widget.dart';
import 'package:lomo/ui/widget/image_widget.dart';
import 'package:lomo/ui/widget/who_suits_me_button.dart';
import 'package:lomo/util/common_utils.dart';
import 'package:lomo/util/constants.dart';
import 'package:lomo/util/date_time_utils.dart';
import 'package:lomo/util/new_feed_util.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  final ProfileModel profileModel;
  final User user;
  final bool isShowBack;

  ProfileView({required this.profileModel, required this.user, required this.isShowBack});

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends BaseState<ProfileModel, ProfileView> {
  final List<NewFeedMenu> menuMoreItems = NewFeedMenu.values;
  double width = 0;
  double height = 0;
  double ratio = 3.5;
  double coverHeight = 200;

  @override
  void initState() {
    super.initState();
    if (widget.user.backgroundImage?.isNotEmpty == true)
      model.imageBackgroundSubject.sink.add(widget.user.backgroundImage!);
  }

  @override
  Widget buildContentView(BuildContext context, ProfileModel model) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        children: [
          _buildImageCover(constraints),
          Positioned(
              width: MediaQuery.of(context).size.width,
              top: coverHeight - Dimens.size20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildAvatarNameProvinceCaption(constraints),
                  _buildFollowCandyBear(),
                  if (model.user.story != null && model.user.story!.isNotEmpty) _statusLayout(),
                  model.user.isMe ? _myActionButton(context) : _userActionButton(context),
                ],
              )),
        ],
      );
    });
  }

  Widget _statusLayout() {
    String firstLink = getFirstLinkInContent(widget.user.story);
    return Visibility(
      visible: widget.user.story != null,
      child: Container(
        margin: EdgeInsets.only(left: 16, top: 15, right: 16),
        child: firstLink.isNotEmpty
            ? HtmlViewContent(
                content: widget.user.story!.replaceAll("\n", " "),
                isShowContentLink: true,
                isViewMore: false,
              )
            : Text(
                widget.user.story != null ? widget.user.story!.replaceAll("\n", " ") : "",
                maxLines: 2,
                style: textTheme(context).text14.darkTextColor,
              ),
      ),
    );
  }

  Widget _buildImageCover(BoxConstraints constraints) {
    return SizedBox(
      width: double.infinity,
      height: coverHeight,
      child: StreamBuilder<String?>(
          stream: model.imageBackgroundSubject.stream,
          builder: (context, snapshot) {
            return InkWell(
              onTap: () {
                Navigator.pushNamed(context, Routes.viewDetailImage,
                    arguments: widget.user.backgroundImage);
              },
              child: Align(
                  alignment: Alignment.topCenter,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
                        child: snapshot.data != null && snapshot.data != ""
                            ? RoundNetworkImage(
                                width: double.infinity,
                                height: coverHeight,
                                url: snapshot.data ?? widget.user.cover,
                              )
                            : Image.asset(DImages.iconBackgroundProfile,
                                width: double.infinity, height: coverHeight, fit: BoxFit.cover),
                      ),
                      Container(
                          height: 100,
                          decoration: new BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: <Color>[
                                Colors.black54,
                                Colors.black26,
                                Colors.black12,
                                Colors.transparent
                              ],
                            ),
                          )),
                      if (widget.user.isMe)
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 10, bottom: 10),
                            child: InkWell(
                              child: Image.asset(
                                DImages.editUserPhoto,
                                width: 32,
                                height: 32,
                              ),
                              onTap: () async {
                                await showImagePicker();
                                await handleAfterUpdate();
                              },
                            ),
                          ),
                        )
                    ],
                  )),
            );
          }),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 76,
      height: 76,
      margin: EdgeInsets.only(left: 16),
      child: ValueListenableProvider.value(
        value: model.avatar,
        child: Consumer<String?>(
          builder: (context, avatarFile, child) => Stack(
            children: [
              _buildRemoteImage(),
              if (widget.user.isMe)
                Align(
                  alignment: Alignment.bottomRight,
                  child: InkWell(
                    onTap: () async {
                      await showImagePickerAvatar();
                    },
                    child: Image.asset(
                      DImages.editUserPhoto,
                      width: 32,
                      height: 32,
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarNameProvinceCaption(BoxConstraints constraints) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAvatar(),
            Expanded(
              child: Container(
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.only(left: 12, right: 30, top: 27),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                            constraints: BoxConstraints(minWidth: 40, maxWidth: 240),
                            child: Text(
                              widget.user.name ?? "",
                              style: textTheme(context).text17.bold.colorDart,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )),
                        SizedBox(
                          width: 3,
                        ),
                        if (widget.user.isKol!)
                          Image.asset(
                            DImages.crown,
                            width: 28,
                            height: 28,
                          ),
                      ],
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    if (widget.user.province != null || widget.user.lomoId != null)
                      RichText(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "@${widget.user.lomoId ?? ""}",
                                style: textTheme(context).text14Normal.fontGoogleSans.colorGrayTime,
                              ),
                              if (widget.user.birthday != null &&
                                  !widget.user.fieldDisabled!.contains(UserFieldDisabled.age))
                                TextSpan(
                                  text:
                                      ", ${widget.user.birthday != null ? getAgeFromDateTime(widget.user.birthday!) : ""} ${Strings.age.localize(context).toLowerCase()}",
                                  style:
                                      textTheme(context).text14Normal.fontGoogleSans.colorGrayTime,
                                ),
                            ],
                          )),
                  ],
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildFollowCandyBear() {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: model.user.isMe ? _buildNormalLayoutCandy() : _buildNormalLayoutFollowing(),
          ),
          Container(
            height: 30,
            width: 1,
            color: getColor().colorDivider,
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                PersonHighlightArguments args = PersonHighlightArguments(widget.user);
                Navigator.pushNamed(context, Routes.personHighlight, arguments: args);
              },
              child: _buildFollow(),
            ),
          ),
          Container(
            height: 30,
            width: 1,
            color: getColor().colorDivider,
          ),
          Expanded(
            child: InkWell(
              child: Column(
                children: [
                  ChangeNotifierProvider.value(
                    value: model,
                    child: Consumer<ProfileModel>(
                      builder: (context, childModel, child) => Text("${childModel.totalBear.value}",
                          style: textTheme(context).text15.bold.colorDart,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(Strings.bear.localize(context),
                      style: textTheme(context).text13.text9094abColor,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFollow() {
    return Column(
      children: [
        Text("${widget.user.numberOfFollower ?? 0}",
            style: textTheme(context).text15.bold.colorDart,
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
        SizedBox(
          height: 3,
        ),
        Text(Strings.follow.localize(context),
            style: textTheme(context).text13.text9094abColor,
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
      ],
    );
  }

  Widget _buildNormalLayoutCandy() {
    return InkWell(
      splashColor: Colors.transparent,
      child: Column(
        children: [
          Text("${widget.user.numberOfCandy ?? 0}",
              style: textTheme(context).text15.bold.colorDart,
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          SizedBox(
            width: 3,
          ),
          Text(Strings.candy.localize(context),
              style: textTheme(context).text13.text9094abColor,
              maxLines: 1,
              overflow: TextOverflow.ellipsis)
        ],
      ),
      onTap: () async {
        if (widget.user.isMe) {
          Navigator.pushNamed(context, Routes.profileCandy);
          locator<TrackingManager>().trackMyBad();
        }
      },
    );
  }

  Widget _buildNormalLayoutFollowing() {
    return InkWell(
      splashColor: Colors.transparent,
      child: Column(
        children: [
          Text("${model.user.numberOfFollowing ?? 0}",
              style: textTheme(context).text15.bold.colorDart,
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          SizedBox(
            width: 3,
          ),
          Text(Strings.forFan.localize(context),
              style: textTheme(context).text13.text9094abColor,
              maxLines: 1,
              overflow: TextOverflow.ellipsis)
        ],
      ),
      onTap: () {
        PersonHighlightArguments args = PersonHighlightArguments(model.user, initIndex: 1);
        Navigator.pushNamed(context, Routes.personHighlight, arguments: args);
      },
    );
  }

  showImagePickerAvatar() async {
    try {
      final result = await getImageUint8List(context, isEdit: true);
      if (result != null && result.u8List != null) {
        if (widget.user.isMe) await model.updateAvatar(result.u8List);
      }
    } on Exception catch (e) {
      print(e.toString());
    }

    if (model.progressState == ProgressState.error) {
      showToast(model.errorMessage!.localize(context));
    }
  }

  Widget _buildRemoteImage() {
    return CircleImageAvatarWidget(
      avatarSize: 76,
      user: model.user,
      canViewDetailUser: true,
    );
  }

  Widget _myActionButton(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(left: Dimens.spacing16, top: Dimens.spacing15, right: Dimens.spacing16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () async {
              Navigator.pushNamed(context, Routes.editPersonalProfile, arguments: widget.user);
              locator<TrackingManager>().trackEditProfile();
            },
            child: Container(
              height: 40,
              width: (width - Dimens.spacing16 * 2) - 125,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24), color: getColor().colorPrimary),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    DImages.editWhite,
                    width: 32,
                    height: 32,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    Strings.editProfile.localize(context),
                    style: textTheme(context).text15.bold.colorWhite,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 12,
          ),
          Container(
            width: 108,
            child: Row(
              children: [
                IconButton(
                    iconSize: 40,
                    padding: EdgeInsets.all(0),
                    onPressed: () async {
                      Navigator.pushNamed(context, Routes.profileCandy);
                      locator<TrackingManager>().trackMyBad();
                    },
                    icon: _iconCircle(DImages.iconGiftv2)),
                SizedBox(
                  width: 12,
                ),
                IconButton(
                    iconSize: 40,
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.whoSuitsMeProfile);
                    },
                    icon: _iconCircle(DImages.iconMatching)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconCircle(String icon, {Color? color}) {
    return Container(
      height: 40,
      width: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color ?? getColor().btnBackgroundColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Image.asset(
        icon,
        width: 20,
        height: 20,
      ),
    );
  }

  Widget _followUserLayout(double width) {
    return Container(
      height: 40,
      width: width,
      alignment: Alignment.center,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(24), color: getColor().colorPrimary),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              DImages.addFollow,
              height: 36,
              width: 36,
              color: getColor().white,
            ),
            SizedBox(
              width: 3,
            ),
            Text(
              Strings.btn_follow.localize(context),
              style: textTheme(context).text15.bold.colorWhite,
            )
          ],
        ),
      ),
    );
  }

  Widget _followedUserLayout(double width) {
    return Container(
      height: 40,
      width: width,
      alignment: Alignment.center,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(24), color: getColor().grayBorder),
      child: Center(
          child: Text(
        Strings.watching.localize(context),
        style: textTheme(context).text15.bold.colorWhite,
      )),
    );
  }

  Widget _userActionButton(BuildContext context) {
    var btnWidth = (width - Dimens.spacing16 * 2) - 75;
    return Container(
      padding: EdgeInsets.only(
          left: Dimens.spacing16, top: Dimens.spacing15, right: model.user.isReadQuiz ? 16 : 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FollowUserCheckBox(
            model.user,
            isUnfollowAction: true,
            followedWidget: _followedUserLayout(btnWidth * 0.55),
            followWidget: _followUserLayout(btnWidth * 0.55),
          ),
          SizedBox(
            width: 12,
          ),
          if (canOpenChatWith(model.user.id))
            InkWell(
              onTap: () {
                model.openChat();
              },
              child: Container(
                height: 40,
                width: btnWidth * 0.45,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24), color: getColor().pinkf3eefc),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      DImages.chatv2,
                      width: 32,
                      height: 32,
                      color: getColor().primaryColor,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      Strings.message.localize(context),
                      style: textTheme(context).text15.bold.colorPrimary,
                    ),
                  ],
                ),
              ),
            ),
          SizedBox(
            width: 12,
          ),
          canOpenChatWith(model.user.id)
              ? WhoSuitsMeButton(model.user, isCircle: true)
              : _buildDisableChatQuizButton(btnWidth * 0.55)
        ],
      ),
    );
  }

  Widget _buildDisableChatQuizButton(double width) {
    return SizedBox(
      height: widget.user.isReadQuiz ? 44 : 48,
      width: width,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Padding(
            padding: widget.user.isReadQuiz ? EdgeInsets.all(0) : EdgeInsets.only(top: 4),
            child: RoundedButton(
              padding: EdgeInsets.only(left: 0, right: 0),
              height: Dimens.size44,
              suffixIcon: Image.asset(
                !widget.user.isQuiz ? DImages.suitableMe : DImages.suitableMeDisable,
                height: 20,
                width: 20,
              ),
              color: !widget.user.isQuiz ? getColor().pinkf3eefc : getColor().grayf1f6aColor,
              text: Strings.whoSuitableMe.localize(context),
              textStyle: !widget.user.isQuiz
                  ? textTheme(context).text15.colorPrimary.bold
                  : textTheme(context).text15.colorGrayBorder.bold,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => OneButtonDialogWidget(
                    title: Strings.noQuizYet.localize(context),
                    description: Strings.noQuizYetStatus.localize(context),
                    textConfirm: Strings.understood.localize(context),
                  ),
                );
              },
            ),
          ),
          if (!widget.user.isReadQuiz)
            Container(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 7),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: getColor().colorRedFf6388),
              child: Text(
                Strings.newQuiz.localize(context),
                style: textTheme(context).text10.bold.colorWhite,
              ),
            )
        ],
      ),
    );
  }

  @override
  bool get isSliverOverlapAbsorber => true;

  @override
  ProfileModel createModel() {
    return widget.profileModel;
  }

  showImagePicker() async {
    final photo = await getImageUint8List(context, isEdit: true);
    if (photo == null || photo.u8List == null) return;
    await model.updateBackGroundImage(photo.u8List!);
  }

  handleAfterUpdate() async {
    if (model.progressState == ProgressState.error) {
      showError(model.errorMessage!.localize(context));
    }
  }
}
