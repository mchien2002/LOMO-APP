import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/tracking/tracking_manager.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/widget/bottom_shadow_button_widget.dart';
import 'package:lomo/ui/widget/gender_widget.dart';
import 'package:lomo/ui/widget/sogiesc_list_widget.dart';
import 'package:lomo/ui/widget/step_widget.dart';

import 'gender_model.dart';

class GenderScreen extends StatefulWidget {
  final User user;

  GenderScreen(this.user);

  @override
  _GenderScreenState createState() => _GenderScreenState();
}

class _GenderScreenState extends BaseState<GenderModel, GenderScreen> {
  @override
  void initState() {
    super.initState();
    model.init(widget.user);
  }

  @override
  Widget buildContentView(BuildContext context, GenderModel model) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: getColor().white,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leading: Padding(
          padding: const EdgeInsets.only(left: Dimens.size16),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset(
              DImages.backBlack,
              height: Dimens.size32,
              width: Dimens.size32,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: Dimens.paddingBodyContent),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StepWidget(
                      currentStep: 3,
                      totalStep: 5,
                    ),
                    SizedBox(
                      height: Dimens.spacing10,
                    ),
                    Image.asset(
                      DImages.gender,
                      width: Dimens.size200,
                      height: Dimens.size120,
                    ),
                    SizedBox(
                      height: Dimens.spacing15,
                    ),
                    Text(
                      Strings.your_gender.localize(context),
                      style: textTheme(context).text22.bold.colorDart,
                    ),
                    SizedBox(
                      height: Dimens.spacing10,
                    ),
                    Text(
                      Strings.find_you_based.localize(context),
                      style: textTheme(context).text15.colorGray77,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: Dimens.spacing30,
                    ),
                    _buildGender(),
                    SizedBox(
                      height: Dimens.spacing40,
                    ),
                    Text(
                      Strings.choose_the_right.localize(context),
                      style: textTheme(context).text17.bold.colorPrimary,
                    ),
                    SizedBox(
                      height: Dimens.spacing5,
                    ),
                    Text(
                      Strings.choose_rainbow.localize(context),
                      style: textTheme(context).text13.colorff6d6e79,
                    ),
                    SizedBox(
                      height: Dimens.spacing20,
                    ),
                    _buildSogiesc(),
                    SizedBox(
                      height: Dimens.spacing30,
                    ),
                  ],
                ),
              ),
            ),
          ),
          BottomOneButton(
            text: Strings.next.localize(context),
            enable: model.confirmEnable,
            onPressed: () {
              model.user.gender = model.selectedGender.value;
              model.user.sogiescs = model.selectedSogiescList;
              Navigator.of(context)
                  .pushNamed(Routes.image, arguments: model.user);
              locator<TrackingManager>().trackRegisterSogiesc();
            },
          )
        ],
      ),
    );
  }

  isValidateData() {
    model.confirmEnable.value = model.selectedGender.value != null &&
        model.selectedSogiescList.isNotEmpty == true;
  }

  Widget _buildGender() {
    return GenderWidget(
      onGenderSelected: (gender) {
        model.selectedGender.value = gender;
        isValidateData();
      },
    );
  }

  Widget _buildSogiesc() {
    return SogiescListWidget(
      model.selectedGender,
      maxItemSelected: 3,
      onSogiescSelected: (sogiesc) {
        if (sogiesc?.isNotEmpty == true)
          model.selectedSogiescList = sogiesc!;
        else
          model.selectedSogiescList.clear();
        isValidateData();
      },
    );
  }
}
