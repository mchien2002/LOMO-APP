import 'dart:io';

import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lomo/app/app_model.dart';
import 'package:lomo/app/base_app_config.dart';
import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/api/api_constants.dart';
import 'package:lomo/data/api/models/net_alo_user.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/eventbus/change_tab_event.dart';
import 'package:lomo/data/repositories/notification_repository.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/data/socket/socket_manager.dart';
import 'package:lomo/data/tracking/tracking_manager.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/util/common_utils.dart';

import '../ui/settings/delete_account/delete_account_model.dart';
import 'constants.dart';
import 'handle_link_util.dart';
import 'image_picker.dart';

class PlatformChannel {
  final _userRepository = locator<UserRepository>();
  final channel = const MethodChannel("vn.netacom.lomo/flutter_channel");
  final handleNativeChannel = const MethodChannel('callbacks');
  bool hasSetNetaloUser = false;

  Future<String> compressFileAndroid(
      {required String filePath,
      int width = 720,
      int height = 1080,
      int quality = 96}) async {
    final compressPath = await channel.invokeMethod("compressImage", {
      "imagePath": filePath,
      "width": width,
      "height": height,
      "quality": quality
    });
    return compressPath;
  }

  Future<bool> setNetaloUser(User me, {bool isForce = false}) async {
    // if (locator<AppModel>().appConfig?.isChat == true) {
    if (hasSetNetaloUser && !isForce) return false;
    print("setNetaloUser: ${me.toJson()}");
    try {
      final myNetAloUser = await NetAloUser().getNetAloUserFromUser(me);
      if (!myNetAloUser.isEnoughBasicInfo) return false;
      await channel.invokeMethod("setNetaloUser", myNetAloUser.toJson());
      hasSetNetaloUser = true;
      setDomainLoadAvatarNetAloSdk(PHOTO_URL);
      return true;
    } catch (e) {
      print(e);
    }
    // }
    return false;
  }

  setEnvironmentNetAloSdk(Environment env) async {
    if (locator<AppModel>().appConfig?.isChat == true) {
      final environment = env == Environment.prod ? "pro" : "dev";
      await channel.invokeMethod("setEnvironmentNetAloSdk", environment);
    }
  }

  openChatConversation(User me) async {
    try {
      if (locator<AppModel>().appConfig?.isChat == true) {
        locator<TrackingManager>().trackOpenChatConversation();
        locator<TrackingManager>().startTrackChatSession();
        final myNetAloUser = await NetAloUser().getNetAloUserFromUser(me);
        await channel.invokeMethod(
            "openChatConversation", myNetAloUser.toJson());
      } else {
        showToast(Strings.chatMaintenance, gravity: ToastGravity.TOP);
      }
    } catch (e) {
      print(e);
    }
  }

  facebookTracking(String event) async {
    channel.invokeMethod("facebookTracking", {"event": event});
  }

  Future<bool> share(String link) async {
    bool result = false;
    try {
      result = await channel.invokeMethod("shareLink", link);
      print("dashareroine:$result");
    } catch (e) {}
    return result;
  }

  initChatSdk() async {
    if (locator<AppModel>().appConfig?.isChat == true) {
      await channel.invokeMethod("initNetAloSDK");
    }
  }

  logOutNetAloSDK() async {
    try {
      await channel.invokeMethod("logOutNetAloSDK");
    } catch (e) {
      print(e);
    }
  }

  closeNetAloChat() async {
    try {
      channel.invokeMethod("closeNetAloChat");
    } catch (e) {
      print(e);
    }
  }

  activeUser(User user, int status) async {
    try {
      final netaloUser = await NetAloUser().getNetAloUserFromUser(user);
      channel.invokeMethod(
          "activeUser", {"status": status, "user": netaloUser.toJson()});
    } catch (e) {}
  }

  openChatWithUser(User me, User target) async {
    try {
      if (locator<AppModel>().appConfig?.isChat == true) {
        locator<TrackingManager>().trackOpenChatWithUser(target.id!);
        locator<TrackingManager>().startTrackChatSession();
        final myNetAloUser = await NetAloUser().getNetAloUserFromUser(me);
        final targetNetAloUser =
            await NetAloUser().getNetAloUserFromUser(target);
        bool isChatWithOA =
            locator<AppModel>().appConfig?.officialLomo == target.id;
        channel.invokeMethod("openChatWithUser", {
          "me": myNetAloUser.toJson(),
          "target": targetNetAloUser.toJson(),
          "isChatWithOA": isChatWithOA
        });
      } else {
        showToast(Strings.chatMaintenance, gravity: ToastGravity.TOP);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String> getResult() async {
    return await channel.invokeMethod("result");
  }

  showTestScreen() async {
    return await channel.invokeMethod("showTestScreen");
  }

  Future<bool> checkGroupChatExist(int netAloId) async {
    return await channel.invokeMethod("checkGroupChatExist", netAloId);
  }

  Future<List<String>> pickImages(int maxImages, GalleryType type,
      {bool autoDismissOnMaxSelections = false}) async {
    try {
      final result = await channel.invokeMethod("pickImages", {
        "maxImages": maxImages,
        "type": type.type,
        "autoDismissOnMaxSelections": autoDismissOnMaxSelections
      });

      List<String> data = result.cast<String>().toList();

      print("dataImagesPicked: $data");
      return data;
    } catch (e) {
      print("errorChooseImages: $e");
      return [];
    }
  }

  blockUser(int netAloId) async {
    return await channel.invokeMethod("blockUser", netAloId);
  }

  unBlockUser(int netAloId) async {
    return await channel.invokeMethod("unBlockUser", netAloId);
  }

  checkPermissionCall() async {
    return channel.invokeMethod("checkPermissionCall");
  }

  setDomainLoadAvatarNetAloSdk(String? avatarNetAloSdkDomain) async {
    if (locator<AppModel>().appConfig?.isChat == true &&
        avatarNetAloSdkDomain?.isNotEmpty == true) {
      print("domainLoadAvatarNetAloSdk: $avatarNetAloSdkDomain");
      channel.invokeMethod(
          "setDomainLoadAvatarNetAloSdk", avatarNetAloSdkDomain);
    }
  }

  Future<int> getNumbersOfBadgesChat() async {
    if (locator<AppModel>().appConfig?.isChat == true) {
      final numBadges = await channel.invokeMethod("getNumbersOfBadgesChat");
      print("NumbersOfBadgesChat:$numBadges");
      return numBadges;
    }
    return 0;
  }

  Future<bool> sendMessage(User receiver, String message) async {
    try {
      if (locator<AppModel>().appConfig?.isChat == true) {
        final receiverNetAloUser =
            await NetAloUser().getNetAloUserFromUser(receiver);
        final isSendMessageSuccess = await channel.invokeMethod("sendMessage",
            {"message": message, "receiver": receiverNetAloUser.toJson()});
        print("sendMessageSuccess");
        return isSendMessageSuccess as bool;
      }
    } catch (e) {
      print("sendMessageError");
      print(e);
    }
    return false;
  }

  setFollowUser(User user, bool isFollow) async {
    try {
      await channel.invokeMethod("setFollowUser", {
        "targetUser": user.toJson(),
        "isFollow": isFollow,
      });
    } catch (e) {
      print("errorsetFollowUser: $e");
      return [];
    }
  }

  deleteAccount(User user, ReasonDeleteAccountItem itemDeleted) async {
    try {
      await channel.invokeMethod("deleteAccount", {
        "user": user.toJson(),
        "reasonId": "4",
        "reasonText": itemDeleted.description.isNotEmpty
            ? itemDeleted.description
            : itemDeleted.item.name
      });
    } catch (e) {
      print("deleteAccount: $e");
      return [];
    }
  }

  setHasFollowByUser(User user, bool isFollow) async {
    try {
      await channel.invokeMethod("setHasFollowByUser", {
        "targetUser": user.toJson(),
        "isFollow": isFollow,
      });
    } catch (e) {
      print("setHasFollowByUser: $e");
      return [];
    }
  }

  startListeningNative(Function(dynamic) callback) async {
    handleNativeChannel.setMethodCallHandler((call) async {
      try {
        switch (call.method) {
          case 'checkIsFriend':
            print(call.arguments);
            try {
              final result = await _userRepository.checkFriend(
                  locator<UserModel>().user?.netAloId?.toString() ?? "",
                  call.arguments?.toString() ?? "");
              return result;
            } catch (e) {
              return false;
            }
          case 'sendEventDeepLink':
            if (call.arguments != null) {
              final link = call.arguments as String;
              print("linkHandleFromNative:$link");
              try {
                locator<HandleLinkUtil>().linkData.value = link;
              } catch (e) {
                print("loiDeepLinkMethodChanel");
                print(e);
              }
            }
            break;
          case 'sendEventHandleLinkFromNetAlo':
            if (locator<AppModel>().appConfig?.isChat == true) {
              if (call.arguments != null) {
                try {
                  final url = call.arguments as String;
                  if (locator<HandleLinkUtil>().containDomainShare(url)) {
                    closeNetAloChat();
                  }
                  locator<HandleLinkUtil>()
                      .openLink(url, source: LinkSourceType.netAlo);
                } catch (e) {
                  print(e);
                }
              }
            }
            break;
          case 'showToast':
            showToast(call.arguments as String);
            break;
          case 'netAloSessionExpire':
            if (locator<AppModel>().appConfig?.isChat == true) {
              // locator<AppModel>().forceLogout();
              print("netAloSessionExpire");
            }
            break;
          case 'netAloExit':
            print("netAloExit");
            locator<TrackingManager>().stopTrackChatSession();
            break;
          case 'netAloPushNotification':
            print('netAloPushNotification: ${call.arguments}');
            //locator<AppModel>().pushNotificationForegroundAndroid(call.arguments);
            break;
          case 'appToBackground':
            locator<TrackingManager>().pauseTrackAppOnSite();
            if (Platform.isIOS) {
              locator<SocketManager>().dispose();
            }
            break;
          case 'appToForeground':
            locator<TrackingManager>().resumeTrackAppOnSite();
            if (Platform.isIOS) {
              locator<SocketManager>().reConnect();
            }
            break;
          case 'netAloChatPushNotification':
            eventBus.fire(ChangeTabEvent(message: call.arguments));
            break;
          case 'updateBadgeChat':
            final numBadgeChats = call.arguments as int;
            locator<NotificationRepository>().setBadgeChat(numBadgeChats);
            print('updateBadgeChat: $numBadgeChats');
            break;
          case 'pressCallChat':
            locator<TrackingManager>().trackCallButton();
            break;
          case 'pressVideoCallChat':
            locator<TrackingManager>().trackVideoCallButton();
            break;
          default:
            print(
                'TestFairy: Ignoring invoke from native. This normally shouldn\'t happen.');
        }
      } catch (e) {}
    });
  }
}
