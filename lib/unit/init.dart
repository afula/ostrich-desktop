import 'dart:io';

import 'package:flutter/services.dart';
import 'package:process_run/shell.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

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
      var bytesNative = await rootBundle.load("assets/bin/windows/misc/native.dll");
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
    } catch (e) {
      print(e);
    }
  }
}
