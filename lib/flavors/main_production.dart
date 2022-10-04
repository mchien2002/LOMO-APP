import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lomo/app/app_model.dart';
import 'package:lomo/app/base_app_config.dart';
import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/app/push_notification_manager.dart';
import 'package:lomo/di/locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await Future.wait([initFirebase(), initAppModel()]);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  setupStatusBar();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(LomoApp()));
}

Future<void> initFirebase() async {
  await Firebase.initializeApp();
}

Future<void> initAppModel() async {
  await locator<AppModel>().init(Environment.prod);
}
