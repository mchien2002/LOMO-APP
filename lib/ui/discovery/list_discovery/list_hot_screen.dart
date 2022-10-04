import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/discovery/list_discovery/list_hot_model.dart';
import 'package:lomo/ui/discovery/list_discovery/list_more_hot/list_more_hot_screen.dart';
import 'package:lomo/ui/widget/item_descovery/item_user_hot_widget.dart';
import 'package:shimmer/shimmer.dart';

import '../../widget/item_descovery/item_list_user_hot.dart';
import '../../widget/loading_widget.dart';

class ListHotScreen extends StatefulWidget {
  final String title;
  final Future<List<User>> Function(int page, int pageSize) getData;
  final Function? onViewMore;
  final Function(User)? onItemClicked;
  final ListUserSubTitleType? subTitleType;
  final ValueNotifier<Object>? onRefresh;
  final Widget? noDataWidget;

  ListHotScreen({
    required this.title,
    required this.getData,
    this.onViewMore,
    this.onItemClicked,
    this.subTitleType = ListUserSubTitleType.bear,
    this.onRefresh,
    this.noDataWidget,
  });

  @override
  _ListHotScreenState createState() => _ListHotScreenState();
}

class _ListHotScreenState extends BaseState<ListHotModel, ListHotScreen> {
  late double widthItem = 150;
  late double heightItem = 180;

  @override
  Widget build(BuildContext context) {
    return buildContent();
  }

  @override
  void initState() {
    super.initState();
    model.setLoading(widget.noDataWidget != null);
    model.init(widget.getData);
    widget.onRefresh?.addListener(() {
      model.getListUser();
    });
  }

  Widget get buildLoadingView => SizedBox(
        height: heightItem,
        child: Center(child: LoadingWidget()),
      );

  @override
  Widget buildContentView(BuildContext context, ListHotModel model) {
    return Container(
      color: Colors.transparent,
      child: _buildContent(),
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
          model.items.length > 0
              ? _buildList()
              : widget.noDataWidget ?? _buildListShimmer(),
        ],
      ),
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
                  Routes.moreHot,
                  arguments: ListMoreHotScreenArguments(
                      widget.getData, widget.title,
                      subTitleType: widget.subTitleType),
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
              width: widthItem,
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
      height: heightItem + Dimens.spacing5 * 2,
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
          return ItemUserHot(
            user: model.items[index],
            index: index,
            subTitleType: widget.subTitleType,
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
