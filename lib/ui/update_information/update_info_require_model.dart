import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/api/models/city.dart';
import 'package:lomo/data/api/models/enums.dart';
import 'package:lomo/data/api/models/gender.dart';
import 'package:lomo/data/api/models/old_lomoid.dart';
import 'package:lomo/data/api/models/old_name.dart';
import 'package:lomo/data/repositories/common_repository.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/ui/base/base_form_model.dart';
import 'package:lomo/ui/base/base_model.dart';
import 'package:lomo/util/constants.dart';
import 'package:lomo/util/image_util.dart';
import 'package:lomo/util/validate_utils.dart';

class UpdateInfoRequireModel extends BaseFormModel {
  final _userRepository = locator<UserRepository>();
  final commonRepository = locator<CommonRepository>();

  TextEditingController tecUserName = TextEditingController();
  TextEditingController tecEmail = TextEditingController();
  TextEditingController tecCaption = TextEditingController();
  TextEditingController textLomoId = TextEditingController();
  ValueNotifier<bool> validateData = ValueNotifier(false);

  final user = locator<UserModel>().user!;
  final List<Gender> genders = [GENDERS[0], GENDERS[1], GENDERS[2]];
  final List<List<Gender>> lookingForGenders = [
    [GENDERS[0]],
    [GENDERS[1]],
    [GENDERS[0], GENDERS[1]]
  ];
  Gender? gender;
  Gender? lookingForGender;
  ValueNotifier<Uint8List?> avatar = ValueNotifier(null);
  City? city;
  int? weight;
  int? height;
  DateTime? dateOfBirth;
  String? email;
  bool isCheckPolicy = false;
  ValueNotifier<bool> validatedInfo = ValueNotifier(false);

  @override
  ViewState get initState => ViewState.loaded;

  init() async {
    // set default value;
    if (this.user.gender == null) this.user.gender = GENDERS[0];
    if (this.user.followGenders == null ||
        !(this.user.followGenders?.isNotEmpty == true))
      this.user.followGenders = [GENDERS[0]];
    tecUserName.text = user.name ?? "";
    tecEmail.text = user.email ?? "";
    textLomoId.text = user.lomoId ?? "";
    dateOfBirth = user.birthday;
    email = user.email ?? "";
    isValidateData();
    isValidateData();
  }

  //Kiem tra name da su dung truoc do
  bool checkEqualOldName(String newName) {
    if (user.oldNames.isEmpty) return false;
    OldName? oldName;
    user.oldNames.forEach((element) {
      if (element.name == newName) oldName = element;
    });
    if (oldName != null && oldName != user.oldNames[0]) return true;
    return false;
  }

//Kiem tra lomoid da su dung truoc do
  bool checkEqualLomoId(String newLomoId) {
    if (user.oldLomoIds.isEmpty) return false;
    OldLomoId? oldLomoId;
    user.oldLomoIds.forEach((element) {
      if (element.lomoId == newLomoId) oldLomoId = element;
    });
    if (oldLomoId != null && oldLomoId != user.oldLomoIds[0]) return true;
    return false;
  }

  bool checkChangeName14Days(String newName) {
    if (user.oldNames.isEmpty ||
        user.oldNames.length <= 1 ||
        newName == user.oldNames[0].name) return false;
    final currentTime = DateTime.now();
    final difference = currentTime.subtract(const Duration(days: 14));
    return difference.millisecondsSinceEpoch <=
            user.oldNames[0].updatedAt * 1000 &&
        newName != user.oldNames[0].name;
  }

  bool checkChangeLomoId14Days(String newLomoId) {
    if (user.oldLomoIds.isEmpty ||
        user.oldLomoIds.length <= 1 ||
        newLomoId == user.oldLomoIds[0].lomoId) return false;
    final currentTime = DateTime.now();
    final difference = currentTime.subtract(const Duration(days: 14));
    return difference.millisecondsSinceEpoch <=
            user.oldLomoIds[0].updatedAt * 1000 &&
        newLomoId != user.oldLomoIds[0].lomoId;
  }

  String? validateName(String newName, BuildContext context) {
    if (checkChangeName14Days(newName)) {
      return Strings.correct_name_after14days.localize(context);
    } else if (checkEqualOldName(newName)) {
      return Strings.correct_old_format.localize(context);
    } else if (!validateUserName(newName)) {
      return Strings.correct_format.localize(context);
    } else {
      return null;
    }
  }

  String? validateLomoId(String newLomoId, BuildContext context) {
    if (checkChangeLomoId14Days(newLomoId)) {
      return Strings.correct_lomoid_after14days.localize(context);
    } else if (checkEqualLomoId(newLomoId)) {
      return Strings.lomo_old_format.localize(context);
    } else if (!validateLoMoId(newLomoId)) {
      if (user.lomoId != null &&
          (user.lomoId!.contains("_") || user.lomoId!.contains("-"))) {
        return null;
      }
      return Strings.lomo_id_format.localize(context);
    } else {
      return null;
    }
  }

  uploadAvatar() async {
    final compressAvatar = await compressImageWithUint8List(avatar.value!);
    if (compressAvatar.u8List != null) {
      String? avatarLinkUploaded = await commonRepository.uploadImageFromBytes(
          compressAvatar.u8List!,
          uploadDir: UploadDirName.avatar);
      user.avatar = avatarLinkUploaded;
    }
  }

  updateProfile(String userName, String lomoId, String email) async {
    await callApi(doSomething: () async {
      user.name = userName;
      user.lomoId = lomoId;
      user.email = email;
      if (avatar.value != null) await uploadAvatar();
      await _userRepository.updateProfile(user);
      _userRepository.getMe();
    });
  }

  clearCurrentUser() async {
    await _userRepository.logout();
    locator<UserModel>().setAuthState(AuthState.unauthorized);
  }

  updateProfileSuccess() async {
    locator<UserModel>().setAuthState(AuthState.authorized);
  }

  isValidateData() {
    validateData.value = checkOldData();
  }

  bool checkOldData() {
    DateFormat dateFormat = DateFormat("yyyyMMdd");
    if (user.name != tecUserName.text ||
        user.lomoId != textLomoId.text ||
        email != tecEmail.text ||
        avatar.value != null ||
        '${dateFormat.format(dateOfBirth ?? DateTime.now())}' !=
            '${dateFormat.format(user.birthday ?? DateTime.now())}')
      return true;
    else
      return false;
  }

  @override
  void dispose() {
    avatar.dispose();
    validatedInfo.dispose();
    tecUserName.dispose();
    tecEmail.dispose();
    tecCaption.dispose();
    textLomoId.dispose();
    super.dispose();
  }
}
