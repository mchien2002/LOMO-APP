import 'package:flutter/material.dart';
import 'package:lomo/app/app_model.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/data/socket/socket_manager.dart';
import 'package:lomo/data/tracking/facebook_tracking.dart';
import 'package:lomo/data/tracking/tracking_manager.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_model.dart';
import 'package:lomo/ui/otp/otp_screen.dart';
import 'package:lomo/util/AppsflyerUtil.dart';
import 'package:lomo/util/platform_channel.dart';

class OtpModel extends BaseModel {
  final _userRepository = locator<UserRepository>();
  late OtpType otpType;
  String? phone;

  ValueNotifier timerNotifier = ValueNotifier(null);
  ValueNotifier<bool> enableResendOtp = ValueNotifier(false);
  ValueNotifier<bool> enableButton = ValueNotifier(true);
  ValueNotifier<String> contentValue = ValueNotifier("");

  @override
  ViewState get initState => ViewState.loaded;

  init(OtpType otpType) async {
    this.otpType = otpType;
    phone = await _userRepository.getPhone();
    notifyListeners();
  }

  confirmOtp(String otp) async {
    await callApi(doSomething: () async {
      var user = await _userRepository.confirmOtp(otp);
      if (user != null) {
        locator<UserModel>().getUserSetting();
        if (user.isEnoughBasicInfo) {
          locator<TrackingManager>().trackLoginRe();
          locator<FacebookTracking>().trackingLoginRe();
          locator<AppsflyerUtil>().trackLoginRe(user);
          await locator<UserModel>().setAuthState(AuthState.authorized);
          await locator<PlatformChannel>().setNetaloUser(user, isForce: true);
          locator<AppModel>().submitFCMToken();
          locator<SocketManager>().connectAndListen();
          locator<AppModel>().setFunctionEvent(true);
        } else {
          locator<UserModel>().setAuthState(AuthState.uncompleted);
          locator<TrackingManager>().trackRegisterOtp();
        }
      }
    });
  }

  reSentOtp() async {
    String? phone = await _userRepository.getPhone();
    await callApi(doSomething: () async {
      await _userRepository.loginByPhone(phone!, resend: true);
    });
  }

  String formatPhoneOtp(String? phone) {
    if (phone == null || phone == "") return "";
    return phone.substring(0, 2) + "*****" + phone.substring(7, phone.length);
  }

  @override
  void dispose() {
    timerNotifier.dispose();
    enableResendOtp.dispose();
    contentValue.dispose();
    super.dispose();
  }
}
