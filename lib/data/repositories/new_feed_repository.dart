import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/api/api_constants.dart';
import 'package:lomo/data/api/models/comments.dart';
import 'package:lomo/data/api/models/comments_param.dart';
import 'package:lomo/data/api/models/filter_request_item.dart';
import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/data/api/models/response/NewFeedResponse.dart';
import 'package:lomo/data/api/models/user_newfeed.dart';
import 'package:lomo/data/api/services/new_feed_service.dart';
import 'package:lomo/data/eventbus/refresh_total_comment_event.dart';
import 'package:lomo/data/repositories/base_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/util/location_manager.dart';

class NewFeedRepository extends BaseRepository {
  final _newFeedService = locator<NewFeedService>();

  Future<List<NewFeed>> getNewFeeds() async {
    return _newFeedService.getNewFeeds();
  }

  Future<List<NewFeed>> getSuggestFeeds(int page, int pageSize, {GetQueryParam? dataPost}) async {
    final _locationManager = locator<LocationManager>();
    final userId = locator<UserModel>().user!.id!;
    return _newFeedService.getSuggestFeeds(
        page, pageSize, _locationManager.locationLng, _locationManager.locationLat, userId,
        dataPost: dataPost);
  }

  Future<List<NewFeed>> getFollowingFeeds(int page, int pageSize) async {
    return _newFeedService.getFollowingFeeds(page, pageSize);
  }

  Future<List<UserNewFeed>> getUserNewFeedsOfUser(String userId, int page, int pageSize) async {
    return _newFeedService.getUserNewFeedsOfUser(userId, page, pageSize);
  }

  Future<List<NewFeed>> getUserNewFeedsOfUserVer3(String userId, int page, int pageSize) async {
    return _newFeedService.getUserNewFeedsOfUserVer3(userId, page, pageSize);
  }

  Future<List<Comments>> getCommentsUnknown(String idPost, int page,
      {int limit = PAGE_SIZE}) async {
    return _newFeedService.getCommentsUnknown(idPost, page, limit);
  }

  Future<List<Comments>> getCommentsChild(String idPost, String idParent,
      {int page = 1, int limit = PAGE_SIZE}) async {
    return _newFeedService.getCommentsChild(idPost, idParent, page: page, limit: limit);
  }

  Future deleteComments(NewFeed newFeed, String idComment) async {
    var response = _newFeedService.deleteComments(newFeed.id!, idComment);
    newFeed.numberOfComment = newFeed.numberOfComment - 1;
    eventBus.fire(RefreshTotalCommentEvent(newFeed, false));
    return response;
  }

  Future editComments(NewFeed newFeed, String idComment, CommentsParam param) async {
    var response = _newFeedService.editComments(newFeed.id!, idComment, param);
    eventBus.fire(RefreshTotalCommentEvent(newFeed, false));
    return response;
  }

  Future<Comments> createComment(NewFeed newFeed, CommentsParam param) async {
    var response = _newFeedService.createComment(newFeed.id!, param);
    newFeed.numberOfComment = newFeed.numberOfComment + 1;
    eventBus.fire(RefreshTotalCommentEvent(newFeed, true));
    return response;
  }

  Future favoriteComment(String idComment, bool isFavorite) async {
    return _newFeedService.favoriteComment(idComment, isFavorite);
  }

  Future<NewFeed?> createNewFeed(NewFeed newFeed) async {
    return _newFeedService.createNewFeed(newFeed);
  }

  Future<void> deleteNewFeed(String newFeedId) async {
    return _newFeedService.deleteNewFeed(newFeedId);
  }

  Future<void> updateNewFeed(NewFeed newFeed) async {
    return _newFeedService.updateNewFeed(newFeed);
  }

  Future<NewFeedResponse> getPostsChoice(
          {required int page,
          required int pageSize,
          List<FilterRequestItem>? filters,
          bool? isChoice}) async =>
      _newFeedService.getPostsChoice(page, pageSize, filters, isChoice: isChoice);

  Future<NewFeedResponse> getPostsHot(
          {required int page, required int pageSize, List<FilterRequestItem>? filters}) async =>
      _newFeedService.getPostsHot(page, pageSize, filters);
}
