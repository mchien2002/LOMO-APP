import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_model.dart';

class PrivacyModel extends BaseModel {
  ValueNotifier<bool> validateData = ValueNotifier(false);

  @override
  ViewState get viewState => ViewState.loaded;

  late User user;
  final List<String> fieldDisabledOld = [];
  final _userRepository = locator<UserRepository>();

  initData() {
    user = User.fromJson(locator<UserModel>().user!.toJson());
    fieldDisabledOld.addAll(user.fieldDisabled!);
    isValidateData();
  }

  isValidateData() {
    fieldDisabledOld.sort((a, b) => a.toString().compareTo(b.toString()));
    user.fieldDisabled?.sort((a, b) => a.toString().compareTo(b.toString()));

    validateData.value =
        (user.fieldDisabled?.join('') == fieldDisabledOld.join('')
            ? false
            : true);
  }

  updateProfile() async {
    await callApi(doSomething: () async {
      await _userRepository.updateProfile(user);
    });
  }

  @override
  void dispose() {
    validateData.dispose();
    super.dispose();
  }
}
