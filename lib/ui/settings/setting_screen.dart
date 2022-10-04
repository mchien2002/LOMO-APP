import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lomo/app/app_model.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/api/api_constants.dart';
import 'package:lomo/data/repositories/common_repository.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/settings/settings_item.dart';
import 'package:lomo/ui/update_information/update_info_require_screen.dart';
import 'package:lomo/ui/webview/webview_screen.dart';
import 'package:lomo/ui/widget/bottom_sheet_widgets.dart';
import 'package:lomo/util/common_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool referralEnable = locator<UserModel>().user!.isReferral;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: getColor().colorviolet6FB,
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
            DImages.backBlack,
            width: 32,
            height: 32,
          ),
        ),
      ),
      title: Text(
        Strings.settings.localize(context),
        style: textTheme(context).text18.bold.colorDart,
      ),
      centerTitle: true,
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildManageAccount(context),
            SizedBox(
              height: 20,
            ),
            // _buildLanguage(context),
            // SizedBox(
            //   height: 20,
            // ),
            _buildSettingAccount(context),
            Container(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  _buildAboutLomo(context),
                  Divider(
                    height: 1,
                  ),
                  SettingWidget(
                    onPressed: () async {
                      shareLink(REDIRECT_TO_STORE_LINK);
                    },
                    leading: Image.asset(DImages.settingShare),
                    tittle: Strings.shareLomo.localize(context),
                    subTittle: "",
                  ),
                  Column(
                    children: [
                      if (referralEnable)
                        Divider(
                          height: 1,
                        ),
                      if (referralEnable)
                        SettingWidget(
                          onPressed: () async {
                            final callback = await Navigator.pushNamed(
                                context, Routes.enterReferralCode,
                                arguments: false);
                            if (callback != null && callback == false) {
                              setState(() {
                                referralEnable = false;
                              });
                            }
                          },
                          leading: Image.asset(
                            DImages.referralGift,
                          ),
                          tittle:
                              Strings.collectReferralReward.localize(context),
                          subTittle: "",
                        ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  SettingWidget(
                    onPressed: () async {
                      await locator<UserModel>().logout();
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    leading: Image.asset(
                      DImages.settingLogout,
                      color: getColor().primaryColor,
                    ),
                    tittle: Strings.exit.localize(context),
                    subTittle: "",
                  ),
                ],
              ),
            ),
            Container(
              height: 20,
            ),
            Text(
              Strings.version.localize(context) +
                  locator<AppModel>().packageInfo.version,
              style: textTheme(context).text12.colorback95FB,
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManageAccount(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          SettingWidget(
            onPressed: () {
              final user = locator<UserModel>().user;
              Navigator.pushNamed(context, Routes.updateRequireProfile,
                  arguments: UpdateInfoRequireArguments(user!, isUpdate: true));
              // Navigator.pushNamed(context, Routes.editPersonalProfile,
              //     arguments: user);
            },
            leading: Image.asset(
              DImages.profileSetting,
              color: getColor().colorPrimary,
            ),
            tittle: Strings.accountManagement.localize(context),
          ),
          Divider(
            height: 1,
          ),
          SettingWidget(
            onPressed: () {
              final user = locator<UserModel>().user;
              Navigator.pushNamed(context, Routes.blockUser, arguments: user);
            },
            leading: Image.asset(
              DImages.listBlock,
              color: getColor().colorPrimary,
            ),
            tittle: Strings.blocklist.localize(context),
            subTittle: "",
          ),
          Divider(
            height: 1,
          ),
          SettingWidget(
            onPressed: () {
              Navigator.pushNamed(context, Routes.userSetting);
            },
            leading: Image.asset(
              DImages.settingCustomized,
              color: getColor().colorPrimary,
            ),
            tittle: Strings.customized.localize(context),
            subTittle: "",
          ),
        ],
      ),
    );
  }

  Widget _buildLanguage(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          BottomSheetMenuWidget(
            child: SettingWidget(
              leading: Image.asset(
                DImages.languageGray,
                color: getColor().colorPrimary,
              ),
              tittle: Strings.language.localize(context),
              subTittle:
                  locator<AppModel>().locale.languageCode.localize(context),
            ),
            items: [Strings.english, Strings.vietnamese],
            onItemClicked: (index) async {
              final appModel = locator<AppModel>();
              await appModel
                  .setLanguage(appModel.supportedLocales[index].languageCode);
              await locator<UserRepository>()
                  .getUserDetail(locator<UserModel>().user!.id!);
              locator<CommonRepository>().clearAllData();
              locator<UserModel>().updateUserInfo();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingAccount(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          SettingWidget(
            onPressed: () {
              Navigator.pushNamed(context, Routes.webView,
                  arguments: WebViewArguments(
                      url: Strings.aboutLomoLink.localize(context)));
            },
            leading: Image.asset(
              DImages.settingAboutLomo,
              color: getColor().colorPrimary,
            ),
            tittle: Strings.aboutLomo.localize(context),
            subTittle: "",
          ),
          Divider(
            height: 1,
          ),
          SettingWidget(
            onPressed: () {
              Navigator.pushNamed(context, Routes.webView,
                  arguments: WebViewArguments(
                      url: Strings.termLink.localize(context)));
            },
            leading: Image.asset(
              DImages.settingTerm,
              color: getColor().colorPrimary,
            ),
            tittle: Strings.rules.localize(context),
            subTittle: "",
          ),
          Divider(
            height: 1,
          ),
          SettingWidget(
            onPressed: () {
              Navigator.pushNamed(context, Routes.webView,
                  arguments:
                      WebViewArguments(url: Strings.faqLink.localize(context)));
            },
            leading: Image.asset(
              DImages.faqs,
              color: getColor().colorPrimary,
            ),
            tittle: Strings.frequentlyAskedQuestions.localize(context),
            subTittle: "",
          ),
          Divider(
            height: 1,
          ),
          SettingWidget(
            onPressed: () {
              final Uri _emailLaunchUri = Uri(
                  scheme: 'mailto',
                  path: Strings.info.localize(context),
                  queryParameters: {'subject': ''});
              launch(_emailLaunchUri.toString());
            },
            leading: Image.asset(
              DImages.settingSupport,
              color: getColor().colorPrimary,
            ),
            tittle: Strings.support.localize(context),
            subTittle: Strings.info.localize(context),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutLomo(BuildContext context) {
    return SettingWidget(
      onPressed: () async {
        try {
          bool launched = await launch(
              Platform.isAndroid
                  ? FACEBOOK_PROTOCOL_ANDROID_LINK
                  : FACEBOOK_PROTOCOL_IOS_LINK,
              forceSafariVC: false);

          if (!launched) {
            await launch(FACEBOOK_FAN_PAGE_LINK, forceSafariVC: false);
          }
        } catch (e) {
          await launch(FACEBOOK_FAN_PAGE_LINK, forceSafariVC: false);
        }
      },
      leading: Image.asset(
        DImages.followFacebook,
      ),
      tittle: Strings.follow_lomo.localize(context),
      subTittle: "",
    );
  }
}
