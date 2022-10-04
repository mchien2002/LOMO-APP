import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/api/models/constant_list.dart';
import 'package:lomo/data/api/models/gender.dart';
import 'package:lomo/data/api/models/sogiesc.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/repositories/common_repository.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_model.dart';
import 'package:lomo/ui/widget/sogiesc_list_widget.dart';
import 'package:lomo/util/constants.dart';

class ProfileGenderModel extends BaseModel {
  final commonRepository = locator<CommonRepository>();
  ValueNotifier<Gender?> selectedGender = ValueNotifier(null);
  late List<Sogiesc> selectedSogiescList;
  ValueNotifier<bool> validateData = ValueNotifier(false);
  ValueNotifier<SelectAllEvent?> setSelectAllSogiesc = ValueNotifier(null);
  final _userRepository = locator<UserRepository>();
  Role? selectedRole;
  KeyValue? selectedTitle;

  late User user;

  @override
  ViewState get initState => ViewState.loaded;

  init() async {
    user = User.fromJson(locator<UserModel>().user!.toJson());
    selectedGender.value = findGenderFromGenderId(user.gender!.id!)!;
    selectedSogiescList = findSogiescListFromListSogiescId(user.sogiescs!);
    selectedRole = user.role != null
        ? (findRoleFromRoleId(user.role!.id!) ?? null)!
        : null;
    selectedTitle =
        user.title != null ? findTitleFromTitleId(user.title!.id!)! : null;
    isValidateData();
  }

  isValidateData() {
    validateData.value =
        selectedSogiescList.isNotEmpty == true && checkOldData();
  }

  //check old data
  bool checkOldData() {
    if ((selectedSogiescList.join('') == user.sogiescs!.join('')
            ? false
            : true) ||
        selectedGender.value!.id! != user.gender?.id ||
        selectedRole?.id != user.role?.id ||
        selectedTitle?.id != user.title?.id)
      return true;
    else
      return false;
  }

  List<Sogiesc> findSogiescListFromListSogiescId(List<Sogiesc> sogiescList) {
    List<String> sogiescIdList = [];
    sogiescList.forEach((data) {
      sogiescIdList.add(data.id!);
    });
    List<Sogiesc> result = [];
    if (sogiescIdList.isNotEmpty == true) {
      sogiescIdList.forEach((id) {
        commonRepository.listSogiesc?.forEach((element) {
          if (element.id == id) {
            result.add(element);
          }
        });
      });
    }
    return result;
  }

  Gender? findGenderFromGenderId(String genderId) {
    return GENDERS.firstWhere((element) => element.id == genderId);
  }

  Role? findRoleFromRoleId(String roleId) {
    return commonRepository.roles!
        .firstWhere((element) => element.id == roleId);
  }

  KeyValue? findTitleFromTitleId(String id) {
    return commonRepository.listTitle.firstWhere((element) => element.id == id);
  }

  updateDatingProfile() async {
    user.gender = selectedGender.value;
    user.sogiescs = selectedSogiescList;
    user.role = selectedRole;
    user.title = selectedTitle;

    await callApi(doSomething: () async {
      await _userRepository.updateProfile(user);
      locator<UserModel>().updateUserInfo();
    });
  }

  @override
  void dispose() {
    selectedGender.dispose();
    validateData.dispose();
    setSelectAllSogiesc.dispose();
    super.dispose();
  }
}
