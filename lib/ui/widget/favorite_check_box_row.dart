// import 'package:flutter/material.dart';
// import 'package:lomo/data/api/models/new_feed.dart';
// import 'package:lomo/data/repositories/user_repository.dart';
// import 'package:lomo/di/locator.dart';
// import 'package:lomo/res/dimens.dart';
// import 'package:lomo/res/images.dart';
// import 'package:lomo/res/theme/text_theme.dart';
// import 'package:lomo/res/theme/theme_manager.dart';
// import 'package:lomo/ui/base/base_list_state.dart';
// import 'package:lomo/ui/profile/profile_timeline/time_line_model.dart';
//
// import 'checkbox_widget.dart';
//
// class FavoriteCheckBoxRow extends StatefulWidget {
//   final NewFeed newFeed;
//   final Function(bool) onCheckChanged;
//   final height;
//   final width;
//
//   FavoriteCheckBoxRow(
//       {Key key,
//       this.newFeed,
//       this.onCheckChanged,
//       this.height = 20.0,
//       this.width = 20.0})
//       : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() => _FavoriteCheckBoxState();
// }
//
// class _FavoriteCheckBoxState
//     extends BaseListState<NewFeed, ProfileTimelineModel, FavoriteCheckBoxRow> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: buildContent(),
//     );
//   }
//
//   @override
//   Widget buildItem(BuildContext context, NewFeed item, int index) {
//     // TODO: implement buildItem
//     return
//   }
//
//   @override
//   // TODO: implement autoLoadData
//   bool get autoLoadData => false;
// }
