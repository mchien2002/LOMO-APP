import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName, {Object? arguments}) async {
    dynamic result;
    try {
      if (navigatorKey.currentState == null) {
        await Future.delayed(Duration(seconds: 1));
      }
      result = await navigatorKey.currentState!
          .pushNamed(routeName, arguments: arguments);
    } catch (e) {
      print("loiChuyenTrang");
      print(e);
    }
    return result;
  }
}
