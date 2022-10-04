import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/comments.dart';
import 'package:lomo/data/api/models/comments_param.dart';
import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/repositories/new_feed_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_list_model.dart';
import 'package:lomo/util/constants.dart';
import 'package:lomo/util/validate_utils.dart';
import 'package:rxdart/rxdart.dart';

import '../../app/lomo_app.dart';
import '../../data/eventbus/outside_newfeed_event.dart';

class CommentModel extends BaseListModel<Comments> {
  late CommentType commentType;
  NewFeed? newFeed;

  final commentsRepository = locator<NewFeedRepository>();

  ValueNotifier<bool> showReplyComment = ValueNotifier(false);
  ValueNotifier<Object?> clearTextNotifier = ValueNotifier(null);
  ValueNotifier<bool> showButtonSend = ValueNotifier(false);
  ValueNotifier<Object?> editCommentNotifier = ValueNotifier(null);

  Comments? replyingComment;
  Comments? replyingSubComment;

  String? imageParam;
  List<String> tagsParam = [];
  List<User> listTaggedUser = [];
  List<String> hashtagsParam = [];
  FocusNode myFocusNode = FocusNode();
  String content = "";
  String idComment = "";

  final textStreamController = BehaviorSubject<String>();

  Stream<bool> get textStream =>
      textStreamController.stream.transform(textValidation);
  var textValidation =
      StreamTransformer<String, bool>.fromHandlers(handleData: (text, sink) {
    sink.add(validateComment(text));
  });

  Sink<String> get textSink => textStreamController.sink;

  init(CommentType commentType, {NewFeed? newFeed}) {
    // bắn event thông báo đã ra khỏi tab news feed
    eventBus.fire(OutSideNewFeedsEvent());
    this.commentType = commentType;
    this.newFeed = newFeed;
    Rx.combineLatest([textStreamController], (text) {
      return validateComment(text[0].toString());
    }).listen((event) {
      showButtonSend.value = event;
    });
    loadData();
  }

  updateText(String? data) {
    notifyListeners();
  }

  @override
  Future<List<Comments>> getData({params, bool isClear = false}) async {
    switch (commentType) {
      case CommentType.post:
        return await commentsRepository.getCommentsUnknown(newFeed!.id!, page);
    }
  }

  Future<Comments?> createComment(bool? isEdit, String idComment) async {
    CommentsParam param = CommentsParam(
      parent: replyingComment == null ? null : replyingComment!.id!,
      image: imageParam,
      tags: tagsParam.toList(),
      hashtags: hashtagsParam.toList(),
      content: content,
      reply: showReplyComment.value
          ? replyingSubComment != null
              ? replyingSubComment!.user!.isMe
                  ? null
                  : replyingSubComment!.user!.id
              : replyingComment!.user!.isMe
                  ? null
                  : replyingComment?.user?.id
          : null,
    );
    Comments? result;
    switch (commentType) {
      case CommentType.post:
        result = isEdit != true
            ? await createCommentPost(param)
            : await editComment(idComment, param);
    }
    if (result != null) {
      if (replyingComment != null) {
        replyingComment?.children.add(replyingComment!);
        replyingComment?.numberOfComment++;
        notifyListeners();
      } else {
        items.insert(0, result);
      }
      clearTextNotifier.value = Object();
      showButtonSend.value = false;
      replyingComment = null;
      replyingSubComment = null;
      showReplyComment.value = false;
      notifyListeners();
    }

    return result;
  }

  Future<Comments?> createCommentPost(CommentsParam param) async {
    Comments? createSuccessComment;
    await callApi(doSomething: () async {
      createSuccessComment =
          await commentsRepository.createComment(newFeed!, param);
    });
    return createSuccessComment;
  }

  deleteComment(String idComment) async {
    await callApi(doSomething: () async {
      await commentsRepository.deleteComments(newFeed!, idComment);
      items.removeWhere((element) => element.id == idComment);
      notifyListeners();
    });
  }

  Future<Comments?> editComment(String idComment, CommentsParam param) async {
    Comments? createSuccessComment;
    await callApi(doSomething: () async {
      createSuccessComment =
          await commentsRepository.editComments(newFeed!, idComment, param);
    });
    return createSuccessComment;
  }

  @override
  void dispose() {
    textStreamController.close();
    myFocusNode.dispose();
    showReplyComment.dispose();
    showButtonSend.dispose();
    super.dispose();
  }
}
