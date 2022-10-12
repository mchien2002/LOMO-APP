import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:lomo/data/api/models/topic_item.dart';
import 'package:lomo/res/colors.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/discovery/list_discovery/list_more_topic/list_more_topic_screen.dart';
import 'package:lomo/ui/discovery/list_discovery/list_more_topic/my_list_more_topic_screen.dart';
import 'package:lomo/ui/discovery/list_discovery/list_topic_hot/list_topic_hot_model.dart';
import 'package:lomo/ui/widget/item_descovery/item_topic_hot_widget.dart';
import 'package:lomo/ui/widget/shimmer_widget.dart';

class ListTopicHotScreen extends StatefulWidget {
  final String title;
  final Future<List<TopictItem>> Function(int page, int pageSize) getData;
  final bool isViewMore;
  final Function? onViewMore;
  final Function(TopictItem)? onItemClicked;

  ListTopicHotScreen(
      {required this.title,
      required this.getData,
      this.isViewMore = true,
      this.onViewMore,
      this.onItemClicked});

  @override
  _ListTopicHotScreenState createState() => _ListTopicHotScreenState();
}

class _ListTopicHotScreenState
    extends BaseState<ListTopicHotModel, ListTopicHotScreen> {
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
  Widget buildContentView(BuildContext context, ListTopicHotModel model) {
    return model.items.isNotEmpty == true
        ? Column(
            children: [
              SizedBox(
                height: 30,
              ),
              _buildTitle(),
              SizedBox(
                height: Dimens.spacing12,
              ),
              _build(),
            ],
          )
        : SizedBox(
            height: 0,
          );
  }

  Widget _buildTitle() {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            widget.title,
            style: textTheme(context).text15.bold.colorDart,
          ),
          if (widget.isViewMore)
            InkWell(
              splashColor: DColors.transparentColor,
              onTap: () {
                if (widget.onViewMore != null) {
                  widget.onViewMore!();
                }
                // Navigator.pushNamed(
                //   context,
                //   Routes.moreTopicHot,
                //   arguments:
                //       ListMoreTopicArguments(widget.title, widget.getData),
                // );
                Navigator.pushNamed(context, Routes.myMoreTopcHot,
                    arguments:
                        MyListMoreTopicArguments(widget.title, widget.getData));
              },
              child: Container(
                padding: EdgeInsets.only(top: 2, bottom: 2, left: 5, right: 5),
                alignment: Alignment.center,
                child: Row(
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      Strings.viewMore.localize(context),
                      style: textTheme(context).text11.medium.colorGray99,
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
    );
  }

  Widget _build() {
    double width = (150 / 375) * (MediaQuery.of(context).size.width);
    return SizedBox(
      height: width * (88 / 150),
      child: model.items.isNotEmpty == true
          ? ListView.separated(
              padding: EdgeInsets.only(left: 16, right: 16),
              itemBuilder: (context, index) => ItemTopicHotWidget(
                    topic: model.items[index],
                    onItemClicked: widget.onItemClicked,
                  ),
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => SizedBox(
                    width: Dimens.size10,
                  ),
              itemCount: model.items.length)
          : ShimmerWidget(
              child: ListView.separated(
                  itemBuilder: (context, index) => Container(
                        height: width * (88 / 150),
                        padding: EdgeInsets.only(
                            left: Dimens.size10,
                            right: Dimens.size10,
                            bottom: Dimens.spacing16),
                        width: width,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(Dimens.spacing10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: width / 2,
                              height: Dimens.spacing14,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: Dimens.spacing5,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: Dimens.spacing16,
                                  height: Dimens.spacing16,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: Dimens.spacing5,
                                ),
                                Container(
                                  width: width / 3.0,
                                  height: Dimens.size12,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, indedevx) => SizedBox(
                        width: Dimens.size10,
                      ),
                  itemCount: 4),
            ),
    );
  }
}
