import 'package:flutter/material.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';

import '../button_widgets.dart';

class EmptyFilterWidget extends StatelessWidget {
  final String? message;
  final String? btnTitle;
  final String? emptyImage;
  final Function onClicked;

  EmptyFilterWidget(
      {this.message, required this.onClicked, required this.btnTitle, required this.emptyImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: Dimens.size100),
      child: Column(
        children: [
          Image.asset(
            emptyImage ?? DImages.emptyDatingItem,
            width: (160 / 375) * MediaQuery.of(context).size.width,
            height: (160 / 375) * MediaQuery.of(context).size.width,
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: Dimens.size36,
                right: Dimens.size36,
                top: Dimens.size30,
                bottom: Dimens.size50),
            child: Text(
              message ?? Strings.noData.localize(context),
              style: textTheme(context).text14.colorDart.captionNormal,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: Dimens.size50, right: Dimens.size50),
            child: RoundedButton(
              text: btnTitle ?? Strings.textBtnEmptyDating.localize(context),
              textStyle: textTheme(context).text17.colorWhite.bold,
              onPressed: () {
                onClicked();
              },
              radius: Dimens.cornerRadius,
              color: getColor().violet,
            ),
          ),
        ],
      ),
    );
  }
}
