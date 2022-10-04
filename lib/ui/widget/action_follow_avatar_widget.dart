import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/colors.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/widget/dialog_widget.dart';
import 'package:lomo/ui/widget/image_widget.dart';
import 'package:lomo/ui/widget/user_info_widget.dart';
import 'package:lomo/util/common_utils.dart';

class ActionFollowAvatarWidget extends StatefulWidget {
  final double? avatarSize;
  final double followButtonSize;
  final User user;
  final Function(bool)? onFollowed;
  final bool canViewDetailUser;

  ActionFollowAvatarWidget(
      {required this.user,
      this.avatarSize = 56,
      this.followButtonSize = 22,
      this.onFollowed,
      this.canViewDetailUser = true});

  @override
  State<StatefulWidget> createState() => _ActionFollowAvatarWidgetState();
}

class _ActionFollowAvatarWidgetState extends State<ActionFollowAvatarWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.avatarSize! + widget.followButtonSize / 2,
      width: widget.avatarSize,
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          if (widget.canViewDetailUser && !widget.user.isMe)
            Navigator.pushNamed(context, Routes.profile,
                arguments: UserInfoAgrument(widget.user));
        },
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: widget.followButtonSize / 2),
              child: CircleNetworkImage(
                strokeColor: getColor().colorPrimary,
                strokeWidth: 2,
                url: widget.user.avatar ?? "",
                size: widget.avatarSize!,
              ),
            ),
            if (!widget.user.isFollow && !widget.user.isMe)
              InkWell(
                onTap: () {
                  locator<UserRepository>().followUser(widget.user).then(
                      (value) => setState(() {
                            widget.user.isFollow = true;
                            if (widget.onFollowed != null)
                              widget.onFollowed!(true);
                            showToast(Strings.followSuccess.localize(context));
                          }), onError: (e) {
                    print(e);
                  });
                },
                child: Container(
                  height: widget.followButtonSize + 12,
                  padding: EdgeInsets.only(bottom: 2, right: 10, left: 10),
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: widget.followButtonSize,
                    width: widget.followButtonSize,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(widget.followButtonSize / 2),
                        color: getColor().colorPrimary),
                    child: Icon(
                      Icons.add,
                      color: getColor().white,
                      size: 15,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CircleImageAvatarWidget extends StatefulWidget {
  final double avatarSize;
  final User user;
  final bool canViewDetailUser;
  final padding;
  final canViewAvatar; //Neu gia tri la true thi uu tien vao xem avatar khong quan tam toi gia tri cua canViewDetailUser

  CircleImageAvatarWidget(
      {required this.user,
      this.avatarSize = 44,
      this.canViewDetailUser = true,
      this.padding = 2.0,
      this.canViewAvatar = true});

  @override
  State<StatefulWidget> createState() => _CircleImageAvatarWidgetState();
}

class _CircleImageAvatarWidgetState extends State<CircleImageAvatarWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.avatarSize,
      width: widget.avatarSize,
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          if (widget.canViewAvatar) {
            //Uu tien vao xem avatar
            Navigator.pushNamed(context, Routes.viewDetailImage,
                arguments: widget.user.avatar);
          } else if (widget.canViewDetailUser) {
            if (widget.user.isDeleted) {
              showDialog(
                context: context,
                builder: (_) => OneButtonDialogWidget(
                  description: Strings.accountDeleted.localize(context),
                  textConfirm: Strings.close.localize(context),
                ),
              );
            } else {
              Navigator.pushNamed(context, Routes.profile,
                  arguments: UserInfoAgrument(widget.user));
            }
          }
        },
        child: Container(
          padding: EdgeInsets.all(widget.padding),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                widget.avatarSize + widget.padding,
              ),
              gradient: LinearGradient(
                colors: [
                  DColors.primaryGradientColor4,
                  DColors.primaryGradientColor3,
                ],
                begin: const Alignment(0.3, 1.0),
                end: const Alignment(0.6, 0.2),
              )),
          child: CircleNetworkImage(
            url: widget.user.avatar ?? "",
            size: widget.avatarSize,
          ),
        ),
      ),
    );
  }
}

class AvatarWidget extends StatefulWidget {
  final double avatarSize;
  final double followButtonSize;
  final User user;
  final Function(bool)? onFollowed;
  final bool canViewDetailUser;

  AvatarWidget(
      {required this.user,
      this.avatarSize = 60,
      this.followButtonSize = 22,
      this.onFollowed,
      this.canViewDetailUser = true});

  @override
  State<StatefulWidget> createState() => _AvatarWidgetState();
}

class _AvatarWidgetState extends State<AvatarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.avatarSize,
      width: widget.avatarSize,
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          if (widget.canViewDetailUser && !widget.user.isMe)
            Navigator.pushNamed(context, Routes.profile,
                arguments: UserInfoAgrument(widget.user));
        },
        child: Container(
          child: CircleNetworkImage(
            strokeColor: getColor().colorPrimary,
            strokeWidth: 2,
            url: widget.user.avatar ?? "",
            size: widget.avatarSize,
          ),
        ),
      ),
    );
  }
}

class ButtonFollowWidget extends StatefulWidget {
  final double avatarSize;
  final double followButtonSize;
  final User user;
  final Function(bool)? onFollowed;
  final bool canViewDetailUser;

  ButtonFollowWidget(
      {required this.user,
      this.avatarSize = 60,
      this.followButtonSize = 22,
      this.onFollowed,
      this.canViewDetailUser = true});

  @override
  State<StatefulWidget> createState() => _ButtonFollowWidgetState();
}

class _ButtonFollowWidgetState extends State<ButtonFollowWidget> {
  @override
  Widget build(BuildContext context) {
    return !widget.user.isFollow && !widget.user.isMe
        ? MaterialButton(
            height: Dimens.size25,
            minWidth: Dimens.size80,
            color: getColor().colorPrimary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
            child: Text(
              Strings.btn_follow.localize(context),
              style: textTheme(context).text12.bold.colorWhite,
            ),
            splashColor: Colors.red,
            onPressed: () async {
              locator<UserRepository>().followUser(widget.user).then(
                  (value) => setState(() {
                        widget.user.isFollow = true;
                        if (widget.onFollowed != null) widget.onFollowed!(true);
                        showToast(Strings.followSuccess.localize(context));
                      }), onError: (e) {
                print(e);
              });
            })
        : Container(
            margin: EdgeInsets.only(bottom: 8),
          );
  }
}
