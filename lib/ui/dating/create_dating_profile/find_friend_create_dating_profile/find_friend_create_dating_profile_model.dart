import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/constant_list.dart';
import 'package:lomo/data/api/models/dating_filter.dart';
import 'package:lomo/data/api/models/gender.dart';
import 'package:lomo/data/api/models/sogiesc.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/repositories/common_repository.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_model.dart';
import 'package:lomo/ui/widget/sogiesc_list_widget.dart';
import 'package:lomo/util/constants.dart';

class FindFriendCreateDatingProfileModel extends BaseModel {
  final _commonRepository = locator<CommonRepository>();
  final _userRepository = locator<UserRepository>();
  ValueNotifier<Gender?> selectedGender = ValueNotifier(null);
  ValueNotifier<bool> validateData = ValueNotifier(false);
  ValueNotifier<SelectAllEvent?> setSelectAllSogiesc = ValueNotifier(null);

  List<Sogiesc>? selectedSogiescList;
  Role? selectedRole;

  late User user;

  @override
  ViewState get initState => ViewState.loaded;

  init(User user) {
    this.user = user;
    selectedGender.value =
        findGenderFromGenderId(user.filter?.gender) ?? GENDERS[1];
    selectedSogiescList =
        findSogiescListFromListSogiescId(user.filter?.sogiescs);
    selectedRole = findRoleFromRoleId(user.filter?.role);
    isValidateData();
  }

  Gender? findGenderFromGenderId(String? genderId) {
    Gender? result;
    GENDERS.forEach((element) {
      if (element.id == genderId) result = element;
    });

    return result;
  }

  Role? findRoleFromRoleId(String? roleId) {
    Role? result;
    _commonRepository.roles?.forEach((element) {
      if (element.id == roleId) result = element;
    });
    return result;
  }

  List<Sogiesc> findSogiescListFromListSogiescId(List<String>? sogiescIdList) {
    List<Sogiesc> result = [];
    if (sogiescIdList?.isNotEmpty == true) {
      sogiescIdList?.forEach((id) {
        _commonRepository.listSogiesc?.forEach((element) {
          if (element.id == id) {
            result.add(element);
          }
        });
      });
    }
    return result;
  }

  isValidateData() async {
    await Future.delayed(Duration(milliseconds: 100));
    validateData.value =
        selectedGender.value != null && selectedSogiescList?.isNotEmpty == true;
  }

  updateDatingProfile() async {
    if (user.filter == null) {
      user.filter = DatingFilter();
      user.filter!.sogiescs = [];
    }
    user.filter?.gender = selectedGender.value?.id;
    user.filter?.sogiescs?.clear();
    selectedSogiescList?.forEach((element) {
      user.filter?.sogiescs?.add(element.id!);
    });
    if (selectedRole != null) user.filter?.role = selectedRole?.id;
    await callApi(doSomething: () async {
      await _userRepository.updateDatingProfile(user);
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
