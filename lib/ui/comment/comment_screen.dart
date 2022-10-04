import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/data/api/models/comments.dart';
import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/data/eventbus/edit_comment_event.dart';
import 'package:lomo/res/colors.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/base/base_list_state.dart';
import 'package:lomo/ui/comment/comment_model.dart';
import 'package:lomo/ui/widget/empty_widget.dart';
import 'package:lomo/ui/widget/favorite_comment_check_box.dart';
import 'package:lomo/ui/widget/html_view_widget.dart';
import 'package:lomo/ui/widget/image_widget.dart';
import 'package:lomo/ui/widget/seo_intent_link_widget.dart';
import 'package:lomo/ui/widget/tag_user_widget.dart';
import 'package:lomo/ui/widget/user_info_widget.dart';
import 'package:lomo/util/common_utils.dart';
import 'package:lomo/util/constants.dart';
import 'package:lomo/util/date_time_utils.dart';
import 'package:lomo/util/new_feed_util.dart';
import 'package:provider/provider.dart';

import 'comment_children/comment_chidren_screen.dart';
import 'option_comment_popup_widget.dart';

class CommentScreen extends StatefulWidget {
  final CommentType commentType;
  final NewFeed? newFeed;

  CommentScreen(this.commentType, {this.newFeed});

  @override
  State<StatefulWidget> createState() => _CommentScreenState();
}

class _CommentScreenState
    extends BaseListState<Comments, CommentModel, CommentScreen> {
  final List<CommentMenu> commentItem = CommentMenu.values;

  @override
  void initState() {
    super.initState();
    model.init(widget.commentType, newFeed: widget.newFeed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Divider(
            height: 2,
            color: getColor().grayBorder,
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: super.build(context),
          ),
          _buildAddComment()
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_ios,
            size: Dimens.size25,
            color: getColor().black4B,
          ),
        ),
      ),
      centerTitle: true,
      title: Text(
        Strings.comments.localize(context),
        style: textTheme(context).text18Bold.colorDart,
      ),
    );
  }

  @override
  Widget buildItem(BuildContext context, Comments item, int index) {
    return InkWell(
      onLongPress: () {
        showModalBottomSheet(
            backgroundColor: Colors.transparent,
            enableDrag: false,
            context: context,
            isScrollControlled: true,
            builder: (context) => OptionCommentWidget(
                  onDeleteClicked: (data) {
                    model.deleteComment(item.id ?? "");
                    Navigator.pop(context);
                    FocusScope.of(context).unfocus();
                    showToast(Strings.deleteSuccess.localize(context));
                  },
                  onEditClicked: (data) {
                    model.idComment = data.id ?? "";
                    // model.updateText(data.content!);
                    eventBus.fire(EditCommentEvent(data: data));
                    Navigator.pop(context);
                    FocusScope.of(context).unfocus();
                    // showToast(Strings.editSuccess.localize(context));
                  },
                  isMe: item.user!.isMe,
                  item: item,
                ));
      },
      child: Container(
        padding: EdgeInsets.only(bottom: 0, top: 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    if (!item.user!.isMe)
                      Navigator.pushNamed(context, Routes.profile,
                          arguments: UserInfoAgrument(item.user!));
                  },
                  child:
                      CircleNetworkImage(url: item.user!.avatar, size: 40.0)),
            ),
            SizedBox(width: 10),
            Expanded(child: _buildContentComment(item)),
          ],
        ),
      ),
    );
  }

  Widget _buildContentComment(Comments comment) {
    String firstLinkInComment = getFirstLinkInComment(comment);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comment.user!.name!,
                    style: textTheme(context).text15.bold.darkTextColor,
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  HtmlViewComments(
                    comments: comment,
                    textStyle: textTheme(context)
                        .text13
                        .captionNormal
                        .colorDart
                        .height30Per,
                    cssTagHtmlClass: CssStyleClass.bold_13_violet,
                    cssHashTagHtmlClass: CssStyleClass.bold_13_black,
                  ),
                ],
              ),
            ),
            FavoriteCommentCheckBox(
              comment: comment,
              width: 32.0,
              height: 32.0,
              padding: 2.0,
            ),
          ],
        ),
        if (firstLinkInComment != "")
          HorizontalSeoIntentLinkWidget(
            firstLinkInComment,
            margin: const EdgeInsets.only(top: 10, bottom: 5),
          ),
        SizedBox(
          height: 5,
        ),
        _buildTimeAndReply(comment),
        SizedBox(
          height: Dimens.size10,
        ),
        Divider(
          height: 2,
          color: getColor().colorDivider,
        ),
        SizedBox(
          height: Dimens.size12,
        ),
        if (comment.numberOfComment != 0)
          CommentChildrenScreen(
            args: CommentChildrenScreenArgument(
              commentType: model.commentType,
              parentComment: comment,
              newFeed: model.newFeed,
              onReplyComment: (reply, subReply) {
                model.replyingComment = reply;
                model.replyingSubComment = subReply;
                model.showReplyComment.value = true;
                model.myFocusNode.requestFocus();
              },
            ),
          ),
      ],
    );
  }

  Widget _buildTimeAndReply(Comments comment) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(right: 5),
          child: Text(
            readTimeStampBySecond(comment.createdAt!, context),
            style: textTheme(context).text13.captionNormal.colorHint,
          ),
        ),
        MediaQuery.removePadding(
          context: context,
          removeTop: true,
          removeLeft: true,
          removeRight: true,
          child: Icon(
            Icons.brightness_1,
            size: 5,
            color: getColor().textHint,
          ),
        ),
        InkWell(
          onTap: () async {
            model.replyingComment = comment;
            model.showReplyComment.value = true;
          },
          child: Container(
            padding: EdgeInsets.only(left: 5, right: 20, top: 5, bottom: 4),
            child: Text(
              Strings.reply.localize(context),
              style:
                  textTheme(context).text13.captionNormal.colorBlack00.semiBold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddComment() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(color: getColor().white, boxShadow: [
            BoxShadow(
                color: getColor().colorDivider,
                blurRadius: 1.0,
                offset: Offset(0.0, 0.2)),
          ]),
          padding: EdgeInsets.only(
              top: 15,
              bottom: 9,
              left: Dimens.padding_left_right + 5,
              right: Dimens.padding_left_right),
          child: SafeArea(
            child: Column(
              children: [
                _buildReplyComment(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: _buildMention(),
                    ),
                    SizedBox(
                      width: Dimens.spacing10,
                    ),
                    _buildActionButton(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReplyComment() {
    return ValueListenableProvider.value(
      value: model.showReplyComment,
      child: Consumer<bool>(
        builder: (context, isShow, child) {
          if (isShow) {
            return SafeArea(
              child: SizedBox(
                height: 30,
                child: Row(
                  children: [
                    Expanded(
                        flex: 3,
                        child: Container(
                          padding: EdgeInsets.only(right: 10),
                          child: Text(
                            Strings.replying.localize(context) +
                                (model.replyingComment != null
                                    ? model.replyingSubComment != null
                                        ? model.replyingSubComment!.user!.name!
                                        : model.replyingComment!.user!.name ??
                                            ""
                                    : ""),
                            style: textTheme(context).text13.bold.darkTextColor,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )),
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        model.replyingComment = null;
                        model.replyingSubComment = null;
                        FocusScope.of(context).unfocus();
                        model.clearTextNotifier.value = Object();
                        model.showReplyComment.value = false;
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            Text(Strings.cancel.localize(context),
                                style: textTheme(context)
                                    .text13
                                    .semiBold
                                    .colorDart,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.close,
                              size: 15,
                              color: getColor().textDart,
                            )
                          ],
                        ),
                      ),
                    )),
                  ],
                ),
              ),
            );
          } else {
            // model.myFocusNode.unfocus();
            return SizedBox(
              height: 0,
            );
          }
        },
      ),
    );
  }

  Widget _buildMention() {
    return StreamBuilder<bool>(
      initialData: true,
      stream: model.textStream,
      builder: (context, sn) {
        return Container(
          padding: EdgeInsets.only(left: 17, right: 17),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: getColor().f8f8faColor,
          ),
          child: TagUserWidget(
            focusNode: model.myFocusNode,
            clearTextEvent: model.clearTextNotifier,
            maxLines: 3,
            // maxLength: 200,
            onUsersTaggedChanged: (listUserTagged) {
              model.tagsParam.clear();
              model.listTaggedUser = listUserTagged;
              model.tagsParam = listUserTagged.map((e) => e.id!).toList();
            },
            defaultText: model.content,
            keyboardType: TextInputType.multiline,
            minLines: 1,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: Strings.addComment.localize(context),
              focusColor: getColor().textHint,
              hintStyle: textTheme(context).text13,
            ),
            onTextChanged: (value) {
              model.content = value;
              model.textSink.add(value);
            },
            textCapitalization: TextCapitalization.sentences,
          ),
        );
      },
    );
  }

  Widget _buildActionButton() {
    return ValueListenableProvider.value(
      value: model.showButtonSend,
      child: Consumer<bool>(
        builder: (context, isShow, child) => InkWell(
          onTap: isShow
              ? () async {
                  if (model.content.isNotEmpty == true) {
                    model.content = replaceUserNameWithUserId(
                        model.content, model.listTaggedUser);
                    model.hashtagsParam = getHashTagsFromText(model.content);
                    model.myFocusNode.unfocus();

                    callApi(callApiTask: () async {
                      await model.createComment(false, model.idComment);
                    }, onSuccess: () {
                      model.myFocusNode.unfocus();
                      print("Check DATA cmt");
                      // widget.newFeed?.numberOfComment ++ ;
                      // setState(() {
                      // });
                    });
                  }
                }
              : null,
          child: Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: !isShow ? DColors.whiteColor : DColors.violetColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(
              Icons.east_rounded,
              size: 26,
              color: !isShow ? DColors.violetColor : DColors.whiteColor,
            ),
          ),
        ),
      ),
    );
  }

  @override
  EdgeInsets get padding => EdgeInsets.symmetric(horizontal: 16);

  @override
  bool get reverse => true;

  @override
  bool get autoLoadData => false;

  Widget buildEmptyView(BuildContext context) {
    return EmptyWidget(
      message: Strings.noComment.localize(context),
    );
  }

  @override
  ScrollPhysics get physics => AlwaysScrollableScrollPhysics();
}

enum CommentMenu { delete }

extension CommentMenuExt on CommentMenu {
  String get name {
    switch (this) {
      case CommentMenu.delete:
        return Strings.delete;
    }
  }
}
