import 'package:lomo/app/app_model.dart';
import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/api/api_constants.dart';
import 'package:lomo/data/api/models/filter_request_item.dart';
import 'package:lomo/data/api/models/ip_model.dart';
import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/data/api/models/response/token_response.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/api/models/who_suits_me_history.dart';
import 'package:lomo/data/api/models/who_suits_me_question_group.dart';
import 'package:lomo/data/api/models/who_suits_me_result_answer.dart';
import 'package:lomo/data/api/rest_client.dart';
import 'package:lomo/data/api/services/user_service.dart';
import 'package:lomo/data/eventbus/favorite_newfeed_event.dart';
import 'package:lomo/data/eventbus/follow_user_event.dart';
import 'package:lomo/data/eventbus/read_quiz_event.dart';
import 'package:lomo/data/eventbus/say_hi_success_event.dart';
import 'package:lomo/data/eventbus/submit_answer_quiz_event.dart';
import 'package:lomo/data/preferences/preferences.dart';
import 'package:lomo/data/repositories/notification_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/util/location_manager.dart';
import 'package:lomo/util/platform_channel.dart';

import '../../ui/settings/delete_account/delete_account_model.dart';
import '../api/models/user_setting.dart';
import 'base_repository.dart';

class UserRepository extends BaseRepository {
  var _userService = locator<UserService>();
  final locationManager = locator<LocationManager>();

  Future<User> getUserDetail(String userId) async {
    final res = await _userService.getUserDetail(userId);
    if (res.isMe) {
      await saveUser(res);
    }
    return res;
  }

  Future<void> loginByPhone(String phone,
      {bool resend = false, bool active = false}) async {
    await _userService.loginByPhone(phone, resend, active);
    await Preferences.setPhone(phone);
  }

  Future<User?> confirmOtp(String otp) async {
    final phone = await Preferences.getPhone();
    final tokenResponse = await _userService.confirmOtp(otp, phone!);
    await saveToken(tokenResponse);
    RestClient.instance.setToken(tokenResponse.accessToken!);
    return await getMyProfile(userId: tokenResponse.id);
  }

  getMe() async {
    await _userService.getMyProfile();
  }

  report({
    required String userId,
    required List<String> reports,
    String? content,
    String? newFeedId,
    List<String>? images,
  }) async =>
      _userService.report(
          userId: userId,
          reports: reports,
          content: content,
          newFeedId: newFeedId,
          images: images);

  Future<User?> getMyProfile({String? userId}) async {
    User? profile;
    if (userId == null) {
      final user = await getUser();
      userId = user?.id;
    }

    if (userId != null) {
      profile = await _userService.getUserDetail(userId);
      await saveUser(profile);
    }
    return profile;
  }

  Future<TokenResponse?> refreshToken() async {
    final refreshToken = await Preferences.getRefreshToken();
    final token = await _userService.refreshToken(refreshToken!);
    if (token != null) {
      RestClient.instance.setToken(token.accessToken!);
      saveToken(token);
      return token;
    } else {
      return null;
    }
  }

  Future<void> updateProfile(User user) async {
    await _userService.updateUserProfile(user);
    await getMyProfile();
  }

  deleteAccount(ReasonDeleteAccountItem item) async =>
      _userService.deleteAccount(item);

  Future<List<User>> getSuggestIdolUsers(int page, int pageSize) async {
    return _userService.getSuggestIdolUsers(page, pageSize);
  }

  setUserSetting(UserSetting? setting) async {
    if (setting != null) {
      await Preferences.setUserSetting(setting);
    }
  }

  Future<UserSetting?> getUserSetting() async => Preferences.getUserSetting();

  // Future<void> followUser(String userId, int netaloId) async {
  //   await _userService.followUser(userId);
  //   locator<PlatformChannel>().setFollowUser(netaloId, true);
  //   updateFollowLomo(true, userId);
  //   eventBus.fire(FollowUserEvent(true, userId));
  // }

  Future<void> followUser(User? user) async {
    if (user != null) {
      await _userService.followUser(user.id!);
      locator<PlatformChannel>().setFollowUser(user, true);
      updateFollowLomo(true, user.id!);
      eventBus.fire(FollowUserEvent(true, user.id!));
    }
  }

  Future<void> unFollowUser(User? user) async {
    if (user != null) {
      await _userService.unFollowUser(user.id!);
      locator<PlatformChannel>().setFollowUser(user, false);
      updateFollowLomo(false, user.id!);
      eventBus.fire(FollowUserEvent(false, user.id!));
    }
  }

  updateFollowLomo(bool isFollowed, String userId) {
    if (userId == locator<AppModel>().appConfig?.officialLomo) {
      locator<UserModel>().user?.isFollowOfficial = isFollowed;
    }
    if (userId == locator<AppModel>().appConfig?.supportLomo) {
      locator<UserModel>().user?.isFollowSupport = isFollowed;
    }
  }

  Future<void> blockUser(User user) async {
    await _userService.blockUser(user.id!);
    locator<PlatformChannel>().blockUser(user.netAloId!);
  }

  Future<void> unBlockUser(User user) async {
    await _userService.unBlockUser(user.id!);
    locator<PlatformChannel>().unBlockUser(user.netAloId!);
  }

  Future<List<User>> getBlockedUsers(
      String userId, int page, int pageSize) async {
    return _userService.getBlockedUsers(userId, page, pageSize);
  }

  Future<NewFeed> getDetailPost(String postId) async {
    return await _userService.getDetailPost(postId);
  }

  setTimeInitProfile(DateTime? time) async =>
      Preferences.setTimeInitProfile(time);

  Future<DateTime?> getTimeInitProfile() async =>
      Preferences.getTimeInitProfile();

  Future<List<User>> getFollowerUser(
      String userId, String textSearch, int page, int pageSize) async {
    return _userService.getFollowerUser(userId, textSearch, page, pageSize);
  }

  Future<List<User>> getFavoritorUser(
      String userId, int page, int pageSize) async {
    return _userService.getFavoritorUser(userId, page, pageSize);
  }

  Future<List<User>> getFollowingUser(
      String userId, String textSearch, int page, int pageSize) async {
    return _userService.getFollowingUser(userId, textSearch, page, pageSize);
  }

  Future<void> favoritePost(String postId) async {
    await _userService.favoritePost(postId);
    eventBus.fire(FavoriteNewFeedEvent(postId, true));
  }

  Future<void> unFavoritePost(String postId) async {
    await _userService.unFavoritePost(postId);
    eventBus.fire(FavoriteNewFeedEvent(postId, false));
  }

  Future<void> sendBear(String userId) async {
    var response = _userService.sendBear(userId);
    return response;
  }

  Future<void> favoriteUser(String userId) async {
    return _userService.favoriteUser(userId);
  }

  Future<void> unFavoriteUser(String userId) async {
    return _userService.unFavoriteUser(userId);
  }

  Future<bool> checkFriend(String myNetAloId, String targetNetAloId) async {
    return _userService.checkFriend(myNetAloId, targetNetAloId);
  }

  Future<void> sentSayHi(String userId) async {
    await _userService.sentSayHi(userId);
    eventBus.fire(SayHiSuccessEvent(userId: userId));
  }

  Future<void> updateUserAfterUpdateProfile(User user) async {
    final userModel = locator<UserModel>();
    userModel.user = user;
    userModel.updateUserInfo();
    await saveUser(user);
  }

  Future<List<User>> searchUserForTag(String textSearch, int page) async {
    return _userService.searchUserForTag(textSearch, page);
  }

  Future<User?> getUser() async {
    return Preferences.getUser();
  }

  Future<String?> getAccessToken() async {
    return Preferences.getAccessToken();
  }

  Future<String?> getRefreshToken() async {
    return Preferences.getRefreshToken();
  }

  Future<String?> getPhone() async => await Preferences.getPhone();

  saveUser(User user) async {
    final userModel = locator<UserModel>();
    userModel.setUser(user);
    userModel.updateUserInfo();
    Preferences.setUser(user);
  }

  setUseAsGuest(bool value) async {
    Preferences.setUseAsGuest(value);
  }

  Future<bool> isUseAsGuest() async {
    return Preferences.isUseAsGuest();
  }

  Future<String?> getNetAloToken() async {
    return await Preferences.getNetaloToken();
  }

  Future<void> saveToken(TokenResponse token) async {
    await Preferences.setAccessToken(token.accessToken!);
    await Preferences.setRefreshToken(token.refreshToken!);
    await Preferences.setNetaloToken(token.netaloToken!);
  }

  logout() async {
    try {
      final deviceId = locator<AppModel>().deviceId;
      final userId = locator<UserModel>().user!.id;
      final accessToken = await getAccessToken();
      await _userService.deleteNotificationToken(deviceId, userId!);
      _userService.logout(userId, accessToken!);
    } catch (e) {
      print(e);
    }
    await Preferences.clearUserInfo();
    await locator<NotificationRepository>().setSendFCMToken(false);
    RestClient.instance.clearToken();
  }

  Future<List<User>> getListHot({required int page, required int limit}) async {
    return _userService.getListHot(page: page, limit: limit);
  }

  Future<List<User>> getListParent(
      {required int page, required int limit}) async {
    return _userService.getListParent(page: page, limit: limit);
  }

  Future<List<User>> getListNearUser({int? page, int? limit}) async {
    final locationManager = locator<LocationManager>();
    return _userService.getListNearUser(
        locationManager.locationLat, locationManager.locationLng,
        page: page, limit: limit);
  }

  Future<List<User>> getListFeeling(
      {required int page, required int limit}) async {
    return _userService.getListFeeling(page: page, limit: limit);
  }

  Future updateLocation(
      {required double lat,
      required double lng,
      String? city,
      bool isGps = false}) async {
    //TODO tam thoi truyen "" cho city do thu vien geocoder khong ho tro null safety(THAI)
    return _userService.updateLocation(
        lat: lat, lng: lng, city: city ?? "", isGps: isGps);
  }

  Future exchangeGift(String idGift,
      {String? name,
      String? phone,
      String? address,
      String? province,
      String? district,
      String? ward,
      String? email}) async {
    return _userService.exchangeGifts(idGift,
        name: name,
        phone: phone,
        address: address,
        province: province,
        district: district,
        ward: ward,
        email: email);
  }

  Future<List<User>> getListLocation(
      {int? page,
      int? limit,
      required double lat,
      required double lng,
      int distance = 100000}) async {
    return _userService.getListLocation(
        page: page, limit: limit, lat: lat, lng: lng, distance: distance);
  }

  Future<IpWifi?> getIpLocation() async {
    return _userService.getIpLocation();
  }

  Future<List<User>> getListFilterRequest(
      List<FilterRequestItem> listItem, int page,
      {required int limit}) async {
    return _userService.searchFilterUser(listItem, page, limit: limit);
  }

  updateDatingProfile(User user) async {
    await _userService.updateDatingProfile(user);
    saveUser(user);
  }

  verifyDatingImage(List<String> datingImageLink) async {
    return _userService.verifyDatingImage(datingImageLink);
  }

  Future<List<User>> getDatingList(
      {int page = 1,
      int limit = PAGE_SIZE,
      List<FilterRequestItem>? filters}) async {
    final _locationManager = locator<LocationManager>();
    final userId = locator<UserModel>().user!.id!;
    return _userService.getDatingList(
        _locationManager.locationLng, _locationManager.locationLat, userId,
        page: page, limit: limit, filters: filters);
  }

  Future<WhoSuitsMeQuestionGroup> getWhoSuitsMeQuestions(String userId) async {
    return _userService.getWhoSuitsMeQuestions(userId);
  }

  createWhoSuitsMeQuestions(WhoSuitsMeQuestionGroup questionGroup) async {
    await _userService.createWhoSuitsMeQuestions(questionGroup);
  }

  Future<List<WhoSuitsMeHistory>> getWhoSuitsMeHistory(String userId,
      {int? page = 1, int limit = PAGE_SIZE}) async {
    return _userService.getWhoSuitsMeHistory(userId, page: page, limit: limit);
  }

  Future<List<WhoSuitsMeHistory>> getWhoSuitsMeResult(String userId,
      {int? page = 1, int limit = PAGE_SIZE}) async {
    return _userService.getWhoSuitsMeResult(userId, page: page, limit: limit);
  }

  Future<WhoSuitsMeHistory?> submitAnswer(String userId,
      WhoSuitsMeResultAnswer? resultAnswer, String? quizId) async {
    final result = await _userService.submitAnswer(resultAnswer, quizId);
    eventBus.fire(SubmitAnswerQuizEvent(userId: userId));
    return result;
  }

  Future<WhoSuitsMeHistory> getHistoryQuizDetail(
      String quizId, String userId) async {
    return _userService.getHistoryQuizDetail(quizId, userId);
  }

  Future<void> readQuiz(String userId) async {
    await _userService.readQuiz(userId);
    eventBus.fire(ReadQuizEvent(userId));
  }

  Future<List<User>> getFavoriteListUser(
      String postId, int page, int pageSize) async {
    return _userService.getFavoriteListUser(postId, page, pageSize);
  }

  Future<void> enterReferral(String referral) async {
    await _userService.enterReferral(referral);
  }
}
