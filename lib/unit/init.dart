import 'dart:io';

import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:ostrich_flutter/unit/native_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:local_notifier/local_notifier.dart';

class InitBeforeLaunch {
  platformInit() {
    windowsInit();
  }

  windowsInit() async {
    try {
      var bytesDll =
          await rootBundle.load("assets/bin/windows/misc/wintun.dll");
      var bytesTun =
          await rootBundle.load("assets/bin/windows/misc/tun2socks.exe");
      var bytesNative =
          await rootBundle.load("assets/bin/windows/misc/native.dll");
      var bytesDb = await rootBundle.load("assets/data/ostrich.db");
      var bytesSqlite = await rootBundle.load("assets/data/sqlite3.dll");

      Map<String, String> envVars = Platform.environment;
      var home = envVars['UserProfile'].toString();
      //没有文件夹则创建文件夹
      Directory dir = Directory(home + "/.ostrichConfig");
      await dir.create(recursive: true);
      Directory miscDir = Directory(dir.path + "/misc");
      await miscDir.create(recursive: true);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("configDir", dir.path);
      //写入wintun.dll
      await File(dir.path + "/wintun.dll").writeAsBytes(bytesDll.buffer
          .asUint8List(bytesDll.offsetInBytes, bytesDll.lengthInBytes));
      await File(dir.path + "/native.dll").writeAsBytes(bytesNative.buffer
          .asUint8List(bytesNative.offsetInBytes, bytesNative.lengthInBytes));
      await File(dir.path + "/tun2socks.exe").writeAsBytes(bytesTun.buffer
          .asUint8List(bytesTun.offsetInBytes, bytesTun.lengthInBytes));
      await File(dir.path + "/ostrich.db").writeAsBytes(bytesDb.buffer
          .asUint8List(bytesDb.offsetInBytes, bytesDb.lengthInBytes));
      await File(dir.path + "/sqlite3.dll").writeAsBytes(bytesSqlite.buffer
          .asUint8List(bytesSqlite.offsetInBytes, bytesSqlite.lengthInBytes));

      // await nativeApi.requireAdministrator();
      if (await nativeApi.isAppElevated()) {
        // EasyLoading.showToast("您已用管理员启动");
      } else {
        LocalNotification? ostrichAdministratorNotification = LocalNotification(
          identifier: 'ostrichAdministratorNotification',
          title: "Ostrich",
          body: "启动失败，请您右键使用管理员启动!",
          actions: [
            LocalNotificationAction(
              text: '好的',
            ),
            LocalNotificationAction(
              text: '不好',
            ),
          ],
        );

        EasyLoading.showToast("请您右键使用管理员启动");
        ostrichAdministratorNotification.show();
        Future.delayed(const Duration(milliseconds: 300), () {
          // exit(0);
        });
      }
    } catch (e) {
      Logger().d(e);
    }
  }
}
