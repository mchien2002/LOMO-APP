import 'package:flutter/material.dart';
import 'package:lomo/res/colors.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';

import 'round_underline_tabindicator.dart';

class DTabBar extends StatelessWidget implements PreferredSizeWidget {
  DTabBar(
      {this.items,
      this.tabController,
      this.labelColor,
      this.unselectedLabelColor,
      this.textStyleSelected,
      this.textStyleUnSelected,
      this.isScrollable = true,
      this.paddingBottom = 3.0,
      this.indicator,
      this.onTap});

  final List<DTabItem>? items;
  final TabController? tabController;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final ValueChanged<int>? onTap;
  final TextStyle? textStyleSelected;
  final TextStyle? textStyleUnSelected;
  final bool isScrollable;
  final double paddingBottom;
  final RoundUnderlineTabIndicator? indicator;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: Theme(
        data: ThemeData(splashColor: Colors.transparent),
        child: TabBar(
            onTap: onTap,
            isScrollable: isScrollable,
            controller: tabController,
            labelColor: labelColor ?? getColor().colorPrimary,
            labelStyle: textStyleSelected ?? textTheme(context).text19,
            unselectedLabelColor: unselectedLabelColor ?? DColors.gray77Color,
            unselectedLabelStyle:
                textStyleUnSelected ?? textTheme(context).text15.bold,
            labelPadding: EdgeInsets.all(5),
            indicator: indicator ??
                RoundUnderlineTabIndicator(
                    borderSide: BorderSide(
                      width: 4,
                      color: DColors.primaryColor,
                    ),
                    paddingBottom: paddingBottom),
            tabs: items!.map((item) => _tabItem(item, context)).toList()),
      ),
    );
  }

  Widget _tabItem(DTabItem item, BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8, right: 8),
      height: 40,
      child: Tab(
        child: Center(child: Text(item.title?.localize(context) ?? "")),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(44);
}

class DTabItem {
  final int? id;
  final String? title;

  // use only for notification

  DTabItem({this.title, this.id});
}
