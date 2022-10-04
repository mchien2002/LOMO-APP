import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/constant_list.dart';
import 'package:lomo/res/colors.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';

class TTabBar extends StatefulWidget {
  TTabBar({
    this.items,
    this.tabController,
  });

  final List<ModelItemSimple>? items;
  final TabController? tabController;

  @override
  _TTabBarState createState() => _TTabBarState();
}

class _TTabBarState extends State<TTabBar> {
  @override
  void initState() {
    widget.tabController?.addListener(() {
      if (widget.tabController?.indexIsChanging == true) {
        FocusScope.of(context).unfocus();
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
        controller: widget.tabController,
        isScrollable: true,
        labelPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        indicatorColor: DColors.transparentColor,
        tabs: widget.items
                ?.map((item) =>
                    widget.items?.indexOf(item) == widget.tabController?.index
                        ? Select(item)
                        : NoSelect(item))
                .toList() ??
            []);
  }

  Widget Select(ModelItemSimple item) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            color: DColors.primaryColor),
        child: Text(
          item.name ?? "",
          style: textTheme(context).text13.bold.colorWhite,
        ));
  }

  Widget NoSelect(ModelItemSimple item) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            color: getColor().pinke6fa),
        child: Text(item.name ?? "",
            style: textTheme(context).text13.bold.colorDart));
  }
}
