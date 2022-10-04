import 'package:flutter/cupertino.dart';
import 'package:lomo/data/api/models/comments.dart';
import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/data/repositories/new_feed_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_model.dart';
import 'package:lomo/util/constants.dart';

class CommentChildrenModel extends BaseModel {
  ValueNotifier<bool> isShowChildren = ValueNotifier(false);
  late CommentType commentType;
  late Comments parentComment;
  var commentsRepository = locator<NewFeedRepository>();
  NewFeed? newFeed;

  init(CommentType commentType, Comments parentComment, {NewFeed? newFeed}) {
    this.commentType = commentType;
    this.newFeed = newFeed;

    this.parentComment = parentComment;
    loadData();
  }

  loadData() async {
    List<Comments> childrenComment = [];
    switch (commentType) {
      case CommentType.post:
        if (parentComment.numberOfComment > 0) {
          childrenComment = await commentsRepository.getCommentsChild(
              newFeed!.id!, parentComment.id!,
              page: 1, limit: 100);
        }
    }
    parentComment.children.clear();
    parentComment.children.addAll(childrenComment.reversed.toList());
    notifyListeners();
  }

  deleteComment(String idComment) async {
    await callApi(doSomething: () async {
      await commentsRepository.deleteComments(newFeed!, idComment);
      parentComment.children.removeWhere((element) => element.id == idComment);
      notifyListeners();
    });
  }

  @override
  void dispose() {
    isShowChildren.dispose();
    super.dispose();
  }
}
