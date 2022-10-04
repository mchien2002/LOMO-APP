import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/api/api_constants.dart';
import 'package:lomo/data/api/models/filter_request_item.dart';
import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/database/db_manager.dart';
import 'package:lomo/data/eventbus/delete_post_event.dart';
import 'package:lomo/data/eventbus/follow_user_event.dart';
import 'package:lomo/data/eventbus/give_bear_event.dart';
import 'package:lomo/data/eventbus/lock_post_event.dart';
import 'package:lomo/data/eventbus/refresh_mypost_event.dart';
import 'package:lomo/data/repositories/new_feed_repository.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_list_model.dart';
import 'package:rxdart/rxdart.dart';

class TimelineListModel extends BaseListModel<NewFeed> {
  final _newFeedRepository = locator<NewFeedRepository>();
  final _userRepository = locator<UserRepository>();
  final commentSubject = BehaviorSubject<bool>();
  GetQueryParam? postFilters;
  bool checkFilter = false;

  @override
  Future<List<NewFeed>?> getData({params, bool isClear = false}) async {
    //Trang dau tien skip = 0
    final data = await _newFeedRepository.getSuggestFeeds(page, PAGE_SIZE,
        dataPost: postFilters);
    //Luu page dau tien vao local
    if (page == 1 && data.isNotEmpty) locator<DbManager>().addNewFeeds(data);
    return data;
    // return [];
  }

  init() {
    eventBus.on<GiveBearUserEvent>().listen((event) async {
      items.forEach((newFeed) {
        if (newFeed.user!.id == event.userId) {
          newFeed.isBear = event.isBear;
        }
      });
      notifyListeners();
    });

    eventBus.on<FollowUserEvent>().listen((event) async {
      items.forEach((newFeed) {
        if (event.userId == newFeed.user!.id) {
          newFeed.user!.isFollow = event.isFollow;
        }
      });
      notifyListeners();
    });
    eventBus.on<RefreshMyPostEvent>().listen((event) {
      items.removeWhere((element) => element.id == event.newFeedId);
      notifyListeners();
    });
    //An bai dang khi CRM lock
    eventBus.on<LockPostEvent>().listen((event) {
      items.forEach((element) {
        if (element.id == event.postId) {
          element.isLock = true;
          notifyListeners();
          return;
        }
      });
    });
    //Xoa bai dang khi owner xoa
    eventBus.on<DeletePostEvent>().listen((event) {
      items.forEach((element) {
        if (element.id == event.postId) {
          element.isDeleted = true;
          notifyListeners();
          return;
        }
      });
    });
  }

  @override
  Future<List<NewFeed>> getCacheData({params}) async {
    var data = await locator<DbManager>().getNewFeeds();
    return data;
  }

  sendBear(String userId) async {
    await callApi(doSomething: () async {
      await _userRepository.sendBear(userId);
      locator<UserModel>().user!.numberOfCandy =
          locator<UserModel>().user!.numberOfCandy! - 1;
      locator<UserModel>().notifyListeners();
    });
  }

  deleteNewFeed(String postId) async {
    await callApi(doSomething: () async {
      await _newFeedRepository.deleteNewFeed(postId);
      items.removeWhere((element) => element.id == postId);
      notifyListeners();
    });
  }

  @override
  void dispose() {
    super.dispose();
    commentSubject.close();
  }

  block(User user) async {
    await callApi(doSomething: () async {
      await _userRepository.blockUser(user);
      items.removeWhere((element) => element.user?.id == user.id);
      notifyListeners();
    });
  }
}
