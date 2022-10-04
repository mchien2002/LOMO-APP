import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/api/models/enums.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/eventbus/give_bear_event.dart';
import 'package:lomo/data/repositories/common_repository.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_model.dart';
import 'package:lomo/util/image_util.dart';
import 'package:lomo/util/platform_channel.dart';
import 'package:lomo/util/tool_tip_manager.dart';
import 'package:rxdart/rxdart.dart';

import '../../data/eventbus/outside_newfeed_event.dart';
import '../../res/strings.dart';

class ProfileModel extends BaseModel {
  final _userRepository = locator<UserRepository>();
  final commonRepository = locator<CommonRepository>();
  late User user;
  ValueNotifier<bool> displaySentBear = ValueNotifier(true);
  ValueNotifier<File?> imageFile = ValueNotifier(null);
  ValueNotifier<int> totalBear = ValueNotifier(0);

  ValueNotifier<String?> avatar = ValueNotifier("");

  BehaviorSubject<String?> imageBackgroundSubject = BehaviorSubject<String?>();

  init(User user) async {
    this.user = user;
    // notifyListeners();

    // bắn event thông báo đã ra khỏi tab news feed
    eventBus.fire(OutSideNewFeedsEvent());

    eventBus.on<GiveBearUserEvent>().listen((event) async {
      if (this.user.id == event.userId) {
        this.user.isBear = event.isBear;
        this.user.numberOfBear = this.user.numberOfBear! + 1;
        totalBear.value =
            this.user.numberOfBear != null ? this.user.numberOfBear! : 1;
        //Disable nut tang gau
        displaySentBear.value = true;
        notifyListeners();
      }
    });
  }

  disableToolTipCheckIn() async {
    locator<ToolTipManager>().setShowToolTipCheckIn(false);
  }

  block(User user) async {
    await callApi(doSomething: () async {
      _userRepository.blockUser(user);
    });
  }

  uploadBackGroundImage(Uint8List u8List) async {
    final avatarCompress = await compressImageWithUint8List(u8List);
    if (avatarCompress.u8List != null) {
      String? avatarLinkUploaded = await commonRepository.uploadImageFromBytes(
          avatarCompress.u8List!,
          uploadDir: UploadDirName.background);
      user.backgroundImage = avatarLinkUploaded;
      imageBackgroundSubject.sink.add(avatarLinkUploaded!);
    }
  }

  updateBackGroundImage(Uint8List u8List) async {
    await callApi(doSomething: () async {
      await uploadBackGroundImage(u8List);
      await _userRepository.updateProfile(user);
      locator<UserModel>().notifyListeners();
      notifyListeners();
    });
  }

  setUserToDeleted(BuildContext context) {
    user.name = Strings.accountDeleted.localize(context);
    user.avatar = "";
    notifyListeners();
  }

  getUserDetailData() async {
    await callApi(doSomething: () async {
      user = await _userRepository.getUserDetail(user.id!);
      imageBackgroundSubject.sink.add(user.backgroundImage);
      totalBear.value = user.numberOfBear!;
      displaySentBear.value = user.isBear!;
      notifyListeners();
    });
  }

  // reloadUser(User user) async {
  //   await init(user);
  //   if (!user.isMe)
  //     eventBus.fire(RefreshProfileEvent(this.user.id!, user: this.user));
  // }

  openChat() async {
    if (!user.isEnoughNetAloBasicInfo) {
      await getUserDetailData();
    }
    locator<PlatformChannel>()
        .openChatWithUser(locator<UserModel>().user!, user);
  }

  uploadAvatar(Uint8List? avatar) async {
    if (avatar == null) return;
    final compressAvatar = await compressImageWithUint8List(avatar);
    if (compressAvatar.u8List != null) {
      String? avatarLinkUploaded = await commonRepository.uploadImageFromBytes(
          compressAvatar.u8List!,
          uploadDir: UploadDirName.avatar);
      user.avatar = avatarLinkUploaded;
      locator<UserModel>().user!.avatar = user.avatar;
      locator<UserModel>().updateUserInfo();
    }
  }

  updateAvatar(Uint8List? avatar) async {
    await callApi(doSomething: () async {
      await uploadAvatar(avatar);
      await _userRepository.updateProfile(user);
    });
  }

  @override
  ViewState get initState => ViewState.loaded;

  @override
  void dispose() {
    imageFile.dispose();
    displaySentBear.dispose();
    imageBackgroundSubject.close();
    totalBear.dispose();
    super.dispose();
  }

  double getHeightStoryView(String story) {
    if (story.isEmpty) return 0.0;
    final content = story.replaceAll("\n", "");
    if (content.length < 55) {
      return 28.0;
    } else {
      return 45.0;
    }
  }
}
