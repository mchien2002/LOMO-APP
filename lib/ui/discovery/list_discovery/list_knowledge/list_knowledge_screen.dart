import 'package:flutter/material.dart';

import '../../../../data/api/models/filter_request_item.dart';
import '../../../../data/api/models/topic_item.dart';
import '../../../../data/tracking/tracking_manager.dart';
import '../../../../di/locator.dart';
import '../../../../res/dimens.dart';
import '../../../../res/images.dart';
import '../../../../res/theme/text_theme.dart';
import '../../../../res/theme/theme_manager.dart';
import '../../../../res/values.dart';
import '../../../../util/constants.dart';
import '../../../base/base_state.dart';
import '../../../widget/image_widget.dart';
import '../../../widget/shimmer_widget.dart';
import '../../list_type_discovery/list_type_discovery_screen.dart';
import 'list_knowledge_model.dart';

class ListKnowledgeScreen extends StatefulWidget {
  const ListKnowledgeScreen({
    Key? key,
    required this.title,
    required this.getData,
  }) : super(key: key);

  final String title;
  final Future<List<TopictItem>> Function(int page, int pageSize) getData;

  @override
  _ListKnowledgeScreenState createState() => _ListKnowledgeScreenState();
}

class _ListKnowledgeScreenState
    extends BaseState<ListKnowledgeModel, ListKnowledgeScreen> {
  @override
  void initState() {
    super.initState();
    model.init(widget.getData);
  }

  @override
  Widget build(BuildContext context) {
    return buildContent();
  }

  itemList({required BuildContext context, required TopictItem item}) {
    double width = (MediaQuery.of(context).size.width - 45) / 2;
    double height = width * (96 / 165);
    return InkWell(
      onTap: () {
        final dataFilter = (item.id == KnowledgeTopicId.official ||
                item.id == KnowledgeTopicId.others)
            ? FilterRequestItem(key: "knowledge", value: item.id)
            : FilterRequestItem(key: "topics", value: item.id);
        var argument = TypeDiscoverAgrument("${item.name}", [dataFilter]);
        Navigator.pushNamed(context, Routes.typeDiscovery, arguments: argument);
        locator<TrackingManager>().trackKnowledge();
      },
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: getColor().black4B,
          borderRadius: BorderRadius.all(Radius.circular(Dimens.spacing10)),
        ),
        child: Stack(
          children: [
            item.imageLocal != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(Dimens.spacing8),
                    child: Image.asset(
                      "${item.imageLocal}",
                      height: height,
                      width: width,
                      fit: BoxFit.cover,
                    ),
                  )
                : RoundNetworkImage(
                    height: height,
                    width: width,
                    url: item.image ?? '',
                    radius: Dimens.spacing8,
                    boxFit: BoxFit.contain,
                  ),
            ClipRRect(
              borderRadius: BorderRadius.circular(Dimens.spacing8),
              child: Image.asset(
                DImages.knowledgeGradient,
                height: height,
                width: width,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: Dimens.size10,
                  right: Dimens.size10,
                  bottom: Dimens.size12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${item.name}",
                    overflow: TextOverflow.ellipsis,
                    style: textTheme(context).text13.bold.colorWhite,
                    maxLines: 1,
                  ),
                  SizedBox(
                    height: Dimens.spacing5,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        DImages.topicHot,
                        color: getColor().white,
                        width: Dimens.spacing16,
                        height: Dimens.spacing16,
                      ),
                      Text(
                        '${item.numberOfPost != null ? item.numberOfPost : 0}',
                        style: textTheme(context).text11.colorWhite,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
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
        ],
      ),
    );
  }

  @override
  Widget buildContentView(BuildContext context, model) {
    double width = (MediaQuery.of(context).size.width - 45) / 2;
    double height = width * (96 / 165);
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
              listBody(width, height),
            ],
          )
        : SizedBox(
            height: 0,
          );
  }

  listBody(double width, double height) {
    return SizedBox(
      height: height,
      child: model.items.isNotEmpty == true
          ? ListView.separated(
              padding: EdgeInsets.only(left: 16, right: 16),
              itemBuilder: (context, index) =>
                  itemList(context: context, item: model.items[index]),
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => SizedBox(
                    width: 13,
                  ),
              itemCount: model.items.length)
          : ShimmerWidget(
              child: ListView.separated(
                  itemBuilder: (context, index) => Container(
                        height: height,
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
