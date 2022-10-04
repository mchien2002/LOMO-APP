import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/ui/base/base_grid_state.dart';
import 'package:lomo/ui/discovery/list_type_discovery/item_type_discovery_view.dart';
import 'package:lomo/ui/search/search_new_feed/search_new_feed_model.dart';
import 'package:lomo/ui/widget/empty_widget.dart';
import 'package:lomo/ui/widget/shimmers/gridview_itemsquare_shimmer.dart';

class SearchNewFeedScreen extends StatefulWidget {
  final ValueNotifier<String> textSearch;
  SearchNewFeedScreen({required this.textSearch});

  @override
  _SearchNewFeedScreenState createState() => _SearchNewFeedScreenState();
}

class _SearchNewFeedScreenState
    extends BaseGridState<NewFeed, SearchNewFeedModel, SearchNewFeedScreen>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<SearchNewFeedScreen> {
  @override
  void initState() {
    super.initState();
    model.init(widget.textSearch);
    model.loadData();
    widget.textSearch.addListener(() {
      model.refresh();
    });
  }

  var size;

  @override
  bool get wantKeepAlive => true;

  @override
  bool get autoLoadData => false;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    final double itemHeight = (size.width / 2) + 80;
    final double itemWidth = size.width / 2;
    childAspectRatio = itemWidth / itemHeight;
    return Scaffold(
      body: buildContent(),
    );
  }

  @override
  Widget buildEmptyView(BuildContext context) {
    return EmptyWidget();
  }

  @override
  Widget buildItem(BuildContext context, NewFeed item, int index) {
    return Container(
      child: ItemTypeDiscoveryView(
        item,
        width: size.width / 2,
      ),
    );
  }

  @override
  Widget get buildLoadingView => GridviewItemSquareShimmer();
}
