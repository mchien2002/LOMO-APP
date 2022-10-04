import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/group_new_feed.dart';
import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/colors.dart';
import 'package:lomo/res/constant.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/home/highlight/post_detail/post_detail_screen.dart';
import 'package:lomo/ui/home/highlight/timeline/item/timeline_item_view.dart';
import 'package:lomo/ui/new_feed/create_new_feed/create_new_feed_screen.dart';
import 'package:lomo/ui/widget/bottom_sheet_widgets.dart';
import 'package:lomo/ui/widget/comment/group_comment_widget.dart';
import 'package:lomo/ui/widget/dialog_widget.dart';
import 'package:lomo/ui/widget/favorite_new_feed_check_box.dart';
import 'package:lomo/ui/widget/html_view_widget.dart';
import 'package:lomo/ui/widget/image_widget.dart';
import 'package:lomo/ui/widget/laze_load_scrollview_widget.dart';
import 'package:lomo/ui/widget/shimmers/gridview_itemsquare_shimmer.dart';
import 'package:lomo/ui/widget/shimmers/image/image_rectangle_shimmer.dart';
import 'package:lomo/util/common_utils.dart';
import 'package:lomo/util/handle_link_util.dart';
import 'package:provider/provider.dart';

import '../../report/report_screen.dart';
import 'my_post_model.dart';

class MyPostScreen extends StatefulWidget {
  final User user;

  MyPostScreen(this.user);

  @override
  _MyPostScreenState createState() => _MyPostScreenState();
}

class _MyPostScreenState extends BaseState<MyPostModel, MyPostScreen>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<MyPostScreen> {
  late double width;
  final List<NewFeedMenu> menuMoreItems = NewFeedMenu.values;
  final List<MyNewFeedMenu> myMenuMoreItems = MyNewFeedMenu.values;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return super.buildContent();
  }

  @override
  void initState() {
    super.initState();
    model.init(widget.user.id!);
    model.getData();
    model.initEventBus();
    if (!widget.user.isMe) model.initEventBus();

    model.initEventBusMe();
  }

  Widget _buildVideoThumb(NewFeed item) {
    return Stack(
      alignment: Alignment.center,
      children: [
        RoundNetworkImage(
          width: width / 2,
          height: width / 2,
          radius: 0,
          url: item.images?[0].thumb,
          placeholder: ImageRectangleShimmer(
            width: width / 2,
            height: width / 2,
          ),
          errorHolder: ImageRectangleShimmer(
            width: width / 2,
            height: width / 2,
          ),
        ),
        Image.asset(
          DImages.btnVideoPause,
          height: 40,
          width: 40,
        )
      ],
    );
  }

  Widget _buildImageItem(NewFeed item) {
    return RoundNetworkImage(
      width: width / 2,
      height: width / 2,
      radius: 0,
      url: item.images?[0].link,
      placeholder: ImageRectangleShimmer(
        width: width / 2,
        height: width / 2,
      ),
      errorHolder: ImageRectangleShimmer(
        width: width / 2,
        height: width / 2,
      ),
    );
  }

  bool isVideoContent(NewFeed item) {
    return item.images?.isNotEmpty == true &&
        item.images?[0].type == Constants.TYPE_VIDEO;
  }

  Widget _itemNewFeed(NewFeed item) {
    var totalImage = item.images != null ? item.images!.length : 0;
    final videoThumb = totalImage > 0 ? item.images![0].thumb : null;

    return InkWell(
      onTap: () {
        if (isVideoContent(item)) {
          Navigator.pushNamed(context, Routes.postVideoDetail,
              arguments: PostDetailAgrument(item));
        } else {
          Navigator.pushNamed(context, Routes.postDetail,
              arguments: PostDetailAgrument(item));
        }
      },
      child: Container(
          child: Stack(
        children: [
          videoThumb?.isNotEmpty == true
              ? _buildVideoThumb(item)
              : totalImage > 0
                  ? _buildImageItem(item)
                  : SizedBox(),
          Visibility(
            visible: totalImage == 0,
            child: Container(
              padding: EdgeInsets.all(5),
              width: width / 2,
              height: width / 2,
              color: Colors.black12,
              child: Center(
                child: HtmlViewNewFeed(
                    newFeed: item,
                    minLengthContent: 150,
                    textStyle: textTheme(context).text13.ff261744Color,
                    cssTagHtmlClass: CssStyleClass.bold_13_violet,
                    cssHashTagHtmlClass: CssStyleClass.bold_13_black,
                    isViewMore: false),
              ),
            ),
          ),
          Container(
            width: width / 2,
            height: width / 2,
            color: Colors.black12,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment(0.0, 0.0),
                      end: Alignment(0.0, 1.0),
                      colors: [
                        const Color(0x00000000),
                        const Color(0x80000000)
                      ]),
                )),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 10, left: 12, right: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FavoriteNewFeedCheckBox(
                    newFeed: item,
                    width: 20.0,
                    height: 20.0,
                    padding: 3.0,
                    isFormatTotal: true,
                    txtTheme: textTheme(context).text13.colorWhite,
                    iconFavorite: DImages.favoriteWhite,
                    iconFavoriteActive: DImages.favoriteWhite,
                    uncheckedColor: DColors.whiteColor,
                    isDisable: true,
                  ),
                  GroupCommentWidget(
                    item,
                    showFullTotalComment: false,
                    disableAction: true,
                  ),
                  totalImage > 1
                      ? Image.asset(
                          DImages.multiplePhoto,
                          height: 20.0,
                          width: 20.0,
                        )
                      : SizedBox(
                          width: 0,
                          height: 0,
                        ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
                child: item.user!.isMe
                    ? _buildMyButtonMore(item)
                    : _buildButtonMore(item)),
          ),
        ],
      )),
    );
  }

  Widget _buildButtonMore(NewFeed newFeed) {
    final menuItems = menuMoreItems
        .where((element) =>
            element != NewFeedMenu.sendMessage &&
            element != NewFeedMenu.unFollow)
        .toList();
    return BottomSheetMenuWidget(
      items: menuItems.map((e) => e.name).toList(),
      onItemClicked: (index) async {
        switch (menuMoreItems[index]) {
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
                          await model.block(newFeed.user!);
                          newFeed.user!.isFollow = false;
                          showToast(Strings.blockSuccess.localize(context));
                        });
                      },
                    ));
            break;
          case NewFeedMenu.share:
            locator<HandleLinkUtil>().shareNewFeed(newFeed.id);
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
                          showToast(Strings.unFollowSuccess.localize(context));
                        });
                      },
                    ));

            break;
          case NewFeedMenu.cancel:
            break;
          case NewFeedMenu.sendMessage:
            break;
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Image.asset(
          DImages.moreGray,
          height: Dimens.size32,
          width: Dimens.size32,
          color: getColor().white,
        ),
      ),
    );
  }

  Future<void> refresh() async {
    model.refresh();
  }

  Widget _buildMyButtonMore(NewFeed newFeed) {
    return BottomSheetMenuWidget(
      items: myMenuMoreItems.map((e) => e.name).toList(),
      onItemClicked: (index) async {
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
              builder: (context) => TwoButtonDialogAwaitConfirmWidget(
                description: Strings.confirmDeletePost.localize(context),
                onFixErrorCallAPI: true,
                onConfirmed: () {
                  callApi(callApiTask: () async {
                    await model.deleteNewFeed(newFeed.id!);
                  }, onSuccess: () {
                    showToast(Strings.deletePostSuccess.localize(context));
                    Navigator.pop(context);
                  });
                },
              ),
            );

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
          color: getColor().white,
        ),
      ),
    );
  }

  showDialogDeletePost(
      BuildContext context, String? idNewFeed, Function? onSuccess) {
    return TwoButtonDialogWidget(
      description: Strings.confirmDeletePost.localize(context),
      onConfirmed: () {
        callApi(callApiTask: () async {
          await model.deleteNewFeed(idNewFeed!);
        }, onSuccess: () {
          onSuccess!();
          print("model");
          showToast(Strings.deletePostSuccess.localize(context));
        });
      },
    );
  }

  Widget buildItem(BuildContext context, GroupNewFeed item, int index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 35,
          color: DColors.grayF0CColor,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: Dimens.spacing16),
          child: Text(
            Strings.month.localize(context) + " " + item.title,
            style: textTheme(context).text12.darkTextColor,
          ),
        ),
        Container(
          child: GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 0),
            physics: NeverScrollableScrollPhysics(),
            itemCount: item.newFeeds.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                mainAxisSpacing: 2.0,
                crossAxisSpacing: 2.0),
            itemBuilder: (contxt, childIndex) {
              var newFeed = item.newFeeds[childIndex];
              return _itemNewFeed(newFeed);
            },
          ),
        )
      ],
    );
  }

  @override
  Widget get buildLoadingView => GridviewItemSquareShimmer();

  Widget buildEmptyView(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
          ),
          Image.asset(
            DImages.empty,
            width: 60,
            height: 60,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            Strings.newfeed_empty.localize(context),
            style: textTheme(context).text15.b6b6cbColor,
          ),
          SizedBox(
            height: 30,
          ),
          InkWell(
            child: Container(
              height: 40,
              padding: EdgeInsets.only(left: 25, right: 25, top: 8, bottom: 8),
              decoration: BoxDecoration(
                  border: Border.all(color: getColor().primaryColor, width: 1),
                  borderRadius: BorderRadius.circular(6)),
              child: Text(
                Strings.create_newfeed.localize(context),
                style: textTheme(context).text15.colorPrimary,
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, Routes.createNewFeed);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget buildContentView(BuildContext context, MyPostModel model) {
    return LazyLoadScrollView(
        child: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: refresh,
            child: ChangeNotifierProvider.value(
              value: model.listValue,
              child: model.listValue.value.length > 0
                  ? ListView.builder(
                      padding: EdgeInsets.only(top: 0.0),
                      itemCount: model.listValue.value.length,
                      itemBuilder: (context, index) {
                        final item = model.listValue.value[index];
                        return buildItem(context, item, index);
                      })
                  : buildEmptyView(context),
            )),
        onEndOfPage: model.getMore);
  }
}

enum MyNewFeedMenu { edit, share, delete, cancel }

extension MyNewFeedMenuExt on MyNewFeedMenu {
  String get name {
    switch (this) {
      case MyNewFeedMenu.edit:
        return Strings.edit;
      case MyNewFeedMenu.share:
        return Strings.share;
      case MyNewFeedMenu.delete:
        return Strings.delete;
      case MyNewFeedMenu.cancel:
        return Strings.close;
    }
  }
}
