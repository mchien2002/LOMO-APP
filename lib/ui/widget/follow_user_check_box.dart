import 'package:flutter/material.dart';
import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/eventbus/follow_user_event.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/colors.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/util/common_utils.dart';

import 'dialog_widget.dart';

class FollowUserCheckBox extends StatefulWidget {
  final User user;
  final Function(User user, bool isFollowed)? onFollowChanged;
  final Widget? followedWidget;
  final Widget? followWidget;
  final bool? isUnfollowAction; //Bien nay cho bam unfollow hay khong
  FollowUserCheckBox(this.user,
      {this.onFollowChanged,
      this.followedWidget,
      this.followWidget,
      this.isUnfollowAction = true});

  @override
  State<StatefulWidget> createState() => _FollowUserCheckBoxState();
}

class _FollowUserCheckBoxState extends State<FollowUserCheckBox> {
  @override
  void initState() {
    super.initState();
    if (mounted) {
      eventBus.on<FollowUserEvent>().listen((event) async {
        if (event.userId == widget.user.id && mounted) {
          setState(() {
            widget.user.isFollow = event.isFollow;
          });
        }
      });
    }
  }

  @override
  void didUpdateWidget(covariant FollowUserCheckBox oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: DColors.transparentColor,
      onTap: () async {
        final _userRepository = locator<UserRepository>();
        try {
          //Chua follow user
          if (!widget.user.isFollow) {
            // khong duoc follow chinh minh
            if (!widget.user.isMe) {
              await _userRepository.followUser(widget.user);
              showToast(Strings.followSuccess.localize(context) +
                  " ${widget.user.name}");
              setState(() {
                widget.user.isFollow = !widget.user.isFollow;
              });
            }
          } else if (widget.user.isFollow && widget.isUnfollowAction!) {
            showDialog(
                context: context,
                builder: (context) => TwoButtonDialogWidget(
                    title: Strings.stopFollowUser.localize(context),
                    description:
                        Strings.stopFollowUserContent.localize(context),
                    onConfirmed: () async {
                      await _userRepository.unFollowUser(widget.user);
                      showToast(Strings.unFollowSuccess.localize(context) +
                          " ${widget.user.name}");
                      setState(() {
                        widget.user.isFollow = !widget.user.isFollow;
                      });
                    }));
          }
          if (widget.onFollowChanged != null) {
            widget.onFollowChanged!(widget.user, widget.user.isFollow);
          }
        } catch (e) {
          print(e);
        }
      },
      child: widget.user.isFollow
          ? widget.followedWidget ?? _buildFollowed()
          : widget.followWidget ?? _buildFollow(),
    );
  }

  Widget _buildFollowed() {
    return Container();
  }

  Widget _buildFollow() {
    return Image.asset(
      DImages.addFollow,
      height: 36,
      width: 36,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
