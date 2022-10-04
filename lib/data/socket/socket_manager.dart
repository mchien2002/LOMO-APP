import 'package:lomo/app/app_model.dart';
import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/data/api/models/socket_response.dart';
import 'package:lomo/data/eventbus/delete_post_event.dart';
import 'package:lomo/data/eventbus/lock_post_event.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/util/common_utils.dart';
import 'package:lomo/util/constants.dart';
import 'package:lomo/util/handle_link_util.dart';
import 'package:lomo/util/platform_channel.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../api/models/user.dart';

class SocketManager {
  IO.Socket? socket;
  int retry = 0;
  final limitRetry = 10;
  void connectAndListen() async {
    dispose();
    try {
      await locator<UserRepository>().getMe();
      final host = locator<HandleLinkUtil>().getLinkDomain();
      final accessToken = await locator<UserRepository>().getAccessToken();
      final url = host + '?token=$accessToken';
      print("SocketManagerUrl: $url");
      if (accessToken?.isNotEmpty == true) {
        socket = IO.io(url, <String, dynamic>{
          'transports': ['websocket'],
          'forceNew': true
        });
        socket?.on('connect', (_) {
          print('SocketManager: connect');
          retry = 0;
        });
        socket?.on('disconnect', (_) => print('SocketManager: disconnect'));
        socket?.on('message', (data) => handleMessage(data));
        socket?.on('error', (error) {
          print('SocketManager error');
          print(error);
          retry++;
          if (retry < limitRetry) reConnect();
        });
      }
    } catch (e) {
      print('SocketManager getme error');
      print(e);
      retry++;
      if (retry < limitRetry) reConnect();
    }
  }

  handleMessage(dynamic data) async {
    print('SocketManager: data');
    print(data);
    try {
      final socketResponse = SocketResponse.fromJson(data);
      switch (socketResponse.model) {
        case SocketModelType.post:
          handleSocketResponsePost(socketResponse);
          break;
        case SocketModelType.event:
          if (locator<AppModel>().appConfig?.isEvent == true) {
            handleSocketResponseVQMM(socketResponse);
          }
          break;
        case SocketModelType.user:
          handleSocketResponseUser(socketResponse);
          break;
        default:
          break;
      }
    } catch (e) {
      print('handleMessageError');
      print(e);
    }
  }

  handleSocketResponseVQMM(SocketResponse response) {
    try {
      switch (response.action) {
        case SocketActionType.notify:
          final data = response.data as Map<String, dynamic>?;
          showToast(data?["message"] as String);
          break;
      }
    } catch (e) {}
  }

  handleSocketResponsePost(SocketResponse response) async {
    try {
      switch (response.action) {
        case SocketActionType.lock:
          final data = response.data as Map<String, dynamic>?;
          eventBus.fire(LockPostEvent(postId: data?["id"]));
          break;
        case SocketActionType.delete:
          final data = response.data as Map<String, dynamic>?;
          eventBus.fire(DeletePostEvent(postId: data?["id"]));
          break;
        default:
          break;
      }
    } catch (e) {
      print('handleSocketResponsePostError');
      print(e);
    }
  }

  handleSocketResponseUser(SocketResponse response) {
    try {
      final data = response.data as Map<String, dynamic>?;
      final user = User.fromJson(data!);
      switch (response.action) {
        case SocketActionType.follow:
          locator<PlatformChannel>().setHasFollowByUser(user, true);
          break;
        case SocketActionType.unfollow:
          locator<PlatformChannel>().setHasFollowByUser(user, false);
          break;
        case SocketActionType.accountActivated:
          locator<PlatformChannel>().activeUser(user, UserStatus.active);
          break;

        case SocketActionType.accountDeactivated:
          locator<PlatformChannel>().activeUser(user, UserStatus.deActive);
          break;
        default:
          break;
      }
    } catch (e) {
      print('handleSocketResponsePostError');
      print(e);
    }
  }

  void close() {
    try {
      socket?.disconnect();
      socket?.close();
    } catch (e) {
      print(e);
    }
  }

  void reConnect() {
    try {
      if (socket?.connected == false) {
        connectAndListen();
      }
    } catch (e) {
      print(e);
    }
  }

  dispose() {
    socket?.dispose();
  }
}
