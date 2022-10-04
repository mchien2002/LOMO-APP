import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';

class ReferralItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Divider(
            height: 3,
            color: getColor().bottomLineTextField,
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Strings.inviteFrendUseLomo.localize(context),
                    style: textTheme(context).text13.medium.darkTextColor,
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    Strings.inviteFrendUseLomoDescription.localize(context),
                    style: textTheme(context).text11.colorGray77,
                  )
                ],
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, Routes.inviteFriend);
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  height: 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: getColor().primaryColor,
                    ),
                  ),
                  child: Text(
                    Strings.btnInviteFrend.localize(context),
                    style: textTheme(context).text14.colorPrimary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
