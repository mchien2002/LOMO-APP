import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/data/eventbus/refresh_mypost_event.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/home/highlight/post_detail/video_detail_model.dart';
import 'package:lomo/ui/new_feed/create_new_feed/create_new_feed_screen.dart';
import 'package:lomo/ui/profile/mypost/my_post_screen.dart';
import 'package:lomo/ui/report/report_screen.dart';
import 'package:lomo/ui/widget/bear/give_bear_widget.dart';
import 'package:lomo/ui/widget/bottom_sheet_widgets.dart';
import 'package:lomo/ui/widget/comment/group_comment_widget.dart';
import 'package:lomo/ui/widget/dialog_widget.dart';
import 'package:lomo/ui/widget/favorite_new_feed_check_box.dart';
import 'package:lomo/ui/widget/follow_user_check_box.dart';
import 'package:lomo/ui/widget/image_widget.dart';
import 'package:lomo/ui/widget/loading_widget.dart';
import 'package:lomo/ui/widget/user_info_widget.dart';
import 'package:lomo/util/common_utils.dart';
import 'package:lomo/util/handle_link_util.dart';
import 'package:provider/provider.dart';
import 'post_detail_screen.dart';

class VideoDetailScreen extends StatefulWidget {
  final PostDetailAgrument agrument;

  VideoDetailScreen(this.agrument);
  @override
  State<StatefulWidget> createState() => _VideoDetailScreenState();
}

class _VideoDetailScreenState
    extends BaseState<VideoDetailModel, VideoDetailScreen>
    with TickerProviderStateMixin {
  late Size size;
  final List<NewFeedDetailMenu> menuMoreItems = NewFeedDetailMenu.values;
  final List<MyNewFeedMenu> myMenuMoreItems = MyNewFeedMenu.values;
  @override
  void initState() {
    super.initState();

    model.controllerBottom =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));

    model.offsetBottom =
        Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 1.5))
            .animate(model.controllerBottom);

    model.controllerTop =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));

    model.offsetTop = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, -1.5))
        .animate(model.controllerTop);

    model.init(widget.agrument.newFeed);
  }

  @override
  void dispose() {
    super.dispose();
    model.videoPlayerController.dispose();
    model.chewieController?.dispose();
  }

  @override
  Widget buildContentView(BuildContext context, VideoDetailModel model) {
    size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            _videoContent(),
            Align(
              alignment: Alignment.topRight,
              child: ValueListenableProvider.value(
                  value: model.closeButtonValue,
                  child: Consumer<bool>(
                    builder: (_, value, child) => value
                        ? InkWell(
                            onTap: () {
                              Navigator.maybePop(context);
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 5),
                              child: Image.asset(
                                DImages.closex,
                                width: 36,
                                height: 36,
                                color: getColor().white,
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                  )),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: SlideTransition(
                  position: model.offsetTop,
                  child: Stack(
                    children: [
                      Container(
                        height: 90,
                        width: double.infinity,
                        color: getColor().black.withOpacity(0.5),
                      ),
                      _userInfoLayout(widget.agrument.newFeed,
                          textStype: textTheme(context).text13.bold.colorWhite),
                    ],
                  )),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SlideTransition(
                  position: model.offsetBottom,
                  child: Stack(
                    children: [
                      Container(
                        height: 90,
                        width: double.infinity,
                        color: getColor().black.withOpacity(0.5),
                      ),
                      _actionLayout(widget.agrument.newFeed),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMyButtonMore(Color color) {
    return BottomSheetMenuWidget(
      items: myMenuMoreItems.map((e) => e.name).toList(),
      onItemClicked: (index) async {
        switch (myMenuMoreItems[index]) {
          case MyNewFeedMenu.edit:
            Navigator.pushNamed(context, Routes.createNewFeed,
                arguments: CreateNewFeedAgrument(newFeed: model.newFeed));
            break;
          case MyNewFeedMenu.share:
            locator<HandleLinkUtil>().shareNewFeed(model.newFeed.id);
            break;
          case MyNewFeedMenu.delete:
            showDialog(
                context: context,
                builder: (context) => TwoButtonDialogWidget(
                      description: Strings.confirmDeletePost.localize(context),
                      onConfirmed: () {
                        callApi(callApiTask: () async {
                          await model
                              .deleteNewFeed(widget.agrument.newFeed.id!);
                        }, onSuccess: () {
                          //Update ben trang ca nhan
                          eventBus.fire(RefreshMyPostEvent(
                              newFeedId: widget.agrument.newFeed.id!));
                          showToast(
                              Strings.deletePostSuccess.localize(context));
                        });
                      },
                    ));
            break;
          case MyNewFeedMenu.cancel:
            break;
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Image.asset(
          DImages.moreGray,
          height: Dimens.size32,
          width: Dimens.size32,
          color: color,
        ),
      ),
    );
  }

  Widget _videoContent() {
    return Center(
      child: Container(
          width: size.width,
          height: size.width / model.videoInfo.ratio!,
          child: ValueListenableProvider.value(
              value: model.videoInitialize,
              child: Consumer<bool>(
                builder: (_, value, child) => value
                    ? Chewie(controller: model.chewieController!)
                    : Stack(
                        children: [
                          RoundNetworkImage(
                            width: size.width,
                            height: size.width / model.videoInfo.ratio!,
                            url: model.videoThumb,
                          ),
                          Center(
                            child: LoadingWidget(
                              inactiveColor: getColor().white.withOpacity(0.5),
                              activeColor: getColor().white,
                            ),
                          )
                        ],
                      ),
              ))),
    );
  }

  Widget _buildButtonMore(Color iconColor) {
    final menuItems = menuMoreItems
        .where((element) => element != NewFeedDetailMenu.download)
        .toList();

    return BottomSheetMenuWidget(
      items: menuItems.map((e) => e.name).toList(),
      onItemClicked: (index) async {
        switch (menuItems[index]) {
          case NewFeedDetailMenu.report:
            Navigator.pushNamed(context, Routes.report,
                arguments: ReportScreenArgs(
                    user: model.newFeed.user!, newFeed: model.newFeed));
            break;
          case NewFeedDetailMenu.block:
            showDialog(
                context: context,
                builder: (context) => TwoButtonDialogWidget(
                      title: Strings.blockThisUser.localize(context),
                      description: Strings.blockedUserContent.localize(context),
                      onConfirmed: () {
                        callApi(callApiTask: () async {
                          await model.block(model.newFeed.user!);
                          model.newFeed.user!.isFollow = false;
                          showToast(Strings.blockSuccess.localize(context));
                        });
                      },
                    ));
            break;
          case NewFeedDetailMenu.share:
            locator<HandleLinkUtil>().shareNewFeed(model.newFeed.id);
            break;
          case NewFeedDetailMenu.cancel:
            break;
          default:
            break;
        }
      },
      child: Image.asset(
        DImages.more,
        height: Dimens.size32,
        width: Dimens.size32,
        color: iconColor,
      ),
    );
  }

  Widget _userInfoLayout(NewFeed newFeed,
      {bool isBorder = false, TextStyle? textStype}) {
    return Container(
        padding: EdgeInsets.only(
            left: Dimens.spacing16, right: Dimens.spacing16, top: 30),
        height: 90,
        child: Row(
          children: [
            Expanded(
              child: UserInfoWidget(
                model.newFeed.user!,
                isBorder: isBorder,
                titleStyle:
                    textStype ?? textTheme(context).text15.bold.colorWhite,
                widgetHeight: MediaQuery.of(context).size.width - 145,
              ),
            ),
            if (model.user.isMe)
              Visibility(
                visible: model.user.isMe != model.newFeed.user!.isMe,
                child: FollowUserCheckBox(
                  model.newFeed.user!,
                  isUnfollowAction: !model.newFeed.user!.isMe,
                  followedWidget: _buildMyFollowed(),
                ),
              ),
            if (!model.user.isMe)
              FollowUserCheckBox(
                model.newFeed.user!,
                isUnfollowAction: widget.agrument.newFeed.user?.isFollow,
                followedWidget: _buildUserFollowed(),
              ),
            model.newFeed.user!.isMe
                ? _buildMyButtonMore(getColor().white)
                : _buildButtonMore(getColor().white),
          ],
        ));
  }

  Widget _buildUserFollowed() {
    return InkWell(
      child: Image.asset(
        DImages.navigationRight,
        height: 36,
        width: 36,
      ),
      onTap: () {
        Navigator.pushNamed(context, Routes.profile,
            arguments: UserInfoAgrument(model.newFeed.user!));
      },
    );
  }

  Widget _buildMyFollowed() {
    return model.newFeed.user!.isMe
        ? InkWell(
            child: Image.asset(
              DImages.navigationRight,
              height: 36,
              width: 36,
            ),
            onTap: () {
              Navigator.pushNamed(context, Routes.profile,
                  arguments: UserInfoAgrument(model.newFeed.user!));
            },
          )
        : Image.asset(
            DImages.unfollow,
            height: 36,
            width: 36,
          );
  }

  Widget _actionLayout(NewFeed item) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {},
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FavoriteNewFeedCheckBox(
                  newFeed: item,
                  width: 32.0,
                  height: 32.0,
                  padding: 5.0,
                  uncheckedColor: getColor().colorGray,
                ),
              ],
            ),
          ),
          GroupCommentWidget(
            item,
            iconComment: Image.asset(
              DImages.comment,
              width: 32,
              height: 32,
              color: getColor().colorGray,
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
}
