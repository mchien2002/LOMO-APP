import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/gift.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/base/base_grid_state.dart';
import 'package:lomo/ui/gift/list_more_gift_model.dart';
import 'package:lomo/ui/widget/image_widget.dart';
import 'package:lomo/util/common_utils.dart';

class GiftScreen extends StatefulWidget {
  final GiftScreenArgs args;

  GiftScreen(this.args);

  @override
  State<StatefulWidget> createState() => _GiftScreenState();
}

class _GiftScreenState extends BaseGridState<Gift, ListMoreGiftModel, GiftScreen> {
  late double itemWidth;
  late double itemHeight;

  @override
  void initState() {
    super.initState();
    model.init(widget.args.getData);
    model.loadData();
  }

  @override
  EdgeInsets get paddingGrid => EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 10);

  @override
  Widget build(BuildContext context) {
    itemWidth = (MediaQuery.of(context).size.width - 3 * Dimens.spacing15) / 2;
    itemHeight = itemWidth + 75;
    childAspectRatio = itemWidth / itemHeight;
    print(itemHeight - itemWidth);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: getColor().white,
        automaticallyImplyLeading: false,
        title: Text(
          widget.args.title,
          style: textTheme(context).text18Bold.colorDart,
        ),
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_ios,
            size: 24,
            color: getColor().colorDart,
          ),
        ),
      ),
      body: super.build(context),
    );
  }

  @override
  Widget buildItem(BuildContext context, Gift item, int index) {
    return InkWell(
      splashColor: Colors.transparent,
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(Dimens.cornerRadius10),
        child: SizedBox(
          height: itemHeight,
          width: itemWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(Dimens.cornerRadius10)),
                child: RoundNetworkImage(
                  width: itemWidth + 10,
                  height: itemWidth,
                  url: item.image,
                  boxFit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 5),
                    child: Text(
                      item.title!.localize(context),
                      style: textTheme(context).text12.bold.colorDart,
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
                          TextSpan(
                            text:
                                "${(item.promotion != 0 && item.promotion != null) ? formatNumberDivThousand(item.promotion!) : formatNumberDivThousand(item.price!)}",
                            style: textTheme(context).text15.semiBold.colorVioletFB,
                          ),
                          WidgetSpan(
                            child: Image.asset(
                              DImages.candy,
                              color: getColor().violetFBColor,
                              width: 17,
                              height: 17,
                            ),
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
                            TextSpan(
                              text: "${formatNumberDivThousand(item.price!)}",
                              style: textTheme(context)
                                  .text14Normal
                                  .semiBold
                                  .colorGray99
                                  .copyWith(decoration: TextDecoration.lineThrough),
                            ),
                            WidgetSpan(
                              child: Image.asset(
                                DImages.candy,
                                color: getColor().unSelectedTabBar,
                                width: 16,
                                height: 16,
                              ),
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
      ),
      onTap: () {
        Navigator.pushNamed(context, Routes.exchangeGiftScreen, arguments: item);
      },
    );
  }

  double get mainAxisSpacing => Dimens.spacing15;

  double get crossAxisSpacing => Dimens.spacing15;

  EdgeInsets get padding => const EdgeInsets.symmetric(horizontal: Dimens.spacing15);
}

class GiftScreenArgs {
  final String title;
  final Future<List<Gift>> Function(int page, int pageSize) getData;
  GiftScreenArgs(this.title, this.getData);
}
