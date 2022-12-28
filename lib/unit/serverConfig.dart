import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServerFileCofig{
  static changeConfig(int index){
    rootBundle
        .loadString("assets/data/socks_auto.json")
        .then((value) async {
      final prefs = await SharedPreferences.getInstance();
      final serverList = prefs.getString("server_list");
      List serverData = json.decode(serverList.toString());
      Map<String, dynamic> jsonMap = json.decode(value);
      print(jsonMap);
      var serverJson = serverData[index];
      jsonMap["outbounds"][0]["settings"]["address"] = serverJson["ip"];
      jsonMap["outbounds"][0]["settings"]["server_name"] = serverJson["host"];
      jsonMap["outbounds"][0]["settings"]["password"] = serverJson["passwd"];
      jsonMap["outbounds"][0]["settings"]["port"] = serverJson["port"];
      //将配置写入本地
      //写入latest.json
      var configDir = prefs.getString("configDir");
      //没有文件夹则创建文件夹
      Directory dir = Directory(configDir!);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      //如果文件存在则删除
      File jsonFile = File(dir.path + "/socks_auto.json");
      var jsonExist = await jsonFile.exists();
      if (jsonExist) {
        await jsonFile.delete();
      }
      print(!await dir.exists());
      print(dir.path);
      var stringJson = json.encode(jsonMap);
      stringJson = stringJson
          .replaceAll(
          "REPLACE_ME_WITH_HOST", "${serverJson["host"]}")
          .replaceAll(
          "REPLACE_ME_WITH_IP", "${serverJson["ip"]}");
      await File(dir.path + "/latest.json").writeAsString(stringJson);
    });
  }
}