import 'package:lomo/data/api/models/notification_item.dart';

class RefreshNotificationEvent {
  List<NotificationItem> notifications;
  RefreshNotificationEvent(this.notifications);
}
