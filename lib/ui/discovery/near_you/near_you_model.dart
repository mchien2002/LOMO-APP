import 'package:flutter/cupertino.dart';
import 'package:lomo/ui/base/base_model.dart';

import '../../../di/locator.dart';
import '../../../util/location_manager.dart';

class NearYouModel extends BaseModel {
  final locationManager = locator<LocationManager>();

  ValueNotifier<bool> hasGps = ValueNotifier(false);
  final ValueNotifier<Object>? onRefresh = ValueNotifier(Object());

  @override
  ViewState get initState => ViewState.loading;

  checkGps() async {
    final isCanGetLocation = await locationManager.canGetGps();
    if (isCanGetLocation) {
      await locationManager.getDataLocation();
    }
    hasGps.value = isCanGetLocation;
    setState(ViewState.loaded);
  }

  requestGps() async {
    await locationManager.requestGps();
  }
}
