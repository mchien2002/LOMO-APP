import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lomo/data/api/api_constants.dart';
import 'package:lomo/data/api/models/app_config.dart';
import 'package:lomo/data/api/models/notification_item.dart';
import 'package:lomo/data/api/models/request/app_config_request.dart';
import 'package:lomo/data/api/rest_client.dart';
import 'package:lomo/data/database/db_manager.dart';
import 'package:lomo/data/eventbus/refresh_notification_event.dart';
import 'package:lomo/data/preferences/preferences.dart';
import 'package:lomo/data/repositories/common_repository.dart';
import 'package:lomo/data/repositories/notification_repository.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/libraries/photo_manager/photo_provider.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/util/constants.dart';
import 'package:lomo/util/platform_channel.dart';
import 'package:lomo/util/tool_tip_manager.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';
import 'package:package_info/package_info.dart';

import 'base_app_config.dart';
import 'lomo_app.dart';
import 'push_notification_manager.dart';
import 'user_model.dart';

class AppModel extends ChangeNotifier {
  final _userRepository = locator<UserRepository>();
  final _notificationRepository = locator<NotificationRepository>();
  final _commonRepository = locator<CommonRepository>();
  final NavigationHistoryObserver historyObserver = NavigationHistoryObserver();
  AppState state = AppState.uninitialized;
  late Locale locale;
  ValueNotifier<dynamic> backToRoot = ValueNotifier(null);
  ValueNotifier<bool?> hasFunctionEvent = ValueNotifier(null);
  late PackageInfo packageInfo;
  AppConfig? appConfig;
  late Environment env;
  String deviceId = "";
  String deviceName = "";
  String osVersion = "";
  List<String> listDisableChat = [];

  bool isConnected = true;
  final Connectivity _connectivity = Connectivity();

  List<Locale> supportedLocales = [
    const Locale('en'),
    const Locale('vi'),
  ];

  setLanguage(String language) async {
    await Preferences.setLanguage(language);
    RestClient.instance.setLanguage(language);
    if (locale.languageCode != language) {
      locale = Locale(language);
      notifyListeners();
    }
  }

  void setBackToRoot(dynamic back) {
    backToRoot.value = back;
  }

  void forceLogout() {
    locator<UserModel>().logout();
    setBackToRoot(Object);
  }

  init(Environment env) async {
    this.env = env;
    // init locale
    var language = await Preferences.getLanguage();
    locale = supportedLocales
        .firstWhere((locale) => locale.languageCode == language, orElse: () {
      language = supportedLocales.last.languageCode;
      return supportedLocales.last;
    });
    initHandleRouteChanged();
    await initDeviceInfo();
    await initApi(language);
    await locator<UserModel>().init(env);
    initUserInfo();
    locator<NotificationRepository>().init();
    locator<ThemeManager>().init();
    locator<ToolTipManager>().init();
    locator<DbManager>().init();
    locator<PhotoProvider>().init();
    locator<PushNotificationManager>().init();
    initConnectivity();
    state = AppState.initialized;
  }

  initHandleRouteChanged() async {
    historyObserver.historyChangeStream.listen(
      (change) {
        final history = change as HistoryChange;
        print("historyChangeStream: ${history.newRoute?.settings.name}");
        if ([Routes.webView, Routes.playerVideo]
            .contains(history.newRoute?.settings.name)) {
          setFunctionEvent(history.action != NavigationStackAction.push);
        }
      },
    );
  }

  initDeviceInfo() async {
    await Future.wait([getPackageInfo(), getDeviceInfo()]);
  }

  Future<void> getPackageInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
  }

  Future<void> getDeviceInfo() async {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var data = await deviceInfoPlugin.androidInfo;
        deviceId = data.androidId ?? ""; //UUID for Android
        deviceName = data.model ?? "";
        osVersion = data.version.release ?? "";
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceId = data.identifierForVendor ?? ""; //UUID for iOS
        deviceName = data.utsname.machine ?? "";
        osVersion = data.systemVersion ?? "";
      }
    } on PlatformException {
      print('Failed to get platform version');
    }
  }

  initApi(String? language) async {
    String baseUrl;
    // init api
    switch (env) {
      case Environment.prod:
        baseUrl = BASE_URL_PROD;
        UPLOAD_PHOTO_URL = UPLOAD_PHOTO_URL_PROD;
        break;
      case Environment.staging:
        baseUrl = BASE_URL_STA;
        UPLOAD_PHOTO_URL = UPLOAD_PHOTO_URL_STA;
        break;
      case Environment.dev:
        baseUrl = BASE_URL_DEV;
        UPLOAD_PHOTO_URL = UPLOAD_PHOTO_URL_DEV;
        break;
    }
    final accessToken = await _userRepository.getAccessToken();
    RestClient.instance.init(baseUrl,
        accessToken: accessToken,
        platform: Platform.isAndroid ? "android" : "ios",
        appVersionName: packageInfo.version,
        appVersionCode: packageInfo.buildNumber,
        deviceId: deviceId,
        language: language);
  }

  initUserInfo() {
    if (locator<UserModel>().user != null) {
      locator<UserModel>().getUserRemote();
      locator<UserModel>().getUserSetting();
    }
    _getAppConFig();
    getConstantListFromApi();
  }

  getConstantListFromApi() async {
    _commonRepository.getConstantList();
  }

  _getAppConFig() async {
    appConfig = await _commonRepository.getAppConfigLocal();
    // update config from local
    setUrlConfig(appConfig);
    try {
      final remoteConfig = await _commonRepository.getAppConfig(
        AppConfigRequest(
          os: Platform.isAndroid ? "android" : "ios",
          verName: packageInfo.version,
          verCode: int.parse(packageInfo.buildNumber),
        ),
      );
      appConfig = remoteConfig;
      // update config after get from server
      setUrlConfig(appConfig);
    } catch (e) {
      print(e);
    }

    if (appConfig?.officialLomo?.isNotEmpty == true) {
      listDisableChat.add(appConfig!.officialLomo!);
    }

    setFunctionEvent(appConfig?.isEvent ?? false);
  }

  setUrlConfig(AppConfig? appConfig) {
    // set photoUrl
    if (appConfig?.photoUrl?.isNotEmpty == true) {
      PHOTO_URL = appConfig!.photoUrl!;
      locator<PlatformChannel>().setDomainLoadAvatarNetAloSdk(PHOTO_URL);
    } else {
      PHOTO_URL = env == Environment.dev
          ? DOWNLOAD_PHOTO_URL_DEV
          : env == Environment.staging
              ? BASE_URL_STA
              : BASE_URL_PROD;
    }

    // set videoUrl
    if (appConfig?.videoUrl?.isNotEmpty == true) {
      VIDEO_URL = appConfig!.videoUrl!;
    } else {
      VIDEO_URL = env == Environment.dev
          ? DOWNLOAD_PHOTO_URL_DEV
          : env == Environment.staging
              ? BASE_URL_STA
              : BASE_URL_PROD;
    }
  }

  setFunctionEvent(bool isShowEvent) {
    if (locator<UserModel>().authState.value == AuthState.authorized &&
        appConfig?.isEvent == true &&
        isShowEvent) {
      hasFunctionEvent.value = true;
    } else
      hasFunctionEvent.value = false;
  }

  getCacheDomainLoadImage() async {
    try {
      final domainImageCached =
          await _commonRepository.getDownloadImageDomain();
      if (domainImageCached?.isNotEmpty == true) {
        PHOTO_URL = domainImageCached!;
      } else {
        PHOTO_URL = env == Environment.dev
            ? DOWNLOAD_PHOTO_URL_DEV
            : env == Environment.staging
                ? BASE_URL_STA
                : BASE_URL_PROD;
      }
    } catch (e) {
      print(e);
    }
  }

  getBadge() async {
    try {
      if (locator<UserModel>().authState.value == AuthState.authorized) {
        _notificationRepository.getListNotification();
        _notificationRepository.getNumberBadgesOfChat();
      }
    } catch (e) {
      _notificationRepository.getBadge();
      _notificationRepository.getBadgeChat();
    }
  }

  saveFCMToken(String? token) async {
    final oldFCMToken = await _notificationRepository.getFCMToken();
    if (oldFCMToken != token && token != null) {
      await _notificationRepository.saveFCMToken(token);
      await _notificationRepository.setSendFCMToken(false);
    }
  }

  submitFCMToken({String? fcmToken, bool isCheckState = true}) async {
    try {
      if ((isCheckState &&
              locator<UserModel>().authState.value == AuthState.authorized) ||
          !isCheckState) {
        await _notificationRepository.submitFCMToken(fcmToken: fcmToken);
        _notificationRepository.setSendFCMToken(true);
        saveFCMToken(fcmToken);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  updateNotificationInfo(NotificationItem item) async {
    if ([
      NOTIFICATION_NOTIFY_DETAIL[6].id,
      NOTIFICATION_NOTIFY_DETAIL[20].id,
      NOTIFICATION_NOTIFY_DETAIL[21].id
    ].contains(item.notify)) {
      if (locator<UserModel>().user?.id != null) {
        locator<UserRepository>().getUserDetail(locator<UserModel>().user!.id!);
      }
    }
    try {
      List<NotificationItem>? notifications =
          await locator<NotificationRepository>().getListNotification();
      eventBus.fire(RefreshNotificationEvent(notifications ?? []));
    } catch (e) {}
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }
    _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        isConnected = true;
        break;
      case ConnectivityResult.none:
        isConnected = false;
        break;
      default:
        isConnected = false;
        break;
    }
  }
}

enum AppState {
  uninitialized,
  initialized,
}

class AppEvent {
  static const eventUpdated = 1;

  final int? type;
  final dynamic arguments;

  AppEvent({this.type, this.arguments});
}
