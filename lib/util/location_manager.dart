import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/libraries/geocoder/geocoder.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/ui/widget/dialog_widget.dart';

import 'constants.dart';
import 'navigator_service.dart';

class LocationManager {
  double locationLat = DEFAULT_LAT;
  double locationLng = DEFAULT_LNG;
  String locationCity = "";

  Future<Position> getLocation() async {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<Position?> getLastLocation() async {
    return await Geolocator.getLastKnownPosition();
  }

  Position? getLocationStreamSubscription() {
    Position? pos;
    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream().listen((Position position) {
      pos = position;
    });
    positionStream.cancel();
    return pos;
  }

  Future<bool> checkEnabledLocation() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  Future<bool> canGetGps() async {
    LocationPermission check = await Geolocator.checkPermission();
    if (check == LocationPermission.whileInUse ||
        check == LocationPermission.always) {
      // check = await Geolocator.requestPermission();
      return await Geolocator.isLocationServiceEnabled();
    } else {
      return false;
    }
  }

  requestEnableGpsWhenHasPermission(BuildContext contextDialog) async {
    final isEnableGps = await Geolocator.isLocationServiceEnabled();
    if (!isEnableGps) {
      if (Platform.isAndroid) {
        await showDialog(
            context: contextDialog,
            builder: (context) {
              return TwoButtonDialogAwaitConfirmWidget(
                description: Strings.pleaseEnableGps.localize(context),
                onConfirmed: () async {
                  await Geolocator.openLocationSettings();
                },
              );
            });
      } else {
        await showDialog(
            context: contextDialog,
            builder: (context) {
              return TwoButtonDialogAwaitConfirmWidget(
                description:
                    Strings.contentOfPermissionLocation.localize(context),
                onConfirmed: () async {
                  await Geolocator.openAppSettings();
                  await Geolocator.openLocationSettings();
                },
              );
            });
      }
    }
  }

  Future<void> requestGps({BuildContext? context}) async {
    BuildContext? contextDialog = context ??
        locator<NavigationService>().navigatorKey.currentState?.context;
    if (contextDialog != null) {
      final currentPermission = await Geolocator.checkPermission();
      if (currentPermission == LocationPermission.denied ||
          currentPermission == LocationPermission.deniedForever) {
        LocationPermission check = await requestPermission();
        if (check == LocationPermission.always ||
            check == LocationPermission.whileInUse) {
          requestEnableGpsWhenHasPermission(contextDialog);
        } else {
          if (Platform.isIOS) {
            showPermissionRequestLocation(
                context: contextDialog,
                callback: () async {
                  await Geolocator.openLocationSettings();
                });
          }
        }
      } else {
        requestEnableGpsWhenHasPermission(contextDialog);
      }
    }
  }

  Future<Position?> getCurrentLocation() async {
    return await GeolocatorPlatform.instance.getLastKnownPosition();
  }

  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
    await Geolocator.openLocationSettings();
  }

  Future<void> getLocationFromGps() async {
    try {
      var position = await GeolocatorPlatform.instance.getCurrentPosition();
      locationLat = position.latitude;
      locationLng = position.longitude;
    } catch (e) {
      print(e);
    }
  }

  Future<void> getDataLocation() async {
    try {
      var userRepository = locator<UserRepository>();
      var isGps = false;
      LocationPermission check = await Geolocator.checkPermission();
      bool isEnabledGps = await Geolocator.isLocationServiceEnabled();
      if (check == LocationPermission.denied ||
          check == LocationPermission.deniedForever) {
        var res = await userRepository.getIpLocation();
        locationLat = res!.lat!;
        locationLng = res.lon!;
      } else if (isEnabledGps) {
        var position = await GeolocatorPlatform.instance.getCurrentPosition();
        locationLat = position.latitude;
        locationLng = position.longitude;
        isGps = true;
      } else {
        var res = await userRepository.getIpLocation();
        locationLat = res!.lat!;
        locationLng = res.lon!;
      }
      try {
        final coordinates = new Coordinates(locationLat, locationLng);
        final addresses =
            await Geocoder.local.findAddressesFromCoordinates(coordinates);
        locationCity = addresses.first.adminArea!;
      } catch (e) {
        print(e);
      }
      print("isGps: $isGps");
      locator<UserRepository>().updateLocation(
          lat: locationLat, lng: locationLng, city: locationCity, isGps: isGps);
    } catch (e) {
      print(e);
    }
  }

  Future<void> showPermissionRequestLocation(
      {BuildContext? context, Function()? callback}) async {
    BuildContext? contextDialog = context ??
        locator<NavigationService>().navigatorKey.currentState?.context;
    if (contextDialog != null)
      await showDialog(
          context: contextDialog,
          builder: (context) {
            return TwoButtonDialogAwaitConfirmWidget(
              title: Strings.needPermissionLocation.localize(context),
              description:
                  Strings.contentOfPermissionLocation.localize(context),
              onConfirmed: () async {
                await openAppSettings();
                if (callback != null) callback();
              },
            );
          });
  }
}

class LocationValue {
  double latitude;
  double longitude;

  LocationValue(this.latitude, this.longitude);
}
