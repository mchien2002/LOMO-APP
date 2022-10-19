import 'package:flutter/material.dart';

import '../../../../../data/api/models/new_feed.dart';
import '../../../../../res/theme/text_theme.dart';
import '../../../../widget/follow_user_check_box.dart';
import '../../../../widget/user_info_widget.dart';

class UserInfoPlayout extends StatefulWidget {
  const UserInfoPlayout(
      {Key? key,
      required this.newFeed,
      required this.moreBtnWidget,
      required this.myMoreBtnWidget})
      : super(key: key);
  final NewFeed newFeed;
  final Widget moreBtnWidget;
  final Widget myMoreBtnWidget;
  @override
  State<UserInfoPlayout> createState() => _UserInfoPlayoutState();
}

class _UserInfoPlayoutState extends State<UserInfoPlayout> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: UserInfoWidget(
              widget.newFeed.user!,
              titleStyle: textTheme(context).text15.bold,
              widgetHeight: MediaQuery.of(context).size.width - 160,
            ),
          ),
          if (!widget.newFeed.user!.isMe)
            FollowUserCheckBox(widget.newFeed.user!),
          SizedBox(
            width: 5,
          ),
          widget.newFeed.user!.isMe
              ? widget.myMoreBtnWidget
              : widget.moreBtnWidget,
          // widget.myMoreBtnWidget
        ],
      ),
    );
  }
}
