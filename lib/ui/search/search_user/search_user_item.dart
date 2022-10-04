import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/widget/image_widget.dart';
import 'package:lomo/ui/widget/user_info_widget.dart';

class SearchUserItem extends StatelessWidget {
  final User user;
  final Function? onPressed;

  const SearchUserItem({
    Key? key,
    required this.user,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onPressed != null) {
          onPressed!();
        }
        Navigator.pushNamed(context, Routes.profile,
            arguments: UserInfoAgrument(user));
      },
      child: Container(
        height: Dimens.size56,
        child: Row(
          children: [
            SizedBox(
              width: Dimens.size16,
            ),
            CircleNetworkImage(
              size: Dimens.size32,
              url: user.avatar,
            ),
            SizedBox(
              width: Dimens.size10,
            ),
            Expanded(
              child: Text(
                user.name!,
                style: textTheme(context).text15.medium.colorDart,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
