import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lomo/app/app_model.dart';
import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/data/api/models/checkin.dart';
import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/data/eventbus/change_menu_event.dart';
import 'package:lomo/data/eventbus/refresh_hightlight_event.dart';
import 'package:lomo/data/repositories/common_repository.dart';
import 'package:lomo/data/repositories/notification_repository.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/base/base_model.dart';
import 'package:lomo/ui/widget/dialog_widget.dart';
import 'package:lomo/util/date_time_utils.dart';
import 'package:lomo/util/location_manager.dart';

import '../../data/eventbus/outside_newfeed_event.dart';

class HomeModel extends BaseModel {
  @override
  ViewState get initState => ViewState.loaded;
  late BuildContext homeContext;
  late PageController pageController;
  final userRepository = locator<UserRepository>();
  final locationManager = locator<LocationManager>();
  final commonRepository = locator<CommonRepository>();
  ValueNotifier<int> tabValue = ValueNotifier(0);
  bool? isEnabledGps;
  bool isShowedEvent = false;

  init() {
    eventBus.on<ChangeMenuEvent>().listen((event) async {
      onTabChanged(event.index, refresh: false);
    });
  }

  updateDataLocation() async {
    await locationManager.getDataLocation();
    print("${locationManager.locationLat} // ${locationManager.locationLng}");
    // await updateLocation(
    //     lat: locationManager.locationLat,
    //     lng: locationManager.locationLng,
    //     city: locationManager.locationCity);
  }

  checkLocationEnabled(bool isPermission) async {
    isEnabledGps = await locationManager.checkEnabledLocation();
    if (isPermission && !isEnabledGps!) {
      await _showMyDialog();
    }
  }

  Future<List<Checkin>> getDataCheckin({params}) async {
    return await commonRepository.getListCheckin();
  }

  setDontShowVQMM(bool value) {
    commonRepository.setDontShowCheckTimeVQMM(value);
  }

  Future<bool> showDialogCheckin(List<Checkin> items) async {
    if (locator<AppModel>().appConfig?.isCheckIn != true) return false;
    var isShow = await commonRepository.isShowPopupCheckin();
    for (Checkin item in items) {
      if (item.check == 2 && isShow) {
        //Luu lai ngay hien tai khi mo app
        commonRepository.setShowPopupCheckin(
            getDayByTimeStamp(DateTime.now().millisecondsSinceEpoch));
        return true;
      }
    }
    return false;
  }

  Future<bool> showDialogCheckEvent() async {
    bool result = false;
    if (locator<AppModel>().appConfig?.isEvent == true) {
      result = await commonRepository.isShowCheckTimeVQMM();
    }
    return result;
  }

  Future<void> _showMyDialog() async {
    return showDialog(
      context: homeContext,
      builder: (context) => TwoButtonDialogWidget(
        title: Strings.notice.localize(context),
        description: Strings.openGpsToFindFriends.localize(context),
        onConfirmed: () async {
          await locationManager.openAppSettings();
          isEnabledGps = await locationManager.checkEnabledLocation();
        },
      ),
    );
  }

  onTabChanged(int index, {bool refresh = true}) async {
    if (index != 0) {
      // bắn event thông báo đã ra khỏi tab news feed
      eventBus.fire(OutSideNewFeedsEvent());
    }
    if (index == 0 && refresh && tabValue.value == index) {
      eventBus.fire(RefreshHighLightEvent());
    }
    if (index != 2) {
      pageController.jumpToPage(index);
      tabValue.value = index;
      notifyListeners();
    } else {
      Navigator.pushNamed(homeContext, Routes.createNewFeed);
    }

    if (index == 3) {
      locator<NotificationRepository>().isOnTabNotification = true;
      locator<NotificationRepository>().badgeNotificationTabIcon.value = 0;
    } else {
      locator<NotificationRepository>().isOnTabNotification = false;
    }
  }

  Future<NewFeed?> getNewFeed(String postId) async {
    try {
      final newFeed = await locator<UserRepository>().getDetailPost(postId);
      return newFeed;
    } catch (e) {
      errorMessage = getErrorMessage(e);
      print(e);
      return null;
    }
  }
}
