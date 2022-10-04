import 'package:flutter/material.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';

class ProfileEditItemWidget extends StatelessWidget {
  final String tittle;
  final Function onPressed;

  const ProfileEditItemWidget({
    Key? key,
    required this.tittle,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPressed();
      },
      splashColor: Colors.transparent,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: Dimens.size16,
              bottom: Dimens.size16,
            ),
            child: Row(
              children: [
                Text(
                  tittle,
                  style: textTheme(context).text15.colorDart.medium,
                ),
                Spacer(),
                Icon(
                  Icons.edit,
                  color: getColor().violet,
                  size: Dimens.size20,
                ),
              ],
            ),
          ),
          Divider(
            thickness: 1.0,
          ),
        ],
      ),
    );
  }
}
