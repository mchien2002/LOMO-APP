import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/widget/button_widgets.dart';
import 'package:lomo/ui/widget/dotter_borer_widget.dart';
import 'package:lomo/util/common_utils.dart';
import 'package:lomo/util/handle_link_util.dart';

class ShareReferralScreen extends StatelessWidget {
  const ShareReferralScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: getColor().white,
      appBar: _buildAppBar(context),
      body: _buildContent(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: getColor().white,
      elevation: 0,
      leading: Padding(
        padding: EdgeInsets.only(left: 16),
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset(
            DImages.closex,
            width: 32,
            height: 32,
          ),
        ),
      ),
      centerTitle: true,
    );
  }

  _buildContent(BuildContext context) {
    double widthItemIg = (265 / 375) * MediaQuery.of(context).size.width;
    double heightItemIg = widthItemIg * (160 / 265);
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
            Image.asset(
              DImages.candyBg,
              height: heightItemIg,
              width: widthItemIg,
              // color:getColor().transparent ,
            ),
            SizedBox(
              height: 25,
            ),
            Text(
              Strings.get_20_free_candies.localize(context),
              style: textTheme(context).text22.bold.colorBlack00,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              Strings.when_friend_sign_in_lomo.localize(context),
              style: textTheme(context).text16.medium.colorBlack00,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: 20,
            ),
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                    text: Strings.when_friend_sign_in_1.localize(context),
                    style: textTheme(context).text14.colorBlack00,
                  ),
                  TextSpan(
                    text: Strings.when_friend_sign_in_2.localize(context),
                    style: textTheme(context).text14.bold.colorBlack00,
                  ),
                  TextSpan(
                    text: Strings.when_friend_sign_in_3.localize(context),
                    style: textTheme(context).text14.colorBlack00,
                  ),
                ])),
            SizedBox(
              height: 25,
            ),
            Container(
              height: 50,
              margin: EdgeInsets.only(left: 0, right: 0),
              child: PrimaryButton(
                suffixIcon: Image.asset(
                  DImages.inviteFr,
                  height: 24,
                  width: 24,
                  color: getColor().white,
                ),
                text: Strings.invite_friends.localize(context),
                textUpperCase: false,
                onPressed: () async {
                  HandleLinkUtil()
                      .shareReferral("${locator<UserModel>().user!.id}}");
                },
              ),
            ),
            SizedBox(
              height: 25,
            ),
            DotterBoderWidget(
              onPress: () {
                if (HandleLinkUtil()
                    .getShareReferral("${locator<UserModel>().user?.lomoId}")
                    .isNotEmpty) {
                  Clipboard.setData(ClipboardData(
                          text: "${locator<UserModel>().user?.lomoId}"))
                      .then((_) {
                    showToast(Strings.copySuccess.localize(context));
                  });
                }
              },
              data: "${locator<UserModel>().user?.lomoId}",
            ),
          ],
        ),
      ),
    );
  }
}
