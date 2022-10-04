import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/login/login_model.dart';
import 'package:lomo/ui/otp/otp_screen.dart';
import 'package:lomo/ui/widget/button_widgets.dart';
import 'package:lomo/ui/widget/dialog_widget.dart';
import 'package:lomo/ui/widget/text_form_field_widget.dart';
import 'package:lomo/util/permission_handle_manager.dart';
import 'package:lomo/util/platform_channel.dart';
import 'package:lomo/util/validate_utils.dart';

import '../../util/constants.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends BaseState<LoginModel, LoginScreen> {
  TextEditingController _tecConfirm = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tecConfirm.addListener(() {
      model.confirmEnable.value = validatePhone(_tecConfirm.text);
    });
    Future.delayed(Duration(seconds: 1), () {
      requestPermission();
    });
  }

  requestPermission() async {
    await locator<PermissionHandleManager>().requestPermissionApp(context);
    if (Platform.isAndroid) {
      locator<PlatformChannel>().checkPermissionCall();
    }
  }

  @override
  Widget buildContentView(BuildContext context, LoginModel model) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: getColor().white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimens.size30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // SizedBox(
              //   height: 30,
              // ),
              Image.asset(
                DImages.logo,
                width: 90,
                height: 90,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                Strings.hello.localize(context),
                style: textTheme(context).text22.bold.colorDart,
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Text(
                  Strings.number_to_register.localize(context),
                  style: textTheme(context).text15.colorGray77.captionNormal,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              ClearTextField(
                hint: Strings.enterPhoneNumber.localize(context),
                leftTitle: Strings.phoneNumber.localize(context),
                maxLength: 10,
                keyboardType: TextInputType.phone,
                controller: _tecConfirm,
              ),
              SizedBox(height: 52),
              PrimaryButton(
                text: Strings.next.localize(context),
                enable: model.confirmEnable,
                onPressed: () async {
                  callApi(callApiTask: () async {
                    await model.login(_tecConfirm.text);
                  }, onSuccess: () {
                    Navigator.of(context)
                        .pushNamed(Routes.otp, arguments: OtpType.register);
                  }, onFail: () {
                    if (model.apiErrorCod == ApiCodType.userDeactivated) {
                      showDialog(
                        context: context,
                        builder: (_) => TwoButtonDialogWidget(
                          title:
                              Strings.accountHasBeenDisable.localize(context),
                          description: Strings.accountDisableDescription
                              .localize(context),
                          textConfirm: Strings.enable.localize(context),
                          onConfirmed: () {
                            activeAccount(_tecConfirm.text);
                          },
                          textCancel: Strings.cancel.localize(context),
                        ),
                      );
                    } else if (model.apiErrorCod == ApiCodType.userDeleted) {
                      showDialog(
                        context: context,
                        builder: (_) => OneButtonDialogWidget(
                          title:
                              Strings.accountHasBeenDeleted.localize(context),
                          description: Strings.accountDeletedDescription
                              .localize(context),
                          textConfirm: Strings.close.localize(context),
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (_) => OneButtonDialogWidget(
                          description: model.errorMessage?.localize(context),
                          textConfirm: Strings.close.localize(context),
                        ),
                      );
                    }
                  });
                },
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  activeAccount(String phone) {
    callApi(callApiTask: () async {
      await model.login(phone, active: true);
    }, onSuccess: () {
      Navigator.of(context).pushNamed(Routes.otp, arguments: OtpType.register);
    });
  }

  @override
  void dispose() {
    _tecConfirm.dispose();
    super.dispose();
  }
}
