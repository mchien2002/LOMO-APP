import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/eventbus/change_dating_view_type_event.dart';
import 'package:lomo/data/eventbus/change_menu_event.dart';
import 'package:lomo/data/eventbus/filter_dating_event.dart';
import 'package:lomo/data/eventbus/filter_highlight_event.dart';
import 'package:lomo/data/eventbus/refresh_hightlight_event.dart';
import 'package:lomo/data/eventbus/update_tab_following_event.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/colors.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/dating/dating_list/dating_list_screen.dart';
import 'package:lomo/ui/home/highlight/highlight_model.dart';
import 'package:lomo/ui/home/highlight/timeline/timeline_new_screen.dart';
import 'package:lomo/ui/widget/bottom_sheet_widgets.dart';
import 'package:lomo/ui/widget/chat_widget.dart';
import 'package:lomo/ui/widget/home_tabbar.dart';
import 'package:lomo/ui/widget/tabbar_widget.dart';
import 'package:provider/provider.dart';

import '../../../data/eventbus/outside_newfeed_event.dart';

class HighlightScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HighlightScreenState();
}

class _HighlightScreenState extends BaseState<HighlightModel, HighlightScreen>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<HighlightScreen>,
        WidgetsBindingObserver {
  static const tabTimeline = 0;
  static const tabDating = 1;

  String currentDatingViewType = Strings.viewAsList;

  late TabController _tabController;
  late List<DTabItem> _tabItems;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _initTabs();
    super.initState();
    eventBus.on<RefreshHighLightEvent>().listen((event) async {
      refreshPage(_tabController.index);
    });
    eventBus.on<ChangeMenuEvent>().listen((event) async {
      if (event.index == 0 && model.tabValue.value == 1) {
        _tabController.index = 0;
        model.changeTabMenu(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildContent();
  }

  void _initTabs() {
    _tabItems = [
      DTabItem(
        id: tabTimeline,
        title: Strings.postTimeline,
      ),
      DTabItem(
        id: tabDating,
        title: Strings.dating,
      )
    ];
    _tabController = TabController(vsync: this, length: _tabItems.length);
    _tabController.addListener(() {
      eventBus
          .fire(UpdateTabFollowingEvent(homeTabType: HomeTabType.highlight));
    });
  }

  @override
  Widget buildContentView(BuildContext context, HighlightModel model) {
    return Scaffold(
      backgroundColor: getColor().white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: getColor().white,
        elevation: 0,
        titleSpacing: 16,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ValueListenableProvider.value(
              value: model.tabValue,
              child: Consumer<int>(
                  builder: (context, tab, child) => _tabController.index == 0
                      ? InkWell(
                          child: Image.asset(
                            DImages.timelineFilter,
                            width: 40,
                            height: 40,
                            color: getColor().colorDart,
                          ),
                          onTap: () {
                            eventBus.fire(FilterHighlightEvent());
                            // bắn event thông báo đã ra khỏi tab news feed
                            eventBus.fire(OutSideNewFeedsEvent());
                          },
                        )
                      : _buildButtonDatingSetting()),
            ),
            DTabBar(
              tabController: _tabController,
              items: _tabItems,
              unselectedLabelColor: DColors.textAppbarGreyColor,
              textStyleSelected: textTheme(context).text19.bold.colorPrimary,
              textStyleUnSelected: textTheme(context).text15.bold.gray77,
              onTap: (index) {
                model.changeTabMenu(index);
              },
              // unselectedLabelColor: ,
            ),
            ChatWidget(),
          ],
        ),
        centerTitle: true,
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: _tabItems.map((item) => _viewByTab(item)).toList(),
            ),
            color: DColors.grayE0Color,
          ),
        ],
      ),
    );
  }

  Widget _buildButtonDatingSetting() {
    return ChangeNotifierProvider.value(
      value: locator<UserModel>(),
      child: Consumer<UserModel>(
        builder: (context, userModel, child) => userModel.user!.hasDatingProfile
            ? ValueListenableProvider.value(
                value: model.isUseAsGrid,
                child: Consumer<bool>(
                  builder: (context, isUseAsGrid, child) =>
                      BottomSheetMenuWidget(
                    items: DatingSettingMenu.values.map((e) {
                      if (e == DatingSettingMenu.viewType) {
                        if (isUseAsGrid) {
                          currentDatingViewType = Strings.viewAsList;
                        } else
                          currentDatingViewType = Strings.viewAsGrid;
                        return currentDatingViewType;
                      } else {
                        return e.name;
                      }
                    }).toList(),
                    onItemClicked: (index) {
                      switch (DatingSettingMenu.values[index]) {
                        case DatingSettingMenu.myProfile:
                          Navigator.pushNamed(context, Routes.datingUserDetail,
                              arguments: locator<UserModel>().user);
                          break;
                        case DatingSettingMenu.setupQuiz:
                          Navigator.pushNamed(
                            context,
                            Routes.whoSuitsMeProfile,
                          );
                          break;
                        case DatingSettingMenu.filterSearch:
                          eventBus.fire(FilterDatingEvent());
                          break;
                        case DatingSettingMenu.viewType:
                          eventBus.fire(ChangeDatingViewTypeEvent());
                          model.isUseAsGrid.value = !model.isUseAsGrid.value;
                          break;
                        case DatingSettingMenu.setting:
                          Navigator.pushNamed(context, Routes.datingSetting);
                          break;
                      }
                    },
                    child: Image.asset(
                      DImages.setting,
                      width: 40,
                      height: 40,
                    ),
                  ),
                ),
              )
            : SizedBox(
                height: 40,
                width: 40,
              ),
      ),
    );
  }

  refreshPage(int pageIndex) {
    switch (pageIndex) {
      case tabTimeline:
        model.refreshForYouPage.value = Object();
        break;
      case tabDating:
        model.refreshDatingPage.value = Object();
        break;
    }
  }

  Widget _viewByTab(DTabItem tab) {
    switch (tab.id) {
      case tabTimeline:
        return TimeLineNewScreen(
          refreshData: model.refreshForYouPage,
        );
      // return TimelineListScreen(
      //   refreshData: model.refreshForYouPage,
      // );
      case tabDating:
        return DatingListScreen(
          refreshData: model.refreshDatingPage,
        );

      default:
        return Container(
          color: Colors.red,
          child: Center(
            child: Text(tab.title!.localize(context),
                style: TextStyle(fontSize: 30)),
          ),
        );
    }
  }

  @override
  bool get wantKeepAlive => true;
}

enum DatingSettingMenu { viewType, filterSearch, myProfile, setupQuiz, setting }

extension DatingSettingMenuExt on DatingSettingMenu {
  String get name {
    switch (this) {
      case DatingSettingMenu.myProfile:
        return Strings.myDatingProfile;
      case DatingSettingMenu.filterSearch:
        return Strings.filterSearch;
      case DatingSettingMenu.setupQuiz:
        return Strings.setupQuiz;
      case DatingSettingMenu.viewType:
        return Strings.viewAsGrid;
      case DatingSettingMenu.setting:
        return Strings.datingViewSetting;
    }
    return "";
  }
}
