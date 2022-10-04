import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/notification_item.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/notification/notification_detail/notification_detail_model.dart';
import 'package:lomo/ui/widget/html_view_widget.dart';
import 'package:lomo/ui/widget/image_widget.dart';
import 'package:lomo/util/date_time_utils.dart';

class NotificationDetailScreen extends StatefulWidget {
  final NotificationItem notification;
  NotificationDetailScreen(this.notification);

  @override
  State<StatefulWidget> createState() => _NotificationDetailScreenState();
}

class _NotificationDetailScreenState extends BaseState<NotificationDetailModel, NotificationDetailScreen> {
  double ratioCover = 375 / 260;
  @override
  void initState() {
    super.initState();
    model.init(widget.notification);
  }

  @override
  Widget buildContentView(BuildContext context, NotificationDetailModel model) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                RoundNetworkImage(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.width / ratioCover,
                  url: model.notification.cover,
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    model.notification.title ?? "",
                    style: textTheme(context).text19.bold.darkTextColor,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Text(
                    readTimeStampByDayHourSpecial(model.notification.createdAt!),
                    style: textTheme(context).text13.colorGrayTime,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: HtmlViewContent(
                    content: model.notification.content ?? "",
                    isShowContentLink: false,
                    isViewMore: true,
                  ),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: Dimens.size16, top: kToolbarHeight),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset(
                DImages.backBlack,
                height: Dimens.size32,
                width: Dimens.size32,
              ),
            ),
          )
        ],
      ),
    );
  }
}
