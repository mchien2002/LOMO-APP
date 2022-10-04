import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/api/models/city.dart';
import 'package:lomo/data/api/models/constant_list.dart';
import 'package:lomo/data/api/models/enums.dart';
import 'package:lomo/data/api/models/gender.dart';
import 'package:lomo/data/api/models/relationship.dart';
import 'package:lomo/data/api/models/sogiesc.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/api/models/zodiac.dart';
import 'package:lomo/data/repositories/common_repository.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/ui/base/base_model.dart';
import 'package:lomo/util/common_utils.dart';
import 'package:lomo/util/constants.dart';
import 'package:lomo/util/image_util.dart';
import 'package:lomo/util/permission_handle_manager.dart';
import 'package:rxdart/rxdart.dart';

class UpdateInformationModel extends BaseModel {
  final _userRepository = locator<UserRepository>();
  final commonRepository = locator<CommonRepository>();
  final permissionManager = locator<PermissionHandleManager>();
  TextEditingController tecUserName = TextEditingController();
  TextEditingController tecEmail = TextEditingController();
  TextEditingController tecCaption = TextEditingController();
  TextEditingController zodiacController = TextEditingController();
  TextEditingController sogiescController = TextEditingController();
  TextEditingController relationshipController = TextEditingController();
  TextEditingController careerController = TextEditingController();
  TextEditingController literacyController = TextEditingController();

  final sogiescSubject = BehaviorSubject<List<String>>();
  final sogiescValueSubject = BehaviorSubject<List<Sogiesc>>();

  final isShowTestSogiescSubject = BehaviorSubject<bool>();

  late User user;
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
  bool isCheckPolicy = false;
  ValueNotifier<bool> validatedInfo = ValueNotifier(false);
  List<Zodiac> listItems = [];
  Zodiac? zodiacValue;
  List<Sogiesc> listSogiesc = [];
  List<Sogiesc> sogiescsValue = [];
  List<Relationship> listRelationship = [];
  Relationship? relationshipValue;
  List<KeyValue> listCareer = [];
  KeyValue? careerValue;
  List<Literacy> listLiteracy = [];
  Literacy? literacyValue;

  @override
  ViewState get initState => ViewState.loaded;

  init(User user) async {
    this.user = user;
    // set default value;
    if (this.user.gender == null) this.user.gender = GENDERS[0];
    if (this.user.followGenders == null || this.user.followGenders!.length == 0)
      this.user.followGenders = [GENDERS[0]];
    if (user.zodiac != null) {
      zodiacValue = user.zodiac;
      zodiacController.text = zodiacValue!.name!;
    }
    if (user.relationship != null) {
      relationshipValue = user.relationship;
      relationshipController.text = relationshipValue!.name!;
    }
    if (user.sogiescs != null && user.sogiescs?.isNotEmpty == true) {
      sogiescsValue = user.sogiescs!;
      setTextSogiescs(sogiescsValue);
    }
    if (user.careers != null) {
      // careerController.text = user.career.name;
      // careerValue = user.career;
    }
    if (user.literacy != null) {
      literacyValue = user.literacy;
      literacyController.text = user.literacy!.name!;
    }
    listItems = (await commonRepository.getZodiac())!;
    listSogiesc = (await commonRepository.getSogiesc())!;
    listRelationship = (await commonRepository.getRelationship())!;
    listLiteracy = (await commonRepository.getListLiteracy())!;
    listCareer = (await commonRepository.getListCareer())!;
    // this.user = await _userRepository.getMe();
    //notifyListeners();
  }

  void setTextSogiescs(List<Sogiesc> value) {
    sogiescSubject.sink.add(sogiescsValue.map((e) => e.name!).toList());
    sogiescValueSubject.sink.add(sogiescsValue);
  }

  void addNowSogiesc(List<String> listData, BuildContext context) {
    List<Sogiesc> listNew = listSogiesc
        .where((e) =>
            listData.any((b) => e.name!.toLowerCase() == b.toLowerCase()))
        .toList();
    List<Sogiesc> list = [];
    if (listNew.isNotEmpty == true && sogiescsValue.isNotEmpty == true) {
      for (int i = 0; i < listNew.length; i++) {
        if (!(sogiescsValue
                .where((e) => e.name!
                    .toLowerCase()
                    .contains(listNew[i].name!.toLowerCase()))
                .isNotEmpty ==
            true)) {
          list.add(listNew[i]);
        }
      }
    } else {
      list.addAll(listNew);
    }
    if (list.isNotEmpty == true) {
      sogiescsValue.addAll(list);
      sogiescSubject.sink
          .add(sogiescsValue.map((e) => e.name!).toList().reversed.toList());
      sogiescValueSubject.sink.add(sogiescsValue);
      isShowTestSogiescSubject.sink.add(false);
      showToast(Strings.success.localize(context));
    } else {
      isShowTestSogiescSubject.sink.add(false);
      showToast(Strings.alreadyExist.localize(context));
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

  updateProfile(
      String userName,
      String email,
      String story,
      Zodiac zodiac,
      List<Sogiesc> sogiescs,
      Relationship relationship,
      List<KeyValue> career,
      Literacy literacy) async {
    await callApi(doSomething: () async {
      user.name = userName;
      user.email = email;
      user.story = story;
      user.zodiac = zodiac;
      user.sogiescs = sogiescs;
      user.relationship = relationship;
      user.careers = career;
      user.literacy = literacy;
      if (avatar.value != null) await uploadAvatar();
      await _userRepository.updateProfile(user);
    });
  }

  clearCurrentUser() async {
    await _userRepository.logout();
    locator<UserModel>().setAuthState(AuthState.unauthorized);
  }

  updateProfileSuccess() async {
    locator<UserModel>().setAuthState(AuthState.authorized);
  }

  @override
  void dispose() {
    avatar.dispose();
    validatedInfo.dispose();
    tecUserName.dispose();
    tecEmail.dispose();
    tecCaption.dispose();
    zodiacController.dispose();
    sogiescController.dispose();
    relationshipController.dispose();
    careerController.dispose();
    literacyController.dispose();
    sogiescSubject.close();
    sogiescValueSubject.close();
    isShowTestSogiescSubject.close();
    super.dispose();
  }
}
