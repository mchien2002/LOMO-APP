import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/data/api/models/event.dart';
import 'package:lomo/data/eventbus/refresh_discovery_list_event.dart';
import 'package:lomo/data/tracking/tracking_manager.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/discovery/event_slider_model.dart';
import 'package:lomo/ui/widget/image_widget.dart';
import 'package:lomo/util/handle_link_util.dart';
import 'package:shimmer/shimmer.dart';

import '../../res/theme/theme_manager.dart';
import 'event_indicator.dart';

class EventSlider extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EventSliderState();
}

class _EventSliderState extends BaseState<EventSliderModel, EventSlider>
    with AutomaticKeepAliveClientMixin {
  final eventSliderRatio = 224.0 / 375;
  ValueNotifier<int> currentPageIndex = ValueNotifier(0);

  double width = 0;
  double height = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    eventBus.on<RefreshDiscoveryListEvent>().listen((event) async {
      await model.getEventsSlider();
    });
    model.getEventsSlider();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = width * eventSliderRatio;
    return buildContent();
  }

  Widget _buildItem(Event event, double height, double width) {
    return InkWell(
      child: Material(
        elevation: 2,
        child: RoundNetworkImage(
          boxFit: BoxFit.fill,
          url: event.image ?? "",
          width: width,
          height: height,
        ),
      ),
      onTap: () async {
        locator<TrackingManager>().trackBanner(event.id);
        locator<HandleLinkUtil>()
            .openLinkDiscoveryEvent(event.link, context, this);
      },
    );
  }

  @override
  Widget buildContentView(BuildContext context, EventSliderModel model) {
    return model.events.isNotEmpty == true
        ? SizedBox(
            height: height,
            width: width,
            child: Stack(
              children: [
                CarouselSlider(
                  items: model.events
                      .map((event) => _buildItem(event, height, width))
                      .toList(),
                  options: CarouselOptions(
                      height: height,
                      viewportFraction: 1,
                      aspectRatio: eventSliderRatio,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      scrollDirection: Axis.horizontal,
                      onPageChanged: (index, reason) {
                        currentPageIndex.value = index;
                      }),
                ),
                Align(
                  child: EventIndicatorWidget(
                      model.events.length, currentPageIndex),
                  alignment: Alignment.bottomCenter,
                ),
              ],
            ),
          )
        : SizedBox(
            height: 0,
          );
  }

  @override
  Widget get buildLoadingView => SizedBox(
        height: height,
        width: width,
        child: Stack(
          children: [
            CarouselSlider(
              items: [1, 2, 3, 4]
                  .map(
                    (event) => Shimmer.fromColors(
                      baseColor: getColor().grayF1Color,
                      highlightColor: getColor().gray2eaColor,
                      child: Container(
                        width: width,
                        height: height,
                        color: getColor().white,
                      ),
                    ),
                  )
                  .toList(),
              options: CarouselOptions(
                  height: height,
                  viewportFraction: 1,
                  aspectRatio: eventSliderRatio,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index, reason) {
                    currentPageIndex.value = index;
                  }),
            ),
            Align(
              child: EventIndicatorWidget(4, currentPageIndex),
              alignment: Alignment.bottomCenter,
            ),
          ],
        ),
      );
}
