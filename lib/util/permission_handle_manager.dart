import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/ui/widget/dialog_widget.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandleManager {
  Future<bool?> checkPermissionStorage() async {
    var status = await Permission.storage.status;
    if (status.isPermanentlyDenied) {
      return null;
    }
    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  requestPermissionApp(BuildContext context) async {
    await checkPermissionTracking(context);
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      Permission.storage,
      Permission.photos,
    ].request();
  }

  Future<bool?> checkPermissionCamera() async {
    var status = await Permission.camera.status;
    if (status.isPermanentlyDenied) {
      return null;
    }
    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkPermissionMicro() async {
    var status = await Permission.microphone.status;
    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> checkPermissionTracking(BuildContext context) async {
    if (Platform.isIOS) {
      var status = await AppTrackingTransparency.trackingAuthorizationStatus;
      if (status == TrackingStatus.notDetermined) {
        await AppTrackingTransparency.requestTrackingAuthorization();
      }
    }
  }

  Future<void> showPermissionRequestStorage(
      BuildContext context, int index, Function callback) async {
    await showDialog(
        context: context,
        builder: (context) {
          return TwoButtonDialogAwaitConfirmWidget(
            title: textTitlePermission(context, index),
            description: textDescriptionPermission(context, index),
            onConfirmed: () async {
              switch (index) {
                case 0:
                  await openStoragePermission();
                  if (await checkPermissionStorage() == true) callback();
                  break;
                case 1:
                  await openCameraPermission();
                  if (await checkPermissionCamera() == true) callback();
                  break;
                case 2:
                  await openStoragePermission();
                  await openCameraPermission();
                  if (await checkPermissionStorage() == true &&
                      await checkPermissionCamera() == true) callback();
                  break;
                default:
                  await openStoragePermission();
                  await openCameraPermission();
                  if (await checkPermissionStorage() == true &&
                      await checkPermissionCamera() == true) callback();
                  break;
              }
            },
          );
        });
  }

  String textTitlePermission(BuildContext context, int index) {
    switch (index) {
      case 0:
        return Strings.needPermissionStorage.localize(context);
      case 1:
        return Strings.needPermissionCamera.localize(context);
      case 2:
        return Strings.needPermissionBothStorageAndCamera.localize(context);
      default:
        return Strings.needPermissionBothStorageAndCamera.localize(context);
    }
  }

  String textDescriptionPermission(BuildContext context, int index) {
    switch (index) {
      case 0:
        return Strings.contentOfPermissionStorage.localize(context);
      case 1:
        return Strings.contentOfPermissionCamera.localize(context);
      case 2:
        return Strings.contentOfPermissionBothStorageAndCamera
            .localize(context);
      default:
        return Strings.contentOfPermissionBothStorageAndCamera
            .localize(context);
    }
  }

  Future<void> openStoragePermission() async {
    await Permission.storage.request();
  }

  Future<void> openLocationPermission() async {
    await Permission.location.request();
  }

  Future<void> openCameraPermission() async {
    await Permission.camera.request();
  }

  Future<void> openMicroPermission() async {
    await Permission.microphone.request();
  }
}
