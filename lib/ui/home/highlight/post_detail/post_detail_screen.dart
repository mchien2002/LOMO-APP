import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/data/api/models/filter_request_item.dart';
import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/data/api/models/topic_item.dart';
import 'package:lomo/data/eventbus/refresh_mypost_event.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/colors.dart';
import 'package:lomo/res/constant.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/animation/route/slide_bottom_to_top_route.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/comment/comment_screen.dart';
import 'package:lomo/ui/discovery/list_type_discovery/list_type_discovery_screen.dart';
import 'package:lomo/ui/home/highlight/timeline/list_favorite/favorite_post_dialog.dart';
import 'package:lomo/ui/new_feed/create_new_feed/create_new_feed_screen.dart';
import 'package:lomo/ui/profile/mypost/my_post_screen.dart';
import 'package:lomo/ui/widget/bear/give_bear_widget.dart';
import 'package:lomo/ui/widget/bottom_sheet_widgets.dart';
import 'package:lomo/ui/widget/comment/group_comment_widget.dart';
import 'package:lomo/ui/widget/dialog_widget.dart';
import 'package:lomo/ui/widget/favorite_new_feed_check_box.dart';
import 'package:lomo/ui/widget/follow_user_check_box.dart';
import 'package:lomo/ui/widget/html_view_widget.dart';
import 'package:lomo/ui/widget/image_widget.dart';
import 'package:lomo/ui/widget/line_indicator_widget.dart';
import 'package:lomo/ui/widget/seo_intent_link_widget.dart';
import 'package:lomo/ui/widget/user_info_widget.dart';
import 'package:lomo/util/common_utils.dart';
import 'package:lomo/util/constants.dart';
import 'package:lomo/util/date_time_utils.dart';
import 'package:lomo/util/handle_link_util.dart';
import 'package:lomo/util/new_feed_util.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../report/report_screen.dart';
import 'post_detail_model.dart';

class PostDetailScreen extends StatefulWidget {
  final PostDetailAgrument agrument;

  PostDetailScreen(this.agrument);

  @override
  State<StatefulWidget> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState
    extends BaseState<PostDetailModel, PostDetailScreen>
    with SingleTickerProviderStateMixin {
  final List<NewFeedDetailMenu> menuMoreItems = NewFeedDetailMenu.values;
  final List<MyNewFeedMenu> myMenuMoreItems = MyNewFeedMenu.values;
  late PageController _pageController;
  PhotoViewComputedScale scale = PhotoViewComputedScale.covered;
  late Size size;

  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    model.init(widget.agrument.newFeed, widget.agrument.photoIndex);
    _pageController = PageController(initialPage: model.indicatorStep.value);
    if (isVideoContent()) {
      initVideo(widget.agrument.newFeed.images?[0].link);
    }
  }

  bool isVideoContent() {
    return widget.agrument.newFeed.images?.isNotEmpty == true &&
        widget.agrument.newFeed.images?[0].type == Constants.TYPE_VIDEO;
  }

  initVideo(String? videoUrl) {
    _videoPlayerController = VideoPlayerController.network(
        getFullLinkVideo(videoUrl),
        videoPlayerOptions: VideoPlayerOptions(
            mixWithOthers: true, allowBackgroundPlayback: true));
    _videoPlayerController.addListener(() {
      model.updateView();
    });
    _videoPlayerController.setLooping(true);
    _videoPlayerController.initialize();
  }

  @override
  Widget buildContentView(BuildContext context, PostDetailModel model) {
    size = MediaQuery.of(context).size;
    return ChangeNotifierProvider.value(
      value: model,
      child: Consumer<PostDetailModel>(builder: (context, myModel, child) {
        return (!myModel.newFeedValue.value!.isDeleted &&
                !myModel.newFeedValue.value!.isLock)
            ? myModel.newFeedValue.value!.images!.length > 0
                ? isVideoContent()
                    ? _buildVideoLayout()
                    : _buildImageLayout()
                : _buildLayoutText()
            : _layoutPostEmpty(myModel.newFeedValue.value!);
      }),
    );
  }

  Widget _layoutPostEmpty(NewFeed newFeed) {
    Color background =
        newFeed.images!.length > 0 ? DColors.blackColor : getColor().white;
    Color content =
        newFeed.images!.length > 0 ? getColor().white : getColor().textDart;
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () async {
            Navigator.of(context).maybePop();
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: SizedBox(
              child: Image.asset(
                DImages.backBlack,
                width: 32,
                height: 32,
                color: content,
              ),
            ),
          ),
        ),
        elevation: newFeed.images!.length > 0 ? 0 : 1,
        title: Row(
          children: [
            UserInfoWidget(
              model.newFeedValue.value!.user!,
              isBorder: false,
              titleStyle: newFeed.images!.length > 0
                  ? textTheme(context).text15.bold.colorWhite
                  : textTheme(context).text15.bold.darkTextColor,
              widgetHeight: MediaQuery.of(context).size.width - 115,
            ),
          ],
        ),
        actions: [
          model.newFeedValue.value!.user!.isMe
              ? _buildMyButtonMore(content)
              : Row(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: _buildButtonMore(content),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
          SizedBox(
            width: Dimens.spacing16,
          )
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              DImages.groupEmpty,
              width: 80,
              height: 80,
              color: getColor().colorGrayC1,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              Strings.postDeleted.localize(context),
              style: newFeed.images!.length > 0
                  ? textTheme(context).text15.colorWhite
                  : textTheme(context).text15.colorGray,
            ),
            SizedBox(
              height: 120,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildImages() {
    return PhotoViewGallery.builder(
      scrollDirection: Axis.horizontal,
      itemCount: model.newFeedValue.value!.images!.length,
      pageController: _pageController,
      backgroundDecoration: BoxDecoration(color: DColors.blackColor),
      onPageChanged: (index) => setState(() {
        model.photoIndex = index;
        model.indicatorStep.value = index;
      }),
      builder: (context, index) {
        return PhotoViewGalleryPageOptions.customChild(
          minScale: scale,
          maxScale: scale * 2,
          child: RoundNetworkImage(
            url: model.newFeedValue.value!.images![index].link,
            width: double.infinity,
            height: double.infinity,
            boxFit: BoxFit.fitWidth,
          ),
        );
      },
      loadingBuilder: (context, event) {
        return CircularProgressIndicator();
      },
    );
  }

  Widget _buildVideoLayout() {
    return Scaffold(
      backgroundColor: DColors.blackColor,
      body: Stack(children: [
        InkWell(
          onTap: () {
            model.onShowHideContent();
          },
          child: _buildVideo(),
        ),
        ChangeNotifierProvider.value(
          value: model.contentValue,
          child: model.contentValue.value
              ? Container(
                  height: 95,
                  color: DColors.cc261744Color,
                  child: _buildGuestAppBar(),
                )
              : SizedBox(
                  width: 0,
                  height: 0,
                ),
        ),
        ChangeNotifierProvider.value(
            value: model.contentValue,
            child: model.contentValue.value
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black87,
                          Colors.black54,
                        ],
                      )),
                      child: ConstrainedBox(
                        constraints: new BoxConstraints(
                          minHeight: 150.0,
                          maxHeight: double.infinity,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _userInfoLayout(model.newFeedValue.value!),
                            _contentInfoLayout(model.newFeedValue.value!),
                            _controlLayout(model.newFeedValue.value!)
                          ],
                        ),
                      ),
                    ),
                  )
                : SizedBox(
                    width: 0,
                    height: 0,
                  )),
      ]),
    );
  }

  Widget _buildImageLayout() {
    return Scaffold(
      backgroundColor: DColors.blackColor,
      body: Stack(children: [
        InkWell(
          onTap: () {
            model.onShowHideContent();
          },
          child: _buildImages(),
        ),
        ChangeNotifierProvider.value(
          value: model.contentValue,
          child: model.contentValue.value
              ? Container(
                  height: 95,
                  color: DColors.cc261744Color,
                  child: _buildGuestAppBar(),
                )
              : SizedBox(
                  width: 0,
                  height: 0,
                ),
        ),
        ChangeNotifierProvider.value(
            value: model.contentValue,
            child: model.contentValue.value
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black87,
                          Colors.black54,
                        ],
                      )),
                      child: ConstrainedBox(
                        constraints: new BoxConstraints(
                          minHeight: 150.0,
                          maxHeight: double.infinity,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _userInfoLayout(model.newFeedValue.value!),
                            _contentInfoLayout(model.newFeedValue.value!),
                            _controlLayout(model.newFeedValue.value!)
                          ],
                        ),
                      ),
                    ),
                  )
                : SizedBox(
                    width: 0,
                    height: 0,
                  )),
      ]),
    );
  }

  Widget _buildLayoutContent() {
    String firstLinkInComment =
        getFirstLinkInContent(widget.agrument.newFeed.content);
    return Container(
      child: ListView(
        children: [
          Container(
            height: 2,
            color: DColors.grayE8Color,
          ),
          SizedBox(
            height: 12,
          ),
          _userInfoLayout(widget.agrument.newFeed,
              isBorder: true, textStype: textTheme(context).text15.bold),
          firstLinkInComment != ""
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: VerticalSeoIntentLinkWidget(
                    firstLinkInComment,
                    margin: EdgeInsets.only(bottom: 15),
                  ),
                )
              : Container(
                  width: 0,
                  height: 0,
                ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: _contentInfoLayout(model.newFeedValue.value!),
          ),
          _actionLayout(model.newFeedValue.value!),
          SizedBox(
            height: 12,
          )
        ],
      ),
    );
  }

  Widget _buildVideo() {
    final ratio = model.newFeedValue.value!.images![0].ratio!;
    double widthVideo = MediaQuery.of(context).size.width;
    double heightVideo =
        ratio > 1 ? widthVideo * 0.75 : size.height - (100 + 160);
    return InkWell(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(top: 95, bottom: 180),
        alignment: Alignment.center,
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: getColor().black,
            ),
            height: heightVideo,
            width: widthVideo,
            child: Stack(
              children: [
                VideoPlayer(_videoPlayerController),
                //ControlsOverlay(controller: _videoPlayerController)
              ],
            )),
      ),
    );
  }

  Widget _actionLayout(NewFeed item) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              callListFavoriteUserPost(context, item.id);
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FavoriteNewFeedCheckBox(
                  newFeed: item,
                  width: 32.0,
                  height: 32.0,
                  padding: 5.0,
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

  PreferredSizeWidget _appbar() {
    return AppBar(
      backgroundColor: getColor().white,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text(
        Strings.newsFeedDetail.localize(context),
        style: textTheme(context).text18Bold.darkTextColor,
      ),
      leading: InkWell(
        onTap: () async {
          Navigator.of(context).maybePop();
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Image.asset(
            DImages.backWhite,
            width: 32,
            height: 32,
            color: getColor().darkTextColor,
          ),
        ),
      ),
      elevation: 0,
      actions: [
        model.newFeedValue.value!.user!.isMe
            ? _buildMyButtonMore(getColor().grayBorder)
            : _buildButtonMore(getColor().grayBorder),
        SizedBox(
          width: Dimens.spacing16,
        )
      ],
    );
  }

  Widget _buildLayoutText() {
    return Scaffold(
      backgroundColor: getColor().white,
      appBar: _appbar(),
      body: _buildLayoutContent(),
    );
  }

  Widget _buildGuestAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: DColors.blackColor,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      leading: InkWell(
        onTap: () async {
          Navigator.of(context).maybePop();
        },
        child: Padding(
          padding: EdgeInsets.only(left: 16),
          child: Image.asset(
            DImages.closex,
            width: 32,
            height: 32,
            color: getColor().white,
          ),
        ),
      ),
      centerTitle: true,
      title: LineIndicatorWidget(
          model.newFeedValue.value!.images!.length, model.indicatorStep),
      actions: [
        model.newFeedValue.value!.user!.isMe
            ? _buildMyButtonMore(getColor().white)
            : _buildButtonMore(getColor().white),
        SizedBox(
          width: Dimens.spacing16,
        )
      ],
    );
  }

  Widget _buildButtonMore(Color iconColor) {
    final menuItems = model.newFeedValue.value!.images!.length > 0
        ? menuMoreItems
        : menuMoreItems
            .where((element) => element != NewFeedDetailMenu.download)
            .toList();

    return BottomSheetMenuWidget(
      items: menuItems.map((e) => e.name).toList(),
      onItemClicked: (index) async {
        switch (menuItems[index]) {
          case NewFeedDetailMenu.report:
            Navigator.pushNamed(context, Routes.report,
                arguments: ReportScreenArgs(
                    user: model.newFeedValue.value!.user!,
                    newFeed: model.newFeedValue.value));
            break;
          case NewFeedDetailMenu.block:
            showDialog(
                context: context,
                builder: (context) => TwoButtonDialogWidget(
                      title: Strings.blockThisUser.localize(context),
                      description: Strings.blockedUserContent.localize(context),
                      onConfirmed: () {
                        callApi(callApiTask: () async {
                          await model.block(model.newFeedValue.value!.user!);
                          model.newFeedValue.value!.user!.isFollow = false;
                          showToast(Strings.blockSuccess.localize(context));
                        });
                      },
                    ));
            break;
          case NewFeedDetailMenu.share:
            locator<HandleLinkUtil>()
                .shareNewFeed(model.newFeedValue.value!.id);
            break;
          case NewFeedDetailMenu.download:
            await downloadImage(getFullLinkImage(
                model.newFeedValue.value?.images?[model.photoIndex].link));
            break;
          case NewFeedDetailMenu.cancel:
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
            top: 5,
            bottom: Dimens.spacing15,
            left: Dimens.spacing16,
            right: Dimens.spacing16),
        child: Row(
          children: [
            Expanded(
              child: UserInfoWidget(
                model.newFeedValue.value!.user!,
                isBorder: isBorder,
                titleStyle:
                    textStype ?? textTheme(context).text15.bold.colorWhite,
                widgetHeight: MediaQuery.of(context).size.width - 115,
              ),
            ),
            if (model.user.isMe)
              Visibility(
                visible:
                    model.user.isMe != model.newFeedValue.value!.user!.isMe,
                child: FollowUserCheckBox(
                  model.newFeedValue.value!.user!,
                  isUnfollowAction: !model.newFeedValue.value!.user!.isMe,
                  followedWidget: _buildMyFollowed(),
                ),
              ),
            if (!model.user.isMe)
              FollowUserCheckBox(
                model.newFeedValue.value!.user!,
                isUnfollowAction: widget.agrument.newFeed.user?.isFollow,
                followedWidget: _buildUserFollowed(),
              ),
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
            arguments: UserInfoAgrument(model.newFeedValue.value!.user!));
      },
    );
  }

  Widget _buildMyFollowed() {
    return model.newFeedValue.value!.user!.isMe
        ? InkWell(
            child: Image.asset(
              DImages.navigationRight,
              height: 36,
              width: 36,
            ),
            onTap: () {
              Navigator.pushNamed(context, Routes.profile,
                  arguments: UserInfoAgrument(model.newFeedValue.value!.user!));
            },
          )
        : Image.asset(
            DImages.unfollow,
            height: 36,
            width: 36,
          );
  }

  Widget _contentInfoLayout(
    NewFeed item,
  ) {
    return Container(
      padding: EdgeInsets.only(
          bottom: Dimens.spacing10,
          left: Dimens.spacing16,
          right: Dimens.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopicLayout(item.topics!),
          SizedBox(
            height: item.topics!.isNotEmpty ? 10 : 0,
          ),
          _buildContent(item),
          if (item.content != null &&
              item.content!.length > 150 &&
              item.images != null &&
              item.images!.length > 0)
            Align(
                alignment: Alignment.centerRight,
                child: ChangeNotifierProvider.value(
                    value: model.viewMoreValue,
                    child: InkWell(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text:
                                      "${model.viewMoreValue.value ? Strings.viewMore.localize(context) : Strings.collapse.localize(context)}",
                                  style: textTheme(context).text13.colorWhite),
                              WidgetSpan(
                                child: Icon(
                                  model.viewMoreValue.value
                                      ? Icons.keyboard_arrow_down
                                      : Icons.keyboard_arrow_up,
                                  size: 14,
                                  color: getColor().white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        model.onViewMoreContent();
                      },
                    ))),
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

  Widget _buildTopicLayout(List<TopictItem> topics) {
    return Visibility(
      visible: topics.length > 0 ? true : false,
      child: Container(
          height: 20,
          child: Row(
            children: [
              Image.asset(
                DImages.topicGroup,
                width: 24,
                height: 24,
                // color: getColor().primaryColor,
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
                        padding: EdgeInsets.only(left: 5),
                        child: InkWell(
                          child: Text(
                            "$topicTitle",
                            style: textTheme(context).text13.bold.colorPrimary,
                          ),
                          onTap: () {
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
          )),
    );
  }

  Widget _controlLayout(NewFeed item) {
    return Container(
      padding: EdgeInsets.only(
          bottom: Dimens.spacing16,
          left: Dimens.spacing16,
          right: Dimens.spacing16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              callListFavoriteUserPost(context, item.id);
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FavoriteNewFeedCheckBox(
                  newFeed: item,
                  width: 32.0,
                  height: 32.0,
                  padding: 5.0,
                  uncheckedColor: DColors.gray6cbColor,
                ),
              ],
            ),
          ),
          InkWell(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  DImages.comment,
                  width: 32,
                  height: 32,
                  color: DColors.gray6cbColor,
                ),
                SizedBox(
                  width: 3,
                ),
                ValueListenableProvider.value(
                  value: model.numOfComment,
                  child: Consumer<int>(
                    builder: (context, numberOfComment, child) => Text(
                        "$numberOfComment ${Strings.comments.localize(context).toLowerCase()}",
                        style: textTheme(context).text13.colorGray),
                  ),
                )
              ],
            ),
            onTap: () {
              Navigator.push(
                  context,
                  SlideBottomToTopRoute(
                      page: CommentScreen(CommentType.post, newFeed: item)));
            },
          ),
          Container(
            width: 44.0,
            height: 44.0,
          ),
          // !item.user!.isMe
          //     ? Container(
          //         width: 44.0,
          //         height: 44.0,
          //         child: GiveBearWidget(
          //           item.user!.id!,
          //           item.isBear!,
          //           width: 44.0,
          //           height: 44.0,
          //           size: 32.0,
          //         ))
          //     :
          //     Container(
          //         width: 44.0,
          //         height: 44.0,
          //       ),
        ],
      ),
    );
  }

  Widget _buildContent(NewFeed newFeed) {
    final isImage =
        newFeed.images != null && newFeed.images!.length > 0 ? true : false;
    return ChangeNotifierProvider.value(
        value: model.viewMoreValue,
        child: Container(
          child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 25.0,
                maxHeight: size.height -
                    (newFeed.topics != null && newFeed.topics!.isNotEmpty
                        ? 310
                        : 275),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Text.rich(
                  TextSpan(
                    children: [
                      WidgetSpan(
                        child: HtmlViewNewFeed(
                            newFeed: newFeed,
                            minLengthContent: model.viewMoreValue.value
                                ? isImage
                                    ? 150
                                    : 5000
                                : 5000,
                            textStyle: newFeed.images!.length > 0
                                ? textTheme(context).text13.colorWhite
                                : textTheme(context).text13.darkTextColor,
                            cssTagHtmlClass: CssStyleClass.bold_13_violet,
                            cssHashTagHtmlClass:
                                model.newFeedValue.value!.images!.length > 0
                                    ? CssStyleClass.bold_13_white
                                    : CssStyleClass.bold_13_black,
                            isViewMore: false),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.start,
                ),
              )),
        ));
  }

  Widget _buildMyButtonMore(Color color) {
    return BottomSheetMenuWidget(
      items: myMenuMoreItems.map((e) => e.name).toList(),
      onItemClicked: (index) async {
        switch (myMenuMoreItems[index]) {
          case MyNewFeedMenu.edit:
            Navigator.pushNamed(context, Routes.createNewFeed,
                arguments:
                    CreateNewFeedAgrument(newFeed: model.newFeedValue.value!));
            break;
          case MyNewFeedMenu.share:
            locator<HandleLinkUtil>()
                .shareNewFeed(model.newFeedValue.value!.id);
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

  void callListFavoriteUserPost(BuildContext context, String? idPost) {
    showModalBottomSheet(
        backgroundColor: getColor().transparent,
        context: context,
        isScrollControlled: true,
        enableDrag: false,
        builder: (context) => FavoritePostDialog(
              onClosed: () {
                Navigator.pop(context);
              },
              isPost: idPost,
            ));
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }
}

enum NewFeedDetailMenu { report, block, share, download, cancel }

extension NewFeedDetailMenuExt on NewFeedDetailMenu {
  String get name {
    switch (this) {
      case NewFeedDetailMenu.report:
        return Strings.report;
      case NewFeedDetailMenu.block:
        return Strings.block;
      case NewFeedDetailMenu.share:
        return Strings.share;
      case NewFeedDetailMenu.download:
        return Strings.download;
      case NewFeedDetailMenu.cancel:
        return Strings.close;
    }
  }
}

class PostDetailAgrument {
  NewFeed newFeed;
  int photoIndex;
  PostDetailAgrument(this.newFeed, {this.photoIndex = 0});
}
