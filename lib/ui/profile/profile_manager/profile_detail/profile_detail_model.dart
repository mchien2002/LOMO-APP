import 'package:flutter/widgets.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/repositories/common_repository.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_model.dart';

class ProfileDetailModel extends BaseModel {
  final commonRepository = locator<CommonRepository>();
  final _userRepository = locator<UserRepository>();
  TextEditingController tecCaption = TextEditingController();
  TextEditingController careerController = TextEditingController();
  TextEditingController hobbyController = TextEditingController();

  final user = User.fromJson(locator<UserModel>().user!.toJson());
  final userOldData = User.fromJson(locator<UserModel>().user!.toJson());
  ValueNotifier<bool> validateData = ValueNotifier(false);

  @override
  ViewState get initState => ViewState.loaded;

  init() {
    tecCaption.text = user.story ?? "";
    if (commonRepository.listZodiac == null) {
      getConstantList();
    }
    isValidateData();
  }

  getConstantList() async {
    callApi(doSomething: () async {
      await commonRepository.getConstantList();
      notifyListeners();
    });
  }

  updateProfile() async {
    user.story = tecCaption.text;
    await callApi(doSomething: () async {
      await _userRepository.updateProfile(user);
    });
  }

  isValidateData() {
    validateData.value = checkOldData();
  }

  bool checkOldData() {
    //getID careers
    List<String?> careersIDOld = [];
    List<String?> careersID = [];
    userOldData.careers?.forEach((element) {
      careersIDOld.add(element.id);
    });
    user.careers?.forEach((element) {
      careersID.add(element.id);
    });

    //getID hobbies
    List<String?> hobbiesIDOld = [];
    List<String?> hobbiesID = [];
    userOldData.hobbies?.forEach((element) {
      hobbiesIDOld.add(element.id);
    });
    user.hobbies?.forEach((element) {
      hobbiesID.add(element.id);
    });

    if (userOldData.province?.id != user.province?.id ||
        userOldData.height != user.height ||
        userOldData.weight != user.weight ||
        userOldData.literacy?.id != user.literacy?.id ||
        userOldData.title?.id != user.title?.id ||
        userOldData.story?.trim() != tecCaption.text.trim() ||
        (careersIDOld.join('') == careersID.join('') ? false : true) ||
        (hobbiesIDOld.join('') == hobbiesID.join('') ? false : true))
      return true;
    else
      return false;
  }

  @override
  void dispose() {
    tecCaption.dispose();
    careerController.dispose();
    hobbyController.dispose();
    super.dispose();
  }
}
