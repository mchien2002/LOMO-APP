import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:lomo/app/app_model.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/api/models/enums.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/repositories/common_repository.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/data/tracking/facebook_tracking.dart';
import 'package:lomo/data/tracking/tracking_manager.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_model.dart';
import 'package:lomo/util/AppsflyerUtil.dart';
import 'package:lomo/util/image_util.dart';

import '../../../util/platform_channel.dart';

class ProfileImageModel extends BaseModel {
  final _userRepository = locator<UserRepository>();
  final commonRepository = locator<CommonRepository>();
  ValueNotifier<bool> confirmEnable = ValueNotifier(false);

  late User user;

  init(User user) {
    this.user = user;
  }

  bool isCheckPolicy = false;

  ValueNotifier<Uint8List?> avatar = ValueNotifier(null);

  @override
  ViewState get initState => ViewState.loaded;

  uploadAvatar() async {
    if (avatar.value == null) return;
    final compressAvatar = await compressImageWithUint8List(avatar.value!);
    if (compressAvatar.u8List != null) {
      String? avatarLinkUploaded = await commonRepository.uploadImageFromBytes(
          compressAvatar.u8List!,
          uploadDir: UploadDirName.avatar);
      user.avatar = avatarLinkUploaded;
      locator<TrackingManager>().trackRegisterImage();
    }
  }

  updateProfile() async {
    await callApi(doSomething: () async {
      if (avatar.value != null) await uploadAvatar();
      await _userRepository.updateProfile(user);
      await locator<AppModel>().submitFCMToken(isCheckState: false);
      await locator<PlatformChannel>().setNetaloUser(user, isForce: true);
      _userRepository.setTimeInitProfile(null);
      locator<TrackingManager>().trackLoginNew();
      locator<FacebookTracking>().trackingLoginNew();
      locator<AppsflyerUtil>().trackLoginNew(user);
      locator<AppModel>().setFunctionEvent(true);
    });
  }

  clearCurrentUser() async {
    await _userRepository.logout();
    locator<UserModel>().setAuthState(AuthState.unauthorized);
  }

  updateProfileSuccess() async {
    locator<UserModel>().setAuthState(AuthState.authorized);
  }

  @override
  void dispose() {
    avatar.dispose();
    confirmEnable.dispose();
    super.dispose();
  }
}
