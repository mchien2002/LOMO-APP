import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/base/base_list_state.dart';

import 'search_user_item.dart';
import 'search_user_model.dart';

class SearchUserScreen extends StatefulWidget {
  final ValueNotifier<String> textSearch;
  SearchUserScreen({required this.textSearch});

  @override
  State<StatefulWidget> createState() => _SearchUserScreenState();
}

class _SearchUserScreenState
    extends BaseListState<User, SearchUserModel, SearchUserScreen>
    with AutomaticKeepAliveClientMixin<SearchUserScreen> {
  @override
  void initState() {
    super.initState();
    model.init(widget.textSearch);
    model.loadData();
    widget.textSearch.addListener(() {
      model.refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildContent();
  }

  @override
  Widget buildItem(BuildContext context, User user, int index) {
    return SearchUserItem(
      user: user,
    );
  }

  @override
  bool get autoLoadData => false;

  @override
  Color get dividerColor => getColor().pinkF2F5Color;

  @override
  bool get wantKeepAlive => true;

  @override
  double get itemSpacing => 1;
}
