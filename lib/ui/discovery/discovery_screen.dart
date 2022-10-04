import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lomo/app/app_model.dart';
import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/data/api/models/discovery_item.dart';
import 'package:lomo/data/api/models/event.dart';
import 'package:lomo/data/api/models/gift.dart';
import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/data/api/models/response/NewFeedResponse.dart';
import 'package:lomo/data/api/models/topic_item.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/eventbus/refresh_discovery_event.dart';
import 'package:lomo/data/eventbus/refresh_discovery_list_event.dart';
import 'package:lomo/data/repositories/common_repository.dart';
import 'package:lomo/data/repositories/new_feed_repository.dart';
import 'package:lomo/data/tracking/tracking_manager.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/discovery/discovery_model.dart';
import 'package:lomo/ui/discovery/list_discovery/list_gift_discovery/list_gift_discovery_screen.dart';
import 'package:lomo/ui/discovery/list_discovery/list_hot_screen.dart';
import 'package:lomo/ui/discovery/newfeed/list_discovery/discovery_newfeeds_screen.dart';
import 'package:lomo/ui/widget/chat_widget.dart';
import 'package:lomo/ui/widget/tabbar_widget.dart';
import 'package:lomo/util/constants.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/user_repository.dart';
import '../widget/item_descovery/item_list_user_hot.dart';
import 'event_slider.dart';
import 'list_discovery/list_knowledge/list_knowledge_screen.dart';
import 'list_discovery/list_topic_hot/list_topic_hot_screen.dart';
import 'near_you/near_you_screen.dart';
import 'out_standing_event.dart';

class DiscoveryScreen extends StatefulWidget {
  @override
  _DiscoveryScreenState createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends BaseState<DiscoveryModel, DiscoveryScreen>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<DiscoveryScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  static const tabLocation = 0;
  static const tabFeeling = 1;
  static const tabHot = 2;

  @override
  Widget build(BuildContext context) {
    return buildContent();
  }

  late List<DTabItem> items;

  @override
  void initState() {
    super.initState();
    items = [
      DTabItem(id: tabLocation, title: Strings.closestToYou),
      DTabItem(id: tabFeeling, title: Strings.emotionalFlow),
      DTabItem(id: tabHot, title: Strings.hot_member),
    ];
    model.getDiscoveryList();
    eventBus.on<RefreshDiscoveryEvent>().listen((event) async {
      showRefreshIndicator();
      onRefresh();
    });
  }

  @override
  Widget buildContentView(BuildContext context, DiscoveryModel model) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: getColor().pinkF2F5Color,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: getColor().white,
          elevation: 0,
          actions: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(
                  right: 16,
                  left: 5,
                ),
                child: ChatWidget(),
              ),
            )
          ],
          leading: Padding(
            padding: EdgeInsets.only(left: 16),
            child: InkWell(
              onTap: () async {
                Navigator.pushNamed(context, Routes.search);
              },
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Image.asset(
                  DImages.icTabSearch,
                  color: getColor().colorDart,
                  height: 40,
                  width: 40,
                ),
              ),
            ),
          ),
          title: Text(
            Strings.discovery.localize(context),
            style: textTheme(context).text19.bold.colorDart,
          ),
          centerTitle: true,
        ),
        body: RefreshIndicator(
          child: _buildContent(),
          onRefresh: () {
            return model.getDiscoveryList(refesh: true);
          },
        ),
      ),
    );
  }

  showRefreshIndicator() {
    _refreshIndicatorKey.currentState?.show();
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          EventSlider(),
          _buildItems(),
          // _buildItemsFromAppConfig(),
        ],
      ),
    );
  }

  Widget _buildItems() {
    return ValueListenableProvider.value(
      value: model.discoveryItems,
      child: Consumer<List<DiscoveryItem>>(
        builder: (context, items, child) {
          List<Widget> children = [];
          items.forEach((element) {
            switch (element.type?.id) {
              case DiscoveryItemTypeId.post:
                children.add(
                  DiscoveryNewFeedsScreen(
                    title: element.displayName,
                    getData: (page, pageSize) async {
                      final data = await model.getDiscoveryListDetail(
                          element, page, pageSize);
                      return NewFeedResponse(
                          data.map((e) => e as NewFeed).toList());
                    },
                  ),
                );
                break;
              case DiscoveryItemTypeId.profile:
                children.add(
                  ListHotScreen(
                    subTitleType: element.isAuto
                        ? ListUserSubTitleType.bear
                        : ListUserSubTitleType.follow,
                    title: element.displayName,
                    getData: (page, pageSize) async {
                      final data = await model.getDiscoveryListDetail(
                          element, page, pageSize);
                      return data.map((e) => e as User).toList();
                    },
                  ),
                );
                break;
              case DiscoveryItemTypeId.topic:
                children.add(
                  ListTopicHotScreen(
                    title: element.displayName,
                    getData: (page, pageSize) async {
                      final data = await model.getDiscoveryListDetail(
                          element, page, pageSize);
                      return data.map((e) => e as TopictItem).toList();
                    },
                  ),
                );
                break;
              case DiscoveryItemTypeId.gift:
                children.add(
                  ListGiftDiscoveryScreen(
                    title: element.displayName,
                    getData: (page, pageSize) async {
                      final data = await model.getDiscoveryListDetail(
                          element, page, pageSize);
                      return data.map((e) => e as Gift).toList();
                    },
                  ),
                );
                break;
              case DiscoveryItemTypeId.banner:
                children.add(
                  OutStandingEvent(
                    title: element.displayName,
                    getData: (page, pageSize) async {
                      final data = await model.getDiscoveryListDetail(
                          element, page, pageSize);
                      return data.map((e) => e as Event).toList();
                    },
                  ),
                );
                break;
              case DiscoveryItemTypeId.profileNear:
                children.add(NearYouScreen(element.displayName));
                break;
              case DiscoveryItemTypeId.knowledge:
                children.add(
                  ListKnowledgeScreen(
                    title: element.displayName,
                    getData: (page, pageSize) => locator<CommonRepository>()
                        .getListKnowledgeTopic(page, pageSize),
                  ),
                );
            }
          });
          children.add(
            SizedBox(
              height: 30,
            ),
          );
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          );
        },
      ),
    );
  }

  Widget _buildItemsFromAppConfig() {
    List<Widget> items = [];
    locator<AppModel>().appConfig?.discoveries.forEach((element) {
      if (element.isHide == false) items.add(_buildDiscoveryItem(element));
    });
    items.add(SizedBox(
      height: 30,
    ));
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: onRefresh,
      color: getColor().colorDart,
      child: SingleChildScrollView(
        child: Column(
          children: items,
        ),
      ),
    );
  }

  Widget _buildDiscoveryItem(DiscoveryItem item) {
    Widget? result;
    switch (item.key) {
      case DiscoveryKey.postHot:
        result = DiscoveryNewFeedsScreen(
          title: item.displayName,
          getData: (page, pageSize) => locator<NewFeedRepository>()
              .getPostsHot(page: page, pageSize: pageSize),
          onViewMore: () async {
            locator<TrackingManager>().trackViewMoreHotMember();
          },
          onItemClicked: (user) async {},
        );
        break;
      case DiscoveryKey.topicHot:
        result = ListTopicHotScreen(
          title: item.displayName,
          getData: (page, pageSize) =>
              locator<CommonRepository>().getListHotTopic(page, pageSize),
          onViewMore: () async {
            locator<TrackingManager>().trackViewMoreTopicHot();
          },
          onItemClicked: (topic) async {
            locator<TrackingManager>().trackTopicHotDetail(topic.id);
          },
        );
        break;
      case DiscoveryKey.lomoChoice:
        result = DiscoveryNewFeedsScreen(
          title: item.displayName,
          getData: (page, pageSize) => locator<NewFeedRepository>()
              .getPostsChoice(page: page, pageSize: pageSize, isChoice: true),
          onViewMore: () async {
            locator<TrackingManager>().trackViewMoreHotMember();
          },
          onItemClicked: (user) async {},
        );
        break;
      case DiscoveryKey.peopleNear:
        result = NearYouScreen(item.displayName);
        break;
      case DiscoveryKey.giftHot:
        result = ListGiftDiscoveryScreen(
          title: item.displayName,
          getData: (page, pageSize) =>
              locator<CommonRepository>().getGifts(page, pageSize, isHot: true),
          onViewMore: () async {},
          onItemClicked: (topic) async {},
        );
        break;
      case DiscoveryKey.peopleHot:
        result = ListHotScreen(
          subTitleType: ListUserSubTitleType.bear,
          title: item.displayName,
          getData: (page, pageSize) =>
              locator<UserRepository>().getListHot(page: page, limit: pageSize),
          onViewMore: () async {
            locator<TrackingManager>().trackViewMoreHotMember();
          },
          onItemClicked: (user) async {
            locator<TrackingManager>().trackHotMemberDetail(user.id);
          },
        );
        break;
      case DiscoveryKey.companion:
        result = ListHotScreen(
          subTitleType: ListUserSubTitleType.follow,
          title: item.displayName,
          getData: (page, pageSize) => locator<UserRepository>()
              .getListParent(page: page, limit: pageSize),
        );
        break;
      case DiscoveryKey.eventQueer:
        result = OutStandingEvent(
          title: item.displayName,
          getData: (page, pageSize) async =>
              await locator<CommonRepository>().getOutStandingEvents(1, 10),
        );
        break;
      case DiscoveryKey.forU:
        result = ListTopicHotScreen(
          title: item.displayName,
          getData: (page, pageSize) =>
              locator<CommonRepository>().getListForYouTopic(page, pageSize),
          onViewMore: () async {
            locator<TrackingManager>().trackViewMoreForYou();
          },
          onItemClicked: (topic) async {
            locator<TrackingManager>().trackForYouDetail(topic.id);
          },
        );
        break;
      case DiscoveryKey.knowledge:
        result = ListTopicHotScreen(
          title: item.displayName,
          getData: (page, pageSize) =>
              locator<CommonRepository>().getListKnowledgeTopic(page, pageSize),
          isViewMore: false,
          onItemClicked: (topic) async {
            locator<TrackingManager>().trackKnowledge();
          },
        );
        break;
      default:
        result = SizedBox(
          height: 0,
        );
    }
    return result;
  }

  Future<void> onRefresh() async {
    eventBus.fire(RefreshDiscoveryListEvent());
  }

  @override
  bool get wantKeepAlive => true;
}
