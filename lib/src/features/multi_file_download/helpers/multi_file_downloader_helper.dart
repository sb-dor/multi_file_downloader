import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class MultiFileDownloaderHelper {
  Future<bool> storagePermission({bool checkOnceAgain = false}) async {
    final deviceInfo = await DeviceInfoPlugin().deviceInfo;
    bool permission = false;

    if (deviceInfo is AndroidDeviceInfo) {
      if (deviceInfo.version.sdkInt >= 33) {
        // On Android 13 (API 33) and above, this permission is deprecated and always returns PermissionStatus.denied.
        // Instead use Permission.photos, Permission.video, Permission.audio or Permission.manageExternalStorage
        permission = await Permission.photos.request().isGranted;
      } else {
        permission = await Permission.storage.request().isGranted;
      }

      if (!permission && !checkOnceAgain) {
        await openAppSettings();
        permission = await storagePermission(checkOnceAgain: true);
      }
    } else {
      permission = true;
    }

    return permission;
  }

  Future<Directory> downloadsDirectory() async {
    late Directory downloadsDirectory;

    if (defaultTargetPlatform == TargetPlatform.android) {
      downloadsDirectory = Directory(
        await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOAD),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      downloadsDirectory = await getApplicationDocumentsDirectory();
    } else {
      downloadsDirectory =
          (await getDownloadsDirectory()) ?? (await getApplicationDocumentsDirectory());
    }
    return downloadsDirectory;
  }
}
