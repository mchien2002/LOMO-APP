import 'package:flutter/material.dart';

class CircleAvatarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.blue,
      child: CircleAvatar(
        radius: 17,
        backgroundImage: AssetImage('assets/images/img_apple_health.png'),
      ),
    );
  }
}
