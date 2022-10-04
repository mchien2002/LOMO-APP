import 'package:lomo/data/api/models/notification_item.dart';
import 'package:lomo/data/repositories/notification_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_model.dart';

class NotificationDetailModel extends BaseModel {
  final _notificationRepository = locator<NotificationRepository>();
  late NotificationItem notification;

  init(NotificationItem notification) {
    this.notification = notification;
    getNotificationDetail();
  }

  getNotificationDetail() async {
    callApi(doSomething: () async {
      final notificationDetail = await _notificationRepository
          .getNotificationDetail(notification.push!);
      this.notification = notificationDetail;
      notifyListeners();
    });
  }
}
