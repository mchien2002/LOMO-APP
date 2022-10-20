import 'package:flutter/material.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:lomo/app/app_model.dart';
import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/data/eventbus/filter_highlight_event.dart';
import 'package:lomo/data/eventbus/outside_newfeed_event.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/home/highlight/my_timeline/item/mytimeline_item_view.dart';
import 'package:lomo/ui/home/highlight/timeline/list_favorite/favorite_post_dialog.dart';
import 'package:lomo/ui/widget/empty/empty_filter_widget.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../../di/locator.dart';
import '../../../../res/colors.dart';
import '../../../../res/theme/theme_manager.dart';
import '../../../../util/common_utils.dart';
import 'my_timeline_list_model.dart';

class MyTimeLineNewScreen extends StatefulWidget {
  final ValueNotifier<dynamic> refreshData;
  const MyTimeLineNewScreen({Key? key, required this.refreshData})
      : super(key: key);

  @override
  State<MyTimeLineNewScreen> createState() => _MyTimeLineNewScreenState();
}

class _MyTimeLineNewScreenState
    extends BaseState<MyTimeLineListModel, MyTimeLineNewScreen>
    with
        WidgetsBindingObserver,
        AutomaticKeepAliveClientMixin<MyTimeLineNewScreen> {
  late ScrollController controller;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool alwaysScrollablePhysics = true;
  bool get enableRefresh => true;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller.removeListener(_scrollLitener);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // init widgetbinding
    WidgetsBinding.instance.addObserver(this);
    // load data trong bộ nhớ đệm nếu app không có kết nối
    controller = new ScrollController()..addListener(_scrollLitener);
    if (isLoadCacheData && !locator<AppModel>().isConnected) {
      model.loadCacheData();
    } else if (autoLoadData && locator<AppModel>().isConnected) {
      model.loadData();
    }

    widget.refreshData.addListener(() {
      if (model.items.isNotEmpty) {
        if (controller.position.pixels == 0) {
          model.refresh();
        } else {
          jumpToTop();
        }
      }
    });
  }

  // CHECK XEM APP CÓ ĐANG Ở CHẾ ĐÔ BACKGROUND HAY KHÔNG
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("Đang ở chế độ: ${state.name}}");
    // Khi app đang ở chế độ background
    if (state == AppLifecycleState.paused) {
      // bắn event thông báo ra ngoài tab view
      // chưa dùng tới
      eventBus.fire(OutSideNewFeedsEvent());
    }
    super.didChangeAppLifecycleState(state);
  }

  Future<void> onRefresh() async {
    return model.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return buildContent();
  }

  callListFavoriteUserPost(BuildContext context, String? idPost) {
    showModalBottomSheet(
      context: context,
      backgroundColor: getColor().transparent,
      isScrollControlled: true,
      enableDrag: false,
      builder: (context) => FavoritePostDialog(
        isPost: idPost,
        onClosed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget buildContentView(BuildContext context, MyTimeLineListModel model) {
    Widget contentBuilder;
    print("ITEM LENGHT: ${model.items.length}");
    if (model.items.isEmpty) {
      contentBuilder = Stack(
        children: [
          ListView(
            physics: AlwaysScrollableScrollPhysics(),
          ),
          buildEmptyView(context)
        ],
      );
    } else if (enableRefresh) {}
    {
      contentBuilder = Container(
        color: backgroundColor,
        child: InViewNotifierList(
          physics: BouncingScrollPhysics(),
          controller: enableRefresh ? controller : null,
          isInViewPortCondition:
              (double deltaTop, double deltaBottom, double viewPortDimension) {
            final avg = (deltaBottom + deltaTop) / 2;
            return (avg > 0.2 * viewPortDimension &&
                avg < 0.7 * viewPortDimension);
          },
          itemCount: model.itemCount,
          initialInViewIds: [if (model.items.isNotEmpty) "0"],
          builder: ((context, index) {
            return InViewNotifierWidget(
                id: '$index',
                builder: (context, isInView, child) =>
                    buildItem(context, model.items[index], index, isInView));
          }),
        ),
      );
    }
    if (enableRefresh) {
      // icon mỗi khi scroll xuống để reload
      contentBuilder = RefreshIndicator(
        child: contentBuilder,
        onRefresh: onRefresh,
        key: refreshIndicatorKey,
      );
    }
    return contentBuilder;
  }

  Widget buildItem(
      BuildContext context, NewFeed item, int index, bool isInView) {
    return VisibilityDetector(
      key: Key(item.id!),
      onVisibilityChanged: (visibilityInfo) {
        var visiblePercentage = visibilityInfo.visibleFraction * 100;
        if (visiblePercentage > 60.0)
          debugPrint(
              'isFinite $index:${visibilityInfo.visibleFraction.isFinite}');
      },
      child: Column(
        children: [
          Container(
            height: index == 0 ? 1.2 : 0,
            color: getColor().pinkF2F5Color,
          ),
          // BEGIN TIMELINE WIDGET
          MyTimeLineItemView(
            newFeed: item,
            isWathching: isInView,
            onBlockUser: (user) async {
              callApi(callApiTask: () async {
                model.block(user);
              }, onSuccess: () {
                showToast(Strings.blockSuccess.localize(context));
              });
            },
            onDeleteAction: () async {
              callApi(callApiTask: () async {
                await model.deleteNewFeedPost(item.id!);
              }, onSuccess: () {
                showToast(Strings.deletePostSuccess.localize(context));
              });
            },
            onViewFavoriteAction: () async {
              eventBus.fire(OutSideNewFeedsEvent());
              callListFavoriteUserPost(context, item.id);
            },
          )
          // TimelineItemView(
          //   isInView: isInView,
          //   newFeed: item,
          //   onViewFavoriteAction: () {
          //     // bắn event thông báo đã ra khỏi tab news feed
          //     eventBus.fire(OutSideNewFeedsEvent());
          //     callListFavoriteUserPost(context, item.id);
          //   },
          //   onDeleteAction: () async {
          //     callApi(callApiTask: () async {
          //       await model.deleteNewFeedPost(item.id!);
          //     }, onSuccess: () {
          //       showToast(Strings.deletePostSuccess.localize(context));
          //       //Update ben trang ca nhan
          //       eventBus.fire(RefreshMyPostEvent(newFeedId: item.id!));
          //     });
          //   },
          //   onBlockUser: (user) async {
          //     await model.block(user);
          //     showToast(Strings.blockSuccess.localize(context));
          //   },
          // )
          // END TIMELINE WIDGET
        ],
      ),
    );
  }

  Widget buildSeparator(BuildContext context, int index) {
    return Container();
  }

  _onRefresh() {}
  @override
  void onRetry() {
    super.onRetry();
  }

  @override
  Widget buildEmptyView(BuildContext context) {
    return EmptyFilterWidget(
        onClicked: () {
          eventBus.fire(FilterHighlightEvent());
        },
        message: Strings.emptyDatingText.localize(context),
        btnTitle: Strings.emptyPostText.localize(context),
        emptyImage: DImages.emptyItem);
  }

  _scrollLitener() {
    if (controller.position.extentAfter < rangeLoadMore) {
      model.loadMoreData();
    }
  }

  jumpToTop() {}

  @override
  bool get wantKeepAlive => true;
  double get rangeLoadMore => 1024;
  bool get isLoadCacheData => false;
  bool get autoLoadData => true;
  EdgeInsets get padding => const EdgeInsets.all(0);
  double get itemSpacing => 0;
  Color get dividerColor => DColors.whiteColor;
  Color get backgroundColor => getColor().white;
  bool get enableScroll => true;
}
