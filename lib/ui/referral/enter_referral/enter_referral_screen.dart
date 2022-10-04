import 'package:flutter/material.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/tracking/tracking_manager.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/base/base_model.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/referral/enter_referral/enter_referral_model.dart';
import 'package:lomo/ui/widget/button_widgets.dart';
import 'package:lomo/ui/widget/step_tabbar_widget.dart';
import 'package:lomo/ui/widget/text_form_field_widget.dart';

class EnterReferralScreen extends StatefulWidget {
  final bool isNewAccount;

  EnterReferralScreen({this.isNewAccount = true});

  @override
  State<StatefulWidget> createState() => _EnterReferralScreenState();
}

class _EnterReferralScreenState
    extends BaseState<EnterReferralModel, EnterReferralScreen> {
  @override
  void initState() {
    super.initState();
    model.init(widget.isNewAccount);
  }

  @override
  Widget buildContentView(BuildContext context, EnterReferralModel model) {
    return Scaffold(
      backgroundColor: getColor().white,
      appBar: model.isNewAccount
          ? StepAppBar(
              totalStep: 5,
              currentStep: 5,
              isShowButton: true,
            )
          : AppBar(
              elevation: 0,
              backgroundColor: getColor().white,
              leading: IconButton(
                icon: Image.asset(DImages.closex),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
      body: Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Image.asset(
                    DImages.referralLogo,
                    width: 200,
                    height: 120,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    Strings.enterReferralCode.localize(context),
                    style: textTheme(context).text22.bold.colorDart,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    Strings.enterReferralCodeDescription.localize(context),
                    style: textTheme(context).text15.colorGray77,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            ClearTextField(
              leftTitle: Strings.enterReferralCode.localize(context),
              hint: Strings.hintReferral.localize(context),
              keyboardType: TextInputType.text,
              controller: model.textCodeController,
              onChangedHandler: (text) {
                model.onChangedReferral(text);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 30, right: 30, bottom: 40),
        child: PrimaryButton(
          text: Strings.next.localize(context),
          enable: model.confirmEnable,
          onPressed: () async {
            final String referral = model.textCodeController.text;
            if (referral.isNotEmpty) {
              showLoading();
              await model.enterReferral(referral);
              if (model.progressState == ProgressState.success) {
                model.user?.isReferral = false;
                hideLoading();
                if (model.isNewAccount) {
                  locator<TrackingManager>()
                      .trackReferralEnterCodeStepRegister();
                  locator<UserModel>().setAuthState(AuthState.authorized);
                }
                model.isNewAccount
                    ? Navigator.popUntil(context, (route) => route.isFirst)
                    : Navigator.pop(context, false);
              } else {
                hideLoading();
                showError(model.errorMessage!.localize(context));
              }
            } else {
              if (model.isNewAccount)
                locator<UserModel>().setAuthState(AuthState.authorized);
              model.isNewAccount
                  ? Navigator.popUntil(context, (route) => route.isFirst)
                  : Navigator.pop(context, true);
            }
          },
        ),
      ),
    );
  }
}
