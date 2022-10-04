import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:lomo/app/app_model.dart';
import 'package:lomo/app/base_app_config.dart';
import 'package:lomo/data/api/models/notification_item.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/notification/notification_list/notification_list_screen.dart';
import 'package:lomo/util/local_notification_manager.dart';

class PushNotificationManager with HandleNotificationMixin {
  LocalNotificationManager? localNotificationManager;
  bool isInit = false;

  init() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    localNotificationManager = LocalNotificationManager();
    onReceiverMessage(getTopicName());
    await localNotificationManager?.init();
    isInit = true;
  }

  String getTopicName() {
    final server = locator<AppModel>().env;
    switch (server) {
      case Environment.dev:
        return "LOMO_DEV";
      case Environment.staging:
        return "LOMO_STAG";
      case Environment.prod:
        return "LOMO_PROD";
      default:
        return "LOMO_DEV";
    }
  }

  void onReceiverMessage(String topic) async {
    //FirebaseMessaging.instance.subscribeToTopic(topic);
    FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      await locator<AppModel>().saveFCMToken(token);
      await locator<AppModel>().submitFCMToken(fcmToken: token);
      print("Firebase onTokenRefresh token: $token");
    });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        var data = getNotificationData(message.data['ejson']);
        print("Firebase message: $data");
        if (data != null) {
          locator<AppModel>().updateNotificationInfo(data);
          Future.delayed(const Duration(seconds: 1), () {
            handleNotification(data);
          });
        }
      }
    });
    if (!isInit) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        try {
          var notification = _getNotification(message);
          var data = getNotificationData(message.data['ejson']);
          print("Firebase onMessage: $data");
          if (notification != null && notification.android != null)
            await localNotificationManager?.showNotification(
                notification.title, notification.body,
                payload: message.data['ejson'] ?? "");
          if (data != null) locator<AppModel>().updateNotificationInfo(data);
        } catch (e) {
          print(e);
        }
      });
      //Truong hop app chay background nhung chua tat han
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        var data = getNotificationData(message.data['ejson']);
        print("Firebase data: $data");
        if (data != null) {
          locator<AppModel>().updateNotificationInfo(data);
          Future.delayed(const Duration(seconds: 1), () {
            handleNotification(data);
          });
        }
      });
    }

    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      await locator<AppModel>().saveFCMToken(token);
      await locator<AppModel>().submitFCMToken(fcmToken: token);
      print("Firebase token: $token");
    }
  }

  RemoteNotification? _getNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    return notification ?? null;
  }
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

NotificationItem? getNotificationData(String ejson) {
  try {
    NotificationItem data;
    data = NotificationItem.fromJson(json.decode(ejson));
    return data;
  } catch (error) {
    print("LOMO_JSON_ERROR: $error ");
    return null;
  }
}
