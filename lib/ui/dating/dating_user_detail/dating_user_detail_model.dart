import 'package:flutter/material.dart';
import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/eventbus/refresh_dating_user_detail_event.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_model.dart';

import '../../../res/strings.dart';

class DatingUserDetailModel extends BaseModel {
  final _userRepository = locator<UserRepository>();
  ValueNotifier<bool> enableButtonSuitableMe = ValueNotifier(false);
  ValueNotifier<int> indicatorStep = ValueNotifier(0);
  ValueNotifier<bool> enableButtonSayHi = ValueNotifier(false);
  late User user;
  late String accessToken = "";

  init(User user) {
    this.user = user;
    enableButtonSayHi.value = !user.isSayhi!;
    getAccessToken().then((value) => accessToken = value);
    eventBus.on<RefreshDatingUserDetail>().listen((event) async {
      getUserDetail();
    });
  }

  getUserDetail() async {
    await callApi(doSomething: () async {
      final userDetail = await _userRepository.getUserDetail(user.id!);
      user = userDetail;
      if (userDetail.isMe) locator<UserModel>().user = userDetail;
      notifyListeners();
    });
  }

  setUserToDeleted(BuildContext context) {
    user.name = Strings.accountDeleted.localize(context);
    user.avatar = "";
    notifyListeners();
  }

  sentFirstMessageSuccess() async {
    callApi(doSomething: () {
      locator<UserRepository>().sentSayHi(user.id!);
    });
  }

  Future<String> getAccessToken() async {
    return await _userRepository.getAccessToken() ?? "";
  }

  block(User user) async {
    await callApi(doSomething: () async {
      await _userRepository.blockUser(user);
    });
  }

  @override
  ViewState get initState => ViewState.loaded;

  @override
  void dispose() {
    enableButtonSuitableMe.dispose();
    indicatorStep.dispose();
    enableButtonSayHi.dispose();
    super.dispose();
  }
}
