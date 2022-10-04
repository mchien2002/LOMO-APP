import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/profile/person/person_follow/person_follow_screen.dart';
import 'package:lomo/ui/profile/person/person_highlight_model.dart';
import 'package:lomo/ui/widget/round_underline_tabindicator.dart';
import 'package:lomo/ui/widget/tabbar_widget.dart';
import 'package:lomo/util/constants.dart';

class PersonHighlightArguments {
  User user;
  int initIndex;

  PersonHighlightArguments(this.user, {this.initIndex = 0});
}

class PersonHighlightScreen extends StatefulWidget {
  final PersonHighlightArguments args;

  PersonHighlightScreen(this.args);

  @override
  _PersonHighlightScreenState createState() => _PersonHighlightScreenState();
}

class _PersonHighlightScreenState
    extends BaseState<PersonHighlightModel, PersonHighlightScreen>
    with SingleTickerProviderStateMixin {
  static const tabFollow = 0;
  static const tabWatching = 1;
  TextEditingController searchController = TextEditingController();

  late TabController _tabController;
  late List<DTabItem> _tabItems;

  @override
  void initState() {
    _initTabs();
    super.initState();
  }

  void _initTabs() {
    _tabItems = [
      DTabItem(
        id: tabFollow,
        title: Strings.follow,
      ),
      DTabItem(
        id: tabWatching,
        title: Strings.watching,
      )
    ];
    _tabController = TabController(
        length: _tabItems.length,
        vsync: this,
        initialIndex: widget.args.initIndex);
  }

  @override
  Widget build(BuildContext context) {
    return buildContent();
  }

  @override
  Widget buildContentView(BuildContext context, PersonHighlightModel model) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: getColor().colorDart),
          backgroundColor: getColor().white,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          automaticallyImplyLeading: false,
          leading: InkWell(
            onTap: () {
              Navigator.of(context).maybePop();
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Container(
                width: 32,
                height: 32,
                child: Image.asset(
                  DImages.backBlack,
                ),
              ),
            ),
          ),
          elevation: 0,
          centerTitle: true,
          title: DTabBar(
            indicator: RoundUnderlineTabIndicator(),
            tabController: _tabController,
            labelColor: getColor().darkTextColor,
            unselectedLabelColor: getColor().darkTextColor,
            textStyleSelected: textTheme(context).text16.bold.darkTextColor,
            textStyleUnSelected: textTheme(context).text16.darkTextColor,
            // paddingBottom: 8.0,
            items: _tabItems,
          ),
        ),
        body: Column(
          children: [
            Divider(
              height: 3,
              color: getColor().underlineClearTextField,
            ),
            SizedBox(
              height: Dimens.size15,
            ),
            Expanded(
              child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: _tabItems.map((item) => _viewByTab(item)).toList()),
            )
          ],
        ));
  }

  Widget _viewByTab(DTabItem tab) {
    switch (tab.id) {
      case tabFollow:
        return PersonFollowScreen(
          widget.args.user,
          FollowType.follower,
        );
      case tabWatching:
        return PersonFollowScreen(
          widget.args.user,
          FollowType.following,
        );
      default:
        return Container(
          color: Colors.red,
          child: Center(
            child: Text(
              tab.title!,
              style: TextStyle(fontSize: 30),
            ),
          ),
        );
    }
  }

  @override
  bool get wantKeepAlive => true;
}
