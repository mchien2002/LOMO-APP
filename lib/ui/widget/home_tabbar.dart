import 'package:flutter/material.dart';
import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/data/eventbus/navigate_to_discovery_event.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:provider/provider.dart';

class HomeTabBar extends StatefulWidget {
  HomeTabBar({required this.items, this.onTabClicked});
  final Function(int index, HomeTabType tabType)? onTabClicked;
  final List<HomeTabItem> items;

  @override
  State<StatefulWidget> createState() => _HomeTabBarState();
}

class _HomeTabBarState extends State<HomeTabBar> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    eventBus.on<NavigateToDiscoveryEvent>().listen((event) async {
      setState(() {
        selectedIndex = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(color: Theme.of(context).backgroundColor, boxShadow: [
        BoxShadow(
          color: getColor().shadowMainTabBar,
          blurRadius: 10,
          spreadRadius: 0,
          offset: Offset(0, 0),
        )
      ]),
      child: SafeArea(
        child: SizedBox(
          height: Dimens.BOTTOM_BAR_HEIGHT,
          child: Row(
            children: widget.items.map((item) => _tabItem(item)).toList(),
          ),
        ),
      ),
    );
  }

  Widget _tabItem(HomeTabItem item) {
    var index = widget.items.indexOf(item);
    var isSelected = index == selectedIndex;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            if (item.focusAfterClicked!) {
              selectedIndex = index;
            }
            if (widget.onTabClicked != null)
              widget.onTabClicked!(index, item.tabType);
          });
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                item.title == ""
                    ? Image.asset(
                        item.icon,
                        width: Dimens.size40,
                        height: Dimens.size40,
                        // color: isSelected? getColor().colorPrimary
                        //     : getColor().unSelectedTabBar,
                      )
                    : Image.asset(
                        isSelected ? item.icon : item.unselectedIcon,
                        width: Dimens.size32,
                        height: Dimens.size32,
                        color: isSelected
                            ? getColor().colorPrimary
                            : getColor().unSelectedTabBar,
                      ),
                if (item.title != "") SizedBox(height: Dimens.spacing4),
                if (item.title != "")
                  Text(
                    item.title!.localize(context),
                    style: isSelected
                        ? textTheme(context).text10.colorPrimary
                        : textTheme(context).text10.colorHint,
                  )
              ],
            ),
            if (item.badge != null)
              ChangeNotifierProvider<ValueNotifier<int>>.value(
                  value: item.badge!,
                  child: Consumer<ValueNotifier<int>>(
                      builder: (context, badge, child) {
                    return (badge.value > 0)
                        ? Container(
                            margin: EdgeInsets.only(left: 30, bottom: 35),
                            height: 6,
                            width: 6,
                            decoration: BoxDecoration(
                              color: getColor().colorError,
                              shape: BoxShape.circle,
                            ))
                        : Container();
                  }))
          ],
        ),
      ),
    );
  }
}

class HomeTabItem {
  final HomeTabType tabType;
  final String? title;
  final String icon;
  final String unselectedIcon;
  final bool? focusAfterClicked;
  final ValueNotifier<int>? badge; // use only for notification

  HomeTabItem(
      {required this.tabType,
      this.title,
      required this.icon,
      required this.unselectedIcon,
      this.badge,
      this.focusAfterClicked = true});
}

enum HomeTabType { highlight, discovery, createPost, notification, profile }
