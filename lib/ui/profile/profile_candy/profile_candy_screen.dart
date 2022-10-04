import 'package:flutter/material.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/colors.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/checkin/list_checkin_screen.dart';
import 'package:lomo/ui/gift/list_gift_screen.dart';
import 'package:lomo/ui/profile/profile_candy/gradient_appbar.dart';
import 'package:lomo/ui/profile/profile_candy/profile_candy_model.dart';
import 'package:lomo/ui/widget/image_widget.dart';
import 'package:provider/provider.dart';

import '../../../data/api/models/user.dart';

class ProfileCandyScreen extends StatefulWidget {
  ProfileCandyScreen();

  @override
  _ProfileCandyScreenState createState() => _ProfileCandyScreenState();
}

class _ProfileCandyScreenState
    extends BaseState<ProfileCandyModel, ProfileCandyScreen>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<ProfileCandyScreen> {
  double statusbarHeight = 0.0;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return buildContent();
  }

  @override
  void initState() {
    super.initState();
    model.init();
  }

  @override
  Widget buildContentView(BuildContext context, ProfileCandyModel model) {
    statusbarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
        body: Stack(
      children: [
        Container(
          height: 155 + statusbarHeight,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [getColor().violet, getColor().pinkColor],
                begin: Alignment.centerLeft,
                end: Alignment.bottomRight,
                tileMode: TileMode.clamp,
              ),
              borderRadius: BorderRadius.only(
                  bottomLeft: const Radius.circular(20),
                  bottomRight: const Radius.circular(20))),
        ),
        GradientAppBar(Strings.mybag.localize(context)),
        _userInfoLayout(),
        Container(
          margin: EdgeInsets.only(top: 155 + statusbarHeight),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListCheckinScreen(),
                _bearInfoGifts(),
                ListGiftScreen(),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        )
      ],
    ));
  }

  Widget _userInfoLayout() {
    return Container(
      height: 105,
      margin: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 20,
        top: 50 + statusbarHeight,
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ChangeNotifierProvider.value(
          value: locator<UserModel>(),
          child: Consumer<UserModel>(
            builder: (context, userModel, child) => Row(
              children: [
                _userAvatarLayout(userModel.user),
                _candyInfoLayout(userModel.user),
                // Spacer(),
                // _addCandyLayout()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _userAvatarLayout(User? user) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [DColors.pinkColor, DColors.violetColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            tileMode: TileMode.clamp,
          ),
          borderRadius: BorderRadius.all(const Radius.circular(70))),
      child: Center(
        child: CircleNetworkImage(
          url: user?.avatar ?? "",
          size: 55,
        ),
      ),
    );
  }

  Widget _candyInfoLayout(User? user) {
    return Container(
      margin: EdgeInsets.only(left: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            Strings.mycandy.localize(context),
            style: textTheme(context).text14Normal.colorWhite,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                user?.numberOfCandy?.toString() ?? "",
                style: textTheme(context).text28Bold.colorWhite,
              ),
              Image.asset(
                DImages.candy,
                width: 32,
                height: 32,
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _bearInfoGifts() {
    return ChangeNotifierProvider.value(
      value: locator<UserModel>(),
      child: Consumer<UserModel>(
        builder: (context, userModel, child) => Padding(
          padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
          child: Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: getColor().colorDivider),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Image.asset(
                  DImages.bearWhite,
                  color: getColor().violet,
                  width: 32,
                  height: 32,
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                    child: Text(
                  Strings.bearGifts.localize(context),
                  style: textTheme(context).text16.bold.colorDart,
                )),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "${userModel.user?.numberOfBear ?? 0}",
                  style: textTheme(context).text16.captionNormal.colorDart,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
