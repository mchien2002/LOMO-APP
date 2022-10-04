import 'package:flutter/material.dart';
import 'package:lomo/ui/base/base_list_state.dart';

import 'base_list_model.dart';

abstract class BaseGridState<I, M extends BaseListModel<I>,
    W extends StatefulWidget> extends BaseListState<I, M, W> {
  @override
  Widget buildContentView(BuildContext context, M model) {
    Widget content;
    if (model.items.isEmpty) {
      content = Stack(children: <Widget>[buildEmptyView(context), ListView()]);
    } else {
      content = GridView.count(
        crossAxisCount: crossAxisCount,
        physics: scrollPhysics,
        padding: paddingGrid,
        controller: controller,
        scrollDirection: axis,
        childAspectRatio: childAspectRatio,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        shrinkWrap: shrinkWrap,
        children: model.items
            .map((e) => buildItem(context, e, model.items.indexOf(e)))
            .toList(),
      );
    }
    if (enableRefresh) {
      content = RefreshIndicator(child: content, onRefresh: onRefresh);
    }
    return content;
  }

  Widget buildEmptyView(BuildContext context) {
    return Container();
  }

  int crossAxisCount = 2;

  double childAspectRatio = 1;

  double mainAxisSpacing = 0;

  double crossAxisSpacing = 0;

  double gridMarginHorizontal = 0;

  bool get shrinkWrap => false;

  Axis get axis => Axis.vertical;

  ScrollPhysics get scrollPhysics => AlwaysScrollableScrollPhysics();

  EdgeInsets get paddingGrid =>
      EdgeInsets.symmetric(horizontal: gridMarginHorizontal);

  int get loadMoreBeforeRange => 6;

  int get scrollOffset => 500;
}
