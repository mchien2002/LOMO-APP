import 'package:flutter/widgets.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_model.dart';

class LoginModel extends BaseModel {
  final _userRepository = locator<UserRepository>();
  ValueNotifier<bool> confirmEnable = ValueNotifier(false);

  @override
  ViewState get initState => ViewState.loaded;

  login(String phone, {bool active = false}) async {
    await callApi(doSomething: () async {
      await _userRepository.loginByPhone(phone, active: active);
    });
  }

  @override
  void dispose() {
    confirmEnable.dispose();
    super.dispose();
  }
}
