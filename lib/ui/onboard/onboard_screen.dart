import 'package:flutter/material.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';

class OnBoardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RaisedButton(
              child: Text("login"),
              color: getColor().success,
              onPressed: () {
                Navigator.pushNamed(context, Routes.login);
              },
            ),
            SizedBox(
              height: 50,
            ),
            RaisedButton(
              color: getColor().buttonSmallText,
              child: Text("register"),
              onPressed: () {
                Navigator.pushNamed(context, Routes.register);
              },
            )
          ],
        ),
      ),
    );
  }
}
