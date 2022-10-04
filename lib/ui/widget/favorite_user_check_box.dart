import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/util/common_utils.dart';

class FavoriteUserCheckBox extends StatefulWidget {
  final User user;
  final double? height;
  final double? width;
  final Function(bool)? onCheckChanged;
  FavoriteUserCheckBox(
      {required this.user,
      this.width = 32.0,
      this.height = 32.0,
      this.onCheckChanged});
  @override
  State<StatefulWidget> createState() => _FavoriteUserCheckBoxState();
}

class _FavoriteUserCheckBoxState extends State<FavoriteUserCheckBox> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (!widget.user.isFollow)
          ? () async {
              try {
                await locator<UserRepository>().followUser(widget.user);
                widget.user.isFollow = true;
                showToast(Strings.followSuccess.localize(context));
                if (widget.onCheckChanged != null)
                  widget.onCheckChanged!(widget.user.isFollow);
              } catch (e) {
                showToast(Strings.unknownErrorMessage.localize(context));
              }
              setState(() {});
            }
          : null,
      splashColor: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        height: Dimens.size44,
        width: Dimens.size44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(Dimens.cornerRadius22),
          ),
          color: getColor().colorVioletEB,
        ),
        child: Image.asset(
          !widget.user.isFollow ? DImages.plus : DImages.check,
          color: !widget.user.isFollow ? null : getColor().backGroundGrayIcon,
          height: widget.height,
          width: widget.height,
        ),
      ),
    );
  }
}
