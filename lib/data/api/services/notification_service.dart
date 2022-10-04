import 'dart:io';

import 'package:lomo/app/app_model.dart';
import 'package:lomo/data/api/api_constants.dart';
import 'package:lomo/data/api/models/filter_request_item.dart';
import 'package:lomo/data/api/models/notification_item.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/util/device_util.dart';
import 'package:sprintf/sprintf.dart';

import '../api_constants.dart';
import 'base_service.dart';

class NotificationService extends BaseService {
  Future<NotificationResponse?> getListNotification({int? page, int? limit, String? idType}) async {
    try {
      final response = await get(
        LIST_NOTIFICATION_PAGING,
        params: GetQueryParam(page: page, limit: limit, filters: [
          if (idType != null) FilterRequestItem(key: "type", value: idType),
        ]).toJson(),
      );
      return NotificationResponse.fromJson(response);
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> readNotification(String id) async {
    await put(sprintf(NOTIFICATION_UPDATE, [id]));
  }

  Future<void> deleteNotification(String id) async {
    await delete(sprintf(NOTIFICATION_UPDATE, [id]));
  }

  Future<NotificationItem> getNotificationDetail(String id) async {
    final response = await get(sprintf(NOTIFICATION_DETAIL, [id]));
    return NotificationItem.fromJson(response);
  }

  submitFCMToken(String token) async {
    final deviceId = await getDeviceId();
    final packageInfo = locator<AppModel>().packageInfo;
    final url = sprintf(PUSH_DEVICE_TOKEN, [deviceId]);
    await post(url, data: {"token": token, "os": Platform.isAndroid ? "android" : "ios", "verName": packageInfo.version, "verCode": int.parse(packageInfo.buildNumber)});
  }
}
