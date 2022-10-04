import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:lomo/app/app_model.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/widget/empty_widget.dart';

import 'base_list_model.dart';
import 'base_state.dart';

abstract class BaseListState<I, M extends BaseListModel<I>,
    W extends StatefulWidget> extends BaseState<M, W> {
  late ScrollController controller;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  // bool alwaysScrollableScrollPhysics = true;

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
    KeyboardVisibilityController().onChange.listen((bool visible) {
      model.isShowKeyBoard = visible;
    });
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
    Widget content;
    if (model.items.isEmpty) {
      content = Stack(children: <Widget>[
        ListView(
          physics: AlwaysScrollableScrollPhysics(),
        ),
        buildEmptyView(context),
      ]);
    } else {
      content = ListView.separated(
          physics: physics,
          shrinkWrap: shrinkWrap,
          reverse: reverse,
          padding: padding,
          controller: controller,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) =>
              buildItem(context, model.items[index], index),
          separatorBuilder: (context, index) => buildSeparator(context, index),
          itemCount: model.items.length);
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

  void _scrollListener() {
    final isScrollUp =
        controller.position.userScrollDirection == ScrollDirection.forward;
    if (controller.position.extentAfter < rangeLoadMore &&
        !isScrollUp &&
        !model.isShowKeyBoard) {
      print('KeyboardIsShow: ${model.isShowKeyBoard}');
      print("LoadMoreMore");
      model.loadMoreData();
    }
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

  bool get shrinkWrap => false;

  bool get reverse => false;

  bool get isLoadCacheData => false;

  double get rangeLoadMore => 500;

  Color get dividerColor => getColor().white;

  ScrollPhysics get physics => AlwaysScrollableScrollPhysics();
}
