import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lomo/res/colors.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/base/base_model.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/webview/webview_screen.dart';
import 'package:lomo/ui/widget/count_down_timer_widget.dart';
import 'package:lomo/ui/widget/pin_code_fields.dart';
import 'package:lomo/ui/widget/stroke_state_button_widget.dart';

import 'otp_model.dart';

class OtpScreen extends StatefulWidget {
  final OtpType otpType;
  OtpScreen({this.otpType = OtpType.register});
  @override
  State<StatefulWidget> createState() => _OtpScreenState();
}

class _OtpScreenState extends BaseState<OtpModel, OtpScreen> {
  TextEditingController textEditingController = TextEditingController();
  bool hasError = false;
  String currentText = "";

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    model.init(widget.otpType);
  }

  @override
  Widget buildContentView(BuildContext context, OtpModel model) {
    return Scaffold(
      backgroundColor: getColor().white,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [_buildContent(), _buildBottomPolicy()],
        ),
      ),
    );
  }

  Widget _buildBottomPolicy() {
    return Positioned(
      left: Dimens.paddingBodyContent + 30,
      right: Dimens.paddingBodyContent + 30,
      bottom: 30,
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
                text: Strings.confirmPolicy.localize(context),
                style: textTheme(context).text12.colorGray),
            TextSpan(
              text: Strings.policy.localize(context),
              style: textTheme(context).text12.bold,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pushNamed(context, Routes.webView,
                      arguments: WebViewArguments(
                          url: Strings.termLink.localize(context)));
                },
            ),
            TextSpan(
                text: Strings.useTo.localize(context),
                style: textTheme(context).text12.colorGray),
            TextSpan(
              text: Strings.lomo.localize(context),
              style: textTheme(context).text12.bold,
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimens.paddingBodyContent),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: Dimens.spacing32,
            ),
            Text(
              Strings.confirmOtp.localize(context),
              style: textTheme(context).text22.bold.colorDart,
            ),
            SizedBox(
              height: Dimens.spacing10,
            ),
            _buildTitleConfirmOtp(),
            SizedBox(
              height: Dimens.spacing15,
            ),
            Center(
              child: CountDownTimerWidget(
                start: 60,
                reload: model.timerNotifier,
                endCountDown: () {
                  model.enableResendOtp.value = true;
                },
              ),
            ),
            SizedBox(
              height: Dimens.spacing18,
            ),
            _buildPinCode(),
            SizedBox(
              height: Dimens.spacing23,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                  hasError == true
                      ? Strings.authentication_code_incorrect.localize(context)
                      : "",
                  style: textTheme(context).text14Normal.colorPink88),
            ),
            SizedBox(
              height: Dimens.spacing23,
            ),
            _buildResendOtpChangePhone()
          ],
        ),
      ),
    );
  }

  Widget _buildTitleConfirmOtp() {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
              text: Strings.otpSentToPhone.localize(context),
              style: textTheme(context).text17.colorGray77),
          TextSpan(
              text: model.formatPhoneOtp(model.phone),
              style: textTheme(context).text17.colorGray77.bold),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildPinCode() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: PinCodeTextField(
          autoDisposeControllers: false,
          autoFocus: true,
          textInputType: TextInputType.number,
          enabled: true,
          textStyle: hasError == true
              ? textTheme(context).text24.colorPink88
              : textTheme(context).text24.colorPrimary,
          pastedTextStyle: textTheme(context).text24.colorDart,
          length: 6,
          obsecureText: false,
          animationType: AnimationType.scale,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.underline,
            borderRadius: BorderRadius.circular(5),
            fieldHeight: 50,
            fieldWidth: 40,
            activeColor:
                hasError == true ? DColors.pinkColor88 : DColors.primaryColor,
            activeFillColor: hasError ? Colors.orange : Colors.white,
          ),
          animationDuration: Duration(milliseconds: 300),
//                      backgroundColor: Colors.blue.shade50,
          enableActiveFill: false,
          controller: textEditingController,
          onCompleted: (v) {
            _sendOtp(v);
          },
          onTap: () {
            print("Pressed");
          },
          onChanged: (value) {
            print(value);
            currentText = value;
            if (currentText.length == 6) {
              setState(() {
                // hasError = true;
              });
            } else {
              setState(() {
                hasError = false;
              });
            }
          },
          beforeTextPaste: (text) {
            return true;
          },
        ));
  }

  Widget _buildResendOtpChangePhone() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StrokeStateButton(
          enable: model.enableResendOtp,
          width: 130,
          height: 32,
          radius: 18.0,
          borderColor: getColor().colorDart,
          disableBorderColor: getColor().colorGray,
          text: Strings.reSentOtp.localize(context),
          textStyle: textTheme(context).text13.bold.colorDart,
          disableTextStyle: textTheme(context).text14Bold.colorGray,
          onPressed: () async {
            callApi(callApiTask: () async {
              await model.reSentOtp();
            }, onSuccess: () {
              model.timerNotifier.value = Object();
              model.enableResendOtp.value = false;
              textEditingController.text = "";
            });
          },
        ),
        ChangePhoneText(
          enable: model.enableResendOtp,
          onPressed: () {
            Navigator.of(context).pop();
          },
          text: Strings.changePhone.localize(context),
          textStyle: textTheme(context).text15.bold.colorDart,
          disableTextStyle: textTheme(context).text14Bold.colorGray,
        ),
        // GestureDetector(
        //   onTap: () {
        //     if (model.enableResendOtp.value = true) {
        //       Navigator.of(context).pop();
        //     }
        //   },
        //   child: Text(
        //     Strings.changePhone.localize(context),
        //     style: textTheme(context).text15.bold.colorDart,
        //   ),
        // ),
      ],
    );
  }

  _sendOtp(String otp) async {
    showLoading();
    await model.confirmOtp(otp);
    if (model.progressState == ProgressState.success) {
      hideLoading();
      Navigator.of(context).popUntil((route) => route.isFirst);
      setState(() {
        hasError = false;
      });
    } else if (model.progressState == ProgressState.error) {
      hideLoading();
      setState(() {
        hasError = true;
      });
      // textEditingController.text = "";
      // showError(model.errorMessage.localize(context));
    }
  }
}

enum OtpType { register, reset_password }
