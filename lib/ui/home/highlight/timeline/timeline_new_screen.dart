import 'package:flutter/material.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../app/app_model.dart';
import '../../../../app/lomo_app.dart';
import '../../../../data/api/models/filter_request_item.dart';
import '../../../../data/api/models/new_feed.dart';
import '../../../../data/eventbus/filter_highlight_event.dart';
import '../../../../data/eventbus/outside_newfeed_event.dart';
import '../../../../data/eventbus/refresh_mypost_event.dart';
import '../../../../data/eventbus/refresh_profile_event.dart';
import '../../../../di/locator.dart';
import '../../../../res/colors.dart';
import '../../../../res/images.dart';
import '../../../../res/strings.dart';
import '../../../../res/values.dart';
import '../../../../util/common_utils.dart';
import '../../../base/base_state.dart';
import '../../../widget/empty/empty_filter_widget.dart';
import '../../../widget/shimmers/timeline/timeline_shimmer_loading.dart';
import 'item/timeline_item_view.dart';
import 'list_favorite/favorite_post_dialog.dart';
import 'timeline_list_model.dart';

class TimeLineNewScreen extends StatefulWidget {
  final ValueNotifier<dynamic> refreshData;

  TimeLineNewScreen({required this.refreshData});

  @override
  State<StatefulWidget> createState() => _TimeLineNewScreenState();
}

class _TimeLineNewScreenState
    extends BaseState<TimelineListModel, TimeLineNewScreen>
    with
        AutomaticKeepAliveClientMixin<TimeLineNewScreen>,
        WidgetsBindingObserver {
  late ScrollController controller;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool alwaysScrollableScrollPhysics = true;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller = new ScrollController()..addListener(_scrollListener);
    if (isLoadCacheData && !locator<AppModel>().isConnected) {
      model.loadCacheData();
    } else if (autoLoadData && locator<AppModel>().isConnected) {
      model.loadData();
    }

    eventBus.on<FilterHighlightEvent>().listen((event) async {
      final result = await Navigator.pushNamed(context, Routes.filterHighlight,
          arguments: model.postFilters);
      if (result != null) {
        model.postFilters = result as GetQueryParam?;
        model.refresh();
      }
    });

    eventBus.on<RefreshWhenCreatePostEvent>().listen((event) async {
      //Chuyen ve tab NOI BAT va add newfeed vao vi tri dau tien
      if (event.newFeed != null) {
        model.items.insert(0, event.newFeed!);
        model.notifyListeners();
        jumpToTop();
      }
    });

    widget.refreshData.addListener(() {
      if (model.items.isNotEmpty == true) {
        if (controller.position.pixels == 0.0) {
          model.refresh();
        } else {
          jumpToTop();
        }
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print("didChangeAppLifecycleState: ${state.name}");
    // Khi app đang ở chế độ background
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      // bắn event thông báo đã ra khỏi tab news feed
      eventBus.fire(OutSideNewFeedsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildContent();
  }

  @override
  Widget buildContentView(BuildContext context, TimelineListModel model) {
    Widget content;
    if (model.items.isEmpty) {
      content = Stack(children: <Widget>[
        ListView(
          physics: AlwaysScrollableScrollPhysics(),
        ),
        buildEmptyView(context),
      ]);
    } else {
      content = Container(
        color: backgroundColor,
        child: model.items.isNotEmpty
            ? InViewNotifierList(
                physics: BouncingScrollPhysics(),
                controller: enableScroll ? controller : null,
                isInViewPortCondition:
                    (double deltaTop, double deltaBottom, double vpHeight) {
                  final average = (deltaTop + deltaBottom) / 2.0;
                  return (average > 0.2 * vpHeight && average < 0.7 * vpHeight);
                },
                itemCount: model.items.length,
                initialInViewIds: [if (model.items.isNotEmpty) '0'],
                builder: (BuildContext context, int index) {
                  return InViewNotifierWidget(
                    id: '$index',
                    builder: (context, isInView, child) {
                      return buildItem(
                          context, model.items[index], index, isInView);
                    },
                  );
                },
              )
            : SizedBox(
                height: 0,
              ),
      );
    }
    if (enableRefresh) {
      content = RefreshIndicator(
        child: content,
        onRefresh: onRefresh,
        key: refreshIndicatorKey,
      );
    }
    return content;
  }

  Future<void> onRefresh() async {
    return model.refresh();
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
          TimelineItemView(
            isInView: isInView,
            newFeed: item,
            onViewFavoriteAction: () {
              // bắn event thông báo đã ra khỏi tab news feed
              eventBus.fire(OutSideNewFeedsEvent());
              callListFavoriteUserPost(context, item.id);
            },
            onDeleteAction: () async {
              callApi(callApiTask: () async {
                await model.deleteNewFeed(item.id!);
              }, onSuccess: () {
                showToast(Strings.deletePostSuccess.localize(context));
                //Update ben trang ca nhan
                eventBus.fire(RefreshMyPostEvent(newFeedId: item.id!));
              });
            },
            onBlockUser: (user) async {
              await model.block(user);
              showToast(Strings.blockSuccess.localize(context));
            },
          )
        ],
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

  void _scrollListener() {
    // if(controller.position.atEdge){
    //   if(controller.position.pixels != 0){
    //     model.loadMoreData();
    //   }
    // }
    if (controller.position.extentAfter < rangeLoadMore) {
      model.loadMoreData();
    }
  }

  jumpToTop() {
    controller.animateTo(
      0.0,
      curve: Curves.easeInOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  Future<void> _onRefresh() async {
    if (!mounted) {
      return;
    }
    return model.refresh();
  }

  @override
  void onRetry() {
    model.loadData();
  }

  Widget buildSeparator(BuildContext context, int index) {
    return Container(
      height: itemSpacing,
      color: dividerColor,
    );
  }

  @override
  Widget buildEmptyView(BuildContext context) {
    return EmptyFilterWidget(
      btnTitle: Strings.emptyPostText.localize(context),
      emptyImage: DImages.emptyItem,
      message: Strings.emptyDatingText.localize(context),
      onClicked: () {
        eventBus.fire(FilterHighlightEvent());
      },
    );
  }

  @override
  Widget get buildLoadingView => TimelineShimmerLoading();

  bool get enableRefresh => true;

  EdgeInsets get padding => const EdgeInsets.all(0);

  double get itemSpacing => 0;

  bool get autoLoadData => true;

  bool get isLoadCacheData => false;

  double get rangeLoadMore => 1024;

  Color get dividerColor => DColors.whiteColor;

  Color get backgroundColor => getColor().white;

  bool get enableScroll => true;

  @override
  bool get wantKeepAlive => true;
}
