import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum Environment { dev, prod, staging }

setupStatusBar() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark));
}
