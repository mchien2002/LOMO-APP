import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lomo/app/app_model.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/colors.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/widget/empty_widget.dart';
import 'package:lomo/ui/widget/loading_widget.dart';
import 'package:provider/provider.dart';

import 'base_list_model.dart';
import 'base_state.dart';

abstract class BaseSliverListState<I, M extends BaseListModel<I>,
    W extends StatefulWidget> extends BaseState<M, W> {
  late ScrollController controller;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool alwaysScrollableScrollPhysics = true;

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = new ScrollController()..addListener(_scrollListener);
    if (isLoadCacheData && !locator<AppModel>().isConnected) {
      model.loadCacheData();
    } else if (autoLoadData && locator<AppModel>().isConnected) {
      model.loadData();
    }
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

  @override
  Widget buildContentView(BuildContext context, M model) {
    return Container(
      color: backgroundColor,
      child: model.items.isNotEmpty
          ? CustomScrollView(
              physics: BouncingScrollPhysics(),
              controller: enableScroll ? controller : null,
              slivers: [
                CupertinoSliverRefreshControl(
                  onRefresh: enableRefresh ? _onRefresh : null,
                  refreshIndicatorExtent: 30,
                  refreshTriggerPullDistance: 30,
                  builder: (_, __, a1, a2, a3) {
                    return Container(
                      alignment: Alignment.center,
                      child: LoadingWidget(
                        radius: 12,
                      ),
                    );
                  },
                ),
                SliverPadding(
                  padding: padding,
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Column(
                          children: [
                            buildItem(context, model.items[index], index),
                            Divider(height: itemSpacing, color: dividerColor)
                          ],
                        );
                      },
                      childCount: model.items.length,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                    child: ChangeNotifierProvider.value(
                  value: model.loadMoreValue,
                  child: model.loadMoreValue.value
                      ? Container(
                          padding: EdgeInsets.only(bottom: 10, top: 10),
                          alignment: Alignment.center,
                          child: LoadingWidget(
                            radius: 16,
                          ),
                        )
                      : SizedBox(),
                )),
              ],
            )
          : buildEmptyView(context),
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

  Widget buildItem(BuildContext context, I item, int index);

  Widget buildSeparator(BuildContext context, int index) {
    return Container(
      height: itemSpacing,
      color: dividerColor,
    );
  }

  Widget buildEmptyView(BuildContext context) {
    return EmptyWidget();
  }

  bool get enableRefresh => true;

  EdgeInsets get padding => const EdgeInsets.all(0);

  double get itemSpacing => 0;

  bool get autoLoadData => true;

  bool get isLoadCacheData => false;

  double get rangeLoadMore => 1024;

  Color get dividerColor => DColors.whiteColor;

  Color get backgroundColor => getColor().white;

  bool get enableScroll => true;
}
