import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/profile/profile_manager/profile_edit/profile_edit_item.dart';
import 'package:lomo/ui/profile/profile_manager/profile_edit/profile_edit_model.dart';

class ProfileEditScreen extends StatefulWidget {
  final User user;

  const ProfileEditScreen(this.user);

  @override
  State<StatefulWidget> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState
    extends BaseState<ProfileEditModel, ProfileEditScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget buildContentView(BuildContext context, ProfileEditModel model) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        automaticallyImplyLeading: false,
        backgroundColor: getColor().white,
        elevation: 0,
        leading: InkWell(
          onTap: () async {
            Navigator.of(context).maybePop();
          },
          child: Icon(
            Icons.arrow_back_ios,
            size: 25,
            color: getColor().colorDart,
          ),
        ),
        title: Text(
          Strings.editProfile.localize(context),
          style: textTheme(context).text18.bold.colorDart,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Divider(
            thickness: 1.0,
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: Dimens.size30,
              right: Dimens.size30,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: Dimens.spacing10,
                ),
                ProfileEditItemWidget(
                  tittle: Strings.detailProfileFull.localize(context),
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.profileDetail);
                  },
                ),
                ProfileEditItemWidget(
                  tittle: Strings.onMyProfile.localize(context),
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.genderProfile,
                        arguments: widget.user);
                  },
                ),
                // ProfileEditItemWidget(
                //   tittle: Strings.relationship.localize(context),
                //   onPressed: () {},
                // ),
                ProfileEditItemWidget(
                  tittle: Strings.displaySetting.localize(context),
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.profilePrivacy);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
