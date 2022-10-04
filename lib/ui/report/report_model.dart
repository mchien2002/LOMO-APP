import 'package:flutter/cupertino.dart';
import 'package:lomo/data/repositories/common_repository.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/libraries/photo_manager/photo_provider.dart';
import 'package:lomo/ui/base/base_model.dart';

import '../../data/api/models/enums.dart';
import '../../libraries/photo_manager/photo_manager.dart';
import '../../res/strings.dart';
import '../../util/image_util.dart';

class ReportModel extends BaseModel {
  final issues = [
    ReportIssue(Strings.offensive),
    ReportIssue(Strings.violence),
    ReportIssue(Strings.harassment),
    ReportIssue(Strings.nudity),
    ReportIssue(Strings.falseInformation),
    ReportIssue(Strings.falsity),
    ReportIssue(Strings.spam),
    ReportIssue(Strings.terrorism),
    ReportIssue(Strings.hateSpeech),
    ReportIssue(Strings.unauthorizedSales),
    ReportIssue(Strings.other),
  ];
  final _userRepository = locator<UserRepository>();
  final _commonRepository = locator<CommonRepository>();
  ValueNotifier<List<String>> selectedIssues = ValueNotifier([]);
  ValueNotifier<List<PhotoInfo>> attachFiles = ValueNotifier([]);
  ValueNotifier<bool> enableButton = ValueNotifier(false);
  ValueNotifier<bool> showOtherContent = ValueNotifier(false);
  List<String> imagesUploaded = [];

  TextEditingController tecContent = TextEditingController();

  report(
    BuildContext context,
    String userId, {
    String? newFeedId,
    List<String>? images,
  }) async {
    await callApi(doSomething: () async {
      List<String> reports = [];
      issues.forEach((element) {
        if (element.isChoose) {
          reports.add(element.title.localize(context));
        }
      });
      if (attachFiles.value.isNotEmpty) {
        await _uploadPhoto();
      }
      await _userRepository.report(
          userId: userId,
          reports: reports,
          content: tecContent.text,
          newFeedId: newFeedId,
          images: imagesUploaded);
    });
  }

  init() async {
    tecContent.addListener(() {
      validateData();
    });
  }

  validateData() {
    final lastCheckedItemIndex =
        issues.lastIndexWhere((element) => element.isChoose);
    // nếu đã check vào phần tử other thì hiển thị ô nhập nội dung khác
    // other là phần tử cuối cùng trong mảng issues
    if (lastCheckedItemIndex == issues.length - 1) {
      showOtherContent.value = true;
    } else {
      showOtherContent.value = false;
      tecContent.text = "";
    }

    enableButton.value = tecContent.text != "" ||
        (lastCheckedItemIndex != -1 &&
            lastCheckedItemIndex != issues.length - 1);
  }

  @override
  void dispose() {
    tecContent.dispose();
    selectedIssues.dispose();
    attachFiles.dispose();
    enableButton.dispose();
    showOtherContent.dispose();
    super.dispose();
  }

  pickImages(BuildContext context) async {
    final photos =
        await getImagesUint8List(context, items: attachFiles.value, limit: 5);
    if (photos.isNotEmpty == true) {
      attachFiles.value = photos.toList();
    }
  }

  removeImage(int index) {
    attachFiles.value.removeAt(index);
    attachFiles.value = attachFiles.value.toList();
  }

  _uploadPhoto() async {
    imagesUploaded.clear();
    await Future.forEach(attachFiles.value, (PhotoInfo photo) async {
      PhotoInfo photoInfo = await compressImageWithUint8List(photo.u8List!);
      String? photoUrl = await _commonRepository.uploadImageFromBytes(
          photoInfo.u8List!,
          uploadDir: UploadDirName.report);
      imagesUploaded.add(photoUrl!);
    });
  }
}

class ReportIssue {
  ReportIssue(this.title);
  final String title;
  bool isChoose = false;
}
