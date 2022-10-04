import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/api/models/who_suits_me_history.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/base/base_list_state.dart';
import 'package:lomo/ui/dating/who_suits_me/profile/history/who_suits_me_history_model.dart';

import 'who_suits_me_history_item.dart';

class WhoSuitsMeHistoryScreen extends StatefulWidget {
  WhoSuitsMeHistoryScreen({required this.user});
  final User user;
  @override
  State<StatefulWidget> createState() => _WhoSuitsMeHistoryScreenState();
}

class _WhoSuitsMeHistoryScreenState extends BaseListState<WhoSuitsMeHistory,
        WhoSuitsMeHistoryModel, WhoSuitsMeHistoryScreen>
    with AutomaticKeepAliveClientMixin<WhoSuitsMeHistoryScreen> {
  @override
  void initState() {
    super.initState();
    model.init(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            height: Dimens.size70,
            child: Center(
              child: Text(
                Strings.history_participation.localize(context),
                style: textTheme(context).text15.text757788Color,
              ),
            )),
        Divider(),
        Expanded(child: buildContent()),
      ],
    );
  }

  @override
  Widget buildItem(BuildContext context, WhoSuitsMeHistory item, int index) {
    return WhoSuitsMeHistoryItem(item);
  }

  @override
  bool get autoLoadData => false;

  @override
  double get itemSpacing => 1;

  Color get dividerColor => getColor().pinkF2F5Color;

  @override
  bool get wantKeepAlive => true;
}
