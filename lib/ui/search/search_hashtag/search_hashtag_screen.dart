import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/hash_tag.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/base/base_list_state.dart';
import 'package:lomo/ui/search/search_hashtag/search_hashtag_item.dart';
import 'package:lomo/ui/search/search_hashtag/search_hashtag_model.dart';

class SearchHashTagScreen extends StatefulWidget {
  final ValueNotifier<String> textSearch;
  SearchHashTagScreen({required this.textSearch});

  @override
  State<StatefulWidget> createState() => _SearchHashTagScreenState();
}

class _SearchHashTagScreenState
    extends BaseListState<HashTag, SearchHashTagModel, SearchHashTagScreen>
    with AutomaticKeepAliveClientMixin<SearchHashTagScreen> {
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
  Widget buildItem(BuildContext context, HashTag hashTag, int index) {
    return SearchHashTagItem(
      hashTag: hashTag,
    );
  }

  @override
  bool get autoLoadData => false;

  @override
  Color get dividerColor => getColor().pinkF2F5Color;

  @override
  bool get wantKeepAlive => true;

  @override
  double get itemSpacing => 1;
}
