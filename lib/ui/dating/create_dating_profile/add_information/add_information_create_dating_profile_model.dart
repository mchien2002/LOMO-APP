import 'package:flutter/widgets.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/api/models/constant_list.dart';
import 'package:lomo/data/api/models/dating_image.dart';
import 'package:lomo/data/api/models/enums.dart';
import 'package:lomo/data/api/models/gender.dart';
import 'package:lomo/data/api/models/sogiesc.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/repositories/common_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_model.dart';
import 'package:lomo/util/common_utils.dart';
import 'package:lomo/util/image_util.dart';

class AddInformationCreateDatingProfileModel extends BaseModel {
  final _commonRepository = locator<CommonRepository>();
  ValueNotifier<List<DatingImage>> datingImages = ValueNotifier([]);
  ValueNotifier<Gender?> selectedGender = ValueNotifier(null);
  TextEditingController tecQuoteDating = TextEditingController();
  List<Sogiesc>? selectedSogiescList;
  Role? selectedRole;
  User user = User.fromJson(locator<UserModel>().user!.toJson());
  bool isShowGender = true;
  bool isShowSogiesc = true;
  bool isShowRole = true;

  ValueNotifier<bool> validateData = ValueNotifier(false);

  ViewState get initState => ViewState.loaded;

  init() {
    tecQuoteDating.text = user.quote ?? "";
    initDatingImages();
    selectedGender.value = user.gender;
    selectedSogiescList = List<Sogiesc>.from(user.sogiescs!).toList();
    selectedRole = user.role;
    // isShowGender = !user.fieldDisabled.contains(UserFieldDisabled.gender);
    // isShowSogiesc = !user.fieldDisabled.contains(UserFieldDisabled.sogiescs);
    // isShowRole =
    //     !user.fieldDisabled.contains(UserDatingFieldDisabled.datingRole);
    isValidateData();
    tecQuoteDating.addListener(() {
      isValidateData();
    });
  }

  isValidateData() {
    validateData.value = (datingImages.value[0].u8List != null ||
            datingImages.value[0].link != null) &&
        (datingImages.value[1].u8List != null ||
            datingImages.value[1].link != null) &&
        tecQuoteDating.text != "" &&
        selectedGender.value != null &&
        selectedSogiescList?.isNotEmpty == true;
  }

  initDatingImages() {
    datingImages.value = user.datingImages?.isNotEmpty == true
        ? List<DatingImage>.from(user.datingImages!)
        : [];
    if (datingImages.value.length < 6) {
      for (int i = datingImages.value.length; i < 6; i++)
        datingImages.value.add(DatingImage());
    }
  }

  uploadImages() async {
    await callApi(doSomething: () async {
      for (DatingImage image in datingImages.value) {
        if (image.u8List != null) {
          final compressAvatar =
              await compressImageWithUint8List(image.u8List!);
          if (compressAvatar.u8List != null) {
            String? linkImageUpload = await _commonRepository
                .uploadImageFromBytes(compressAvatar.u8List!,
                    uploadDir: UploadDirName.dating);
            image.link = linkImageUpload;
          }
        }
      }
    });
  }

  updateImages() {
    datingImages.notifyListeners();
  }

  User getUserInfo() {
    user.datingImages?.clear();
    user.datingImages =
        datingImages.value.where((element) => element.link != null).toList();
    user.quote = removeInvalidSpaceAndEnter(tecQuoteDating.text);
    // addOrRemoveShowHideField(UserFieldDisabled.gender, isShowGender);
    user.gender = selectedGender.value;
    // addOrRemoveShowHideField(UserFieldDisabled.sogiescs, isShowSogiesc);
    user.sogiescs?.clear();
    user.sogiescs?.addAll(selectedSogiescList ?? []);
    // addOrRemoveShowHideField(UserDatingFieldDisabled.datingRole, isShowRole);
    user.role = selectedRole;
    return user;
  }

  addOrRemoveShowHideField(String field, bool isShow) {
    try {
      bool isExistDisabledField = user.fieldDisabled!.contains(field);
      if (isShow) {
        if (isExistDisabledField) {
          user.fieldDisabled!.remove(field);
        }
      } else {
        if (!isExistDisabledField) {
          user.fieldDisabled!.add(field);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    tecQuoteDating.dispose();
    selectedGender.dispose();
    validateData.dispose();
    datingImages.dispose();
    super.dispose();
  }
}
