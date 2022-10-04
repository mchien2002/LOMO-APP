
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:lomo/app/app_model.dart';
import 'package:lomo/app/base_app_config.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/di/locator.dart';

class AppsflyerUtil {
  late AppsflyerSdk _appsflyerSdk;
  init() async {
    try {
      final AppsFlyerOptions options = AppsFlyerOptions(
          afDevKey: "eatJy8yT4em9xsTtq5UjzU",
          appId: "1542295325",
          showDebug: true);
      _appsflyerSdk = AppsflyerSdk(options);

      _appsflyerSdk.initSdk(
          registerConversionDataCallback: true,
          registerOnAppOpenAttributionCallback: true,
          registerOnDeepLinkingCallback: false);
    } catch (e) {
      print(e);
    }
  }

  updateServerUninstallToken(String fcmToken) async {
    _appsflyerSdk.updateServerUninstallToken(fcmToken);
  }

  Future<bool> trackLoginRe(User user) async {
    bool result = false;
    if (locator<AppModel>().env == Environment.prod)
      try {
        result =
            (await _appsflyerSdk.logEvent("Login_re", {"user_id": user.id}))!;
        print("Result trackLoginRe: $result");
      } on Exception catch (e) {
        print("errorTrackLoginRe");
        print(e);
      }

    return result;
  }

  Future<bool> trackLoginNew(User user) async {
    bool result = false;
    if (locator<AppModel>().env == Environment.prod)
      try {
        result =
            (await _appsflyerSdk.logEvent("Login_new", {"user_id": user.id}))!;
        print("Result trackLoginNew: $result");
      } on Exception catch (e) {
        print("errorTrackLoginNew");
        print(e);
      }

    return result;
  }
}
