import 'package:flutter/material.dart';
import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/data/api/models/filter_request_item.dart';
import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/data/eventbus/filter_highlight_event.dart';
import 'package:lomo/data/eventbus/refresh_mypost_event.dart';
import 'package:lomo/data/eventbus/refresh_profile_event.dart';
import 'package:lomo/res/colors.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/base/base_list_state.dart';
import 'package:lomo/ui/home/highlight/timeline/list_favorite/favorite_post_dialog.dart';
import 'package:lomo/ui/home/highlight/timeline/timeline_list_model.dart';
import 'package:lomo/ui/widget/empty/empty_filter_widget.dart';
import 'package:lomo/ui/widget/shimmers/timeline/timeline_shimmer_loading.dart';
import 'package:lomo/util/common_utils.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'item/timeline_item_view.dart';

class TimelineListScreen extends StatefulWidget {
  final ValueNotifier<dynamic> refreshData;

  TimelineListScreen({required this.refreshData});

  @override
  State<StatefulWidget> createState() => _TimelineListScreen();
}

class _TimelineListScreen
    extends BaseListState<NewFeed, TimelineListModel, TimelineListScreen>
    with AutomaticKeepAliveClientMixin<TimelineListScreen> {
  @override
  void initState() {
    super.initState();
    model.init();
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
  Widget build(BuildContext context) {
    return super.buildContent();
  }

  @override
  Widget get buildLoadingView => TimelineShimmerLoading();

  @override
  Widget buildItem(BuildContext context, NewFeed item, int index) {
    return VisibilityDetector(
      key: Key(item.id!),
      onVisibilityChanged: (visibilityInfo) {
        var visiblePercentage = visibilityInfo.visibleFraction * 100;
        if (visiblePercentage > 60.0)
          debugPrint(
              'isFinite $index:${visibilityInfo.visibleFraction.isFinite}');
        // debugPrint(
        //     'isInfinite $index:${visibilityInfo.visibleFraction.isInfinite}');
        // debugPrint(
        //     'isNegative $index:${visibilityInfo.visibleFraction.isNegative}');
      },
      child: Column(
        children: [
          Container(
            height: index == 0 ? 1.2 : 0,
            color: DColors.pinkF2F5,
          ),
          TimelineItemView(
            newFeed: item,
            onViewFavoriteAction: () {
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

  @override
  bool get wantKeepAlive => true;

  @override
  bool get isLoadCacheData => true;

  @override
  double get itemSpacing => 2.0;

  @override
  Color get dividerColor => DColors.grayE0Color;

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
}
