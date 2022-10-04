import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/otp/otp_screen.dart';
import 'package:lomo/ui/register/register_model.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends BaseState<RegisterModel, RegisterScreen> {
  @override
  Widget buildContentView(BuildContext context, RegisterModel model) {
    return Scaffold(
      appBar: AppBar(
        title: Text("register"),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RaisedButton(
              color: getColor().success,
              child: Text("register"),
              onPressed: () async {
                await model.register();
                Navigator.pushNamed(context, Routes.otp,
                    arguments: OtpType.register);
              },
            )
          ],
        ),
      ),
    );
  }
}
