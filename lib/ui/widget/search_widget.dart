import 'package:flutter/material.dart';
import 'package:lomo/res/dimens.dart';

class ItemListSearchWidget extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget? trailing;
  final Function()? onPressed;

  const ItemListSearchWidget({
    Key? key,
    required this.leading,
    required this.title,
    this.trailing,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: Dimens.size56,
        child: Row(
          children: [
            SizedBox(
              width: Dimens.size16,
            ),
            leading,
            SizedBox(
              width: Dimens.size10,
            ),
            Expanded(
              flex: 6,
              child: Container(
                child: title,
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                child: trailing,
              ),
            ),
            SizedBox(
              width: Dimens.size16,
            ),
          ],
        ),
      ),
    );
  }
}
