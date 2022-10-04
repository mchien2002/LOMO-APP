import 'package:flutter/material.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/forgot_password/forgot_password_model.dart';
import 'package:lomo/ui/otp/otp_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends BaseState<ForgotPasswordModel, ForgotPasswordScreen> {
  @override
  Widget buildContentView(BuildContext context, ForgotPasswordModel model) {
    return Scaffold(
      appBar: AppBar(
        title: Text("forgot password"),
      ),
      body: Center(
        child: RaisedButton(
          child: Text("forgot password"),
          onPressed: () {
            Navigator.pushNamed(context, Routes.otp,
                arguments: OtpType.reset_password);
          },
        ),
      ),
    );
  }
}
