import "package:collection/collection.dart";
import 'package:flutter/cupertino.dart';
import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/data/api/api_constants.dart';
import 'package:lomo/data/api/models/group_new_feed.dart';
import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/eventbus/delete_post_event.dart';
import 'package:lomo/data/eventbus/follow_user_event.dart';
import 'package:lomo/data/eventbus/lock_post_event.dart';
import 'package:lomo/data/eventbus/refresh_mypost_event.dart';
import 'package:lomo/data/eventbus/refresh_profile_event.dart';
import 'package:lomo/data/repositories/new_feed_repository.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_model.dart';
import 'package:lomo/util/date_time_utils.dart';
import 'package:rxdart/rxdart.dart';

class MyPostModel extends BaseModel {
  final newNewFeedRepository = locator<NewFeedRepository>();
  final userRepository = locator<UserRepository>();
  final commentSubject = BehaviorSubject<bool>();
  ValueNotifier<List<GroupNewFeed>> listValue = ValueNotifier([]);
  late String userId;
  int page = 1;
  bool stop = false;

  ViewState get initState => ViewState.loading;

  init(String userId) {
    this.userId = userId;
    eventBus.on<FollowUserEvent>().listen((event) async {
      listValue.value.forEach((element) {
        element.newFeeds.forEach((element1) {
          element1.user?.isFollow = event.isFollow;
        });
      });
    });
  }

  List<GroupNewFeed> renderGroupNewFeed(List<NewFeed> newFeeds) {
    List<GroupNewFeed> items = [];
    var groupByDate = groupBy(newFeeds,
        (item) => getMonthYearByTimeStamp((item as NewFeed).createdAt!));
    groupByDate.forEach((date, list) {
      items.add(GroupNewFeed(date, list));
    });
    return items;
  }

  void getMore() async {
    if (!stop) {
      page++;
      await getData();
    }
  }

  favoritePost(String id, bool isFavorite) async {
    if (isFavorite) {
      await callApi(doSomething: () async {
        await userRepository.unFavoritePost(id);
      });
    } else {
      await callApi(doSomething: () async {
        await userRepository.favoritePost(id);
      });
    }
  }

  block(User user) async {
    await callApi(doSomething: () async {
      userRepository.blockUser(user);
    });
  }

  unFollow(User user) async {
    await callApi(doSomething: () async {
      userRepository.unFollowUser(user);
    });
  }

  initEventBus() async {
    eventBus.on<RefreshProfileEvent>().listen((event) async {
      await refresh();
    });
    //An bai dang khi CRM lock
    eventBus.on<LockPostEvent>().listen((event) {
      listValue.value.forEach((group) {
        group.newFeeds.removeWhere((element) => element.id == event.postId);
      });
      notifyListeners();
    });
    //Xoa bai dang khi owner xoa
    eventBus.on<DeletePostEvent>().listen((event) {
      listValue.value.forEach((group) {
        group.newFeeds.removeWhere((element) => element.id == event.postId);
      });
      notifyListeners();
    });
  }

  initEventBusMe() async {
    eventBus.on<RefreshWhenCreatePostEvent>().listen((event) async {
      await refresh();
    });
    eventBus.on<RefreshMyPostEvent>().listen((event) {
      refresh();
    });
  }

  deleteNewFeed(String postId) async {
    await callApi(doSomething: () async {
      await newNewFeedRepository.deleteNewFeed(postId);
      removeNewFeedItem(postId);
    });
  }

  removeNewFeedItem(String postId) {
    listValue.value.forEach((group) {
      group.newFeeds.removeWhere((element) => element.id == postId);
    });
    listValue.value.removeWhere((element) => element.newFeeds.length == 0);
    notifyListeners();
  }

  @override
  void dispose() {
    commentSubject.close();
    listValue.dispose();
    super.dispose();
  }

  Future<void> getData({params}) async {
    final res = await newNewFeedRepository.getUserNewFeedsOfUserVer3(
        userId, page, PAGE_SIZE);
    final group = renderGroupNewFeed(res);
    stop = res.length < PAGE_SIZE;
    listValue.value.addAll(group);
    viewState = ViewState.loaded;
    notifyListeners();
  }

  Future<void> refresh() async {
    page = 1;
    stop = false;
    listValue.value.clear();
    getData();
  }
}
