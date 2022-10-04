import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/base/base_list_state.dart';
import 'package:lomo/ui/discovery/list_discovery/list_more_hot/list_more_hot_model.dart';
import 'package:lomo/ui/widget/item_descovery/item_list_user_hot.dart';

class ListMoreHotScreenArguments {
  final String title;
  final Future<List<User>> Function(int page, int pageSize) getData;
  final ListUserSubTitleType? subTitleType;

  ListMoreHotScreenArguments(this.getData, this.title,
      {this.subTitleType = ListUserSubTitleType.bear});
}

class ListMoreHotScreen extends StatefulWidget {
  final ListMoreHotScreenArguments args;

  ListMoreHotScreen(this.args);

  @override
  _ListMoreHotScreenState createState() => _ListMoreHotScreenState();
}

class _ListMoreHotScreenState
    extends BaseListState<User, ListMoreHotModel, ListMoreHotScreen> {
  @override
  void initState() {
    super.initState();
    model.init(widget.args.getData);
    model.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getColor().pinkF2F5Color,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: getColor().white,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        automaticallyImplyLeading: false,
        title: Text(
          widget.args.title.localize(context),
          style: textTheme(context).text19.bold.colorDart,
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Image.asset(
              DImages.backBlack,
              color: getColor().colorDart,
            ),
          ),
        ),
      ),
      body: buildContent(),
    );
  }

  @override
  Widget buildItem(BuildContext context, item, int index) {
    return ListItemUserHot(
      user: model.items[index],
      index: index,
      subTitleType: widget.args.subTitleType,
    );
  }

  @override
  EdgeInsets get padding => EdgeInsets.only(bottom: 10);

  @override
  bool get autoLoadData => false;

  @override
  Color get dividerColor => getColor().pinkF2F5Color;

  @override
  double get itemSpacing => 1;
}
