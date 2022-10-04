import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lomo/ui/widget/empty_widget.dart';

import 'base_list_model.dart';
import 'base_state.dart';

abstract class BaseSnapListState<I, M extends BaseListModel<I>, W extends StatefulWidget>
    extends BaseState<M, W> {
  PageController controller = PageController();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: initIndexPage);
    if (autoLoadData) {
      model.loadData();
    }
  }

  showRefreshIndicator() {
    refreshIndicatorKey.currentState?.show();
  }

  jumpToTop() {
    controller.jumpToPage(1);
    controller.animateToPage(
      0,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget buildContentView(BuildContext context, M model) {
    Widget content;
    if (model.items.isEmpty) {
      content = Stack(children: <Widget>[buildEmptyView(context)]);
    } else {
      content = PageView.builder(
        allowImplicitScrolling: true,
        controller: controller,
        physics: ClampingScrollPhysics(),
        itemBuilder: (BuildContext context, int itemIndex) {
          if (itemIndex == model.items.length - loadMoreBeforeRange - 1) model.loadMoreData();
          return buildItem(context, model.items[itemIndex], itemIndex);
        },
        onPageChanged: (pageIdx) {
          controller.animateToPage(pageIdx,
              duration: const Duration(milliseconds: 150), curve: Curves.linearToEaseOut);
        },
        itemCount: model.items.length,
        scrollDirection: Axis.vertical,
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

  @override
  void onRetry() {
    model.loadData();
  }

  Widget buildItem(BuildContext context, I item, int index);

  Widget buildSeparator(BuildContext context, int index) {
    return SizedBox(height: itemSpacing);
  }

  Widget buildEmptyView(BuildContext context) {
    return EmptyWidget();
  }

  bool get enableRefresh => true;

  EdgeInsets get padding => const EdgeInsets.all(0);

  double get itemSpacing => 0;

  bool get autoLoadData => true;

  double get rangeLoadMore => 500;

  int get loadMoreBeforeRange => 4;

  int get initIndexPage => 0;
}
