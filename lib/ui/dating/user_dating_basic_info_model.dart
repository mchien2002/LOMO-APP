import 'package:flutter/cupertino.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_model.dart';

class UserDatingBasicInfoModel extends BaseModel {
  final _userRepository = locator<UserRepository>();
  ValueNotifier<bool> follow = ValueNotifier(false);

  init(User user) {
    follow.value = user.isFollow;
  }

  followUser(User user) async {
    await callApi(doSomething: () async {
      await _userRepository.followUser(user);
      follow.value = true;
    });
  }

  block(User user) async {
    await callApi(doSomething: () async {
      await _userRepository.blockUser(user);
      follow.value = false;
    });
  }

  Future<String> getAccessToken() async {
    return await _userRepository.getAccessToken() ?? "";
  }

  @override
  ViewState get initState => ViewState.loaded;
}
