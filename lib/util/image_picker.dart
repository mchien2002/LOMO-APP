import 'package:flutter/material.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/libraries/absolute_path/flutter_absolute_path.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/ui/widget/dialog_widget.dart';
import 'package:lomo/util/platform_channel.dart';
import 'package:permission_handler/permission_handler.dart';

class MyImagePicker {
  final platformChannel = locator<PlatformChannel>();

  // Future<String?> pickSingleImageNative(BuildContext context,
  //     {GalleryType type = GalleryType.image}) async {
  //   final hasPermissionImages = await checkPermissionImage(context);
  //   if (hasPermissionImages) {
  //     try {
  //       List<String> images = await platformChannel.pickImages(1, type,
  //           autoDismissOnMaxSelections: true);
  //       return images.isNotEmpty == true ? images[0] : null;
  //     } catch (e) {
  //       print(e);
  //       return null;
  //     }
  //   } else {
  //     return null;
  //   }
  // }
  //
  // Future<List<String>?> pickMultiImageNative(BuildContext context,
  //     {GalleryType type = GalleryType.image, int totalItem = 2}) async {
  //   final hasPermissionImages = await checkPermissionImage(context);
  //   if (hasPermissionImages) {
  //     try {
  //       List<String> images = await platformChannel.pickImages(totalItem, type,
  //           autoDismissOnMaxSelections: false);
  //       return images.isNotEmpty == true ? images : null;
  //     } catch (e) {
  //       print(e);
  //       return null;
  //     }
  //   } else {
  //     return null;
  //   }
  // }

  Future<bool> checkPermissionImage(BuildContext context) async {
    final status = await Permission.photos.status;
    if (status.isDenied || status.isPermanentlyDenied) {
      showDialog(
          context: context,
          builder: (context) => TwoButtonDialogWidget(
                description:
                    Strings.pleaseGrandPhotoPermission.localize(context),
                onConfirmed: () async {
                  openAppSettings();
                },
              ));
      return false;
    }
    return true;
  }
}
 Future<String> getImagePathFromAsset(String imageId) async {
   return await FlutterAbsolutePath.getAbsolutePath(imageId);
 }
enum GalleryType { all, image, video }

extension GalleryTypeExt on GalleryType {
  int get type {
    switch (this) {
      case GalleryType.all:
        return 0;
      case GalleryType.image:
        return 1;
      case GalleryType.video:
        return 2;
      default:
        return 1;
    }
  }
}
