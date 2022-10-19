import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/res/constant.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/home/highlight/my_timeline/item/content_item.dart';
import 'package:lomo/ui/home/highlight/my_timeline/item/timeline_photo.dart';
import 'package:lomo/ui/home/highlight/my_timeline/item/timeline_video.dart';
import 'package:lomo/ui/home/highlight/my_timeline/item/user_info_playout.dart';
import 'package:lomo/ui/home/highlight/my_timeline/my_timeline_item_model.dart';
import 'package:lomo/ui/profile/mypost/my_post_screen.dart';
import 'package:lomo/ui/widget/seo_intent_link_widget.dart';
import 'package:lomo/util/new_feed_util.dart';

import '../../../../../app/lomo_app.dart';
import '../../../../../app/user_model.dart';
import '../../../../../data/api/models/filter_request_item.dart';
import '../../../../../data/api/models/topic_item.dart';
import '../../../../../data/api/models/user.dart';
import '../../../../../data/eventbus/outside_newfeed_event.dart';
import '../../../../../di/locator.dart';
import '../../../../../res/dimens.dart';
import '../../../../../res/images.dart';
import '../../../../../res/strings.dart';
import '../../../../../res/theme/text_theme.dart';
import '../../../../../res/values.dart';
import '../../../../../util/common_utils.dart';
import '../../../../../util/date_time_utils.dart';
import '../../../../../util/handle_link_util.dart';
import '../../../../../util/platform_channel.dart';
import '../../../../discovery/list_type_discovery/list_type_discovery_screen.dart';
import '../../../../new_feed/create_new_feed/create_new_feed_screen.dart';
import '../../../../report/report_screen.dart';
import '../../../../widget/bear/give_bear_widget.dart';
import '../../../../widget/bottom_sheet_widgets.dart';
import '../../../../widget/comment/group_comment_widget.dart';
import '../../../../widget/dialog_widget.dart';
import '../../../../widget/favorite_new_feed_check_box.dart';
import '../../../../widget/html_view_widget.dart';
import '../../timeline/item/timeline_item_view.dart';

class MyTimeLineItemView extends StatefulWidget {
  const MyTimeLineItemView(
      {Key? key,
      required this.newFeed,
      this.user,
      this.onDeleteAction,
      this.onViewFavoriteAction,
      this.onBlockUser,
      required this.isWathching})
      : super(key: key);
  final NewFeed newFeed;
  final User? user;
  final Function()? onDeleteAction;
  final Function()? onViewFavoriteAction;
  final Function(User)? onBlockUser;
  final bool isWathching;
  @override
  State<MyTimeLineItemView> createState() => _MyTimeLineItemViewState();
}

class _MyTimeLineItemViewState
    extends BaseState<MyTimeLineItemModel, MyTimeLineItemView>
    with SingleTickerProviderStateMixin {
  final List<NewFeedMenu> menuMoreItems = NewFeedMenu.values;
  final List<MyNewFeedMenu> myMenuMoreItems = MyNewFeedMenu.values;
  @override
  void initState() {
    super.initState();
    model.init(widget.newFeed);
  }

  isVideoContentPost() {
    return widget.newFeed.images!.isNotEmpty == true &&
        widget.newFeed.images![0].type == Constants.TYPE_VIDEO;
  }

  Widget _buildButtonMore(NewFeed newFeed) {
    var menuItems = newFeed.user!.isFollow
        ? menuMoreItems.toList()
        : menuMoreItems
            .where((element) => element != NewFeedMenu.unFollow)
            .toList();
    if (!canOpenChatWith(newFeed.user?.id) &&
        menuItems.contains(NewFeedMenu.sendMessage)) {
      menuItems.removeWhere((element) => element == NewFeedMenu.sendMessage);
    }
    return BottomSheetMenuWidget(
      items: menuItems.map((e) => e.name).toList(),
      onItemClicked: (index) async {
        switch (menuItems[index]) {
          case NewFeedMenu.report:
            Navigator.pushNamed(context, Routes.report,
                arguments:
                    ReportScreenArgs(user: newFeed.user!, newFeed: newFeed));
            break;
          case NewFeedMenu.block:
            showDialog(
                context: context,
                builder: (context) => TwoButtonDialogWidget(
                      title: Strings.blockThisUser.localize(context),
                      description: Strings.blockedUserContent.localize(context),
                      onConfirmed: () {
                        callApi(callApiTask: () async {
                          widget.onBlockUser!(newFeed.user!);
                        });
                      },
                    ));
            break;
          case NewFeedMenu.share:
            locator<HandleLinkUtil>().shareNewFeed(newFeed.id);
            break;
          case NewFeedMenu.sendMessage:
            locator<PlatformChannel>().openChatWithUser(
                locator<UserModel>().user!, widget.newFeed.user!);
            break;
          case NewFeedMenu.unFollow:
            showDialog(
                context: context,
                builder: (context) => TwoButtonDialogWidget(
                      title: Strings.stopFollowUser.localize(context),
                      description:
                          Strings.stopFollowUserContent.localize(context),
                      onConfirmed: () {
                        callApi(callApiTask: () async {
                          await model.unfolowUser(newFeed.user!);
                          newFeed.user!.isFollow = false;
                          showToast(Strings.unFollowSuccess.localize(context) +
                              " ${model.newFeed.user!.name}");
                        });
                      },
                    ));
            break;
          case NewFeedMenu.cancel:
            break;
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Image.asset(
          DImages.moreGray,
          height: Dimens.size36,
          width: Dimens.size36,
          color: getColor().grayBorder,
        ),
      ),
    );
  }

  Widget _buildMyButtonMore(NewFeed newFeed) {
    return BottomSheetMenuWidget(
      items: myMenuMoreItems.map((e) => e.name).toList(),
      onItemClicked: (index) async {
        // bắn event thông báo đã ra khỏi tab news feed
        eventBus.fire(OutSideNewFeedsEvent());
        switch (myMenuMoreItems[index]) {
          case MyNewFeedMenu.edit:
            Navigator.pushNamed(context, Routes.createNewFeed,
                arguments: CreateNewFeedAgrument(newFeed: newFeed));
            break;
          case MyNewFeedMenu.share:
            locator<HandleLinkUtil>().shareNewFeed(newFeed.id);
            break;
          case MyNewFeedMenu.delete:
            showDialog(
                context: context,
                builder: (context) => TwoButtonDialogWidget(
                      description: Strings.confirmDeletePost.localize(context),
                      onConfirmed: () {
                        callApi(callApiTask: () async {
                          if (widget.onDeleteAction != null)
                            widget.onDeleteAction!();
                        });
                      },
                    ));

            break;
          case MyNewFeedMenu.cancel:
            break;
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Image.asset(
          DImages.moreGray,
          height: Dimens.size36,
          width: Dimens.size36,
          color: getColor().grayBorder,
        ),
      ),
    );
  }

  Widget _contentInfoLayout(NewFeed item) {
    return Container(
      padding: EdgeInsets.only(bottom: Dimens.spacing15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: item.topics!.isNotEmpty ? 6 : 0,
          ),
          if (item.content != null && item.content!.isNotEmpty)
            _buildContent(item),
          SizedBox(
            height: item.content!.isNotEmpty ? 10 : 0,
          ),
          Text(
            readTimeStampByDayHourSpecial(item.createdAt!),
            style: textTheme(context).text12.colorGray,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(NewFeed newFeed) {
    return Text.rich(
      TextSpan(
        children: [
          WidgetSpan(
            child: HtmlViewNewFeed(
                newFeed: newFeed,
                textStyle: textTheme(context).text13.colorBlack00,
                cssTagHtmlClass: CssStyleClass.bold_13_violet,
                cssHashTagHtmlClass: CssStyleClass.bold_13_black,
                isViewMore: false),
          ),
        ],
      ),
      textAlign: TextAlign.start,
    );
  }

  Widget _topicsLayout(List<TopictItem> topics) {
    return Container(
      height: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            DImages.topicGroup,
            width: 28,
            height: 28,
          ),
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: topics.length,
                itemBuilder: (context, index) {
                  var topicTitle = (index != topics.length - 1)
                      ? topics[index].name! + ","
                      : topics[index].name;
                  return Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 5),
                    child: InkWell(
                      child: Text(
                        "$topicTitle",
                        style: textTheme(context).text13.bold.f5425a7Color,
                      ),
                      onTap: () {
                        // bắn event thông báo đã ra khỏi tab news feed
                        eventBus.fire(OutSideNewFeedsEvent());
                        var dataFilter = FilterRequestItem(
                            key: "topics", value: topics[index].id);
                        var argument = TypeDiscoverAgrument(
                            topics[index].name!, [dataFilter]);
                        Navigator.pushNamed(context, Routes.typeDiscovery,
                            arguments: argument);
                      },
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget _actionLayout(NewFeed item) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  if (widget.onViewFavoriteAction != null)
                    widget.onViewFavoriteAction!();
                  print("FavoriteNewFeedCheckBox");
                },
                child: FavoriteNewFeedCheckBox(
                  newFeed: item,
                  width: 32.0,
                  height: 32.0,
                  padding: 5.0,
                ),
              ),
            ],
          ),
          GroupCommentWidget(
            item,
            iconComment: Image.asset(
              DImages.comment,
              width: 32,
              height: 32,
            ),
            showFullTotalComment: true,
            textTheme: textTheme(context).text13.colorGray,
          ),
          !item.user!.isMe
              ? Container(
                  width: 44.0,
                  height: 44.0,
                  child: GiveBearWidget(
                    item.user!.id!,
                    item.isBear!,
                    width: 44.0,
                    height: 44.0,
                    size: 32.0,
                  ))
              : Container(
                  width: 44.0,
                  height: 44.0,
                ),
        ],
      ),
    );
  }

  @override
  Widget buildContentView(BuildContext context, MyTimeLineItemModel model) {
    String firstCommentLink = getFirstLinkInContent(widget.newFeed.content);
    return InkWell(
      onTap: () {},
      child: Container(
        color: getColor().white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 15,
            ),
            UserInfoPlayout(
                newFeed: widget.newFeed,
                moreBtnWidget: _buildButtonMore(widget.newFeed),
                myMoreBtnWidget: _buildMyButtonMore(widget.newFeed)),
            SizedBox(
              height: widget.newFeed.images!.isNotEmpty ? 15 : 10,
            ),
            widget.newFeed.images!.isNotEmpty
                ? widget.newFeed.images![0].type == Constants.TYPE_VIDEO
                    ? TimeLineVideoItem(
                        willPlay: widget.isWathching,
                        photo: widget.newFeed.images![0],
                      )
                    : TimeLinePhotoItem(
                        newFeed: widget.newFeed,
                      )
                : firstCommentLink != ""
                    ? VerticalSeoIntentLinkWidget(firstCommentLink,
                        margin: EdgeInsets.only(bottom: 5))
                    : Container(),
            SizedBox(
              height: widget.newFeed.images!.isNotEmpty ? 20 : 0,
            ),
            ContentItemWidget(
                topicsLayout: _topicsLayout(widget.newFeed.topics!),
                actionLayout: _actionLayout(widget.newFeed),
                contentInfoLayout: _contentInfoLayout(widget.newFeed),
                newFeed: widget.newFeed)
          ],
        ),
      ),
    );
  }
}
