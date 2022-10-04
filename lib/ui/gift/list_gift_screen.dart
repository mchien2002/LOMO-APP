import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/gift.dart';
import 'package:lomo/data/repositories/common_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/base/base_grid_state.dart';
import 'package:lomo/ui/widget/image_widget.dart';
import 'package:lomo/util/common_utils.dart';
import 'package:provider/provider.dart';

import 'list_gift_model.dart';
import 'list_more_gift_screen.dart';

class ListGiftScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ListGiftScreenState();
}

class _ListGiftScreenState extends BaseGridState<Gift, ListGiftModel, ListGiftScreen> {
  late double itemWidth;
  late double itemHeight;

  @override
  bool get shrinkWrap => true;

  @override
  ScrollPhysics get scrollPhysics => NeverScrollableScrollPhysics();

  @override
  EdgeInsets get paddingGrid => EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 10);

  @override
  void initState() {
    super.initState();
    model.isHot = false;
    loadDataDelay();
  }

  loadDataDelay() async {
    await Future.delayed(Duration(milliseconds: 300));
    model.loadData();
  }

  @override
  bool get autoLoadData => false;

  @override
  Widget build(BuildContext context) {
    itemWidth = (MediaQuery.of(context).size.width - 3 * Dimens.spacing15) / 2;
    itemHeight = itemWidth + 75;
    childAspectRatio = itemWidth / itemHeight;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin:
              EdgeInsets.only(left: Dimens.padding_left_right, right: Dimens.padding_left_right),
          height: 44,
          child: Row(
            children: <Widget>[
              Container(
                width: 44,
                height: 44,
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: getColor().pink.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Image.asset(
                  DImages.iconExGifts,
                  height: 32,
                  width: 32,
                ),
                alignment: Alignment.center,
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: Text(
                  Strings.exchangeGifts.localize(context),
                  style: textTheme(context).text16Bold.colorDart,
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 2, bottom: 2, left: 10, right: 5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: getColor().backgroundSearch,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.gift,
                        arguments: GiftScreenArgs(
                            Strings.giftTitle.localize(context),
                            (page, pageSize) async => locator<CommonRepository>().getGifts(
                                  page,
                                  pageSize,
                                )));
                  },
                  child: Row(
                    children: [
                      Text(
                        Strings.all.localize(context),
                        style: textTheme(context).text12.bold.colorGrayTime,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: getColor().textHint,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        ChangeNotifierProvider.value(
          value: model,
          child: Consumer<ListGiftModel>(
            builder: (context, model, child) {
              final height = model.items.isNotEmpty == true
                  ? (itemHeight + mainAxisSpacing) * (model.items.length ~/ crossAxisCount)
                  : 0.0;
              return SizedBox(
                child: super.build(context),
                height: height,
              );
            },
          ),
        ),
      ],
    );
  }

  double heightContent = 0;

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
