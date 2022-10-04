import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lomo/data/api/models/notification_item.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/notification/notification_voucher_detail/notification_voucher_detail_model.dart';
import 'package:lomo/ui/widget/dotter_borer_widget.dart';
import 'package:lomo/ui/widget/html_view_widget.dart';
import 'package:lomo/ui/widget/image_widget.dart';
import 'package:lomo/util/common_utils.dart';

class NotificationVoucherDetailScreen extends StatefulWidget {
  final NotificationItem notification;

  NotificationVoucherDetailScreen(this.notification);

  @override
  State<StatefulWidget> createState() =>
      _NotificationVoucherDetailScreenState();
}

class _NotificationVoucherDetailScreenState extends BaseState<
    NotificationVoucherDetailModel, NotificationVoucherDetailScreen> {
  @override
  void initState() {
    super.initState();
    model.init(widget.notification.gift);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: super.buildContent(),
    );
  }

  // voucher la field code trong otp

  @override
  Widget buildContentView(
      BuildContext context, NotificationVoucherDetailModel model) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildContent(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: getColor().white,
      elevation: 0,
      leading: Padding(
        padding: EdgeInsets.only(left: 16),
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset(
            DImages.closex,
            width: 32,
            height: 32,
          ),
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildContent(BuildContext context) {
    double widthItemIg = (220 / 375) * MediaQuery.of(context).size.width;
    double heightItemIg = widthItemIg * (183 / 220);
    String? dataCode = widget.notification.opt?.code;
    return SingleChildScrollView(
        child: Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          SizedBox(
            height: 0,
          ),
          ClipRRect(
            child: RoundNetworkImage(
              width: widthItemIg,
              height: heightItemIg,
              url: widget.notification.opt?.image,
              boxFit: BoxFit.contain,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            Strings.voucher_success.localize(context),
            style: textTheme(context).text18Bold.colorBlack00,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            Strings.voucher_check_info_please.localize(context),
            style: textTheme(context).text16.colorBlack00,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            Strings.voucher_your_code.localize(context),
            style: textTheme(context).text14Bold.colorBlack00,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 15,
          ),
          DotterBoderWidget(
            onPress: () {
              if (dataCode?.isNotEmpty == true) {
                Clipboard.setData(ClipboardData(text: "$dataCode")).then((_) {
                  showToast(Strings.copySuccess.localize(context));
                });
              }
            },
            data: "$dataCode".toUpperCase(),
          ),
          SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                Strings.title_detail_voucher.localize(context),
                style: textTheme(context).text14Bold.colorBlack00,
                textAlign: TextAlign.left,
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          HtmlView(
            htmlData: model.itemGift.infoVoucher,
            textStyle: textTheme(context).text14Normal.colorDart,
          ),
          SizedBox(
            height: 30,
          ),
          // SizedBox(
          //   height: 40,
          // ),
          // Text(
          //   Strings.voucher_your_code.localize(context),
          //   style: textTheme(context).text14Bold.colorBlack00,
          //   textAlign: TextAlign.left,
          // ),
          // SizedBox(
          //   height: 15,
          // ),
          // HtmlWidget(
          //   model.itemGift?.description ?? "",
          //   textStyle: textTheme(context).text14Normal.colorDart,
          // ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    ));
  }
}
