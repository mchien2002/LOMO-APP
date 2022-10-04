import 'package:flutter/cupertino.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_model.dart';

class EnterReferralModel extends BaseModel {
  final _userRepository = locator<UserRepository>();
  User? user = locator<UserModel>().user;
  TextEditingController textCodeController = TextEditingController();
  ValueNotifier<bool> confirmEnable = ValueNotifier(true);
  late bool isNewAccount;

  init(bool isNewAccount) {
    this.isNewAccount = isNewAccount;
    if (!this.isNewAccount) {
      confirmEnable.value = false;
    }
  }

  onChangedReferral(String text) {
    if (!this.isNewAccount) {
      confirmEnable.value = text.length > 6 ? true : false;
      notifyListeners();
    }
  }

  enterReferral(String referral) async {
    await callApi(doSomething: () async {
      await _userRepository.enterReferral(referral);
    });
  }
}
