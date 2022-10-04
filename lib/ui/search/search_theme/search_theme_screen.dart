import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/topic_item.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/base/base_list_state.dart';
import 'package:lomo/ui/search/search_theme/search_them_item.dart';
import 'package:lomo/ui/search/search_theme/search_theme_model.dart';

class SearchThemeScreen extends StatefulWidget {
  final ValueNotifier<String> textSearch;

  SearchThemeScreen({required this.textSearch});

  @override
  State<StatefulWidget> createState() => _SearchThemeScreen();
}

class _SearchThemeScreen
    extends BaseListState<TopictItem, SearchThemeModel, SearchThemeScreen> {
  @override
  void initState() {
    super.initState();
    model.init(widget.textSearch);
    model.loadData();
    widget.textSearch.addListener(() {
      model.refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildContent();
  }

  @override
  Widget buildItem(BuildContext context, TopictItem item, int index) {
    return SearchThemItem(
      topic: item,
    );
  }

  @override
  EdgeInsets get padding => EdgeInsets.only(bottom: 10);

  @override
  double get itemSpacing => 1;

  @override
  bool get autoLoadData => false;

  @override
  Color get dividerColor => getColor().pinkF2F5Color;

  @override
  bool get wantKeepAlive => true;
}
