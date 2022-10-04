import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/comments.dart';
import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/comment/comment_children/comment_children_model.dart';
import 'package:lomo/ui/widget/favorite_comment_check_box.dart';
import 'package:lomo/ui/widget/html_view_widget.dart';
import 'package:lomo/ui/widget/image_widget.dart';
import 'package:lomo/ui/widget/seo_intent_link_widget.dart';
import 'package:lomo/ui/widget/user_info_widget.dart';
import 'package:lomo/util/common_utils.dart';
import 'package:lomo/util/constants.dart';
import 'package:lomo/util/date_time_utils.dart';
import 'package:lomo/util/new_feed_util.dart';
import 'package:provider/provider.dart';

import '../option_comment_popup_widget.dart';

class CommentChildrenScreen extends StatefulWidget {
  final CommentChildrenScreenArgument args;

  // CommentChildrenScreen(this.args);

   CommentChildrenScreen({Key? key,  required this.args}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CommentChildrenScreenState();
}

class _CommentChildrenScreenState
    extends BaseState<CommentChildrenModel, CommentChildrenScreen> {
  @override
  void initState() {
    super.initState();
    model.init(widget.args.commentType, widget.args.parentComment,
        newFeed: widget.args.newFeed);
  }

  @override
  void didUpdateWidget(covariant CommentChildrenScreen oldWidget) {
    model.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: model),
          ValueListenableProvider.value(value: model.isShowChildren),
        ],
        child: Consumer2<CommentChildrenModel, bool>(
          builder: (context, model, isShowChildren, child) =>
              model.parentComment.children.isNotEmpty == true
                  ? isShowChildren
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListView.separated(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) => buildItem(
                                  context,
                                  model.parentComment.children[index],
                                  index),
                              separatorBuilder: (context, index) => SizedBox(
                                height: 0,
                              ),
                              itemCount: model.parentComment.children.length,
                            ),
                            _buildShowLessChildren()
                          ],
                        )
                      : _buildShowFullChildren()
                  : SizedBox(
                      height: 5,
                    ),
        ));
  }

  Widget _buildShowLessChildren() {
    return InkWell(
      onTap: () {
        model.isShowChildren.value = false;
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 8, bottom: 8),
        child: Row(
          children: [
            Spacer(),
            Text(
              Strings.collapse.localize(context),
              style: textTheme(context).text12.colorHint,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              width: 2,
            ),
            Icon(
              Icons.keyboard_arrow_up_outlined,
              size: 17,
              color: getColor().textHint,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildShowFullChildren() {
    return InkWell(
      onTap: () {
        model.isShowChildren.value = true;
      },
      onLongPress: () {},
      child: Container(
        padding: EdgeInsets.only(left: 15, top: 0, bottom: 10),
        child: Text(
          Strings.extendThisComment.localize(context),
          style: textTheme(context).text13.semiBold.colorDart,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  @override
  Widget buildContentView(BuildContext context, CommentChildrenModel model) {
    return Container();
  }

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
                    model.deleteComment(item.id!);
                    Navigator.pop(context);
                    FocusScope.of(context).unfocus();
                    showToast(Strings.deleteSuccess.localize(context));
                  },
                  onEditClicked: (data) {
                    Navigator.pop(context);
                    FocusScope.of(context).unfocus();
                    showToast(Strings.editSuccess.localize(context));
                  },
                  item: item,
                  isMe: item.user!.isMe,
                ));
      },
      child: Container(
        padding: EdgeInsets.only(bottom: 0, top: 15),
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
            SizedBox(width: 12),
            Expanded(child: _buildContentComment(item)),
            FavoriteCommentCheckBox(
              comment: item,
              width: 32.0,
              height: 32.0,
              padding: 2.0,
            ),
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
        SizedBox(
          height: 5,
        ),
        Text(
          comment.user?.name ?? "",
          style: textTheme(context).text15.bold.darkTextColor,
        ),
        SizedBox(
          height: 2,
        ),
        HtmlViewComments(
          comments: comment,
          textStyle:
              textTheme(context).text15.captionNormal.colorDart.height30Per,
          cssTagHtmlClass: CssStyleClass.bold_13_violet,
          cssHashTagHtmlClass: CssStyleClass.bold_13_black,
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
        // if (model.parentComment.children.indexOf(comment) !=
        //     model.parentComment.children.length - 1)
        SizedBox(
          height: Dimens.size10,
        ),
        Divider(
          height: 2,
          color: getColor().colorDivider,
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
            style: textTheme(context).text12.captionNormal.colorHint,
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
            if (widget.args.onReplyComment != null) {
              widget.args.onReplyComment!(model.parentComment, comment);
            }
          },
          child: Container(
            padding: EdgeInsets.only(left: 5, right: 20, top: 5, bottom: 4),
            child: Text(
              Strings.reply.localize(context),
              style: textTheme(context).text13.colorBlack00.semiBold,
            ),
          ),
        ),
      ],
    );
  }
}

class CommentChildrenScreenArgument {
  CommentType commentType;
  Comments parentComment;
  NewFeed? newFeed;
  Function(Comments reply, Comments subReply)? onReplyComment;

  CommentChildrenScreenArgument(
      {required this.commentType,
      required this.parentComment,
      this.newFeed,
      this.onReplyComment});
}
