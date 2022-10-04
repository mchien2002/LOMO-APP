import 'package:flutter/material.dart';
import 'package:lomo/data/api/api_constants.dart';
import 'package:lomo/data/api/models/notification_item.dart';
import 'package:lomo/data/api/services/notification_service.dart';
import 'package:lomo/data/preferences/preferences.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/util/AppsflyerUtil.dart';
import 'package:lomo/util/platform_channel.dart';

import 'base_repository.dart';

class NotificationRepository extends BaseRepository {
  final _notificationService = locator<NotificationService>();

  final ValueNotifier<int> badgeNotificationTabIcon = ValueNotifier(0);
  final ValueNotifier<int> badgeNotification = ValueNotifier(0);
  final ValueNotifier<int> badgeChatNotification = ValueNotifier(0);

  bool isOnTabNotification = false;

  init() {
    badgeNotification.addListener(() {
      if (!isOnTabNotification) {
        badgeNotificationTabIcon.value = badgeNotification.value;
      } else {
        badgeNotificationTabIcon.value = 0;
      }
    });
  }

  setBadge(int badge, {bool isSaveLocal = true}) async {
    badgeNotification.value = badge;
    if (isSaveLocal) await Preferences.setBadge(badgeNotification.value);
  }

  Future<int> getBadge() async {
    badgeNotification.value = await Preferences.getBadge();
    return badgeNotification.value;
  }

  setBadgeChat(int badge) async {
    badgeChatNotification.value = badge;
    await Preferences.setBadgeChat(badgeChatNotification.value);
  }

  Future<int> getBadgeChat() async {
    badgeChatNotification.value = await Preferences.getBadgeChat();
    return badgeChatNotification.value;
  }

  Future<int> getNumberBadgesOfChat() async {
    int numBadges = 0;
    try {
      numBadges = await locator<PlatformChannel>().getNumbersOfBadgesChat();
      setBadgeChat(numBadges);
    } catch (e) {}
    return numBadges;
  }

  saveFCMToken(String token) async {
    await Preferences.setFCMToken(token);
  }

  Future<bool> isSendFCMToken() async {
    return Preferences.isSendFCMToken();
  }

  setSendFCMToken(bool isSent) async {
    await Preferences.setSendFCMToken(isSent);
  }

  Future<String?> getFCMToken() async {
    return Preferences.getFCMToken();
  }

  submitFCMToken({String? fcmToken}) async {
    try {
      if (fcmToken == null) {
        fcmToken = await getFCMToken();
      }
      await _notificationService.submitFCMToken(fcmToken!);
      locator<AppsflyerUtil>().updateServerUninstallToken(fcmToken);
    } catch (e) {
      print(e);
    }
  }

  Future<List<NotificationItem>?> getListNotification(
      {int page = 1, int limit = PAGE_SIZE, String? idType}) async {
    final response = await _notificationService.getListNotification(
        page: page, limit: limit, idType: idType);
    if (idType == null && !isOnTabNotification) {
      setBadge(response!.undRead!);
    }
    return response!.list;
  }

  Future<void> readNotification(String id) async {
    await _notificationService.readNotification(id);
    if (badgeNotification.value > 0) badgeNotification.value--;
  }

  Future<void> readAllNotification() async {
    await _notificationService.readNotification("multi");
    badgeNotification.value = 0;
  }

  Future<void> deleteNotification(String id, bool isRead) async {
    await _notificationService.deleteNotification(id);
    if (!isRead) {
      if (badgeNotification.value > 0) badgeNotification.value--;
    }
  }

  Future<NotificationItem> getNotificationDetail(String id) =>
      _notificationService.getNotificationDetail(id);
}
