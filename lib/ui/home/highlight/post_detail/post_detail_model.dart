import 'package:flutter/cupertino.dart';
import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/eventbus/delete_post_event.dart';
import 'package:lomo/data/eventbus/lock_post_event.dart';
import 'package:lomo/data/eventbus/refresh_total_comment_event.dart';
import 'package:lomo/data/repositories/new_feed_repository.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_model.dart';

class PostDetailModel extends BaseModel {
  final _newFeedRepository = locator<NewFeedRepository>();
  final _userRepository = locator<UserRepository>();
  ValueNotifier<bool> contentValue = ValueNotifier(true);
  ValueNotifier<bool> viewMoreValue = ValueNotifier(true);
  ValueNotifier<int> indicatorStep = ValueNotifier(0);
  ValueNotifier<int> numOfComment = ValueNotifier(0);
  ValueNotifier<NewFeed?> newFeedValue = ValueNotifier(null);
  int photoIndex = 0;
  final user = User.fromJson(locator<UserModel>().user!.toJson());

  init(NewFeed newFeed, int photoIndex) async {
    this.newFeedValue.value = newFeed;
    this.photoIndex = photoIndex;
    indicatorStep.value = photoIndex;
    numOfComment.value = newFeed.numberOfComment;
    eventBus.on<RefreshTotalCommentEvent>().listen((event) {
      if (event.newFeed.id == newFeed.id)
        numOfComment.value = event.newFeed.numberOfComment;
    });
    //An bai dang khi CRM lock
    eventBus.on<LockPostEvent>().listen((event) {
      if (newFeed.id == event.postId) {
        newFeed.isLock = true;
        print(">>>>>>>>>>>>>>>>DETAIL Lock POST: ${event.postId}");
        notifyListeners();
        return;
      }
    });
    //Xoa bai dang khi owner xoa
    eventBus.on<DeletePostEvent>().listen((event) {
      if (newFeed.id == event.postId) {
        newFeed.isDeleted = true;
        print(">>>>>>>>>>>>>>>>DETAIL DELETE POST: ${event.postId}");
        notifyListeners();
        return;
      }
    });
  }

  onShowHideContent() {
    contentValue.value = !contentValue.value;
    notifyListeners();
  }

  onViewMoreContent() {
    viewMoreValue.value = !viewMoreValue.value;
    notifyListeners();
  }

  @override
  ViewState get initState => ViewState.loaded;

  sendBear(String userId) async {
    await callApi(doSomething: () async {
      await _userRepository.sendBear(userId);
      locator<UserModel>().user!.numberOfCandy =
          locator<UserModel>().user!.numberOfCandy! - 1;
      locator<UserModel>().notifyListeners();
    });
  }

  block(User user) async {
    await callApi(doSomething: () async {
      _userRepository.blockUser(user);
    });
  }

  deleteNewFeed(String postId) async {
    await callApi(doSomething: () async {
      await _newFeedRepository.deleteNewFeed(postId);
    });
  }

  @override
  void dispose() {
    indicatorStep.dispose();
    contentValue.dispose();
    numOfComment.dispose();
    newFeedValue.dispose();
    super.dispose();
  }
}
