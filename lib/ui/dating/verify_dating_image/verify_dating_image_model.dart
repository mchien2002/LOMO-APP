import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:lomo/data/api/models/dating_image.dart';
import 'package:lomo/data/api/models/enums.dart';
import 'package:lomo/data/repositories/common_repository.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/ui/base/base_model.dart';
import 'package:lomo/util/image_util.dart';

class VerifyDatingImageModel extends BaseModel {
  final _userRepository = locator<UserRepository>();
  List<DatingImage> verifyImages = [DatingImage(), DatingImage()];
  ValueNotifier<bool> enableButtonSend = ValueNotifier(false);

  final List<String> sampleImages = [
    DImages.verifyDating1,
    DImages.verifyDating2,
    DImages.verifyDating3,
    DImages.verifyDating4,
    DImages.verifyDating5,
    DImages.verifyDating6,
    DImages.verifyDating7,
    DImages.verifyDating8,
    DImages.verifyDating9,
    DImages.verifyDating10,
  ];

  ValueNotifier<String> sampleImage1 = ValueNotifier(DImages.verifyDating1);
  ValueNotifier<String> sampleImage2 = ValueNotifier(DImages.verifyDating2);

  @override
  ViewState get initState => ViewState.loaded;

  isValidateData() {
    enableButtonSend.value =
        verifyImages[0].u8List != null && verifyImages[1].u8List != null;
  }

  updateImages() {
    notifyListeners();
  }

  String getRandomSampleImage() {
    Random rnd = new Random();
    final listRandom = sampleImages
        .where((element) =>
            element != sampleImage1.value && element != sampleImage2.value)
        .toList();
    return listRandom[rnd.nextInt(listRandom.length)];
  }

  uploadImages() async {
    await callApi(doSomething: () async {
      for (DatingImage image in verifyImages) {
        if (image.u8List != null) {
          final compressAvatar =
              await compressImageWithUint8List(image.u8List!);
          if (compressAvatar.u8List != null) {
            String? linkImageUpload = await locator<CommonRepository>()
                .uploadImageFromBytes(compressAvatar.u8List!,
                    uploadDir: UploadDirName.dating);
            image.link = linkImageUpload;
          }
        }
      }
    });
  }

  sendVerifyRequest() async {
    await callApi(doSomething: () async {
      await uploadImages();
      await _userRepository
          .verifyDatingImage(verifyImages.map((e) => e.link!).toList());
    });
  }

  @override
  void dispose() {
    enableButtonSend.dispose();
    sampleImage1.dispose();
    sampleImage2.dispose();
    super.dispose();
  }
}
