import 'package:flutter/material.dart';
import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/data/api/models/event.dart';
import 'package:lomo/data/eventbus/refresh_discovery_list_event.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/widget/image_widget.dart';
import 'package:lomo/ui/widget/shimmer_widget.dart';
import 'package:lomo/util/date_time_utils.dart';
import 'package:lomo/util/handle_link_util.dart';

import 'list_more_out_standing/list_more_out_standing_screen.dart';
import 'out_standing_event_model.dart';

class OutStandingEvent extends StatefulWidget {
  final String title;
  final Future<List<Event>> Function(int page, int pageSize)? getData;
  OutStandingEvent({required this.title, required this.getData});
  @override
  State<StatefulWidget> createState() => _OutStandingEventState();
}

class _OutStandingEventState extends BaseState<OutStandingEventModel, OutStandingEvent>
    with AutomaticKeepAliveClientMixin {
  late double itemWidth;
  late double itemHeight;
  late double itemImageHeight;

  @override
  void initState() {
    super.initState();
    eventBus.on<RefreshDiscoveryListEvent>().listen((event) async {
      await model.getEvents();
    });
    model.init(widget.getData);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return buildContent();
  }

  Widget _buildTitle() {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            widget.title,
            style: textTheme(context).text15.bold.colorDart,
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, Routes.outStanding,
                  arguments: ListMoreOutStandingScreenArgs(widget.title, widget.getData));
            },
            child: Container(
              padding: EdgeInsets.only(top: 2, bottom: 2, left: 5, right: 5),
              alignment: Alignment.center,
              child: Row(
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    Strings.viewMore.localize(context),
                    style: textTheme(context).text11.medium.text9094abColor,
                  ),
                  Container(
                    width: 18,
                    height: 18,
                    child: Image.asset(
                      DImages.nextNew,
                      color: getColor().text9094abColor,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      color: getColor().transparent,
      height: itemHeight + 8,
      padding: EdgeInsets.symmetric(vertical: 4),
      alignment: Alignment.center,
      child: model.events?.isNotEmpty == true ? _buildEvents() : _buildNoDataContent(),
    );
  }

  Widget _buildEvents() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(left: 16, right: 16),
      itemCount: model.events?.length ?? 0,
      itemBuilder: (context, index) => InkWell(
        splashColor: Colors.transparent,
        child: Container(
          height: itemHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimens.cornerRadius6),
            color: getColor().white,
            boxShadow: [
              BoxShadow(
                color: Color(0x338a5adf),
                offset: Offset(0, 0),
                blurRadius: 2,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(Dimens.cornerRadius6)),
                child: RoundNetworkImage(
                  width: itemWidth,
                  height: itemImageHeight,
                  url: model.events?[index].image,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  model.events?[index].title?.localize(context) ?? "",
                  style: textTheme(context).text13.bold.colorDart,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "${Strings.to.localize(context)} ${getDayBySecond(model.events![index].expiryDate!)}",
                  style: textTheme(context).text11.ff85889c,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ),
        onTap: () async {
          locator<HandleLinkUtil>()
              .openLinkDiscoveryEvent(model.events?[index].link, context, this);
        },
      ),
      separatorBuilder: (BuildContext context, int index) => SizedBox(
        width: 10,
      ),
    );
  }

  Widget _buildNoDataContent() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(left: 16),
      itemCount: 2,
      itemBuilder: (context, index) => Container(
        height: itemHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimens.cornerRadius6),
          color: getColor().white,
          boxShadow: [
            BoxShadow(
              color: Color(0x338a5adf),
              offset: Offset(0, 0),
              blurRadius: 2,
              spreadRadius: 0,
            ),
          ],
        ),
        child: ShimmerWidget(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(Dimens.cornerRadius6)),
                    color: getColor().grayBorder),
                width: itemWidth,
                height: itemImageHeight,
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  height: 18,
                  width: 150,
                  color: getColor().grayBorder,
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  height: 14,
                  width: 100,
                  color: getColor().grayBorder,
                ),
              )
            ],
          ),
        ),
      ),
      separatorBuilder: (BuildContext context, int index) => SizedBox(
        width: 10,
      ),
    );
  }

  @override
  Widget buildContentView(BuildContext context, OutStandingEventModel model) {
    itemWidth = MediaQuery.of(context).size.width * 205 / 375;
    itemImageHeight = itemWidth * 120 / 205;
    itemHeight = itemImageHeight + 70;
    return model.events?.isNotEmpty == true
        ? Column(
            children: [
              SizedBox(
                height: 30,
              ),
              _buildTitle(),
              SizedBox(
                height: 14,
              ),
              _buildContent(),
            ],
          )
        : SizedBox(
            height: 0,
          );
  }
}
