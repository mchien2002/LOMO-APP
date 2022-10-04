import 'dart:convert';

import 'package:lomo/data/api/models/app_config.dart';
import 'package:lomo/data/api/models/city.dart';
import 'package:lomo/data/api/models/discovery_item.dart';
import 'package:lomo/data/api/models/gender.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/api/models/user_setting.dart';
import 'package:lomo/util/date_time_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static const LANGUAGE = "language";
  static const USER = "user";
  static const PROFILE = "profile";
  static const PHONE = "phone";
  static const BADGE_CHAT = "badge_chat";
  static const BADGE = "badge";
  static const ACCESS_TOKEN = "access_token";
  static const REFRESH_TOKEN = "refresh_token";
  static const NETALO_TOKEN = "netalo_token";
  static const LOGIN_PHONE_TOKEN = "login_phone_token";
  static const FCM_TOKEN = "fcm_token";
  static const SEND_FCM_TOKEN = "send_fcm_token";
  static const CITIES = "cities";
  static const SOGIESC = "sogiesc";
  static const SEARCH_RECENTLY = "search_recently";
  static const ZODIAC = "zodiac";
  static const RELATIONSHIP = "relationship";
  static const USE_AS_GUEST = "use_as_guest";
  static const FIRST_USE_APP = "first_use_app";
  static const SHOW_SOGIES_TEST = "show_sogiest_test";
  static const THEME = "theme";
  static const DOMAIN_DOWNLOAD_IMAGE = "domain_download_image";
  static const DAY_SHOW_POPUP_CHECKIN = "day_show_popup_checkin";
  static const TOOL_TIP_CHECK_IN = "tool_tip_check_in";
  static const SHOW_VQMM = "show_vqmm";
  static const APP_CONFIG = "app_config";
  static const DAY_SHOW_POPUP_CHECK_VQMM = "day_show_popup_check_vqmm";
  static const DISCOVERY_ITEM = "discovery_item";
  static const TIME_INIT_PROFILE = "time_init_profile";
  static const USER_SETTING = "user_setting";

  static setUserSetting(UserSetting setting) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(USER_SETTING, jsonEncode(setting.toJson()));
  }

  static Future<UserSetting?> getUserSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userJson = prefs.getString(USER_SETTING);
    if (userJson != null) {
      return UserSetting.fromJson(json.decode(userJson));
    }
    return null;
  }

  static setLanguage(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(LANGUAGE, language);
  }

  static Future<String?> getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(LANGUAGE);
  }

  static setTimeInitProfile(DateTime? time) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(TIME_INIT_PROFILE, time?.millisecondsSinceEpoch ?? 0);
  }

  static Future<DateTime?> getTimeInitProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final time = prefs.getInt(TIME_INIT_PROFILE);
    return time != null && time != 0
        ? DateTime.fromMillisecondsSinceEpoch(time)
        : null;
  }

  static setCities(List<City> cities) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(CITIES, City.encodeCity(cities));
  }

  static Future<List<City>?> getCities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? a = prefs.getString(CITIES);
    return a == null ? null : City.decodeCity(a);
  }

  static setSearchRecently(List<String> texts) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(SEARCH_RECENTLY, texts);
  }

  static Future<List<String>> getSearchRecently() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final a = prefs.getStringList(SEARCH_RECENTLY);
    return a ?? [];
  }

  static setSogiesc(List<Gender> gender) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(SOGIESC, Gender.encodeGender(gender));
  }

  static Future<List<Gender>?> getSogiesc() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? a = prefs.getString(SOGIESC);
    return a == null ? null : Gender.decodeGender(a);
  }

  static setDiscoveryItems(List<DiscoveryItem> items) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(DISCOVERY_ITEM, DiscoveryItem.encodeGender(items));
  }

  static Future<List<DiscoveryItem>?> getDiscoveryItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? a = prefs.getString(DISCOVERY_ITEM);
    return a == null ? null : DiscoveryItem.decodeGender(a);
  }

  static setZodiac(List<Gender> gender) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(ZODIAC, Gender.encodeGender(gender));
  }

  static Future<List<Gender>?> getZodiac() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? a = prefs.getString(ZODIAC);
    return a == null ? null : Gender.decodeGender(a);
  }

  static setRelationship(List<Gender> gender) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(RELATIONSHIP, Gender.encodeGender(gender));
  }

  static Future<List<Gender>?> getRelationship() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? a = prefs.getString(RELATIONSHIP);
    return a == null ? null : Gender.decodeGender(a);
  }

  static setAccessToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(ACCESS_TOKEN, token);
  }

  static Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(ACCESS_TOKEN);
  }

  static setRefreshToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(REFRESH_TOKEN, token);
  }

  static Future<String?> getRefreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(REFRESH_TOKEN);
  }

  static setNetaloToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(NETALO_TOKEN, token);
  }

  static Future<String?> getNetaloToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(NETALO_TOKEN);
  }

  static setLoginPhoneToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(LOGIN_PHONE_TOKEN, token);
  }

  static Future<String?> getLoginPhoneToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(LOGIN_PHONE_TOKEN);
  }

  static setPhone(String phone) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(PHONE, phone);
  }

  static Future<String?> getPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(PHONE);
  }

  static setUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(USER, jsonEncode(user.toJson()));
  }

  static Future<User?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userJson = prefs.getString(USER);
    if (userJson != null) {
      return User.fromJson(json.decode(userJson));
    }
    return null;
  }

  static setAppConfig(AppConfig config) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(APP_CONFIG, jsonEncode(config.toJson()));
  }

  static Future<AppConfig> getAppConfig() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var appConfigJson = prefs.getString(APP_CONFIG);
    if (appConfigJson != null) {
      return AppConfig.fromJson(json.decode(appConfigJson));
    }
    return AppConfig();
  }

  static setProfile(User profile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(PROFILE, jsonEncode(profile.toJson()));
  }

  static Future<User?> getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userJson = prefs.getString(PROFILE);
    if (userJson != null) {
      return User.fromJson(json.decode(userJson));
    }
    return null;
  }

  static setFCMToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(FCM_TOKEN, token);
  }

  static Future<String?> getFCMToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(FCM_TOKEN);
  }

  static setDownloadImageDomain(String domain) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(DOMAIN_DOWNLOAD_IMAGE, domain);
  }

  static Future<String?> getDownloadImageDomain() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(DOMAIN_DOWNLOAD_IMAGE);
  }

  static setSendFCMToken(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SEND_FCM_TOKEN, value);
  }

  static Future<bool> isSendFCMToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SEND_FCM_TOKEN) ?? false;
  }

  static Future<bool> isShowPopupCheckin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var dayChecked = prefs.getString(DAY_SHOW_POPUP_CHECKIN) ?? "";
    var currentDay = getDayByTimeStamp(DateTime.now().millisecondsSinceEpoch);
    return dayChecked != currentDay;
  }

  static setCurrentDayShowPopupCheckin(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(DAY_SHOW_POPUP_CHECKIN, value);
  }

  static Future<bool> isShowPopupCheckTimeVQMM() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var dayChecked = prefs.getString(DAY_SHOW_POPUP_CHECK_VQMM) ?? "";
    var currentDay = getDayByTimeStamp(DateTime.now().millisecondsSinceEpoch);
    return dayChecked != currentDay;
  }

  static setCurrentDayShowPopupCheckVQMM(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(DAY_SHOW_POPUP_CHECK_VQMM, value);
  }

  static setTheme(int theme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(THEME, theme);
  }

  static Future<int> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(THEME) ?? 0;
  }

  static setBadge(int badge) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(BADGE, badge);
  }

  static Future<int> getBadge() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(BADGE) ?? 0;
  }

  static setBadgeChat(int badge) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(BADGE_CHAT, badge);
  }

  static Future<int> getBadgeChat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(BADGE_CHAT) ?? 0;
  }

  static setUseAsGuest(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(USE_AS_GUEST, value);
  }

  static Future<bool> isUseAsGuest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(USE_AS_GUEST) ?? false;
  }

  static setFirstUseApp(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(FIRST_USE_APP, value);
  }

  static Future<bool> isFirstUseApp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(FIRST_USE_APP) ?? true;
  }

  static setShowSogiesTest(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SHOW_SOGIES_TEST, value);
  }

  static Future<bool> isShowSogiesTest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SHOW_SOGIES_TEST) ?? true;
  }

  static setShowToolTipCheckIn(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(TOOL_TIP_CHECK_IN, value);
  }

  static Future<bool> isShowToolTipCheckIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(TOOL_TIP_CHECK_IN) ?? true;
  }

  static clearUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(ACCESS_TOKEN);
    await prefs.remove(REFRESH_TOKEN);
    await prefs.remove(NETALO_TOKEN);
    await prefs.remove(USER);
    await prefs.remove(PHONE);
    await prefs.remove(BADGE_CHAT);
    await prefs.remove(BADGE);

    // await prefs.remove(PROFILE);
    // await prefs.remove(LOGIN_PHONE_TOKEN);
    // await prefs.remove(RELATIONSHIP);
    // await prefs.remove(USE_AS_GUEST);
    // await prefs.remove(SHOW_SOGIES_TEST);
    // await prefs.remove(DAY_SHOW_POPUP_CHECKIN);
  }

  static setShowVQMM(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SHOW_VQMM, value);
  }

  static Future<bool> isNoShowAgainVQMM() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SHOW_VQMM) ?? false;
  }
}
