import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/filter_request_item.dart';
import 'package:lomo/data/api/models/topic_item.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/discovery/list_type_discovery/list_type_discovery_screen.dart';
import 'package:lomo/ui/widget/image_widget.dart';
import 'package:lomo/util/constants.dart';

class SearchThemItem extends StatelessWidget {
  final TopictItem topic;
  final Function? onPressed;

  const SearchThemItem({
    required this.topic,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onPressed != null) {
          onPressed!();
        }
        final dataFilter = (topic.id == KnowledgeTopicId.official ||
                topic.id == KnowledgeTopicId.others)
            ? FilterRequestItem(key: "knowledge", value: topic.id)
            : FilterRequestItem(key: "topics", value: topic.id);
        var argument = TypeDiscoverAgrument(topic.name ?? "", [dataFilter]);
        Navigator.pushNamed(context, Routes.typeDiscovery, arguments: argument);
      },
      child: Container(
        height: Dimens.size56,
        child: Row(
          children: [
            SizedBox(
              width: Dimens.size16,
            ),
            RoundNetworkImage(
              width: Dimens.size32,
              height: Dimens.size32,
              url: topic.image,
              radius: 4,
            ),
            SizedBox(
              width: Dimens.size10,
            ),
            Expanded(
              child: Text(
                topic.name!,
                style: textTheme(context).text15.medium.darkTextColor,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "${topic.numberOfPost}" + " " + Strings.posts.localize(context),
              style: textTheme(context).text13.gray77,
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: Dimens.size16,
            ),
          ],
        ),
      ),
    );
  }
}
