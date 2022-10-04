import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/constant_list.dart';
import 'package:lomo/res/colors.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';

class TTabBarView extends StatefulWidget {
  TTabBarView({
    this.messages,
    this.tabController,
    this.onMessageSelected,
    this.items,
  });

  // final List<String> messages;
  final TabController? tabController;
  final Function(String)? onMessageSelected;
  final List<ModelItemSimple>? items;
  final ModelItemSimple? messages;

  @override
  _TTabBarState createState() => _TTabBarState();
}

class _TTabBarState extends State<TTabBarView> {
  String selectedMessage = "";

  @override
  void initState() {
    widget.tabController?.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      physics: const NeverScrollableScrollPhysics(),
      controller: widget.tabController,
      children:
          widget.items?.map((item) => tabBarViewItem(item)).toList() ?? [],
    );
  }

  Widget tabBarViewItem(ModelItemSimple item) {
    return ListView.separated(
      itemCount: item.messages?.length ?? 0,
      physics: AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) => item.messages![index] == selectedMessage
          ? select(item.messages![index])
          : noSelect(item.messages![index]),
      separatorBuilder: (context, index) => SizedBox(
        height: 10,
      ),
    );
  }

  Widget select(String message) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
        setState(() {});

        selectedMessage = message;
        if (this.widget.onMessageSelected != null) {
          widget.onMessageSelected!(message);
        }
      },
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: DColors.primaryColor)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              message,
              style: textTheme(context).text13.colorPrimary,
            ),
          )),
    );
  }

  Widget noSelect(String message) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
        setState(() {});

        selectedMessage = message;
        if (this.widget.onMessageSelected != null) {
          widget.onMessageSelected!(message);
        }
      },
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: getColor().gray2eaColor)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              message,
              style: textTheme(context).text13.ff261744Color,
            ),
          )),
    );
  }
}
