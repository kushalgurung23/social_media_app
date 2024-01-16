import 'dart:async';
import 'dart:io';
import 'package:c_talent/logic/providers/auth_provider.dart';
import 'package:c_talent/logic/providers/drawer_provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:c_talent/logic/providers/main_screen_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../data/models/all_services.dart';
import '../../data/repositories/services/services_repo.dart';

class PermissionProvider extends ChangeNotifier {
  late MainScreenProvider mainScreenProvider;

  PermissionProvider({required this.mainScreenProvider});
  // translate
  String androidStoragePermissionDenyTitle = "Photos and Media";
  String androidStoragePermissionDenyDescription =
      "Allow photos and media access to add photos to your News, Paper Share and Profile. Would you like to go to app settings to give this permission?";

  String iosPhotosPermissionDenyTitle = "Photos";
  String iosPhotosPermissionDenyDesc =
      "To upload photos, please open the app settings and allow photos access.";

  Future<bool> requestPermission({required Permission permission}) async {
    if (await permission.isGranted) {
      return true;
    } else {
      PermissionStatus permissionStatus = await permission.request();
      if (permissionStatus == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  Future<bool> checkPermission(
      {required BuildContext context,
      required Permission permission,
      required String denyTitle,
      required String denyDescription}) async {
    DeviceInfoPlugin? plugin;
    AndroidDeviceInfo? android;
    if (Platform.isAndroid) {
      plugin = DeviceInfoPlugin();
      android = await plugin.androidInfo;
    }
    // if user's device is ios, they require photos permission instead of storage which is already handled by info.plist
    if (Platform.isIOS && permission == Permission.storage) {
      return true;
    }
    // if android sdk version is greater or equal to 33, the device doesn't require storage permission.
    else if (Platform.isAndroid &&
        android != null &&
        android.version.sdkInt >= 33 &&
        permission == Permission.storage) {
      return true;
    } else {
      // Ask permission..
      if (!await requestPermission(permission: permission)) {
        if (context.mounted) {
          // translate
          mainScreenProvider.showCustomAlertDialog(
              context: context,
              title: denyTitle,
              description: denyDescription,
              okButtonText: 'Ok',
              onOkClick: () async {
                Navigator.of(context).pop();
                await openAppSettings();
              },
              isOneButton: false,
              cancelButtonText: "Cancel",
              onCancelClick: () {
                Navigator.of(context).pop();
              });
        }
        return false;
      } else {
        return true;
      }
    }
  }

  // When image picker permission is not granted,
  Future<void> onImagePickerPermissionPlatformException(
      {required BuildContext context}) async {
    DeviceInfoPlugin? plugin;
    AndroidDeviceInfo? android;
    if (Platform.isAndroid) {
      plugin = DeviceInfoPlugin();
      android = await plugin.androidInfo;
    }
    // if exception occurs in android which has sdk lower than 33.
    // Note: Android sdk >= 33 does not require storage permission
    if (android != null &&
        android.version.sdkInt < 33 &&
        !await Permission.storage.isGranted &&
        Platform.isAndroid) {
      await Permission.storage.request();
    }
    // if permission is not granted in IOS
    else if (!await Permission.photos.isGranted && Platform.isIOS) {
      if (context.mounted) {
        mainScreenProvider.showCustomAlertDialog(
          context: context,
          title: iosPhotosPermissionDenyTitle,
          description: iosPhotosPermissionDenyDesc,
          okButtonText: AppLocalizations.of(context).ok,
          onOkClick: () {
            Navigator.of(context).pop();
            openAppSettings();
          },
          isOneButton: false,
          cancelButtonText: 'Cancel',
          onCancelClick: () {
            Navigator.of(context).pop();
          },
        );
      }
    } else {
      return;
    }
  }
}
