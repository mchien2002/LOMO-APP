import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/api/models/notification_item.dart';
import 'package:lomo/data/api/models/notification_type.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/eventbus/refresh_notification_event.dart';
import 'package:lomo/data/repositories/notification_repository.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_list_model.dart';
import 'package:lomo/util/constants.dart';
import 'package:lomo/util/platform_channel.dart';
import 'package:rxdart/rxdart.dart';

class NotificationListModel extends BaseListModel<NotificationItem> {
  final listNotificationType = LIST_NOTIFICATION_DATA_TYPE;
  final listNotifyDetail = NOTIFICATION_NOTIFY_DETAIL;

  final notificationTypeSubject = BehaviorSubject<NotificationType>();

  final notificationRepository = locator<NotificationRepository>();
  final userRepository = locator<UserRepository>();

  String? idType;

  @override
  Future<List<NotificationItem>?> getData(
      {params, bool isClear = false}) async {
    return await notificationRepository.getListNotification(
        page: page, limit: pageSize, idType: idType);
  }

  init() {
    eventBus.on<RefreshNotificationEvent>().listen((event) async {
      page = 1;
      items.clear();
      items.addAll(event.notifications);
      notifyListeners();
    });
  }

  openChat(String id) async {
    User user = await userRepository.getUserDetail(id);
    notifyListeners();
    if (!user.isEnoughNetAloBasicInfo) {
      return;
    }
    locator<PlatformChannel>()
        .openChatWithUser(locator<UserModel>().user!, user);
  }

  readNotification(NotificationItem item) async {
    await notificationRepository.readNotification(item.id!);
    item.isRead = true;
    notifyListeners();
  }

  readAllNotification() async {
    await callApi(doSomething: () async {
      await notificationRepository.readAllNotification();
      items.forEach((element) {
        element.isRead = true;
      });
      notifyListeners();
    });
  }

  setReadAllNotification() {
    items.forEach((element) {
      element.isRead = true;
    });
    notifyListeners();
  }

  deleteNotification(String id, bool isRead, int indexOfNotification) async {
    await notificationRepository.deleteNotification(id, isRead);
    items.removeAt(indexOfNotification);
    notifyListeners();
  }

  Future<User> getUserDetailData(NotificationItem item) async {
    User? user;
    try {
      user = await userRepository.getUserDetail(item.sender!.id!);
    } catch (e) {}

    return user!;
  }

  @override
  void dispose() {
    super.dispose();
    notificationTypeSubject.close();
  }
}
