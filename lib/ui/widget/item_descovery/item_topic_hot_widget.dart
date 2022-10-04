import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/filter_request_item.dart';
import 'package:lomo/data/api/models/topic_item.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/discovery/list_type_discovery/list_type_discovery_screen.dart';
import 'package:lomo/ui/widget/image_widget.dart';
import 'package:lomo/util/constants.dart';

class ItemTopicHotWidget extends StatelessWidget {
  final TopictItem topic;
  final Function(TopictItem)? onItemClicked;

  ItemTopicHotWidget({required this.topic, this.onItemClicked});

  @override
  Widget build(BuildContext context) {
    double width = (150 / 375) * (MediaQuery.of(context).size.width);
    double height = width * (88 / 150);
    return InkWell(
      onTap: () {
        if (onItemClicked != null) {
          onItemClicked!(topic);
        }
        final dataFilter = (topic.id == KnowledgeTopicId.official ||
                topic.id == KnowledgeTopicId.others)
            ? FilterRequestItem(key: "knowledge", value: topic.id)
            : FilterRequestItem(key: "topics", value: topic.id);
        var argument = TypeDiscoverAgrument(topic.name!, [dataFilter]);
        Navigator.pushNamed(context, Routes.typeDiscovery, arguments: argument);
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
            topic.imageLocal != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(Dimens.spacing8),
                    child: Image.asset(
                      topic.imageLocal!,
                      height: height,
                      width: width,
                    ),
                  )
                : RoundNetworkImage(
                    height: height,
                    width: width,
                    url: topic.image ?? '',
                    radius: Dimens.spacing8,
                    boxFit: BoxFit.cover,
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
                    topic.name!.localize(context),
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
                        '${topic.numberOfPost != null ? topic.numberOfPost : 0}',
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
}
