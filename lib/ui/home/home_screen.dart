import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lomo/app/app_model.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/api/models/app_config.dart';
import 'package:lomo/data/repositories/common_repository.dart';
import 'package:lomo/data/repositories/notification_repository.dart';
import 'package:lomo/data/tracking/tracking_manager.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/discovery/discovery_screen.dart';
import 'package:lomo/ui/home/center_screen.dart';
import 'package:lomo/ui/home/home_model.dart';
import 'package:lomo/ui/notification/notification_list/notification_list_screen.dart';
import 'package:lomo/ui/profile/profile_screen.dart';
import 'package:lomo/ui/webview/webview_screen.dart';
import 'package:lomo/ui/widget/dialog_new_widget.dart';
import 'package:lomo/ui/widget/dialog_widget.dart';
import 'package:lomo/ui/widget/user_info_widget.dart';
import 'package:lomo/ui/widget/vqmm/dialog_image_and_check_display_widget.dart';
import 'package:lomo/util/common_utils.dart';
import 'package:lomo/util/date_time_utils.dart';
import 'package:lomo/util/handle_link_util.dart';
import 'package:provider/provider.dart';

import 'highlight/higlight_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseState<HomeModel, HomeScreen>
    with SingleTickerProviderStateMixin {
  List<Widget> screens = [
    HighlightScreen(),
    DiscoveryScreen(),
    CenterScreen(),
    NotificationListScreen(),
    ProfileScreen(UserInfoAgrument(locator<UserModel>().user!, isBack: false))
  ];

  bool isShowingBannerEvent = false;

  @override
  void initState() {
    super.initState();
    model.init();
    model.pageController = PageController();
    model.homeContext = context;
    checkDeepLink();
    checkShowEvent();
    model.updateDataLocation();
    Future.delayed(const Duration(seconds: 2), () async {
      checkUpdateApp();
    });
    locator<TrackingManager>().startTrackTime();
  }

  checkDeepLink() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    locator<HandleLinkUtil>().executeDeepLink(context);
    locator<HandleLinkUtil>().addListenerExecuteDeepLink(context);
  }

  checkUpdateApp() async {
    Future.delayed(const Duration(seconds: 2), () async {
      final hasUpdateApp = await isUpdateApp();
      // if (!hasUpdateApp) {
      //   viewCheckin();
      // }
    });
  }

  Future<bool> isUpdateApp() async {
    AppConfig? appConfig = locator<AppModel>().appConfig;
    if (appConfig?.hasFuncUpdateApp == true && appConfig?.isUpdateApp == true) {
      await Future.delayed(Duration(seconds: 1));
      if (appConfig?.isForceUpdate == true) {
        showDialog(
            context: context,
            builder: (context) => WillPopScope(
                  onWillPop: () async => false,
                  child: OneButtonDialogWidget(
                    title: Strings.hasNewVersion.localize(context),
                    description: appConfig?.description ?? "",
                    autoCloseAfterConfirm: false,
                    onConfirmed: () {
                      navigateToStore();
                    },
                    textConfirm: Strings.update.localize(context),
                  ),
                ),
            barrierDismissible: false);
      } else {
        showDialog(
          context: context,
          builder: (context) => TwoButtonDialogWidget(
            title: Strings.hasNewVersion.localize(context),
            description: appConfig?.description ?? "",
            textConfirm: Strings.update.localize(context),
            textCancel: Strings.viewLater.localize(context),
            onConfirmed: () {
              navigateToStore();
            },
          ),
        );
      }
      return true;
    } else {
      return false;
    }
  }

  checkShowCheckIn() async {
    model.getDataCheckin().then((value) => {
          model.showDialogCheckin(value).then((value) => {
                if (value)
                  {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => DialogImageOneButtonWidget(
                              width: 300,
                              height: 300,
                              imagePath: DImages.bannerPopupCheckin,
                              onPressed: () async {
                                locator<TrackingManager>()
                                    .trackConfirmCheckIn();
                                Navigator.pop(context);
                                Navigator.pushNamed(
                                    context, Routes.profileCandy);
                              },
                              onCancel: () async {
                                locator<TrackingManager>().trackDeniedCheckIn();
                              },
                            ))
                  }
              })
        });
  }

  checkShowEvent() async {
    await Future.delayed(Duration(seconds: 1));
    // kiểm tra xem api đã tra appConfig chưa
    // Nếu trả rồi thì kiểm tra và bung vqmm
    if (locator<AppModel>().hasFunctionEvent.value != null) {
      if (locator<AppModel>().hasFunctionEvent.value == true) {
        showPopupEvent();
      } else {
        checkShowCheckIn();
      }
    } // nếu chưa trả api thì listen
    else {
      locator<AppModel>().hasFunctionEvent.addListener(() {
        if (!model.isShowedEvent) {
          showPopupEvent();
        }
      });
    }
  }

  showPopupEvent() {
    model.showDialogCheckEvent().then((value) {
      Size size = MediaQuery.of(context).size;
      double width = (300 / 375) * size.width;
      double height = width + 50;
      if (value) {
        isShowingBannerEvent = true;
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) =>
                DialogImageOneAndCheckDisplayWidget(
                  width: width,
                  height: height,
                  imagePath: locator<AppModel>().appConfig?.bannerEventImage,
                  onPressed: () async {
                    isShowingBannerEvent = false;
                    Navigator.pop(context);
                    locator<HandleLinkUtil>().openEvent();
                  },
                  onCancel: (notShowAgain) async {
                    isShowingBannerEvent = false;
                    if (notShowAgain) {
                      model.commonRepository.setShowVQMM(getDayByTimeStamp(
                          DateTime.now().millisecondsSinceEpoch));
                    }
                    checkShowCheckIn();
                  },
                  selectedCheckBox: (bool) {},
                ));
        model.isShowedEvent = true;
      } else {
        checkShowCheckIn();
      }
    });
  }

  Future<bool> isShowSogiescTest() async {
    await Future.delayed(Duration(seconds: 1));
    final isShowSogiescTest =
        await locator<CommonRepository>().isShowSogiesTest();
    if (locator<AppModel>().appConfig?.hasFuncSogiesTest == true &&
        isShowSogiescTest) {
      showDialog(
          context: context,
          builder: (context) => TwoButtonDialogNewWidget(
                title: Strings.knowYou.localize(context),
                textConfirm: Strings.start.localize(context),
                textCancel: Strings.viewLater.localize(context),
                onCanceled: () {
                  checkShowCheckIn();
                },
                onConfirmed: () {
                  Navigator.pushNamed(context, Routes.webView,
                      arguments: WebViewArguments(
                          url: Strings.sogiesTestLink.localize(context)));
                },
                description: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                          text: Strings.sogiescCap.localize(context),
                          style: textTheme(context).text16.bold.colorDart),
                      TextSpan(
                        text: Strings.sogiescTestFeature.localize(context),
                        style: textTheme(context).text16..colorDart,
                      ),
                      TextSpan(
                          text:
                              Strings.sogiescTestDescription.localize(context),
                          style: textTheme(context).text16.colorDart),
                      TextSpan(
                        text: Strings.sogiescCap.localize(context),
                        style: textTheme(context).text16.bold.colorDart,
                      ),
                      TextSpan(
                        text: Strings.ofYouYet.localize(context),
                        style: textTheme(context).text16.colorDart,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ));
      await locator<CommonRepository>().setShowSogiesTest(false);
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget buildContentView(BuildContext context, HomeModel model) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Consumer<HomeModel>(builder: (context, myModel, child) {
              return PageView(
                  controller: myModel.pageController,
                  physics: new NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    model.onTabChanged(index, refresh: false);
                  },
                  children: screens);
            }),
          ),
        ],
      ),
      bottomNavigationBar:
          Consumer<HomeModel>(builder: (context, myModel, child) {
        return _bottomMenu();
      }),
    );
  }

  Widget _bottomMenu() {
    return Container(
      child: BottomNavigationBar(
        currentIndex: model.tabValue.value,
        selectedItemColor: getColor().colorPrimary,
        unselectedItemColor: getColor().b6b6cbColor,
        type: BottomNavigationBarType.fixed,
        backgroundColor: getColor().white,
        onTap: (index) {
          locator<TrackingManager>().trackHomeTab(index);
          model.onTabChanged(index);
        },
        unselectedFontSize: 10,
        selectedLabelStyle: textTheme(context).text11,
        unselectedLabelStyle: textTheme(context).text11.b6b6cbColor,
        selectedFontSize: 10,
        iconSize: Dimens.size32,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: Strings.highlight.localize(context),
            icon: Image.asset(
              DImages.tabHightLight,
              width: 32,
              height: 32,
            ),
            activeIcon:
                Image.asset(DImages.tabHightLightActive, width: 32, height: 32),
          ),
          BottomNavigationBarItem(
            label: Strings.discovery.localize(context),
            icon: Image.asset(
              DImages.tabDiscovery,
              width: 32,
              height: 32,
            ),
            activeIcon:
                Image.asset(DImages.tabDiscoveryActive, width: 32, height: 32),
          ),
          BottomNavigationBarItem(
            label: Strings.post.localize(context),
            icon: Image.asset(
              DImages.createPost,
              width: 32,
              height: 32,
            ),
          ),
          BottomNavigationBarItem(
            label: Strings.tabNotification.localize(context),
            icon: Stack(
              alignment: Alignment.topRight,
              children: [
                Image.asset(
                  DImages.tabMessage,
                  width: 32,
                  height: 32,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2, right: 2),
                  child: ValueListenableProvider.value(
                    value: locator<NotificationRepository>()
                        .badgeNotificationTabIcon,
                    child: Consumer<int>(
                      builder: (context, numBadge, child) => numBadge > 0
                          ? Container(
                              height: 6,
                              width: 6,
                              margin: EdgeInsets.only(right: 3),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: getColor().colorRedE5597a),
                            )
                          : SizedBox(
                              height: 0,
                            ),
                    ),
                  ),
                )
              ],
            ),
            activeIcon: Stack(
              alignment: Alignment.topRight,
              children: [
                Image.asset(
                  DImages.tabMessageActive,
                  width: 32,
                  height: 32,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2, right: 2),
                  child: ValueListenableProvider.value(
                    value: locator<NotificationRepository>()
                        .badgeNotificationTabIcon,
                    child: Consumer<int>(
                      builder: (context, numBadge, child) => numBadge > 0
                          ? Container(
                              height: 6,
                              width: 6,
                              margin: EdgeInsets.only(right: 3),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: getColor().colorRedE5597a),
                            )
                          : SizedBox(
                              height: 0,
                            ),
                    ),
                  ),
                )
              ],
            ),
          ),
          BottomNavigationBarItem(
            label: Strings.personal.localize(context),
            icon: Image.asset(
              DImages.tabAccount,
              width: 32,
              height: 32,
            ),
            activeIcon: Image.asset(
              DImages.tabAccountActive,
              width: 32,
              height: 32,
            ),
          ),
        ],
      ),
    );
  }
}
