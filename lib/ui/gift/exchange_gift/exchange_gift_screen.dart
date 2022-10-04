import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:lomo/data/api/models/gift.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/gift/exchange_gift/exchange_gift_model.dart';
import 'package:lomo/ui/gift/send_information_gift/send_information_gift_screen.dart';
import 'package:lomo/ui/widget/bottom_sheet_widgets.dart';
import 'package:lomo/ui/widget/button_widgets.dart';
import 'package:lomo/ui/widget/dialog_widget.dart';
import 'package:lomo/ui/widget/image_widget.dart';
import 'package:lomo/util/common_utils.dart';
import 'package:lomo/util/handle_link_util.dart';

import '../../../data/tracking/tracking_manager.dart';
import '../../../util/constants.dart';

class ExchangeGiftScreen extends StatefulWidget {
  final Gift gift;

  ExchangeGiftScreen({required this.gift});

  @override
  _ExchangeGiftScreenState createState() => _ExchangeGiftScreenState();
}

class _ExchangeGiftScreenState
    extends BaseState<ExchangeGiftModel, ExchangeGiftScreen> {
  @override
  Widget build(BuildContext context) {
    return buildContent();
  }

  @override
  void initState() {
    super.initState();
    model.init();
    locator<TrackingManager>().trackGiftDetail(widget.gift.id);
  }

  @override
  Widget buildContentView(BuildContext context, ExchangeGiftModel model) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        Container(
          child: SliverAppBar(
            leading: InkWell(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(
                  DImages.backWhite,
                  width: 16,
                  height: 16,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              BottomSheetMenuWidget(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Image.asset(
                      DImages.menuWhite,
                      width: 32,
                      height: 32,
                    ),
                  ),
                  items: ExchangeGiftMenu.values
                      .map((e) => e.name.localize(context))
                      .toList(),
                  onItemClicked: (index) {
                    switch (ExchangeGiftMenu.values.toList()[index]) {
                      case ExchangeGiftMenu.share:
                        if (widget.gift.id != null) {
                          locator<HandleLinkUtil>().shareGift(widget.gift.id!);
                        }
                        break;
                      case ExchangeGiftMenu.cancel:
                        break;
                    }
                  })
            ],
            pinned: true,
            floating: true,
            snap: true,
            expandedHeight: size.width / (375.0 / 320) - 56,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment(0.5, 0),
                      end: Alignment(0.5, 1),
                      colors: [
                    const Color(0x00000000),
                    const Color(0x99000000),
                  ])),
              child: RoundNetworkImage(
                height: size.width / (375.0 / 320),
                width: double.infinity,
                url: widget.gift.image,
                boxFit: BoxFit.fill,
                radius: 0,
              ),
            ),
          ),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          SizedBox(
            height: Dimens.size20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              widget.gift.title!,
              style: textTheme(context).text18.bold.colorDart,
            ),
          ),
          SizedBox(
            height: Dimens.size10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                RichText(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(children: [
                      TextSpan(
                        text:
                            "${(widget.gift.promotion != 0 && widget.gift.promotion != null) ? formatNumberDivThousand(widget.gift.promotion!) : formatNumberDivThousand(widget.gift.price!)}",
                        style: textTheme(context).text16.semiBold.colorVioletFB,
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
                  width: Dimens.size10,
                ),
                if (widget.gift.price != widget.gift.promotion)
                  Expanded(
                    child: RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(children: [
                        TextSpan(
                          text:
                              "${formatNumberDivThousand(widget.gift.price!)}",
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
          ),
          SizedBox(
            height: Dimens.size20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: HtmlWidget(
              widget.gift.description!,
              textStyle: textTheme(context).text14Normal.colorDart,
            ),
          ),
          SizedBox(
            height: Dimens.size30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: PrimaryButton(
              text: Strings.bonusRedemption.localize(context),
              onPressed: () async {
                exchangeGift();
              },
            ),
          ),
          SizedBox(
            height: Dimens.size50,
          ),
        ]))
      ],
    ));
  }

  exchangeGift() {
    // _exchangeGift();
    var price = (widget.gift.promotion != null && widget.gift.promotion != 0)
        ? widget.gift.promotion
        : widget.gift.price;
    if (price! > model.user.numberOfCandy!) {
      showDialog(
        context: context,
        builder: (context) => TwoButtonDialogWidget(
          title: Strings.notEnoughCandy.localize(context),
          description: Strings.pleaseGetMoreCandy.localize(context),
        ),
      );
    } else {
      if (widget.gift.type?.id == GiftTypeId.voucher) {
        callApi(callApiTask: () async {
          await model.getExchangeGift(widget.gift.id!, price);
        }, onSuccess: () {
          locator<TrackingManager>().trackRewardExchange();
          showDialog(
            context: context,
            builder: (context) => OneButtonDialogWidget(
              title: Strings.voucher.localize(context),
              description: Strings.exchange_voucher_success.localize(context),
              textConfirm: Strings.done.localize(context),
              onConfirmed: () {
                Navigator.pop(context);
              },
            ),
          );
        });
      } else {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) {
              return SendInformationGiftScreen(gift: widget.gift);
            });
      }
    }
  }
}

enum ExchangeGiftMenu { share, cancel }

extension ExchangeGiftMenuExt on ExchangeGiftMenu {
  String get name {
    switch (this) {
      case ExchangeGiftMenu.share:
        return Strings.share;
      case ExchangeGiftMenu.cancel:
        return Strings.close;
    }
  }
}
