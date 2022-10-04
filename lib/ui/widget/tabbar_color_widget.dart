
import 'package:flutter/material.dart';
import 'package:lomo/res/theme/theme_manager.dart';

class ColoredTabBar extends StatelessWidget implements PreferredSizeWidget {
  final TabBar tabBar;
  ColoredTabBar(this.tabBar);

  @override
  Size get preferredSize => tabBar.preferredSize;

  @override
  Widget build(BuildContext context) => PreferredSize(
        preferredSize: preferredSize,
        child: Container(
          color: getColor().white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                height: 3,
                color: getColor().backgroundSearch,
              ),
              tabBar,
            ],
          ),
        ),
      );
}
