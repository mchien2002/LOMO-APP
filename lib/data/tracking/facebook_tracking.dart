import 'package:lomo/di/locator.dart';
import 'package:lomo/util/platform_channel.dart';

class FacebookTracking {
  trackingLoginNew() async {
    try {
      locator<PlatformChannel>().facebookTracking("login_new");
    } catch (e) {}
  }

  trackingLoginRe() async {
    try {
      locator<PlatformChannel>().facebookTracking("login_re");
    } catch (e) {}
  }
}
