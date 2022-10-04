import 'package:flutter/material.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/api/models/filter_request_item.dart';
import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/data/api/models/response/photo_model.dart';
import 'package:lomo/data/api/models/topic_item.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/constant.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/discovery/list_type_discovery/list_type_discovery_screen.dart';
import 'package:lomo/ui/home/highlight/post_detail/post_detail_screen.dart';
import 'package:lomo/ui/home/highlight/timeline/item/referral_item.dart';
import 'package:lomo/ui/home/highlight/timeline/item/timeline_item_model.dart';
import 'package:lomo/ui/new_feed/create_new_feed/create_new_feed_screen.dart';
import 'package:lomo/ui/profile/mypost/my_post_screen.dart';
import 'package:lomo/ui/report/report_screen.dart';
import 'package:lomo/ui/widget/bear/give_bear_widget.dart';
import 'package:lomo/ui/widget/bottom_sheet_widgets.dart';
import 'package:lomo/ui/widget/comment/group_comment_widget.dart';
import 'package:lomo/ui/widget/dialog_widget.dart';
import 'package:lomo/ui/widget/favorite_new_feed_check_box.dart';
import 'package:lomo/ui/widget/follow_user_check_box.dart';
import 'package:lomo/ui/widget/html_view_widget.dart';
import 'package:lomo/ui/widget/image_widget.dart';
import 'package:lomo/ui/widget/seo_intent_link_widget.dart';
import 'package:lomo/ui/widget/timeline/timeline_photo.dart';
import 'package:lomo/ui/widget/user_info_widget.dart';
import 'package:lomo/util/common_utils.dart';
import 'package:lomo/util/date_time_utils.dart';
import 'package:lomo/util/handle_link_util.dart';
import 'package:lomo/util/new_feed_util.dart';
import 'package:lomo/util/platform_channel.dart';

import '../../../../../app/lomo_app.dart';
import '../../../../../data/eventbus/outside_newfeed_event.dart';
import 'time_line_item_video.dart';

class TimelineItemView extends StatefulWidget {
  final NewFeed newFeed;
  final User? user;
  final Function()? onDeleteAction;
  final Function()? onViewFavoriteAction;
  final Function(User)? onBlockUser;
  final bool isInView;

  TimelineItemView(
      {required this.newFeed,
      this.user,
      this.onDeleteAction,
      this.onViewFavoriteAction,
      this.onBlockUser,
      this.isInView = false});

  @override
  State<StatefulWidget> createState() => _TimelineItemViewState();
}

class _TimelineItemViewState
    extends BaseState<TimelineItemModel, TimelineItemView>
    with SingleTickerProviderStateMixin {
  final List<NewFeedMenu> menuMoreItems = NewFeedMenu.values;
  final List<MyNewFeedMenu> myMenuMoreItems = MyNewFeedMenu.values;

  @override
  void initState() {
    super.initState();
    model.init(widget.newFeed);
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
                          await model.unFollow(newFeed.user!);
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

  bool isVideoContent() {
    return widget.newFeed.images?.isNotEmpty == true &&
        widget.newFeed.images?[0].type == Constants.TYPE_VIDEO;
  }

  @override
  Widget buildContentView(BuildContext context, TimelineItemModel model) {
    String firstLinkInComment = getFirstLinkInContent(widget.newFeed.content);
    return InkWell(
      onTap: () {
        if (isVideoContent()) {
          Navigator.pushNamed(context, Routes.postVideoDetail,
              arguments: PostDetailAgrument(widget.newFeed));
        } else {
          Navigator.pushNamed(context, Routes.postDetail,
              arguments: PostDetailAgrument(widget.newFeed));
        }

        // bắn event thông báo đã ra khỏi tab news feed
        eventBus.fire(OutSideNewFeedsEvent());
      },
      child: (!widget.newFeed.isLock && !widget.newFeed.isDeleted)
          ? Container(
              color: getColor().white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  _userInfoLayout(widget.newFeed),
                  SizedBox(
                    height: widget.newFeed.images?.isNotEmpty == true ? 15 : 10,
                  ),
                  widget.newFeed.images?.isNotEmpty == true
                      ? widget.newFeed.images![0].type == Constants.TYPE_VIDEO
                          ? _buildItemVideo(
                              widget.newFeed.images![0], widget.isInView)
                          : TimelinePhoto(widget.newFeed)
                      : firstLinkInComment != ""
                          ? VerticalSeoIntentLinkWidget(
                              firstLinkInComment,
                              margin: EdgeInsets.only(bottom: 15),
                            )
                          : Container(
                              width: 0,
                              height: 0,
                            ),
                  SizedBox(
                    height: widget.newFeed.images!.isNotEmpty ? 20 : 0,
                  ),
                  _buildContentItem()
                ],
              ),
            )
          : _newFeedEmpty(),
    );
  }

  Widget _buildContentItem() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.newFeed.topics!.isNotEmpty)
            _topicsLayout(widget.newFeed.topics!),
          _contentInfoLayout(widget.newFeed),
          _actionLayout(widget.newFeed),
          SizedBox(
            height: 12,
          ),
          if (widget.newFeed.isReferral) ReferralItem()
        ],
      ),
    );
  }

  Widget _buildItemVideo(PhotoModel item, bool willPlay) {
    final ratio = (item.ratio != null && item.ratio != 0 ? item.ratio! : 1);
    final width = MediaQuery.of(context).size.width;
    // double height = ratio > 1 ? width / ratio : 300;
    double height = width / ratio;
    return TimeLineItemVideo(
      network: getFullLinkVideo(item.link),
      height: height,
      width: width,
      isPlaying: willPlay,
      loader: Stack(
        alignment: Alignment.center,
        children: [
          RoundNetworkImage(
            width: width,
            height: height,
            url: getFullLinkImage(item.thumb),
          ),
          Image.asset(
            DImages.btnVideoPause,
            height: 50,
            width: 50,
          )
        ],
      ),
    );
  }

  Widget _newFeedEmpty() {
    return Container(
      padding: EdgeInsets.only(left: Dimens.spacing16, right: Dimens.spacing16),
      child: Column(
        children: [
          _userInfoLayout(widget.newFeed),
          Container(
            height: 90,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: getColor().gray2eaColor, // red as border color
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  DImages.groupEmpty,
                  width: 18,
                  height: 18,
                  color: getColor().colorGrayC1,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                            text: Strings.postDeleted.localize(context),
                            style: textTheme(context)
                                .text14Normal
                                .bold
                                .darkTextColor),
                        TextSpan(
                            text: Strings.postDeletedContent.localize(context),
                            style: textTheme(context)
                                .text13
                                .height50Per
                                .darkTextColor),
                      ],
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _userInfoLayout(NewFeed newFeed) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: UserInfoWidget(
              newFeed.user!,
              titleStyle: textTheme(context).text15.bold,
              widgetHeight: MediaQuery.of(context).size.width - 160,
            ),
          ),
          if (!newFeed.user!.isMe) FollowUserCheckBox(newFeed.user!),
          SizedBox(
            width: 5,
          ),
          newFeed.user!.isMe
              ? _buildMyButtonMore(newFeed)
              : _buildButtonMore(newFeed),
        ],
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
}

enum NewFeedMenu { report, block, share, sendMessage, unFollow, cancel }

extension NewFeedMenuExt on NewFeedMenu {
  String get name {
    switch (this) {
      case NewFeedMenu.report:
        return Strings.report;
      case NewFeedMenu.block:
        return Strings.block;
      case NewFeedMenu.share:
        return Strings.share;
      case NewFeedMenu.sendMessage:
        return Strings.sendMessage;
      case NewFeedMenu.unFollow:
        return Strings.unFollow;
      case NewFeedMenu.cancel:
        return Strings.close;
    }
  }
}
