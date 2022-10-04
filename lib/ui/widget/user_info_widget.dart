import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/values.dart';

import 'action_follow_avatar_widget.dart';
import 'dialog_widget.dart';

class UserInfoWidget extends StatefulWidget {
  final User? user;
  final bool isBorder;
  final double avatarSize;
  final Widget? subTitle;
  final bool isBack;
  final TextStyle? titleStyle;
  final double paddingAvatarName;
  final double? widgetHeight;

  UserInfoWidget(this.user,
      {this.isBorder = false,
      this.avatarSize = 36.0,
      this.subTitle,
      this.isBack = false,
      this.titleStyle,
      this.paddingAvatarName = 10.0,
      this.widgetHeight});

  _UserInfoWidgetState createState() => _UserInfoWidgetState();
}

class _UserInfoWidgetState extends State<UserInfoWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleImageAvatarWidget(
          avatarSize: widget.avatarSize,
          user: widget.user!,
          canViewDetailUser: true,
          canViewAvatar: false,
          padding: widget.isBorder ? 1.0 : 0.0,
        ),
        SizedBox(
          width: widget.paddingAvatarName,
        ),
        InkWell(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    constraints:
                        BoxConstraints(minWidth: 20, maxWidth: getMaxWidth()),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Tooltip(
                              message: widget.user!.name ?? "",
                              child: Text(
                                widget.user!.name ?? "",
                                style: widget.titleStyle != null
                                    ? widget.titleStyle
                                    : textTheme(context)
                                        .text15
                                        .medium
                                        .darkTextColor,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )),
                        ),
                        if (widget.user!.isKol!)
                          Image.asset(
                            DImages.crown,
                            width: 24,
                            height: 24,
                          ),
                        if (widget.user!.isKol!)
                          SizedBox(
                            width: 4,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              if (widget.subTitle != null)
                SizedBox(
                  height: 2,
                ),
              if (widget.subTitle != null) widget.subTitle!
            ],
          ),
          onTap: () {
            if (!widget.user!.isDeleted) {
              Navigator.pushNamed(context, Routes.profile,
                  arguments: UserInfoAgrument(widget.user!));
            } else {
              showDialog(
                context: context,
                builder: (_) => OneButtonDialogWidget(
                  description: Strings.accountDeleted.localize(context),
                  textConfirm: Strings.close.localize(context),
                ),
              );
            }
          },
        )
      ],
    );
  }

  double getMaxWidth() {
    if (widget.widgetHeight != null) {
      return widget.widgetHeight!;
    } else {
      return MediaQuery.of(context).size.width - 115;
    }
  }
}

class UserInfoAgrument {
  User user;
  bool isBack;

  UserInfoAgrument(this.user, {this.isBack = true});
}
