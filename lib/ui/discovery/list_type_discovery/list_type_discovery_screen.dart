import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lomo/data/api/models/filter_request_item.dart';
import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/res/colors.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/ui/base/base_grid_state.dart';
import 'package:lomo/ui/discovery/list_type_discovery/item_type_discovery_view.dart';
import 'package:lomo/ui/discovery/list_type_discovery/list_type_discovery_model.dart';
import 'package:lomo/ui/widget/shimmers/gridview_itemsquare_shimmer.dart';
import 'package:provider/provider.dart';

class ListTypeDiscoveryScreen extends StatefulWidget {
  final TypeDiscoverAgrument argument;

  ListTypeDiscoveryScreen(this.argument);

  @override
  _ListTypeDiscoveryScreenState createState() =>
      _ListTypeDiscoveryScreenState();
}

class _ListTypeDiscoveryScreenState extends BaseGridState<NewFeed,
        ListTypeDiscoveryModel, ListTypeDiscoveryScreen>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<ListTypeDiscoveryScreen> {
  var size;

  @override
  bool get wantKeepAlive => true;

  @override
  bool get autoLoadData => false;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    final double itemHeight = (size.width / 2) + 75;
    final double itemWidth = size.width / 2;
    childAspectRatio = itemWidth / itemHeight;
    return Scaffold(
      backgroundColor: DColors.pinkF2F5,
      appBar: AppBar(
        backgroundColor: DColors.pinkF2F5,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        centerTitle: true,
        leading: IconButton(
            icon: Image.asset(DImages.backBlack),
            onPressed: () => Navigator.pop(context)),
        title: _buildTitle(),
      ),
      body: Container(margin: EdgeInsets.only(top: 10), child: buildContent()),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        Text(
          widget.argument.title.localize(context),
          style: textTheme(context).text19.bold.darkTextColor,
        ),
        SizedBox(
          height: 2,
        ),
        ChangeNotifierProvider.value(
          value: model,
          child: Consumer<ListTypeDiscoveryModel>(
              builder: (context, model, child) => Text(
                    "${model.totalValue.value} ${Strings.post.localize(context).toLowerCase()}",
                    style: textTheme(context).text13.text757788Color,
                  )),
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    model.init(widget.argument.dataFilter);
    model.loadData();
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

class TypeDiscoverAgrument {
  String title;
  List<FilterRequestItem> dataFilter;

  TypeDiscoverAgrument(this.title, this.dataFilter);
}
