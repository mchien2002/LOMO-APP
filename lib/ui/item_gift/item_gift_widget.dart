import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/gift.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/widget/image_widget.dart';
import 'package:lomo/util/common_utils.dart';

class ItemGiftWidget extends StatelessWidget {
  const ItemGiftWidget({required this.item, required this.onItemClicked});

  final Function(Gift)? onItemClicked;
  final Gift item;

  @override
  Widget build(BuildContext context) {
    double width = 150;
    // double width = (150 / 375) * (MediaQuery.of(context).size.width);
    double height = width * (225 / 150);
    return InkWell(
      splashColor: Colors.transparent,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: getColor().white,
          borderRadius: BorderRadius.all(Radius.circular(Dimens.spacing10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(Dimens.cornerRadius10)),
              child: RoundNetworkImage(
                width: width,
                height: width,
                url: item.image,
                boxFit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Text(
                    item.title!.localize(context),
                    style: textTheme(context).text13.bold.colorDart,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Row(
                children: [
                  RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(children: [
                        WidgetSpan(
                          child: Image.asset(
                            DImages.candy,
                            color: getColor().violetFBColor,
                            width: 17,
                            height: 17,
                          ),
                        ),
                        TextSpan(
                          text:
                              "${(item.promotion != 0 && item.promotion != null) ? formatNumberDivThousand(item.promotion!) : formatNumberDivThousand(item.price!)}",
                          style:
                              textTheme(context).text14.semiBold.colorVioletFB,
                        ),
                      ])),
                  SizedBox(
                    width: 7,
                  ),
                  if (item.price != item.promotion)
                    Expanded(
                      child: RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(children: [
                          WidgetSpan(
                            child: Image.asset(
                              DImages.candy,
                              color: getColor().unSelectedTabBar,
                              width: 16,
                              height: 16,
                            ),
                          ),
                          TextSpan(
                            text: "${formatNumberDivThousand(item.price!)}",
                            style: textTheme(context)
                                .text14Normal
                                .colorGray99
                                .copyWith(
                                    decoration: TextDecoration.lineThrough),
                          ),
                        ]),
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, Routes.exchangeGiftScreen,
            arguments: item);
      },
    );
  }
}
