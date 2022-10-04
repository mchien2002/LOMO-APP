import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/data/api/models/response/NewFeedResponse.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/base/base_grid_state.dart';
import 'package:lomo/ui/discovery/newfeed/item/newfeed_item.dart';
import 'package:lomo/ui/discovery/newfeed/list_more/discovery_newfeeds_more_model.dart';
import 'package:lomo/ui/widget/shimmers/gridview_itemsquare_shimmer.dart';

class ListMorePostArguments {
  final String title;
  final Future<NewFeedResponse> Function(int page, int pageSize) getPosts;

  ListMorePostArguments(this.getPosts, this.title);
}

class DiscoveryNewFeedsMoreScreen extends StatefulWidget {
  final ListMorePostArguments arguments;

  DiscoveryNewFeedsMoreScreen(this.arguments);

  @override
  State<StatefulWidget> createState() => _DiscoveryNewFeedsMoreScreenState();
}

class _DiscoveryNewFeedsMoreScreenState extends BaseGridState<NewFeed,
    DiscoveryNewFeedsMoreModel, DiscoveryNewFeedsMoreScreen> {
  late double itemWidth;
  late double itemHeight;

  @override
  void initState() {
    super.initState();
    model.init(widget.arguments.getPosts);
    model.loadData();
  }

  @override
  bool get autoLoadData => false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    itemWidth = (size.width / 2) - 20;
    itemHeight = itemWidth + 70;
    childAspectRatio = itemWidth / itemHeight;
    return Scaffold(
      backgroundColor: getColor().pinkF2F5Color,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: getColor().white,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        automaticallyImplyLeading: false,
        title: Text(
          widget.arguments.title,
          style: textTheme(context).text19.bold.colorDart,
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Image.asset(
              DImages.backBlack,
              color: getColor().colorDart,
            ),
          ),
        ),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: buildContent()),
    );
  }

  @override
  Widget buildItem(BuildContext context, NewFeed item, int index) {
    return NewFeedItem(
      item: item,
      index: index,
      width: itemWidth,
      height: itemHeight,
    );
  }

  @override
  Widget get buildLoadingView => GridviewItemSquareShimmer();

  @override
  double get mainAxisSpacing => 10;

  @override
  double get crossAxisSpacing => 10;
}
