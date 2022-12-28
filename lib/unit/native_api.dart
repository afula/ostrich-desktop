import 'dart:ffi';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

import 'bridge_generated.dart';

// Re-export the bridge so it is only necessary to import this file.
export 'bridge_generated.dart';
import 'dart:io' as io;

 Native getDyLibApi(){
  Map<String, String> envVars = Platform.environment;
  var home = envVars['UserProfile'].toString();
  Directory dir = Directory(home + "/.ostrichConfig");
  File nativeFile = File(dir.path + "/native.dll");
  Native api = NativeImpl(io.Platform.isIOS || io.Platform.isMacOS
      ? DynamicLibrary.executable()
      : DynamicLibrary.open(nativeFile.path));
  return api;
}

