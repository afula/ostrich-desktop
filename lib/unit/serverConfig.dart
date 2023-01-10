import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:ostrich_flutter/node/models/node_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../node/models/node_model.dart';

class ServerFileCofig {
 Future<String>  changeConfig(NodeModel node) async{
   Completer<String> completer = Completer();
    Map<String, String> envVars = Platform.environment;
    var home = envVars['UserProfile'].toString();
    //没有文件夹则创建文件夹
    Directory dir = Directory(home + "/.ostrichConfig");
    final String configDir = dir.path;

    rootBundle.loadString("assets/data/socks_auto.json").then((value) async {
/*       final prefs = await SharedPreferences.getInstance();
      final serverList = prefs.getString("server_list");
      List serverData = json.decode(serverList.toString());
      var serverJson = serverData[index]; */

      Map<String, dynamic> jsonMap = json.decode(value);
       Logger().d(jsonMap);
      jsonMap["outbounds"][0]["settings"]["address"] = node.ip;
      jsonMap["outbounds"][0]["settings"]["server_name"] = node.host;
      jsonMap["outbounds"][0]["settings"]["password"] = node.passwd;
      jsonMap["outbounds"][0]["settings"]["port"] = node.port;
      //将配置写入本地
      //写入latest.json
      //没有文件夹则创建文件夹
      Directory dir = Directory(configDir);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      //如果文件存在则删除
      File jsonFile = File(dir.path + "/socks_auto.json");
      var jsonExist = await jsonFile.exists();
      if (jsonExist) {
        await jsonFile.delete();
      }
       Logger().d(!await dir.exists());
       Logger().d(dir.path);
      var stringJson = json.encode(jsonMap);
      stringJson = stringJson
          .replaceAll("REPLACE_ME_WITH_HOST", node.host)
          .replaceAll("REPLACE_ME_WITH_IP", node.ip);
      await File(dir.path + "/latest.json").writeAsString(stringJson);
      Logger().d("成功写入配置文件");
      completer.complete("success");
    });
    return completer.future;
  }
}
