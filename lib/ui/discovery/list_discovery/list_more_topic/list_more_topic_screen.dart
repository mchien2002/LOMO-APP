import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lomo/data/api/models/filter_request_item.dart';
import 'package:lomo/data/api/models/topic_item.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/base/base_grid_state.dart';
import 'package:lomo/ui/discovery/list_type_discovery/list_type_discovery_screen.dart';
import 'package:lomo/ui/widget/image_widget.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/util/constants.dart';

import 'list_more_topic_model.dart';

class ListMoreTopicArguments {
  final Future<List<TopictItem>> Function(int page, int pageSize) getData;
  final String title;
  ListMoreTopicArguments(this.title, this.getData);
}

class ListMoreTopicScreen extends StatefulWidget {
  final ListMoreTopicArguments args;
  ListMoreTopicScreen(this.args);
  @override
  _ListMoreTopicScreenState createState() => _ListMoreTopicScreenState();
}

class _ListMoreTopicScreenState
    extends BaseGridState<TopictItem, ListMoreTopicModel, ListMoreTopicScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getColor().pinkF2F5Color,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0,
        backgroundColor: getColor().white,
        automaticallyImplyLeading: false,
        title: Text(
          widget.args.title.localize(context),
          style: textTheme(context).text19.bold.colorDart,
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Image.asset(
              DImages.backBlack,
              color: getColor().colorDart,
            ),
          ),
        ),
      ),
      body: buildContent(),
    );
  }

  @override
  void initState() {
    super.initState();
    model.init(widget.args.getData);
    model.loadData();
  }

  @override
  Widget buildItem(BuildContext context, TopictItem item, int index) {
    double widthItem = (MediaQuery.of(context).size.width - 2 * 16 - 11) / 2;
    double heightItem = widthItem * childAspectRatio;
    return InkWell(
      onTap: () {
        final dataFilter = (item.id == KnowledgeTopicId.official ||
                item.id == KnowledgeTopicId.others)
            ? FilterRequestItem(key: "knowledge", value: item.id)
            : FilterRequestItem(key: "topics", value: item.id);
        var argument = TypeDiscoverAgrument(item.name ?? "", [dataFilter]);
        Navigator.pushNamed(context, Routes.typeDiscovery, arguments: argument);
      },
      child: Container(
        height: heightItem,
        width: widthItem,
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
                      item.imageLocal!,
                      height: heightItem,
                      width: widthItem,
                    ),
                  )
                : RoundNetworkImage(
                    height: heightItem,
                    width: widthItem,
                    url: item.image ?? '',
                    radius: Dimens.spacing8,
                    boxFit: BoxFit.cover,
                  ),
            ClipRRect(
              borderRadius: BorderRadius.circular(Dimens.spacing8),
              child: Image.asset(
                DImages.knowledgeGradient,
                height: heightItem,
                width: widthItem,
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
                    item.name?.localize(context) ?? "",
                    overflow: TextOverflow.ellipsis,
                    style: textTheme(context).text15.bold.colorWhite,
                    maxLines: 1,
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

  @override
  double get childAspectRatio => 166 / 97;

  @override
  bool get autoLoadData => false;

  double get mainAxisSpacing => 11;

  double get crossAxisSpacing => 11;

  @override
  EdgeInsets get paddingGrid =>
      EdgeInsets.symmetric(horizontal: 16, vertical: 16);
}
