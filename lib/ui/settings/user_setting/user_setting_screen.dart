import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/settings/user_setting/user_setting_model.dart';

import '../../../app/app_model.dart';
import '../../../data/repositories/common_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../res/images.dart';
import '../../../res/strings.dart';
import '../../../res/theme/text_theme.dart';
import '../../../res/theme/theme_manager.dart';
import '../../base/base_state.dart';
import '../../widget/bottom_sheet_widgets.dart';
import '../privacy/custom_switch_privacy_widget.dart';
import '../settings_item.dart';

class UserSettingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StatefulWidgetState();
}

class _StatefulWidgetState
    extends BaseState<UserSettingModel, UserSettingScreen> {
  @override
  Widget buildContentView(BuildContext context, UserSettingModel model) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: getColor().colorviolet6FB,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Strings.system.localize(context),
                style: textTheme(context).text13.gray77,
              ),
              SizedBox(
                height: 8,
              ),
              _buildSystem(context),
              SizedBox(
                height: 20,
              ),
              if (locator<AppModel>().appConfig?.isVideo == true &&
                  locator<UserModel>().user?.isVideo == true)
                _buildVideo(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemSetting(String title, String iconResource, bool enable,
      Function(bool) onChanged) {
    return Container(
      color: getColor().transparent00Color,
      height: 50,
      child: Row(
        children: [
          SizedBox(
            width: 10,
          ),
          SizedBox(
            width: 26,
            height: 26,
            child: Image.asset(
              iconResource,
              color: getColor().primaryColor,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 1,
            child: Container(
              child:
                  Text(title, style: textTheme(context).text15.colorblack3dD),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          CustomSwitchPrivacyWidget(
            value: enable,
            activeColor: getColor().primaryColor,
            inactiveColor: getColor().gray2eaColor,
            onToggle: (val) {
              onChanged(val);
            },
          ),
          SizedBox(
            width: 15,
          ),
        ],
      ),
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
        Strings.newFeedSetting.localize(context),
        style: textTheme(context).text18.bold.colorDart,
      ),
      centerTitle: true,
    );
  }

  Widget _buildSystem(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          SettingWidget(
            onPressed: () async {
              AppSettings.openNotificationSettings();
            },
            leading: Image.asset(
              DImages.tabMessage,
              color: getColor().primaryColor,
            ),
            tittle: Strings.tabNotification.localize(context),
            subTittle: "",
          ),
          Divider(
            height: 1,
          ),
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

  Widget _buildVideo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.video.localize(context),
          style: textTheme(context).text13.gray77,
        ),
        SizedBox(
          height: 8,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              _buildItemSetting(
                  Strings.videoAutoplay.localize(context),
                  DImages.autoPlaySetting,
                  locator<UserModel>().userSetting.value?.isVideoAutoPlay ??
                      false, (checked) {
                setState(() {
                  locator<UserModel>()
                      .updateUserSetting(isVideoAutoPlay: checked);
                });
              }),
            ],
          ),
        ),
      ],
    );
  }
}
