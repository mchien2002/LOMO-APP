import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/profile/profile_manager/profile_gender/profile_gender_model.dart';
import 'package:lomo/ui/widget/bottom_shadow_button_widget.dart';
import 'package:lomo/ui/widget/dialog_widget.dart';
import 'package:lomo/ui/widget/dropdown_button_widget.dart';
import 'package:lomo/ui/widget/gender_widget.dart';
import 'package:lomo/ui/widget/role_widget.dart';
import 'package:lomo/ui/widget/sogiesc_list_widget.dart';

class ProfileGenderScreen extends StatefulWidget {
  final User user;

  const ProfileGenderScreen(this.user);

  @override
  State<StatefulWidget> createState() => _ProfileGenderScreenState();
}

class _ProfileGenderScreenState
    extends BaseState<ProfileGenderModel, ProfileGenderScreen> {
  @override
  void initState() {
    super.initState();
    model.init();
  }

  @override
  Widget buildContentView(BuildContext context, ProfileGenderModel model) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        automaticallyImplyLeading: false,
        backgroundColor: getColor().white,
        elevation: Dimens.spacing2,
        leading: InkWell(
          onTap: () async {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            size: Dimens.size24,
            color: getColor().colorDart,
          ),
        ),
        title: Text(
          Strings.onMyProfile.localize(context),
          style: textTheme(context).text18.bold.colorDart,
        ),
        centerTitle: true,
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
            child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
                left: Dimens.size30, right: Dimens.size30),
            child: Column(
              children: [
                SizedBox(
                  height: Dimens.size20,
                ),
                _buildTitle(),
                SizedBox(
                  height: Dimens.size25,
                ),
                _buildGender(),
                SizedBox(
                  height: Dimens.size25,
                ),
                _buildSogiesc(),
                SizedBox(
                  height: Dimens.size25,
                ),
                _buildRole(),
                SizedBox(
                  height: Dimens.size40,
                ),
              ],
            ),
          ),
        )),
        _buildButtonFinish(),
      ],
    );
  }

  Widget _buildGender() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              Strings.your_gender.localize(context),
              style: textTheme(context).text13.bold,
            ),
            // TargetWidget(),
          ],
        ),
        SizedBox(
          height: Dimens.size18,
        ),
        GenderWidget(
          selectedGender: model.selectedGender.value,
          onGenderSelected: (gender) {
            model.selectedGender.value = gender;
            model.selectedSogiescList.clear();
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
          children: [
            Text(
              Strings.sogiescLabel.localize(context),
              style: textTheme(context).text13.bold,
            ),
            // TargetWidget(),
          ],
        ),
        SizedBox(
          height: Dimens.size15,
        ),
        SogiescListWidget(
          model.selectedGender,
          setSelectAll: model.setSelectAllSogiesc,
          initSogiescSelected: model.selectedSogiescList,
          maxItemSelected: 3,
          onSogiescSelected: (sogiesc) {
            model.selectedSogiescList = sogiesc!;
            model.isValidateData();
          },
        ),
      ],
    );
  }

  Widget _buildButtonFinish() {
    return BottomOneButton(
      onPressed: () async {
        showLoading();
        callApi(
            callApiTask: model.updateDatingProfile,
            onSuccess: () {
              updateSuccess();
            },
            onFail: () {
              showError(model.errorMessage!.localize(context));
            });
      },
      text: Strings.save.localize(context),
      enable: model.validateData,
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
            model.selectedRole = role!;
            model.isValidateData();
          },
        )
      ],
    );
  }

  Widget _buildTitle() {
    return DropDownListWidget(
      titleDropdown: Strings.titleName.localize(context),
      titleContentPopUp: Strings.titleName.localize(context),
      initValue: model.user.title?.name?.localize(context) ?? null,
      items: model.commonRepository.listTitle.map((e) => e.name!).toList(),
      onSelected: (index) {
        model.selectedTitle = model.commonRepository.listTitle[index];
        model.isValidateData();
      },
    );
  }

  updateSuccess() {
    showDialog(
        context: context,
        builder: (context) => OneButtonDialogWidget(
              description: Strings.success.localize(context),
              textConfirm: Strings.close.localize(context),
              onConfirmed: () {
                Navigator.pop(context);
              },
            ),
        barrierDismissible: false);
  }
}
