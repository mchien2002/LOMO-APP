import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lomo/data/api/models/event.dart';
import 'package:lomo/res/colors.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/base/base_grid_state.dart';
import 'package:lomo/ui/discovery/list_more_out_standing/list_more_out_standing_model.dart';
import 'package:lomo/ui/home/highlight/post_detail/post_detail_screen.dart';
import 'package:lomo/ui/webview/webview_screen.dart';
import 'package:lomo/ui/widget/image_widget.dart';
import 'package:lomo/util/date_time_utils.dart';

class ListMoreOutStandingScreen extends StatefulWidget {
  final ListMoreOutStandingScreenArgs args;
  ListMoreOutStandingScreen(this.args);
  @override
  _ListMoreOutStandingScreenState createState() => _ListMoreOutStandingScreenState();
}

class _ListMoreOutStandingScreenState
    extends BaseGridState<Event, ListMoreOutStandingModel, ListMoreOutStandingScreen> {
  late double itemWidth;
  late double itemHeight;
  late double itemImageHeight;

  @override
  EdgeInsets get paddingGrid => EdgeInsets.symmetric(horizontal: 16, vertical: 16);

  @override
  void initState() {
    super.initState();
    model.init(widget.args.getItems);
    model.loadData();
  }

  @override
  Widget build(BuildContext context) {
    itemWidth = (MediaQuery.of(context).size.width - 2 * 16 - 13) / 2;
    itemImageHeight = itemWidth * 96 / 165;
    itemHeight = itemImageHeight + 75;
    childAspectRatio = itemHeight / itemHeight;

    return Scaffold(
      backgroundColor: DColors.pinkF2F5,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: getColor().white,
        automaticallyImplyLeading: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: Text(
          widget.args.title,
          style: textTheme(context).text19.bold.colorDart,
        ),
        centerTitle: true,
        leading: InkWell(
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              width: 40,
              height: 40,
              child: Image.asset(DImages.calendar),
            ),
          )
        ],
      ),
      body: super.build(context),
    );
  }

  @override
  Widget buildItem(BuildContext context, Event item, int index) {
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
                borderRadius: BorderRadius.circular(Dimens.cornerRadius6),
                child: RoundNetworkImage(
                  width: itemWidth,
                  height: itemImageHeight,
                  url: item.image,
                  boxFit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    item.title?.localize(context) ?? "",
                    style: textTheme(context).text13.bold.colorDart,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Text(
                  item.expiryDate != null
                      ? "${Strings.to.localize(context)} ${getDayBySecond(item.expiryDate!)}"
                      : "",
                  style: textTheme(context).text11.ff85889c,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () async {
        if (item.link?.startsWith("postDetail:") == true) {
          showLoading();
          final postId = item.link!.replaceFirst("postDetail:", "");
          final newFeed = await model.getNewFeed(postId);
          hideLoading();
          if (newFeed != null)
            Navigator.pushNamed(context, Routes.postDetail, arguments: PostDetailAgrument(newFeed));
          else
            showError(model.errorMessage?.localize(context));
        } else
          Navigator.pushNamed(context, Routes.webView,
              arguments: WebViewArguments(url: item.link ?? ""));
      },
    );
  }

  double get mainAxisSpacing => Dimens.spacing13;

  double get crossAxisSpacing => Dimens.spacing13;

  EdgeInsets get padding => const EdgeInsets.symmetric(horizontal: Dimens.spacing16);

  @override
  bool get autoLoadData => false;
}

class ListMoreOutStandingScreenArgs {
  final String title;
  final Future<List<Event>> Function(int page, int pageSize)? getItems;
  ListMoreOutStandingScreenArgs(this.title, this.getItems);
}
