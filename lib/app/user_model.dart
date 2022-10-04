import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/repositories/common_repository.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/data/socket/socket_manager.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_model.dart';
import 'package:lomo/util/platform_channel.dart';

import '../data/api/models/user_setting.dart';
import 'app_model.dart';
import 'base_app_config.dart';

class UserModel extends BaseModel {
  final _userRepository = locator<UserRepository>();
  final _commonRepository = locator<CommonRepository>();
  ValueNotifier<AuthState?> authState = ValueNotifier(null);
  ValueNotifier<UserSetting?> userSetting = ValueNotifier(null);
  User? user;

  init(Environment env) async {
    var isFirstTimeUseApp = await _commonRepository.isFirstUseApp();
    if (isFirstTimeUseApp) {
      setAuthState(AuthState.new_install);
    } else {
      user = await _userRepository.getUser();
      var hasUserLocal = user != null;

      if (!hasUserLocal) {
        await setAuthState(AuthState.unauthorized);
      } else if (user?.isEnoughBasicInfo == true) {
        await setAuthState(AuthState.authorized);
        await initSdk(env);
        locator<SocketManager>().connectAndListen();
      } else {
        final timeInitProfile = await _userRepository.getTimeInitProfile();
        final mustInputInitProfileInfo = timeInitProfile != null &&
            (DateTime.now().millisecondsSinceEpoch -
                    timeInitProfile.millisecondsSinceEpoch <
                24 * 3600 * 1000);
        print("mustInputInitProfileInfo: $mustInputInitProfileInfo");
        if (mustInputInitProfileInfo) {
          await setAuthState(AuthState.uncompleted);
        } else {
          logout();
        }
      }
    }
  }

  updateUserSetting(
      {bool? hasSoundVideoAutoPlay,
      bool? isVideoAutoPlay,
      bool isSaveSetting = true}) {
    if (hasSoundVideoAutoPlay != null) {
      userSetting.value?.hasSoundVideoAutoPlay = hasSoundVideoAutoPlay;
    }
    if (isVideoAutoPlay != null) {
      userSetting.value?.isVideoAutoPlay = isVideoAutoPlay;
    }
    userSetting.notifyListeners();
    if (isSaveSetting) {
      _userRepository.setUserSetting(userSetting.value);
    }
    print("update userSetting:\n ${userSetting.value?.toJson()}");
  }

  getUserSetting() async {
    final setting = await _userRepository.getUserSetting();
    userSetting.value = setting ?? UserSetting();
  }

  getUserRemote() async {
    try {
      final userRemote = await _userRepository.getMyProfile();
      user = userRemote;
    } catch (e) {
      print("GetMeFailed");
    }
  }

  initSdk(Environment env) async {
    try {
      final platformChannel = locator<PlatformChannel>();
      platformChannel.startListeningNative((call) {});
      await platformChannel.setEnvironmentNetAloSdk(env);
      if (user != null) {
        locator<PlatformChannel>().setNetaloUser(user!);
      }
    } catch (e) {
      print("lỗi init sdk: $e");
    }
  }

  setAuthState(AuthState authState) async {
    this.authState.value = authState;
    notifyListeners();
  }

  bool isLogin() => user != null;

  setUser(User user) {
    this.user = user;
    // setAuthState(
    //     user.isFirstLogin ? AuthState.uncompleted : AuthState.authorized);
    // notifyListeners();
  }

  updateUserInfo() {
    notifyListeners();
  }

// only call 1 time after install app
  setUsedApp() async {
    await _commonRepository.setFirstUseApp(false);
    await setAuthState(AuthState.unauthorized);
  }

  logout() async {
    try {
      await _userRepository.logout();
      locator<PlatformChannel>().logOutNetAloSDK();
      user = null;
      setAuthState(AuthState.unauthorized);
      locator<AppModel>().setFunctionEvent(false);
    } catch (e) {
      print(e);
    }
  }
}

enum AuthState { unauthorized, authorized, uncompleted, new_install }
