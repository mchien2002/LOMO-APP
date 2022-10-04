import 'package:lomo/data/api/api_constants.dart';
import 'package:lomo/data/api/models/comments.dart';
import 'package:lomo/data/api/models/comments_param.dart';
import 'package:lomo/data/api/models/filter_request_item.dart';
import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/data/api/models/response/NewFeedResponse.dart';
import 'package:lomo/data/api/models/user_newfeed.dart';
import 'package:lomo/data/api/services/base_service.dart';
import 'package:sprintf/sprintf.dart';

class NewFeedService extends BaseService {
  Future<List<NewFeed>> getNewFeeds() async {
    return [];
  }

  Future<List<NewFeed>> getSuggestFeeds(
      int page, int pageSize, double lng, double lat, String userId,
      {GetQueryParam? dataPost}) async {
    if (dataPost == null) dataPost = GetQueryParam();
    dataPost.page = page;
    dataPost.limit = pageSize;
    dataPost.filters?.add(FilterRequestItem(key: "user", value: userId)) ;
    final response =
        await get(sprintf(SUGGEST_POST, [lng, lat]), params: dataPost.toJson());
    return List<NewFeed>.from(response.map((item) => NewFeed.fromJson(item)));
  }

  Future<NewFeedResponse> getPostsChoice(
      int page, int pageSize, List<FilterRequestItem>? filters,
      {bool? isChoice}) async {
    if (isChoice != null) {
      if (filters == null) filters = [];
      filters.add(FilterRequestItem(key: "isChoice", value: isChoice));
    }
    final response = await get2(
      FILTER_POST,
      params:
          GetQueryParam(page: page, limit: pageSize, filters: filters).toJson(),
    );
    var items =
        List<NewFeed>.from(response.data.map((item) => NewFeed.fromJson(item)));
    return NewFeedResponse(items, total: response.total);
  }

  Future<NewFeedResponse> getPostsHot(
      int page, int pageSize, List<FilterRequestItem>? filters) async {
    final response = await get2(
      DISCOVERY_HOT_NEWFEED,
      params:
          GetQueryParam(page: page, limit: pageSize, filters: filters).toJson(),
    );
    var items =
        List<NewFeed>.from(response.data.map((item) => NewFeed.fromJson(item)));
    return NewFeedResponse(items, total: response.total);
  }

  Future<List<NewFeed>> getFollowingFeeds(int page, int pageSize) async {
    final response =
        await post(FOLLOWING_POST, data: {"page": page, "limit": pageSize});
    return List<NewFeed>.from(response.map((item) => NewFeed.fromJson(item)));
  }

  Future<List<UserNewFeed>> getUserNewFeedsOfUser(
      String userId, int page, int pageSize) async {
    final response = await get(
      sprintf(USER_POST, [userId]),
      params: GetQueryParam(
        page: page,
        limit: pageSize,
      ).toJson(),
    );
    return List<UserNewFeed>.from(
        response.map((item) => UserNewFeed.fromJson(item)));
  }

  Future<List<NewFeed>> getUserNewFeedsOfUserVer3(
      String userId, int page, int pageSize) async {
    final response = await get(
      sprintf(USER_POST_V3, [userId]),
      params: GetQueryParam(page: page, limit: pageSize, filters: [
        FilterRequestItem(key: "ver", value: "v3"),
      ]).toJson(),
    );
    return List<NewFeed>.from(response.map((item) => NewFeed.fromJson(item)));
  }

  Future<List<Comments>> getCommentsUnknown(
      String idPost, int page, int limit) async {
    final response = await get(
      sprintf(COMMENTS_UNKNOWN_POST, [idPost]),
      params: GetQueryParam(page: page, limit: limit).toJson(),
    );
    return List<Comments>.from(response.map((item) => Comments.fromJson(item)));
  }

  Future<List<Comments>> getCommentsChild(String idPost, String idParent,
      {required int page, required int limit}) async {
    final response = await get(sprintf(COMMENTS_CHILD_POST, [idPost, idParent]),
        params: GetQueryParam(page: page, limit: limit).toJson());
    return List<Comments>.from(response.map((item) => Comments.fromJson(item)));
  }

  Future deleteComments(String idPost, String idComment) async {
    final response =
        await delete(sprintf(COMMENTS_DELETE_POST, [idPost, idComment]));
    return response;
  }

  Future editComments(
      String idPost, String idComment, CommentsParam param) async {
    final response = await put(
        sprintf(COMMENTS_DELETE_POST, [idPost, idComment]),
        data: param.toJson());
    return response;
  }

  Future<Comments> createComment(String idPost, CommentsParam param) async {
    final response = await post(sprintf(CREATE_COMMENTS_POST, [idPost]),
        data: param.toJson());
    return Comments.fromJson(response);
  }

  Future favoriteComment(String idComment, bool isFavorite) async {
    if (isFavorite) {
      final response =
          await post(sprintf(COMMENTS_FAVORITE_POST_DELETE, [idComment]));
      return response;
    } else {
      final response =
          await delete(sprintf(COMMENTS_FAVORITE_POST_DELETE, [idComment]));
      return response;
    }
  }

  Future<NewFeed?> createNewFeed(NewFeed newFeed) async {
    try {
      Map<String, dynamic> data = newFeed.toJson();
      data["topics"] = newFeed.topics != null
          ? List<dynamic>.from(
              newFeed.topics!.toSet().toList().map((x) => x.id))
          : [];
      data["tags"] = newFeed.tags != null
          ? List<dynamic>.from(newFeed.tags!.toSet().toList().map((x) => x.id))
          : [];
      data["hashtags"] = newFeed.hashtags != null
          ? List<dynamic>.from(newFeed.hashtags!.toSet().toList().map((x) => x))
          : [];
      var response = await post(CREATE_POST, data: data);
      return NewFeed.fromJson(response);
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> deleteNewFeed(String newFeedId) async {
    await delete(sprintf(DELETE_POST, [newFeedId]));
  }

  Future<void> updateNewFeed(NewFeed newFeed) async {
    newFeed.tags = newFeed.tags!.toSet().toList();
    newFeed.hashtags = newFeed.hashtags!.toSet().toList();
    Map<String, dynamic> data = newFeed.toJson();
    data["topics"] = newFeed.topics != null
        ? List<dynamic>.from(newFeed.topics!.toSet().toList().map((x) => x.id))
        : [];
    data["tags"] = newFeed.tags != null
        ? List<dynamic>.from(newFeed.tags!.toSet().toList().map((x) => x.id))
        : [];
    data["hashtags"] = newFeed.hashtags != null
        ? List<dynamic>.from(newFeed.hashtags!.toSet().toList().map((x) => x))
        : [];
    await put(sprintf(UPDATE_POST, [newFeed.id]), data: data);
  }
}
