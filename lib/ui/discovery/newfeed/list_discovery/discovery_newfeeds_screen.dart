import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/data/api/models/response/NewFeedResponse.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/discovery/newfeed/item/newfeed_item.dart';
import 'package:lomo/ui/discovery/newfeed/list_more/discovery_newfeeds_more_screen.dart';
import 'package:shimmer/shimmer.dart';

import 'discovery_newfeeds_model.dart';

class DiscoveryNewFeedsScreen extends StatefulWidget {
  final String title;
  final Future<NewFeedResponse> Function(int page, int pageSize) getData;
  final Function? onViewMore;
  final Function(NewFeed)? onItemClicked;

  DiscoveryNewFeedsScreen(
      {required this.title,
      required this.getData,
      this.onViewMore,
      this.onItemClicked});

  @override
  _DiscoveryNewFeedsScreenState createState() =>
      _DiscoveryNewFeedsScreenState();
}

class _DiscoveryNewFeedsScreenState
    extends BaseState<DiscoveryNewFeedsModel, DiscoveryNewFeedsScreen> {
  late double widthItem = 150;
  late double heightItem = 217;

  @override
  Widget build(BuildContext context) {
    return buildContent();
  }

  @override
  void initState() {
    super.initState();
    model.init(widget.getData);
  }

  @override
  Widget buildContentView(BuildContext context, DiscoveryNewFeedsModel model) {
    return Container(
      color: Colors.transparent,
      child: _buildContent(),
    );
  }

  Widget _buildTitle() {
    return Container(
      margin: EdgeInsets.only(
          left: Dimens.padding_left_right, right: Dimens.padding_left_right),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                widget.title.localize(context),
                style: textTheme(context).text15.bold.colorDart,
              ),
            ),
            InkWell(
              onTap: () {
                if (widget.onViewMore != null) {
                  widget.onViewMore!();
                }
                Navigator.pushNamed(
                  context,
                  Routes.morePost,
                  arguments:
                      ListMorePostArguments(widget.getData, widget.title),
                );
              },
              child: Container(
                padding: EdgeInsets.only(top: 2, bottom: 2, left: 5, right: 5),
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Text(
                      "${Strings.viewMore.localize(context)} ",
                      style: textTheme(context).text11.medium.text9094abColor,
                    ),
                    Container(
                      width: 18,
                      height: 18,
                      child: Image.asset(
                        DImages.nextNew,
                        color: getColor().text9094abColor,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      color: Colors.transparent,
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          _buildTitle(),
          model.items.length > 0 ? _buildList() : _buildListShimmer(),
        ],
      ),
    );
  }

  Widget _buildListShimmer() {
    return Container(
      width: double.infinity,
      height: heightItem + 5 * 2,
      child: ListView.separated(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        padding: EdgeInsets.only(
            left: Dimens.padding_left_right,
            right: Dimens.padding_left_right,
            top: Dimens.spacing5,
            bottom: Dimens.spacing5),
        itemBuilder: (BuildContext context, index) {
          return Shimmer.fromColors(
            baseColor: getColor().grayF1Color,
            highlightColor: getColor().gray2eaColor,
            child: Container(
              width: 157,
              height: heightItem,
              decoration: BoxDecoration(
                color: getColor().colorDivider,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, index) {
          return SizedBox(
            width: 10,
          );
        },
        itemCount: model.items.length,
      ),
    );
  }

  Widget _buildList() {
    return Container(
      width: double.infinity,
      height: heightItem + 5 * 2,
      child: ListView.separated(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        padding: EdgeInsets.only(
            left: Dimens.padding_left_right,
            right: Dimens.padding_left_right,
            top: Dimens.spacing5,
            bottom: Dimens.spacing5),
        itemBuilder: (BuildContext context, index) {
          return NewFeedItem(
            item: model.items[index],
            index: index,
            onItemClicked: widget.onItemClicked,
          );
        },
        separatorBuilder: (BuildContext context, index) {
          return SizedBox(
            width: 10,
          );
        },
        itemCount: model.items.length,
      ),
    );
  }
}
