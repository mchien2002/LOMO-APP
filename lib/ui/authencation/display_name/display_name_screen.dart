import 'package:flutter/material.dart';
import 'package:lomo/data/tracking/tracking_manager.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/widget/bottom_shadow_button_widget.dart';
import 'package:lomo/ui/widget/step_widget.dart';
import 'package:lomo/ui/widget/text_form_field_widget.dart';
import 'package:lomo/util/validate_utils.dart';

import 'display_name_model.dart';

class DisplayNameScreen extends StatefulWidget {
  @override
  _DisplayNameScreenState createState() => _DisplayNameScreenState();
}

class _DisplayNameScreenState
    extends BaseState<DisplayNameModel, DisplayNameScreen> {
  TextEditingController tecUserName = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();

  @override
  void initState() {
    tecUserName.addListener(() {
      model.confirmEnable.value = validateDisplayName(tecUserName.text);
    });
    super.initState();
    model.init();
  }

  @override
  Widget buildContentView(BuildContext context, DisplayNameModel model) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimens.size30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: Dimens.spacing60,
                    ),
                    StepWidget(
                      currentStep: 1,
                      totalStep: 5,
                    ),
                    SizedBox(
                      height: Dimens.spacing20,
                    ),
                    Image.asset(
                      DImages.nameDisplay,
                      width: Dimens.size200,
                      height: Dimens.size120,
                    ),
                    SizedBox(
                      height: Dimens.spacing15,
                    ),
                    Text(
                      Strings.display_name.localize(context),
                      style: textTheme(context).text22.bold.colorDart,
                    ),
                    SizedBox(
                      height: Dimens.spacing10,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        Strings.real_name.localize(context),
                        style: textTheme(context).text15.colorGray77,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: Dimens.spacing58,
                    ),
                    Form(
                      key: formGlobalKey,
                      child: ClearTextField(
                        hint: Strings.enterUserName.localize(context),
                        leftTitle: Strings.visibleName.localize(context),
                        controller: tecUserName,
                        maxLength: 30,
                        textStyle: textTheme(context).text19.light.colorPrimary,
                        errorStyle: textTheme(context).text14.colorPink88,
                        onValidated: (text) => !validateUserName(text!)
                            ? Strings.correct_format.localize(context)
                            : null,
                      ),
                    ),
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
            onPressed: saveProfile,
          ),
        ],
      ),
    );
  }

  saveProfile() async {
    if (formGlobalKey.currentState!.validate()) {
      model.user.name = tecUserName.text;
      Navigator.of(context).pushNamed(Routes.birthday, arguments: model.user);
      locator<TrackingManager>().trackRegisterName();
    }
  }

  @override
  void dispose() {
    tecUserName.dispose();
    super.dispose();
  }
}
