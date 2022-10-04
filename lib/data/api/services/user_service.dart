import 'dart:async';

import 'package:lomo/data/api/api_constants.dart';
import 'package:lomo/data/api/models/filter_request_item.dart';
import 'package:lomo/data/api/models/ip_model.dart';
import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/data/api/models/response/token_response.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/api/models/verify_dating_image.dart';
import 'package:lomo/data/api/models/who_suits_me_history.dart';
import 'package:lomo/data/api/models/who_suits_me_question_group.dart';
import 'package:lomo/data/api/models/who_suits_me_result_answer.dart';
import 'package:lomo/util/constants.dart';
import 'package:sprintf/sprintf.dart';

import '../../../ui/settings/delete_account/delete_account_model.dart';
import '../api_constants.dart';
import 'base_service.dart';

class UserService extends BaseService {
  Future<void> loginByPhone(String phone, bool resend, bool active) async {
    final params = {"phone": phone, "resend": resend, "active": active};
    await post(LOGIN_BY_PHONE, data: params);
  }

  Future<TokenResponse> confirmOtp(String otp, String phone) async {
    final params = {"code": otp, "phone": phone};
    final response = await post(CONFIRM_OTP, data: params);
    return TokenResponse.fromJson(response);
  }

  Future<TokenResponse?> refreshToken(String refreshToken) async {
    try {
      final response = await get(sprintf(REFRESH_TOKEN, [refreshToken]));
      return TokenResponse.fromJson(response);
    } catch (e) {
      print(e);
      return null;
    }
  }

  getMyProfile() async {
    await get(MY_PROFILE);
  }

  report({
    required String userId,
    required List<String> reports,
    String? content,
    String? newFeedId,
    List<String>? images,
  }) async {
    await post(REPORT, data: {
      "user": userId,
      "reports": reports,
      if (images?.isNotEmpty == true) "images": images,
      if (content != null) "content": content,
      if (newFeedId != null) "post": newFeedId,
    });
  }

  deleteAccount(ReasonDeleteAccountItem item) async {
    final data = {
      "deletedReasons": [
        item.description.isNotEmpty ? item.description : item.item.id
      ]
    };
    await post(DELETE_ACCOUNT, data: data);
  }

  Future<void> updateUserProfile(User user) async {
    await put(USER_UPDATE_PROFILE, data: getDataPostUser(user));
  }

  Map<String, dynamic> getDataPostUser(User user) {
    Map<String, dynamic> data = user.toJson();
    data["gender"] = user.gender?.id;
    data["followGenders"] = user.followGenders?.map((e) => e.id).toList() ?? [];
    data["province"] = user.province?.id;
    data["zodiac"] = user.zodiac?.id;
    data["sogiescs"] = user.sogiescs?.isNotEmpty == true
        ? user.sogiescs!.map((e) => e.id).toList()
        : [];
    data["relationship"] = user.relationship?.id;
    data["careers"] = user.careers?.isNotEmpty == true
        ? user.careers!.map((e) => e.id).toList()
        : [];
    data["literacy"] = user.literacy?.id;
    data["hobbies"] = user.hobbies?.isNotEmpty == true
        ? user.hobbies!.map((e) => e.id).toList()
        : [];
    data["role"] = user.role?.id ?? null;
    data["title"] = user.title?.id ?? null;
    data["email"] = user.email ?? null;
    return data;
  }

  Future<List<User>> getSuggestIdolUsers(int page, int pageSize) async {
    final response =
        await post(SUGGEST_USER, data: {"page": page, "limit": pageSize});
    return List<User>.from(response.map((item) => User.fromJson(item)));
  }

  Future<void> followUser(String userId) async {
    await post(sprintf(FOLLOW_USER, [userId]));
  }

  Future<void> unFollowUser(String userId) async {
    await delete(sprintf(FOLLOW_USER, [userId]));
  }

  Future<void> blockUser(String userId) async {
    await post(sprintf(BLOCK_USER, [userId]));
  }

  Future<void> unBlockUser(String userId) async {
    await delete(sprintf(BLOCK_USER, [userId]));
  }

  Future<List<User>> getBlockedUsers(
      String userId, int page, int pageSize) async {
    final response = await get(
      sprintf(LIST_USER_BLOCKED, [userId]),
      params: GetQueryParam(page: page, limit: pageSize).toJson(),
    );
    return List<User>.from(response.map((item) => User.fromJson(item)));
  }

  Future<NewFeed> getDetailPost(String postId) async {
    final response = await get(sprintf(DETAIL_POST, [postId]));
    return NewFeed.fromJson(response);
  }

  Future<void> favoritePost(String postId) async {
    await post(sprintf(FAVORITE_POST, [postId]));
  }

  Future<void> unFavoritePost(String postId) async {
    await delete(sprintf(FAVORITE_POST, [postId]));
  }

  Future<void> favoriteUser(String userId) async {
    await post(sprintf(FAVORITE_USER, [userId]));
  }

  Future<bool> checkFriend(String myNetAloId, String targetNetAloId) async {
    return await get(sprintf(CHECK_FRIEND, [myNetAloId, targetNetAloId]));
  }

  Future<void> sentSayHi(String userId) async {
    await post(sprintf(SENT_SAY_HI, [userId]));
  }

  Future<void> unFavoriteUser(String userId) async {
    await delete(sprintf(FAVORITE_USER, [userId]));
  }

  Future<void> sendBear(String userId) async {
    await post(sprintf(SEND_BEAR, [userId]));
  }

  Future<List<User>> searchUserForTag(String textSearch, int page) async {
    final response = await get(SEARCH_USER_TAG,
        params: GetQueryParam(
          page: page,
          filters: [
            FilterRequestItem(key: "\$text", value: textSearch),
          ],
        ).toJson());
    return List<User>.from(response.map((item) => User.fromJson(item)));
  }

  Future<User> getUserDetail(String userId) async {
    final response = await get(sprintf(DETAIL_USER, [userId]));
    return User.fromJson(response);
  }

  //sdgkhf
  Future<List<User>> getFollowerUser(
      String userId, String? textSearch, int page, int pageSize) async {
    final response = await get(
      sprintf(FOLLOWERS_USER, [userId]),
      params: GetQueryParam(page: page, limit: pageSize, filters: [
        if (textSearch?.isNotEmpty == true)
          FilterRequestItem(
            key: "name",
            value: textSearch,
          )
      ]).toJson(),
    );
    return List<User>.from(response.map((item) => User.fromJson(item)));
  }

  Future<List<User>> getFavoritorUser(
      String userId, int page, int pageSize) async {
    final response = await get(
      sprintf(FAVORITOR_USER, [userId]),
      params: GetQueryParam(
        page: page,
        limit: pageSize,
      ).toJson(),
    );
    return List<User>.from(response.map((item) => User.fromJson(item)));
  }

  Future<List<User>> getFollowingUser(
      String userId, String? textSearch, int page, int pageSize) async {
    final response = await get(sprintf(FOLLOWINGS_USER, [userId]),
        params: GetQueryParam(
          page: page,
          limit: pageSize,
          filters: [
            if (textSearch?.isNotEmpty == true)
              FilterRequestItem(key: "name", value: textSearch),
          ],
        ).toJson());
    return List<User>.from(response.map((item) => User.fromJson(item)));
  }

  Future<void> logout(String userId, String token) async {
    try {
      await delete(sprintf(LOGOUT, [userId, token]));
    } catch (e) {
      print("logoutException");
      print(e);
    }
  }

  Future<void> deleteNotificationToken(String deviceId, String userId) async {
    try {
      await delete(sprintf(DELETE_TOKEN_WHEN_LOGOUT, [deviceId]));
    } catch (e) {
      print("deleteNotificationTokenException");
      print(e);
    }
  }

  Future<List<User>> getListHot({int page = 1, int limit = 10}) async {
    final response = await get(DISCOVERY_HOT_MEMBER,
        params: GetQueryParam(
          page: page,
          limit: limit,
        ).toJson());
    return List<User>.from(response.map((item) => User.fromJson(item)));
  }

  Future<List<User>> getListParent({int page = 1, int limit = 10}) async {
    final response = await get(DISCOVERY_PARENT,
        params: GetQueryParam(
          page: page,
          limit: limit,
        ).toJson());
    return List<User>.from(response.map((item) => User.fromJson(item)));
  }

  Future<List<User>> getListNearUser(double lat, double lng,
      {int? page = 1, int? limit = 10}) async {
    final response = await get(DISCOVERY_HOT_NEAR_USER,
        params: {"page": page, "limit": limit, "lng": lng, "lat": lat});
    return List<User>.from(response.map((item) => User.fromJson(item)));
  }

  Future<List<User>> getListFeeling({int page = 1, int limit = 10}) async {
    final response = await post(DISCOVERY_FEELING_POST,
        data: {"page": page, "limit": limit});
    return List<User>.from(response.map((item) => User.fromJson(item)));
  }

  Future updateLocation(
      {double lat = DEFAULT_LAT,
      double lng = DEFAULT_LNG,
      required String city,
      bool isGps = false}) async {
    final response = await put(UPDATE_LOCATION_POST,
        data: {"lat": lat, "lng": lng, "city": city, "isGps": isGps});
    return response;
  }

  Future exchangeGifts(String idGift,
      {String? name,
      String? phone,
      String? address,
      String? province,
      String? district,
      String? ward,
      String? email}) async {
    final response = await post(POST_ORDER_GIFTS, data: {
      "name": name,
      "phone": phone,
      "address": address,
      "gift": idGift,
      "province": province,
      "district": district,
      "ward": ward,
      "email": email
    });
    return response;
  }

  Future<List<User>> getListLocation(
      {int? page,
      int? limit,
      int? distance,
      double lat = DEFAULT_LAT,
      double lng = DEFAULT_LNG}) async {
    final response = await post(
        sprintf(DISCOVERY_LOCATION_POST, [lng, lat, distance]),
        data: {"page": page ?? 1, "limit": limit ?? 10});
    return List<User>.from(response.map((item) => User.fromJson(item)));
  }

  Future<IpWifi?> getIpLocation() async {
    var url = 'http://ip-api.com';
    var response = await getWithCustomUrl(url, "/json");
    if (response["status"] == "fail") {
      return null;
    } else {
      return IpWifi.fromJson(response);
    }
  }

  Future<List<User>> searchFilterUser(
      List<FilterRequestItem>? listData, int page,
      {int limit = 20}) async {
    final response = await get(SEARCH_USER,
        params: GetQueryParam(page: page, limit: limit, filters: listData)
            .toJson());
    return List<User>.from(response.map((item) => User.fromJson(item)));
  }

  updateDatingProfile(User user) async {
    await put(UPDATE_DATING_PROFILE, data: getDataPostUser(user));
  }

  verifyDatingImage(List<String> datingImageLink) async {
    await put(VERIFY_DATING_IMAGE,
        data: VerifyDatingImage(verifyImages: datingImageLink).toJson());
  }

  Future<List<User>> getDatingList(double lng, double lat, String userId,
      {int? page = 1,
      int limit = PAGE_SIZE,
      List<FilterRequestItem>? filters}) async {
    final response = await get(sprintf(LIST_DATING, [lng, lat]),
        params:
            GetQueryParam(page: page, limit: limit, filters: filters).toJson());
    return List<User>.from(response.map((item) => User.fromJson(item)));
  }

  Future<WhoSuitsMeQuestionGroup> getWhoSuitsMeQuestions(String userId) async {
    final response = await get(sprintf(GET_WHO_SUITS_ME_QUESTION, [userId]));
    return WhoSuitsMeQuestionGroup.fromJson(response);
  }

  createWhoSuitsMeQuestions(WhoSuitsMeQuestionGroup questionGroup) async {
    await post(CREATE_WHO_SUITS_ME_QUESTION, data: questionGroup.toJson());
  }

  Future<List<WhoSuitsMeHistory>> getWhoSuitsMeHistory(String userId,
      {int? page = 1, int limit = PAGE_SIZE}) async {
    final response = await get(sprintf(WHO_SUITS_ME_HISTORY, [userId]),
        params: GetQueryParam(
          page: page,
          limit: limit,
        ).toJson());
    return List<WhoSuitsMeHistory>.from(
        response.map((item) => WhoSuitsMeHistory.fromJson(item)));
  }

  Future<List<WhoSuitsMeHistory>> getWhoSuitsMeResult(String userId,
      {int? page = 1, int limit = PAGE_SIZE}) async {
    final response = await get(
      sprintf(WHO_SUITS_ME_RESULT, [userId]),
      params: GetQueryParam(
        page: page,
        limit: limit,
      ).toJson(),
    );
    return List<WhoSuitsMeHistory>.from(
        response.map((item) => WhoSuitsMeHistory.fromJson(item)));
  }

  Future<WhoSuitsMeHistory> submitAnswer(
      WhoSuitsMeResultAnswer? resultAnswer, String? quizId) async {
    final response = await post(sprintf(SUBMIT_RESULT_ANSWER, [quizId]),
        data: resultAnswer);
    return WhoSuitsMeHistory.fromJson(response);
  }

  Future<WhoSuitsMeHistory> getHistoryQuizDetail(
      String quizId, String userId) async {
    final response = await get(sprintf(HISTORY_QUIZ_DETAIL, [quizId, userId]));
    return WhoSuitsMeHistory.fromJson(response);
  }

  Future<void> readQuiz(String userId) async {
    await put(sprintf(READ_QUIZ, [userId]));
  }

  //get list favorite
  Future<List<User>> getFavoriteListUser(
      String postId, int page, int pageSize) async {
    final response = await get(
      sprintf(FAVORITE_POST_LIST, [postId]),
      params: GetQueryParam(
        page: page,
        limit: pageSize,
      ).toJson(),
    );
    return List<User>.from(response.map((item) => User.fromJson(item)));
  }

  Future<void> enterReferral(String referral) async {
    final data = {"referral": referral};
    await put(REFERRAL, data: data);
  }
}
