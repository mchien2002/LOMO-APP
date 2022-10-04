import 'package:flutter/material.dart';
import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/eventbus/refresh_dating_user_detail_event.dart';
import 'package:lomo/data/eventbus/reload_dating_list_event.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/dating/create_dating_profile/find_friend_create_dating_profile/find_friend_create_dating_profile_model.dart';
import 'package:lomo/ui/widget/button_widgets.dart';
import 'package:lomo/ui/widget/dialog_widget.dart';
import 'package:lomo/ui/widget/gender_widget.dart';
import 'package:lomo/ui/widget/role_widget.dart';
import 'package:lomo/ui/widget/sogiesc_list_widget.dart';
import 'package:lomo/ui/widget/step_tabbar_widget.dart';

class FindFriendCreateDatingProfileScreen extends StatefulWidget {
  final User user;
  FindFriendCreateDatingProfileScreen(this.user);
  @override
  State<StatefulWidget> createState() => _FindFriendCreateDatingProfileState();
}

class _FindFriendCreateDatingProfileState extends BaseState<
    FindFriendCreateDatingProfileModel, FindFriendCreateDatingProfileScreen> {
  @override
  void initState() {
    super.initState();
    model.init(widget.user);
  }

  @override
  Widget buildContentView(
      BuildContext context, FindFriendCreateDatingProfileModel model) {
    return Scaffold(
      appBar: StepAppBar(
        totalStep: 3,
        currentStep: 3,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      Strings.whoYouFind.localize(context),
                      style: textTheme(context).text22.colorDart.bold,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      Strings.selectAudiance.localize(context),
                      style: textTheme(context).text17.colorGray77,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    _buildGender(),
                    SizedBox(
                      height: 25,
                    ),
                    _buildSogiesc(),
                    SizedBox(
                      height: 30,
                    ),
                    // _buildRole(),
                    // SizedBox(
                    //   height: 20,
                    // ),
                  ],
                ),
              ),
            ),
            _buildButtonFinish(),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonFinish() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SafeArea(
        child: PrimaryButton(
          onPressed: () async {
            callApi(
                callApiTask: model.updateDatingProfile,
                onSuccess: () {
                  eventBus.fire(ReloadDatingListEvent());
                  eventBus.fire(RefreshDatingUserDetail());
                  showDialog(
                      context: context,
                      builder: (context) => TwoButtonDialogWidget(
                            title: Strings.complete.localize(context),
                            description:
                                Strings.datingProfileComplete.localize(context),
                            textConfirm: Strings.startNow.localize(context),
                            textCancel: Strings.myProfile.localize(context),
                            onConfirmed: () {
                              Navigator.popUntil(
                                  context, (route) => route.isFirst);
                            },
                            onCanceled: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pushReplacementNamed(
                                context,
                                Routes.datingUserDetail,
                                arguments: model.user,
                              );
                            },
                          ));
                });
          },
          text: Strings.complete.localize(context),
          enable: model.validateData,
        ),
      ),
    );
  }

  Widget _buildGender() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.findGender.localize(context),
          style: textTheme(context).text13.bold,
        ),
        SizedBox(
          height: 18,
        ),
        GenderWidget(
          selectedGender: model.selectedGender.value,
          textOther: Strings.both.localize(context),
          onGenderSelected: (gender) {
            model.selectedGender.value = gender;
            model.selectedSogiescList?.clear();
            model.isValidateData();
          },
        )
      ],
    );
  }

  Widget _buildSogiesc() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              Strings.sogiescLabel.localize(context),
              style: textTheme(context).text13.bold,
            ),
            InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                model.setSelectAllSogiesc.value = SelectAllEvent();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Text(
                  Strings.all.localize(context),
                  style: textTheme(context).text13.colorPrimary,
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        SogiescListWidget(
          model.selectedGender,
          setSelectAll: model.setSelectAllSogiesc,
          initSogiescSelected: model.selectedSogiescList,
          onSogiescSelected: (sogiesc) {
            model.selectedSogiescList = sogiesc;
            model.isValidateData();
          },
        ),
      ],
    );
  }

  Widget _buildRole() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.role.localize(context),
          style: textTheme(context).text13.bold,
        ),
        SizedBox(
          height: 18,
        ),
        RoleWidget(
          selectedRole: model.selectedRole,
          onRoleSelected: (role) {
            model.selectedRole = role;
            model.isValidateData();
          },
        )
      ],
    );
  }
}
