import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/eventbus/my_newfeed_scroll_event.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/colors.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/profile/profile_file/profile_file_screen.dart';
import 'package:lomo/ui/profile/profile_model.dart';
import 'package:lomo/ui/profile/profile_view.dart';
import 'package:lomo/ui/widget/action_follow_avatar_widget.dart';
import 'package:lomo/ui/widget/bear/give_bear_widget.dart';
import 'package:lomo/ui/widget/bottom_sheet_widgets.dart';
import 'package:lomo/ui/widget/dialog_widget.dart';
import 'package:lomo/ui/widget/round_underline_tabindicator.dart';
import 'package:lomo/ui/widget/tabbar_color_widget.dart';
import 'package:lomo/ui/widget/user_info_widget.dart';
import 'package:lomo/util/common_utils.dart';
import 'package:lomo/util/handle_link_util.dart';
import 'package:lomo/util/platform_channel.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../util/constants.dart';
import '../base/base_model.dart';
import '../report/report_screen.dart';
import 'mypost/my_post_screen.dart';

class ProfileScreen extends StatefulWidget {
  final UserInfoAgrument userInfoAgrument;

  ProfileScreen(this.userInfoAgrument);

  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends BaseState<ProfileModel, ProfileScreen>
    with
        AutomaticKeepAliveClientMixin<ProfileScreen>,
        SingleTickerProviderStateMixin {
  late ScrollController scrollController;
  double toolBarHeight = 56;
  late double collapsePercent;
  bool stream = false;
  bool stop = false;
  double width = 0;
  double expandedHeightDefault = 0;
  BehaviorSubject<bool> scrollListenerStreamController =
      BehaviorSubject<bool>();

  late AnimationController animationSentBearController;

  Duration animationTime = Duration(seconds: 1);
  final List<ProfileMenu> menuMoreItems = ProfileMenu.values;
  final List<MyProfileMenu> myProfileMoreItem = MyProfileMenu.values;
  final List<MyProfileMenuNotDating> myProfileMoreItemNotDating =
      MyProfileMenuNotDating.values;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    expandedHeightDefault = Platform.isIOS ? 360 : 380;
    return model.user.isMe
        ? ChangeNotifierProvider.value(
            value: locator<UserModel>(),
            child: Consumer<UserModel>(
              builder: (context, userModel, child) {
                model.user = userModel.user!;
                return super.buildContent();
              },
            ),
          )
        : super.buildContent();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    scrollListenerStreamController.close();
    animationSentBearController.dispose();
  }

  initScrollListener() {
    scrollController = ScrollController()
      ..addListener(() {
        collapsePercent = getAppBarCollapsePercent(scrollController.offset);
        if (collapsePercent > 0.9) {
          stream = true;
          if (stop != stream) {
            stop = !stop;
            scrollListenerStreamController.sink.add(stream);
          }
        } else {
          stream = false;
          if (stop != stream) {
            stop = !stop;
            scrollListenerStreamController.sink.add(stream);
          }
        }
        eventBus.fire(MyNewFeedScrollEvent(stop));
      });
  }

  double getAppBarCollapsePercent(double offset) {
    if (!scrollController.hasClients) {
      return 0.0;
    }
    return (offset /
            (((MediaQuery.of(context).size.width) / 1.4) - toolBarHeight))
        .clamp(0.0, 1.0);
  }

  @override
  void initState() {
    super.initState();
    model.init(widget.userInfoAgrument.user);
    initScrollListener();
    animationSentBearController = AnimationController(
      duration: animationTime,
      vsync: this,
    );
    getUserDetail();
  }

  getUserDetail() async {
    try {
      await model.getUserDetailData();
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
  Widget buildContentView(BuildContext context, ProfileModel model) {
    return Scaffold(
        body: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        DefaultTabController(
            length: 2,
            child: Scaffold(
              body: NestedScrollView(
                  controller: scrollController,
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverOverlapAbsorber(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                        sliver: SliverSafeArea(
                          top: false,
                          bottom: false,
                          sliver: SliverAppBar(
                            systemOverlayStyle: SystemUiOverlayStyle.dark,
                            leading: widget.userInfoAgrument.isBack
                                ? StreamBuilder<bool>(
                                    initialData: false,
                                    stream:
                                        scrollListenerStreamController.stream,
                                    builder: (context, snap) {
                                      return InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                left: Dimens.spacing16),
                                            child: Image.asset(
                                              DImages.backWhite,
                                              width: 40,
                                              height: 40,
                                              color: snap.data!
                                                  ? getColor().colorDart
                                                  : getColor().white,
                                            ),
                                          ));
                                    },
                                  )
                                : null,
                            actions: [
                              StreamBuilder<bool>(
                                  stream: scrollListenerStreamController.stream,
                                  builder: (context, snapshot) {
                                    var isScrollTop = snapshot.data != null
                                        ? snapshot.data
                                        : false;
                                    return model.user.isMe
                                        ? _buildCheckCreateDating(isScrollTop!)
                                        : _buildButtonUserMore(isScrollTop!);
                                  })
                            ],
                            title: StreamBuilder<bool>(
                              initialData: false,
                              stream: scrollListenerStreamController.stream,
                              builder: (context, snap) {
                                return Visibility(
                                    visible: snap.data!, child: _userInfo());
                              },
                            ),
                            centerTitle: false,
                            backgroundColor: DColors.whiteColor,
                            floating: false,
                            pinned: true,
                            expandedHeight: model.user.story != null &&
                                    model.user.story!.isNotEmpty
                                ? expandedHeightDefault +
                                    model.getHeightStoryView(
                                        model.user.story ?? "")
                                : expandedHeightDefault,
                            forceElevated: innerBoxIsScrolled,
                            elevation: 0,
                            flexibleSpace: FlexibleSpaceBar(
                              background: ProfileView(
                                user: model.user,
                                isShowBack: widget.userInfoAgrument.isBack,
                                profileModel: model,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ];
                  },
                  body: Column(
                    children: [
                      ColoredTabBar(
                        TabBar(
                          isScrollable: true,
                          physics: AlwaysScrollableScrollPhysics(),
                          indicatorColor: getColor().colorPrimary,
                          unselectedLabelColor: getColor().grayBorder,
                          labelColor: getColor().darkTextColor,
                          labelStyle: textTheme(context).text15.bold,
                          unselectedLabelStyle: textTheme(context).text13.bold,
                          tabs: [
                            Tab(
                              text: Strings.postTimeline.localize(context),
                            ),
                            Tab(
                              text: Strings.file.localize(context),
                            ),
                          ],
                          indicator: RoundUnderlineTabIndicator(
                              borderSide: BorderSide(
                                width: 3,
                                color: DColors.primaryColor,
                              ),
                              paddingBottom: 6),
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          physics: AlwaysScrollableScrollPhysics(),
                          children: [
                            MyPostScreen(model.user),
                            FileScreen(
                              user: model.user,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            )),
        Align(
            alignment: Alignment.bottomRight,
            child: !model.user.isMe
                ? ChangeNotifierProvider.value(
                    value: model,
                    child: Consumer<ProfileModel>(
                        builder: (context, mModel, child) => Container(
                              width: 60,
                              height: 60,
                              margin: EdgeInsets.only(bottom: 66, right: 16),
                              child: GiveBearWidget(
                                  model.user.id!, mModel.displaySentBear.value),
                            )),
                  )
                : SizedBox(
                    width: 0,
                    height: 0,
                  )),
      ],
    ));
  }

  Widget _buildButtonUserMore(bool isSrollTop) {
    var menuProfile = menuMoreItems
        .where((element) => element != ProfileMenu.unFollow)
        .toList();
    if (!canOpenChatWith(model.user.id)) {
      menuProfile.remove(ProfileMenu.sendMessage);
    }

    return BottomSheetMenuWidget(
      items: menuProfile.map((e) => e.name).toList(),
      onItemClicked: (index) async {
        switch (menuProfile[index]) {
          case ProfileMenu.report:
            Navigator.pushNamed(context, Routes.report,
                arguments: ReportScreenArgs(user: model.user));
            break;
          case ProfileMenu.block:
            showDialog(
                context: context,
                builder: (context) => TwoButtonDialogWidget(
                      title: Strings.blockThisUser.localize(context),
                      description: Strings.blockedUserContent.localize(context),
                      onConfirmed: () {
                        callApi(callApiTask: () async {
                          await model.block(model.user);
                          showToast(Strings.blockSuccess.localize(context));
                        });
                      },
                    ));
            break;
          case ProfileMenu.share:
            locator<HandleLinkUtil>().shareProfile(model.user.id!);
            break;
          case ProfileMenu.sendMessage:
            locator<PlatformChannel>()
                .openChatWithUser(locator<UserModel>().user!, model.user);
            break;
          case ProfileMenu.cancel:
            break;
          default:
            break;
        }
      },
      child: Container(
        padding: EdgeInsets.only(right: Dimens.spacing16),
        child: Image.asset(
          DImages.more,
          height: Dimens.size40,
          width: Dimens.size40,
          color: isSrollTop ? getColor().colorDart : getColor().white,
        ),
      ),
    );
  }

  Widget _buildButtonMyProfileMore(bool isSrollTop) {
    final menuItems = myProfileMoreItem.toList();

    return BottomSheetMenuWidget(
      items: menuItems.map((e) => e.name).toList(),
      onItemClicked: (index) async {
        switch (menuItems[index]) {
          case MyProfileMenu.setting:
            Navigator.pushNamed(context, Routes.settingScreen);
            break;
          case MyProfileMenu.share:
            locator<HandleLinkUtil>().shareProfile(model.user.id!);
            break;
          case MyProfileMenu.datingProfile:
            Navigator.pushNamed(context, Routes.datingUserDetail,
                arguments: locator<UserModel>().user);
            break;
          case MyProfileMenu.cancel:
            break;
          default:
            break;
        }
      },
      child: Container(
        padding: EdgeInsets.only(right: Dimens.spacing16),
        child: Image.asset(
          DImages.more,
          height: Dimens.size40,
          width: Dimens.size40,
          color: isSrollTop ? getColor().colorDart : getColor().white,
        ),
      ),
    );
  }

  Widget _userInfo() {
    return Container(
      child: ValueListenableProvider.value(
        value: model.avatar,
        child: Consumer<String?>(
          builder: (context, avatarFile, child) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildRemoteImage(),
              SizedBox(
                width: 13,
              ),
              Text(
                model.user.name?.localize(context) ?? "",
                style: textTheme(context).text15.bold.darkTextColor,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRemoteImage() {
    return CircleImageAvatarWidget(
      avatarSize: 38,
      user: model.user,
      canViewDetailUser: true,
      padding: 1.0,
    );
  }

  Widget _buildCheckCreateDating(bool isSrollTop) {
    return model.user.datingImages!.isNotEmpty
        ? _buildButtonMyProfileMore(isSrollTop)
        : _buildButtonMyProfileMoreNotDating(isSrollTop);
  }

  Widget _buildButtonMyProfileMoreNotDating(bool isSrollTop) {
    final menuItems = myProfileMoreItemNotDating.toList();

    return BottomSheetMenuWidget(
      items: menuItems.map((e) => e.name).toList(),
      onItemClicked: (index) async {
        switch (menuItems[index]) {
          case MyProfileMenuNotDating.setting:
            Navigator.pushNamed(context, Routes.settingScreen);
            break;
          case MyProfileMenuNotDating.share:
            locator<HandleLinkUtil>().shareProfile(model.user.id!);
            break;
          case MyProfileMenuNotDating.cancel:
            break;
          default:
            break;
        }
      },
      child: Container(
        padding: EdgeInsets.only(right: Dimens.spacing16),
        child: Image.asset(
          DImages.more,
          height: Dimens.size40,
          width: Dimens.size40,
          color: isSrollTop ? getColor().colorDart : getColor().white,
        ),
      ),
    );
  }

  @override
  bool get isSliverOverlapAbsorber => true;

  @override
  bool get wantKeepAlive => true;
}

enum MyProfileMenu { setting, share, datingProfile, cancel }

extension MyProfileMenuExt on MyProfileMenu {
  String get name {
    switch (this) {
      case MyProfileMenu.setting:
        return Strings.settings;
      case MyProfileMenu.share:
        return Strings.shareProfile;
      case MyProfileMenu.datingProfile:
        return Strings.myDatingProfile;
      case MyProfileMenu.cancel:
        return Strings.close;
    }
  }
}

enum MyProfileMenuNotDating { setting, share, cancel }

extension MyProfileMenuNotDatingExt on MyProfileMenuNotDating {
  String get name {
    switch (this) {
      case MyProfileMenuNotDating.setting:
        return Strings.settings;
      case MyProfileMenuNotDating.share:
        return Strings.shareProfile;
      case MyProfileMenuNotDating.cancel:
        return Strings.close;
    }
  }
}

enum ProfileMenu { report, block, share, sendMessage, unFollow, cancel }

extension ProfileMenuExt on ProfileMenu {
  String get name {
    switch (this) {
      case ProfileMenu.report:
        return Strings.report;
      case ProfileMenu.block:
        return Strings.block;
      case ProfileMenu.share:
        return Strings.shareProfile;
      case ProfileMenu.sendMessage:
        return Strings.sendMessage;
      case ProfileMenu.unFollow:
        return Strings.unFollow;
      case ProfileMenu.cancel:
        return Strings.close;
    }
  }
}
