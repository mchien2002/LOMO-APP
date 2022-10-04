import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as IMG;
import 'package:image_cropper/image_cropper.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/new_feed/video_resize/video_resize_screen.dart';
import 'package:lomo/ui/widget/dialog_widget.dart';
import 'package:lomo/util/common_utils.dart';
import 'package:lomo/util/image_util.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

import 'grid_photos_screen.dart';
import 'photo_provider.dart';

Future<PhotoInfo?> getVideo(BuildContext context,
    {List<PhotoInfo>? items, bool isEdit = true}) async {
  final hasPermissionImages = await checkPermissionImage(context);
  if (hasPermissionImages) {
    var page = GridPhotosScreen(
      totalPhoto: 1,
      itemsSelected: items ?? [],
      isMultiple: false,
      type: RequestType.video,
    );
    final result = await Navigator.of(context).push(_createRoute(page));

    if (isEdit && result != null && result.entity != null) {
      final file = await result.entity?.file;
      final editVideo = VideoResizeScreen(file: file);
      final listEdit =
          await Navigator.of(context).push(_createRoute(editVideo));
      if (listEdit != null) {
        result.u8List = listEdit[0];
        result.thumb = listEdit[1];
        result.duration = listEdit[2];
        if (result.thumb != null) {
          IMG.Image? image = IMG.decodeImage(result.thumb!);
          result.ratio = image != null
              ? double.parse((image.width / image.height).toStringAsFixed(2))
              : 1;
        }
        return result;
      } else {
        return null;
      }
    } else {
      return result;
    }
  } else {
    showToast(Strings.loadImageError.localize(context));
    return null;
  }
}

Future<PhotoInfo?> getImageUint8List(BuildContext context,
    {bool isEdit = false}) async {
  final hasPermissionImages = await checkPermissionImage(context);
  if (hasPermissionImages) {
    var page = GridPhotosScreen(
      totalPhoto: 1,
      isMultiple: false,
      type: RequestType.image,
    );
    final result = await Navigator.of(context).push(_createRoute(page));
    if (isEdit && result != null && result.entity != null) {
      final file = await result.entity!.file;
      final u8ListEdit = await editPhoto(context, file?.readAsBytesSync());
      result.u8List = u8ListEdit;
      return result;
    } else {
      final file = await result.entity!.file;
      result.u8List = file?.readAsBytesSync();
      return result;
    }
  } else {
    showToast(Strings.loadImageError.localize(context));
    return null;
  }
}

Future<List<PhotoInfo>> getImagesUint8List(BuildContext context,
    {int limit = 5, List<PhotoInfo>? items}) async {
  final hasPermissionImages = await checkPermissionImage(context);
  if (hasPermissionImages) {
    var page = GridPhotosScreen(
      totalPhoto: limit,
      itemsSelected: items ?? [],
      isMultiple: true,
      type: RequestType.image,
    );
    final result = await Navigator.of(context).push(_createRoute(page));
    if (result != null)
      await Future.forEach(result as List<PhotoInfo>,
          (PhotoInfo element) async {
        if (element.entity != null) {
          final file = await element.entity!.file;
          element.u8List = file?.readAsBytesSync();
        }
      });
    return result ?? [];
  } else {
    return [];
  }
}

Future<Uint8List?> editVideo(BuildContext context, Uint8List u8List) async {
  final filePath = await destinationFileVideo;
  final file = await writeToFile(u8List, filePath);
  final editVideo = VideoResizeScreen(pathVideo: file.path);
  final u8ListEdit = await Navigator.of(context).push(_createRoute(editVideo));
  return u8ListEdit[0] as Uint8List;
}

Future<Uint8List?> editPhoto(BuildContext context, Uint8List? u8List) async {
  if (u8List == null) return null;
  final filePath = await destinationFileImage;
  await writeToFile(u8List, filePath);
  File? croppedFile = await ImageCropper().cropImage(
      maxWidth: 720,
      maxHeight: 1080,
      sourcePath: filePath,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: Strings.edit.localize(context),
          toolbarColor: getColor().colorPrimary,
          cropFrameColor: getColor().colorPrimary,
          activeControlsWidgetColor: getColor().colorPrimary,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      iosUiSettings: IOSUiSettings(
        title: Strings.edit.localize(context),
      ));
  if (croppedFile != null) {
    return croppedFile.readAsBytesSync();
  }
  return null;
}

Route _createRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Future<bool> checkPermissionImage(BuildContext context) async {
  await PhotoManager.requestPermissionExtend();
  final status = await Permission.photos.status;
  if (status.isDenied || status.isPermanentlyDenied) {
    showDialog(
        context: context,
        builder: (context) => TwoButtonDialogWidget(
              description: Strings.pleaseGrandPhotoPermission.localize(context),
              onConfirmed: () async {
                openAppSettings();
              },
            ));
    return false;
  }
  return true;
}
