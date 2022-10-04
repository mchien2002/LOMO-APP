import 'package:flutter/material.dart';
import 'package:lomo/res/theme/theme_manager.dart';

class CreateDatingProfileAppBar extends StatelessWidget {
  final int step;
  CreateDatingProfileAppBar({this.step = 1});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: 32,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: getColor().colorDart,
                    size: 22,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 8,
                width: 100,
                color: getColor().colorError,
              ),
            )
          ],
        ),
      ),
    );
  }
}
