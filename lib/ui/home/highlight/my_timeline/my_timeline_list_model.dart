// ignore_for_file: unnecessary_statements

import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/api/api_constants.dart';
import 'package:lomo/data/api/models/filter_request_item.dart';
import 'package:lomo/data/eventbus/delete_post_event.dart';
import 'package:lomo/data/eventbus/follow_user_event.dart';
import 'package:lomo/data/eventbus/give_bear_event.dart';
import 'package:lomo/data/eventbus/lock_post_event.dart';
import 'package:lomo/ui/base/base_list_model.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/api/models/new_feed.dart';
import '../../../../data/api/models/user.dart';
import '../../../../data/database/db_manager.dart';
import '../../../../data/repositories/new_feed_repository.dart';
import '../../../../data/repositories/user_repository.dart';
import '../../../../di/locator.dart';

class MyTimeLineListModel extends BaseListModel<NewFeed> {
  final _newFeedRepository = locator<NewFeedRepository>();
  final _userRepository = locator<UserRepository>();
  // BehaviorSubject lưu trữ lại giá trị mới emit gần nhất để khi một Observer mới subscribe vào, nó sẽ emit giá trị đó ngay lập tức cho Observer vừa rồi.
  // Chưa biết dùng commentSubject để làm gì
  final commentSubject = BehaviorSubject<bool>();
  GetQueryParam? postFilters;
  bool checkFilter = false;
  @override
  Future<List<NewFeed>?> getData({params, bool isClear = false}) async {
    final data = await _newFeedRepository.getSuggestFeeds(page, PAGE_SIZE,
        dataPost: postFilters);
    // Lưu vào data local khi không có mạng
    if (data.isNotEmpty) locator<DbManager>().addNewFeeds(data);
    return data;
  }

  // register listener
  init() {
    eventBus.on<GiveBearUserEvent>().listen((event) async {
      items.forEach((newFeed) {
        if (newFeed.user!.id == event.userId) {
          newFeed.isBear = event.isBear;
        }
      });
      notifyListeners();
    });
    eventBus.on<FollowUserEvent>().listen((event) {
      items.forEach((newFeed) {
        if (newFeed.user!.id == event.userId) {
          newFeed.user!.isFollow == event.isFollow;
        }
      });
      notifyListeners();
    });
    eventBus.on<DeletePostEvent>().listen((event) {
      items.forEach((newFeed) {
        if (newFeed.user!.id == event.postId) {
          newFeed.isDeleted = true;
          notifyListeners();
          return;
        }
      });
    });
    eventBus.on<LockPostEvent>().listen((event) {
      items.forEach((element) {
        if (element.user!.id == event.postId) {
          element.isLock = true;
          notifyListeners();
          return;
        }
      });
    });
  }

  // chưa hiểu lắm
  sendBear(String userID) async {
    await callApi(doSomething: () async {
      await _userRepository.sendBear(userID);
      locator<UserModel>().user!.numberOfCandy =
          locator<UserModel>().user!.numberOfCandy! - 1;
      // locator<UserModel>().notifyListeners();
      notifyListeners();
    });
  }

  deleteNewFeedPost(String postID) async {
    await callApi(doSomething: () async {
      await _newFeedRepository.deleteNewFeed(postID);
      items.removeWhere((element) => element.id == postID);
      notifyListeners();
    });
  }

  // lấy data trong bộ nhớ đệm
  @override
  Future<List<NewFeed>?>? getCacheData({params}) async {
    var data = await locator<DbManager>().getNewFeeds();
    return data;
  }

  @override
  void dispose() {
    commentSubject.close();
    super.dispose();
  }

  // block user đã chọn
  block(User user) async {
    await _userRepository.blockUser(user);
    // remove user id
    items.removeWhere((element) => element.user!.id == user.id);
    notifyListeners();
  }
}
