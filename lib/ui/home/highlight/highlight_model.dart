import 'package:flutter/cupertino.dart';
import 'package:lomo/data/tracking/tracking_manager.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_model.dart';

import '../../../app/lomo_app.dart';
import '../../../data/eventbus/outside_newfeed_event.dart';

class HighlightModel extends BaseModel {
  @override
  ViewState get initState => ViewState.loaded;

  ValueNotifier<bool> isDartThemTabBar = ValueNotifier(false);

  ValueNotifier<dynamic> refreshForYouPage = ValueNotifier(null);
  ValueNotifier<dynamic> refreshDatingPage = ValueNotifier(null);
  ValueNotifier<bool> isUseAsGrid = ValueNotifier(false);
  ValueNotifier<int> tabValue = ValueNotifier(0);

  @override
  void dispose() {
    isDartThemTabBar.dispose();
    refreshForYouPage.dispose();
    isUseAsGrid.dispose();
    tabValue.dispose();
    super.dispose();
  }

  changeTabMenu(int index) {
    if (index != 0) {
      // bắn event thông báo đã ra khỏi tab news feed
      eventBus.fire(OutSideNewFeedsEvent());
    }
    locator<TrackingManager>().trackHighlightTab(index);
    tabValue.value = index;
    notifyListeners();
  }
}
