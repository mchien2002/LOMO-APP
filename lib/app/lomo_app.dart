import 'dart:io';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lomo/data/api/models/filter_request_item.dart';
import 'package:lomo/data/api/models/gift.dart';
import 'package:lomo/data/api/models/notification_item.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/api/models/who_suits_me_history.dart';
import 'package:lomo/data/tracking/tracking_manager.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/authencation/birthday/birthday_screen.dart';
import 'package:lomo/ui/authencation/display_name/display_name_screen.dart';
import 'package:lomo/ui/authencation/gender/gender_screen.dart';
import 'package:lomo/ui/authencation/image/image_screen.dart';
import 'package:lomo/ui/crop_image/crop_image_screen.dart';
import 'package:lomo/ui/dating/create_dating_profile/add_information/add_information_create_dating_profile_screen.dart';
import 'package:lomo/ui/dating/create_dating_profile/find_friend_create_dating_profile/find_friend_create_dating_profile_screen.dart';
import 'package:lomo/ui/dating/create_dating_profile/review_information/review_information_create_dating_profile_screen.dart';
import 'package:lomo/ui/dating/dating_user_detail/dating_user_detail_screen.dart';
import 'package:lomo/ui/dating/filter/dating_filter_screen.dart';
import 'package:lomo/ui/dating/first_message/first_message_screen.dart';
import 'package:lomo/ui/dating/setting/dating_setting_screen.dart';
import 'package:lomo/ui/dating/who_suits_me/profile/review/review_quiz_result_screen.dart';
import 'package:lomo/ui/dating/who_suits_me/profile/template_question/template_question_screen.dart';
import 'package:lomo/ui/dating/who_suits_me/profile/who_suits_me_profile_screen.dart';
import 'package:lomo/ui/dating/who_suits_me/reply_question/reply_question_screen.dart';
import 'package:lomo/ui/discovery/discovery_screen.dart';
import 'package:lomo/ui/discovery/list_discovery/list_more_hot/list_more_hot_screen.dart';
import 'package:lomo/ui/discovery/list_discovery/list_more_topic/list_more_topic_screen.dart';
import 'package:lomo/ui/discovery/list_more_discovery/list_more_discovery_screen.dart';
import 'package:lomo/ui/discovery/list_more_out_standing/list_more_out_standing_screen.dart';
import 'package:lomo/ui/discovery/list_type_discovery/list_type_discovery_screen.dart';
import 'package:lomo/ui/discovery/newfeed/list_more/discovery_newfeeds_more_screen.dart';
import 'package:lomo/ui/forgot_password/forgot_password_screen.dart';
import 'package:lomo/ui/gift/attendance_every_day/attendance_every_day_screen.dart';
import 'package:lomo/ui/gift/exchange_gift/exchange_gift_screen.dart';
import 'package:lomo/ui/gift/list_more_gift_screen.dart';
import 'package:lomo/ui/gift/send_information_gift/send_information_gift_screen.dart';
import 'package:lomo/ui/home/highlight/fliter_timeline/filter_timeline_screen.dart';
import 'package:lomo/ui/home/highlight/post_detail/post_detail_screen.dart';
import 'package:lomo/ui/home/highlight/post_detail/video_detail_screen.dart';
import 'package:lomo/ui/home/home_screen.dart';
import 'package:lomo/ui/introduce/intro_screen.dart';
import 'package:lomo/ui/login/login_screen.dart';
import 'package:lomo/ui/new_feed/create_new_feed/create_new_feed_screen.dart';
import 'package:lomo/ui/notification/notification_detail/notification_detail_screen.dart';
import 'package:lomo/ui/otp/otp_screen.dart';
import 'package:lomo/ui/profile/person/person_highlight_screen.dart';
import 'package:lomo/ui/profile/person/person_message/person_message_screen.dart';
import 'package:lomo/ui/profile/profile_candy/profile_candy_screen.dart';
import 'package:lomo/ui/profile/profile_manager/profile_detail/profile_detail_screen.dart';
import 'package:lomo/ui/profile/profile_manager/profile_edit/profile_edit_screen.dart';
import 'package:lomo/ui/profile/profile_manager/profile_gender/profile_gender_screen.dart';
import 'package:lomo/ui/profile/profile_screen.dart';
import 'package:lomo/ui/register/register_screen.dart';
import 'package:lomo/ui/report/report_screen.dart';
import 'package:lomo/ui/search/search_screen.dart';
import 'package:lomo/ui/settings/block_user/block_user_screen.dart';
import 'package:lomo/ui/settings/delete_account/delete_account_screen.dart';
import 'package:lomo/ui/settings/privacy/privacy_screen.dart';
import 'package:lomo/ui/settings/setting_screen.dart';
import 'package:lomo/ui/settings/user_setting/user_setting_screen.dart';
import 'package:lomo/ui/update_information/update_info_non_require_screen.dart';
import 'package:lomo/ui/update_information/update_info_require_screen.dart';
import 'package:lomo/ui/update_information/update_information_screen.dart';
import 'package:lomo/ui/video/player/player_screen.dart';
import 'package:lomo/ui/view_image.dart';
import 'package:lomo/ui/webview/webview_screen.dart';
import 'package:lomo/ui/widget/maintenance_widget.dart';
import 'package:lomo/ui/widget/user_info_widget.dart';
import 'package:lomo/ui/widget/vqmm/bubble_button_animation_widget.dart';
import 'package:lomo/util/AppsflyerUtil.dart';
import 'package:lomo/util/firebase_realtime_database_util.dart';
import 'package:lomo/util/handle_link_util.dart';
import 'package:lomo/util/navigator_service.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';
import 'package:provider/provider.dart';

import '../data/eventbus/outside_newfeed_event.dart';
import '../data/eventbus/server_maintenance_event.dart';
import '../ui/notification/notification_voucher_detail/notification_voucher_detail_screen.dart';
import '../ui/referral/enter_referral/enter_referral_screen.dart';
import '../ui/referral/share_referral/share_referral_screen.dart';
import '../ui/widget/loading_widget.dart';
import 'app_model.dart';
import 'localization/app_localizations.dart';
import 'user_model.dart';

class LomoApp extends StatefulWidget {
  @override
  _LomoAppState createState() => _LomoAppState();
}

class _LomoAppState extends State<LomoApp> with WidgetsBindingObserver {
  AppModel _appModel = locator<AppModel>();
  bool isCloseVQMM = false;
  Widget? _maintenancePopup;

  @override
  void initState() {
    super.initState();
    handleBackToRoot();
    _appModel.getBadge();
    locator<AppsflyerUtil>().init();
    WidgetsBinding.instance.addObserver(this);
    locator<FireBaseRealTimeDatabaseUtil>().init();
    handleShowMaintenancePopup();
  }

  handleShowMaintenancePopup() {
    eventBus.on<ServerMaintenanceEvent>().listen((event) {
      if (_maintenancePopup == null) {
        final popupContext =
            locator<NavigationService>().navigatorKey.currentState?.context ??
                context;
        _maintenancePopup = MaintenanceWidget();
        showDialog(
            barrierDismissible: false,
            context: popupContext,
            builder: (_) =>
                _maintenancePopup ??
                Container(
                  color: Colors.transparent,
                ));
      }
    });
  }

  handleBackToRoot() async {
    _appModel.backToRoot.addListener(() {
      locator<NavigationService>()
          .navigatorKey
          .currentState
          ?.popUntil((route) => route.isFirst);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: _appModel),
          ChangeNotifierProvider.value(value: locator<UserModel>()),
          ChangeNotifierProvider.value(value: locator<ThemeManager>()),
          ValueListenableProvider.value(value: _appModel.hasFunctionEvent),
        ],
        child: Consumer3<AppModel, UserModel, ThemeManager>(
          builder: (context, model, userModel, theme, child) {
            return Portal(
              child: MaterialApp(
                navigatorKey: locator<NavigationService>().navigatorKey,
                title: "Lomo",
                theme: theme.themeData,
                debugShowCheckedModeBanner: false,
                localizationsDelegates: [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                navigatorObservers: [NavigationHistoryObserver()],
                supportedLocales: model.supportedLocales,
                locale: model.locale,
                initialRoute: Routes.root,
                onGenerateRoute: (settings) => _getRoute(settings),
                builder: (context, child) {
                  return MediaQuery(
                    child: Stack(
                      children: [
                        child ??
                            Container(
                              width: 0.0,
                              height: 0.0,
                            ),
                        Consumer<bool?>(
                          builder: (context, hasEvent, child) =>
                              hasEvent == true
                                  ? _buildBubbleButtonWidget(context)
                                  : SizedBox(
                                      height: 0,
                                    ),
                        ),
                      ],
                    ),
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.1),
                  );
                },
              ),
            );
          },
        ),
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
    );
  }

  Widget _buildBubbleButtonWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // pos
    Offset _offset =
        Offset(size.width - (size.width / 4), size.height - (size.width / 2.3));

    return Visibility(
        visible: !isCloseVQMM,
        child: BubbleAnimationWidget(
          width: 64,
          offset: _offset,
          onTapClose: () {
            isCloseVQMM = true;
            setState(() {});
          },
          onTap: () {
            locator<HandleLinkUtil>().openEvent();
          },
          imageUrl: locator<AppModel>().appConfig?.iconEventImage ?? "",
        ));
  }

  Route<dynamic> _getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.root:
        return CustomPageRoute(
          settings: RouteSettings(name: Routes.root),
          builder: (_) => _getRootPageRoute(_getRootScreenByAppState()),
        );
      case Routes.login:
        return CustomPageRoute(
          builder: (_) => LoginScreen(),
        );

      case Routes.birthday:
        return CustomPageRoute(
          builder: (_) => BirthdayScreen(
            settings.arguments as User,
          ),
        );
      case Routes.gender:
        return CustomPageRoute(
          builder: (_) => GenderScreen(
            settings.arguments as User,
          ),
        );
      case Routes.image:
        return CustomPageRoute(
          builder: (_) => ImageScreen(
            settings.arguments as User,
          ),
        );
      case Routes.otp:
        return CustomPageRoute(
          builder: (_) => OtpScreen(
            otpType: settings.arguments as OtpType,
          ),
        );
      case Routes.register:
        return CustomPageRoute(
          builder: (_) => RegisterScreen(),
        );
      case Routes.search:
        return CustomPageRoute(
          builder: (_) => SearchScreen(),
        );
      case Routes.createNewFeed:
        return CustomPageRoute(
          builder: (_) => CreateNewFeedScreen(
            agrument: settings.arguments as CreateNewFeedAgrument?,
          ),
        );
      case Routes.forgotPassword:
        return CustomPageRoute(
          builder: (_) => ForgotPasswordScreen(),
        );
      case Routes.home:
        return CustomPageRoute(
          builder: (_) => HomeScreen(),
        );
      case Routes.profile:
        return CustomPageRoute(
          builder: (_) => ProfileScreen(settings.arguments as UserInfoAgrument),
        );
      case Routes.editProfile:
        return CustomPageRoute(
          builder: (_) => UpdateInformationScreen(
              settings.arguments as UpdateInformationArguments),
        );
      case Routes.updateNonRequireProfile:
        return CustomPageRoute(
          builder: (_) => UpdateInfoNonRequireScreen(
              settings.arguments as UpdateInfoNonRequireArguments),
        );
      case Routes.updateRequireProfile:
        return CustomPageRoute(
          builder: (_) => UpdateInfoRequireScreen(
              settings.arguments as UpdateInfoRequireArguments),
        );
      case Routes.settingScreen:
        return CustomPageRoute(
          builder: (_) => SettingScreen(),
        );
      case Routes.discovery:
        return CustomPageRoute(
          builder: (_) => DiscoveryScreen(),
        );
      case Routes.moreDiscovery:
        return CustomPageRoute(
          builder: (_) => ListMoreDiscoveryScreen(
              settings.arguments as ListMoreDiscoveryArguments),
        );
      case Routes.moreTopicHot:
        return CustomPageRoute(
          builder: (_) =>
              ListMoreTopicScreen(settings.arguments as ListMoreTopicArguments),
        );
      case Routes.moreHot:
        return CustomPageRoute(
          builder: (_) => ListMoreHotScreen(
              settings.arguments as ListMoreHotScreenArguments),
        );
      case Routes.morePost:
        return CustomPageRoute(
          builder: (_) => DiscoveryNewFeedsMoreScreen(
              settings.arguments as ListMorePostArguments),
        );
      case Routes.personMessage:
        return CustomPageRoute(
          builder: (_) => PersonMessageScreen(
            user: settings.arguments as User,
          ),
        );
      case Routes.personHighlight:
        return CustomPageRoute(
          builder: (_) => PersonHighlightScreen(
            settings.arguments as PersonHighlightArguments,
          ),
        );
      case Routes.webView:
        return CustomPageRoute(
            builder: (_) => WebViewScreen(
                  settings.arguments as WebViewArguments,
                ),
            settings: settings);
      case Routes.cropImage:
        return CustomPageRoute(
          builder: (_) => CropImageScreen(
            settings.arguments as File,
          ),
        );
      case Routes.gift:
        return CustomPageRoute(
          builder: (_) => GiftScreen(
            settings.arguments as GiftScreenArgs,
          ),
        );
      case Routes.voucherDetail:
        return CustomPageRoute(
          builder: (_) => NotificationVoucherDetailScreen(
            settings.arguments as NotificationItem,
          ),
        );

      case Routes.outStanding:
        return CustomPageRoute(
          builder: (_) => ListMoreOutStandingScreen(
              settings.arguments as ListMoreOutStandingScreenArgs),
        );
      case Routes.attendanceEveryDay:
        return CustomPageRoute(
          builder: (_) => AttendanceEveryDayScreen(),
        );
      case Routes.exchangeGiftScreen:
        return CustomPageRoute(
          builder: (_) => ExchangeGiftScreen(gift: settings.arguments as Gift),
        );
      case Routes.profileCandy:
        return CustomPageRoute(
          builder: (_) => ProfileCandyScreen(),
        );
      case Routes.profilePrivacy:
        return CustomPageRoute(
          builder: (_) => PrivacyScreen(),
        );
      case Routes.blockUser:
        return CustomPageRoute(
          builder: (_) => BlockUserScreen(user: settings.arguments as User),
        );
      case Routes.viewDetailImage:
        return CustomPageRoute(
          builder: (_) => ViewImageScreen(
            url: (settings.arguments ?? "") as String,
          ),
        );
      case Routes.sendInformationGift:
        return CustomPageRoute(
          builder: (_) =>
              SendInformationGiftScreen(gift: settings.arguments as Gift),
        );
      case Routes.addInformationCreateDatingProfile:
        return CustomPageRoute(
          builder: (_) => AddInformationCreateDatingProfileScreen(),
        );
      case Routes.reviewInformationCreateDatingProfile:
        return CustomPageRoute(
          builder: (_) => ReviewInformationCreateDatingProfileScreen(),
        );
      case Routes.datingFilter:
        return CustomPageRoute(
          builder: (_) => DatingFilterScreen(
            filters: settings.arguments != null
                ? settings.arguments as List<FilterRequestItem>
                : null,
          ),
        );
      case Routes.findFriendCreateDatingProfileScreen:
        return CustomPageRoute(
          builder: (_) =>
              FindFriendCreateDatingProfileScreen(settings.arguments as User),
        );
      case Routes.datingUserDetail:
        return CustomPageRoute(
          builder: (_) => DatingUserDetailScreen(settings.arguments as User),
        );
      case Routes.postDetail:
        return CustomPageRoute(
          builder: (_) =>
              PostDetailScreen(settings.arguments as PostDetailAgrument),
        );
      case Routes.postVideoDetail:
        return CustomPageRoute(
          fullscreenDialog: true,
          builder: (_) =>
              VideoDetailScreen(settings.arguments as PostDetailAgrument),
        );
      case Routes.editPersonalProfile:
        return CustomPageRoute(
          builder: (_) => ProfileEditScreen(settings.arguments as User),
        );
      case Routes.genderProfile:
        return CustomPageRoute(
          builder: (_) => ProfileGenderScreen(settings.arguments as User),
        );
      case Routes.profileDetail:
        return CustomPageRoute(
          builder: (_) => ProfileDetailScreen(
            useForDatingEdit: (settings.arguments ?? false) as bool,
          ),
        );
      case Routes.filterHighlight:
        var data = settings.arguments != null
            ? (settings.arguments as GetQueryParam)
            : null;
        return CustomPageRoute(
          builder: (_) => FilterTimelineScreen(data),
        );
      case Routes.firstMessageScreen:
        return CustomPageRoute(
          builder: (_) => FirstMessageScreen(settings.arguments as User),
        );

      case Routes.typeDiscovery:
        return CustomPageRoute(
          builder: (_) => ListTypeDiscoveryScreen(
              settings.arguments as TypeDiscoverAgrument),
        );
      case Routes.datingSetting:
        return CustomPageRoute(
          builder: (_) => DatingSettingScreen(),
        );
      case Routes.relyWhoSuitsMeQuestion:
        return CustomPageRoute(
          builder: (_) => ReplyQuestionScreen(
            argument: settings.arguments as RelyQuestionArgument,
          ),
        );
      case Routes.whoSuitsMeProfile:
        return CustomPageRoute(
          builder: (_) => WhoSuitsMeProfileScreen(
            index: settings.arguments != null ? settings.arguments as int : 0,
          ),
        );
      case Routes.reviewQuizResultScreen:
        return CustomPageRoute(
            builder: (_) => ReviewQuizResultScreen(
                result: settings.arguments as WhoSuitsMeHistory));
      case Routes.sampleQuestion:
        return CustomPageRoute(
          builder: (_) => TemplateQuestionScreen(
              agrument: settings.arguments as QuestionAgrument),
        );
      case Routes.playerVideo:
        return CustomPageRoute(
          builder: (_) => PlayerScreen(settings.arguments as String?),
        );
      case Routes.deleteAccount:
        return CustomPageRoute(
          builder: (_) => DeleteAccountScreen(),
        );
      case Routes.notificationDetail:
        return CustomPageRoute(
          builder: (_) =>
              NotificationDetailScreen(settings.arguments as NotificationItem),
        );
      case Routes.inviteFriend:
        return CustomPageRoute(
          builder: (_) => ShareReferralScreen(),
        );
      case Routes.enterReferralCode:
        return CustomPageRoute(
          builder: (_) => EnterReferralScreen(
            isNewAccount: settings.arguments as bool,
          ),
        );
      case Routes.report:
        return CustomPageRoute(
          builder: (_) => ReportScreen(
            settings.arguments as ReportScreenArgs,
          ),
        );
      case Routes.userSetting:
        return CustomPageRoute(
          builder: (_) => UserSettingScreen(),
        );

      default:
        throw Exception("Route ${settings.name} is not defined");
    }
  }

  Widget _getRootScreenByAppState() {
    final authState = locator<UserModel>().authState;
    switch (authState.value) {
      case AuthState.new_install:
        return IntroScreen();
      //return LoginScreen();
      case AuthState.unauthorized:
        return LoginScreen();
      case AuthState.authorized:
        return HomeScreen();
      case AuthState.uncompleted:
        return DisplayNameScreen();
      default:
        return LoadingWidget();
    }
  }

  Widget _getRootPageRoute(Widget wid) {
    return WillPopScope(
      child: wid,
      onWillPop: onWillPop,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _appModel.submitFCMToken();
        locator<TrackingManager>().resumeTrackTime();
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.inactive:
        // bắn event thông báo đã ra khỏi tab news feed
        eventBus.fire(OutSideNewFeedsEvent());
        break;
      case AppLifecycleState.paused:
        locator<TrackingManager>().pauseTrackTime();
        break;

      default:
        break;
    }
  }

  DateTime? currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Back again to exit");
      return Future.value(false);
    }
    return Future.value(true);
  }
}

class CustomPageRoute extends MaterialPageRoute {
  @override
  Duration get transitionDuration => const Duration(milliseconds: 0);

  CustomPageRoute({settings, builder, fullscreenDialog = false})
      : super(
            settings: settings,
            builder: builder,
            fullscreenDialog: fullscreenDialog);
}

EventBus eventBus = EventBus();
