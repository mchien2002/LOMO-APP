import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';

import 'user.dart';

class NetAloUser {
  NetAloUser({
    this.id,
    this.username,
    this.avatar,
    this.phone,
    this.token,
  });

  int? id;
  String? username;
  String? avatar;
  String? phone;
  String? token;

  factory NetAloUser.fromJson(Map<String, dynamic> json) => NetAloUser(
        id: json["id"] ?? "",
        username: json["username"],
        avatar: json["avatar"] ?? "",
        phone: json["phone"],
        token: json["token"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "avatar": avatar ?? "",
        "phone": phone,
        "token": token ?? "",
      };

  Future<NetAloUser> getNetAloUserFromUser(User user) async {
    return NetAloUser(
      id: user.netAloId,
      username: user.name,
      avatar: user.avatar ?? "",
      phone: user.phone,
      token: user.isMe
          ? user.netAloToken ?? await locator<UserRepository>().getNetAloToken()
          : "",
    );
  }

  bool get isEnoughBasicInfo => id != null && phone != null;
}
