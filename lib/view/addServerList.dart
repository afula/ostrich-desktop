import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';
import 'package:ostrich_flutter/unit/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:window_manager/window_manager.dart';

import '../unit/current_page.dart';

class AddServerList extends StatefulWidget {
  const AddServerList({Key? key}) : super(key: key);
  @override
  State<AddServerList> createState() => _AddServerList();
}

class _AddServerList extends State<AddServerList> {
  final TextEditingController _serverController = TextEditingController();
  final TextEditingController _idController = TextEditingController();

  @override
  void initState() {
    super.initState();
    CurrentPage.currentPage = "server_page";
    _getSaveValue();
  }

  _getSaveValue() async {
    final prefs = await SharedPreferences.getInstance();
    var server = prefs.getString("ip");
    var user = prefs.getString("id");
    if (server != null && user != null) {
      _serverController.text = server;
      _idController.text = user;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("添加服务器"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
          child: Container(
        padding: const EdgeInsets.fromLTRB(80, 0, 80, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: '服务器地址：',
                labelStyle: TextStyle(color: Colors.blue),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0x00FF0000)),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0x00000000)),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                fillColor: Color(0x30cccccc),
                filled: true,
              ),
              textAlign: TextAlign.center,
              controller: _serverController,
            ),
            Container(
              padding: const EdgeInsets.only(top: 20),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: '用户ID：',
                  labelStyle: TextStyle(color: Colors.blue),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0x00FF0000)),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0x00000000)),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  fillColor: Color(0x30cccccc),
                  filled: true,
                ),
                controller: _idController,
                textAlign: TextAlign.center,
              ),
            ),
            Container(
                padding: const EdgeInsets.only(top: 20),
                child: CupertinoButton(
                    child: const Text("确定"),
                    color: Colors.blueGrey,
                    pressedOpacity: .5,
                    onPressed: () {
                      _getServerList();
                      print("确定");
                      print(_serverController.text);
                      print(_idController.text);
                    }))
          ],
        ),
      )),
    );
  }

  _getServerList() async {
    if (_serverController.text.isEmpty || _idController.text.isEmpty) {
      EasyLoading.showToast("不能输入为空！");
      return;
    }
    const regex =
        "(https?|ftp|file)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]";
    RegExp isUrl = RegExp(regex);
    if (!isUrl.hasMatch(_serverController.text.toString())) {
      EasyLoading.showError("服务器地址格式不正确！");
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    //将服务器地址和用户ID持久存储
    prefs.setString("ip", _serverController.text.toString());
    prefs.setString("id", _idController.text.toString().trim());
    const path = ":443/ostrich/api/mobile/servers/list";
    Map<String, dynamic> data = {
      "user_id": _idController.text.toString().trim(),
      "plateform": 1
    };
    Logger().d("data", data);
    EasyLoading.show(status: '正在获取...');
    HttpNetwork.postJson(_serverController.text.toString() + path, data)
        .then((value) {
      EasyLoading.dismiss();
      print("result is :");
      print(value);
      var str = json.encode(value);
      Map<String, dynamic> data = json.decode(str);
      if (data["code"] == 200) {
        EasyLoading.showToast("获取服务器配置成功！");
        rootBundle
            .loadString("assets/data/socks_auto.json")
            .then((value) async {
          Map<String, dynamic> jsonMap = json.decode(value);
          print(jsonMap);
          jsonMap["outbounds"][0]["settings"]["address"] =
              data["ret"]["server"][0]["ip"];
          jsonMap["outbounds"][0]["settings"]["server_name"] =
          data["ret"]["server"][0]["host"];
          jsonMap["outbounds"][0]["settings"]["password"] =
              data["ret"]["server"][0]["passwd"];
          jsonMap["outbounds"][0]["settings"]["port"] =
              data["ret"]["server"][0]["port"];
          //将配置写入本地
          //写入latest.json
          final prefs = await SharedPreferences.getInstance();
          prefs.setString("server_list", jsonEncode(data["ret"]["server"]));
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
                  "REPLACE_ME_WITH_HOST", "${data["ret"]["server"][0]["host"]}")
              .replaceAll(
                  "REPLACE_ME_WITH_IP", "${data["ret"]["server"][0]["ip"]}");
          await File(dir.path + "/latest.json").writeAsString(stringJson);
          Future.delayed(Duration(seconds: 2),(){
            windowManager.hide();
            CurrentPage.currentPage = "home_page";
            Navigator.of(context).pop("savedServerList");
          });
        });
      } else {
        EasyLoading.showToast(data["msg"]);
      }
    }).onError((error, stackTrace) {
      print("error is :");
      print(error);
    });
  }
}
