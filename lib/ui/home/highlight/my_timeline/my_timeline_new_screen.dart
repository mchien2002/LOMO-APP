import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/data/eventbus/filter_highlight_event.dart';
import 'package:lomo/data/eventbus/outside_newfeed_event.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/ui/base/base_list_state.dart';
import 'package:lomo/ui/widget/empty/empty_filter_widget.dart';
import 'my_timeline_list_model.dart';

class MyTimeLineNewScreen extends StatefulWidget {
  const MyTimeLineNewScreen({Key? key}) : super(key: key);

  @override
  State<MyTimeLineNewScreen> createState() => _MyTimeLineNewScreenState();
}

class _MyTimeLineNewScreenState
    extends BaseListState<NewFeed, MyTimeLineListModel, MyTimeLineNewScreen>
    with
        WidgetsBindingObserver,
        AutomaticKeepAliveClientMixin<MyTimeLineNewScreen> {
  ScrollController? timeLineController;
  bool alwaysScrollablePhysics = true;
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    timeLineController?.removeListener(_scrollLitener);
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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

  @override
  Future<void> onRefresh() {
    // TODO: implement onRefresh
    return super.onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // ListView(
        //   physics: AlwaysScrollableScrollPhysics(),
        // ),
        buildEmptyView(context)
      ],
    );
  }

  callListFavoriteUserPost(
      BuildContext context, NewFeed item, String? idPost) {}

  @override
  Widget buildContentView(BuildContext context, MyTimeLineListModel model) {
    // TODO: implement buildContentView
    throw UnimplementedError();
  }

  @override
  Widget buildItem(BuildContext context, NewFeed item, int index) {
    // TODO: implement buildItem
    throw UnimplementedError();
  }

  @override
  Widget buildSeparator(BuildContext context, int index) {
    // TODO: implement buildSeparator
    return super.buildSeparator(context, index);
  }

  _onRefresh() {}
  @override
  void onRetry() {
    // TODO: implement onRetry
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
    
  }
  @override
  jumpToTop() {
    // TODO: implement jumpToTop
    return super.jumpToTop();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => throw UnimplementedError();
  @override
  // TODO: implement rangeLoadMore
  double get rangeLoadMore => 1024;
}
