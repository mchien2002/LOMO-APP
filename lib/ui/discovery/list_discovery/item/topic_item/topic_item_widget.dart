import 'package:flutter/material.dart';

import '../../../../../data/api/models/topic_item.dart';
import '../../../../../res/dimens.dart';
import '../../../../../res/images.dart';
import '../../../../../res/theme/text_theme.dart';
import '../../../../../res/theme/theme_manager.dart';
import '../../../../widget/image_widget.dart';

class TopicItemWidget extends StatefulWidget {
  const TopicItemWidget(
      {Key? key,
      required this.item,
      required this.paddingC,
      required this.spaceItem,
      required this.childAspectRatio})
      : super(key: key);
  final TopictItem item;
  final double paddingC;
  final double spaceItem;
  final double childAspectRatio;

  @override
  State<TopicItemWidget> createState() => _TopicItemWidgetState();
}

class _TopicItemWidgetState extends State<TopicItemWidget> {
  @override
  Widget build(BuildContext context) {
    double widthItem = (MediaQuery.of(context).size.width -
            2 * widget.paddingC -
            widget.spaceItem) /
        2;
    double heightItem = widthItem * widget.childAspectRatio;
    return InkWell(
        onTap: () {},
        child: Container(
          height: heightItem,
          width: widthItem,
          decoration: BoxDecoration(
              color: getColor().black4B,
              borderRadius: BorderRadius.circular(Dimens.spacing10)),
          child: Stack(
            children: [
              widget.item.imageLocal != null
                  ? ClipRRect(
                      child: Image.asset(
                        widget.item.imageLocal!,
                        height: heightItem,
                        width: widthItem,
                      ),
                    )
                  : RoundNetworkImage(
                      height: heightItem,
                      width: widthItem,
                      url: widget.item.image ?? '',
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
                padding: EdgeInsets.only(
                    left: Dimens.size10,
                    right: Dimens.size10,
                    bottom: Dimens.size12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.name ?? " ",
                      overflow: TextOverflow.ellipsis,
                      style: textTheme(context).text15.bold.colorWhite,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          DImages.topicHot,
                          height: Dimens.spacing16,
                          width: Dimens.spacing16,
                        ),
                        Text(
                          widget.item.numberOfPost.toString(),
                          style: textTheme(context).text10.bold.colorWhite,
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
