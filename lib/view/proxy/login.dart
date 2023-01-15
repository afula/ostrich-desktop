import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';
import 'package:ostrich_flutter/node/bloc/node_bloc.dart';
import 'package:ostrich_flutter/unit/http.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';

import '../../../node/models/node_model.dart';
import '../../../node/database/db.dart';

class LoginService extends StatefulWidget {
  const LoginService({Key? key}) : super(key: key);
  @override
  State<LoginService> createState() => _LoginService();
}

class _LoginService extends State<LoginService> {
  final TextEditingController _serverController = TextEditingController();
  final TextEditingController _idController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
      body: BlocBuilder<NodeBloc, NodeState>(
          // bloc:,

          builder: (context, state) {
        return Center(
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
                      child: const Text("确定 "),
                      color: Colors.blueGrey,
                      pressedOpacity: .5,
                      onPressed: () async {
                        _getServerList();
                        Logger().d("确定");
                        Logger().d(_serverController.text);
                        Logger().d(_idController.text);
                      }))
            ],
          ),
        ));
      }),
    );
  }

//split old _getServerList into _getServerList and _update
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
        .then((value) async {
      EasyLoading.dismiss();
      Logger().d("result is :");
      Logger().d(value);
      var str = json.encode(value);
      Map<String, dynamic> data = json.decode(str);
      if (data["code"] == 200) {
        EasyLoading.showToast("获取服务器配置成功！");
        List<NodeModel> nodeList = [];
        List serverList = data["ret"]["server"];
        for (int item = 0; item < serverList.length; item++) {
          String ip = serverList[item]['ip'].toString();
          String host = serverList[item]['host'].toString();
          String passwd = serverList[item]['passwd'].toString();
          int port = serverList[item]['port'];
          String country = serverList[item]['country'].toString();
          String city = serverList[item]['city'].toString();

          NodeModel model = NodeModel(
            ip: ip,
            host: host,
            passwd: passwd,
            port: port,
            country: country,
            city: city,
          );
          nodeList.add(model);

          DBHelper.insert(DBHelper.nodeTable, {
            'ip': ip,
            'host': host,
            'passwd': passwd,
            'port': port,
            'country': country,
            'city': city,
          });
        }
        //保存数据
        context.read<NodeBloc>().add(
              AddNodeEvent(nodeList: nodeList),
            );

        rootBundle
            .loadString("assets/data/socks_auto.json")
            .then((value) async {
          Map<String, dynamic> jsonMap = json.decode(value);
          Logger().d(jsonMap);
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
          Logger().d(!await dir.exists());
          Logger().d(dir.path);
          var stringJson = json.encode(jsonMap);
          stringJson = stringJson
              .replaceAll(
                  "REPLACE_ME_WITH_HOST", "${data["ret"]["server"][0]["host"]}")
              .replaceAll(
                  "REPLACE_ME_WITH_IP", "${data["ret"]["server"][0]["ip"]}");
          await File(dir.path + "/latest.json").writeAsString(stringJson);
          Future.delayed(Duration(seconds: 2), () {
            //页面跳转
            context.read<NodeBloc>().add(
                  const UpdateMenuIndexEvent(index: 1),
                );
          });
        });
      } else {
        EasyLoading.showToast(data["msg"]);
/*         await _getServerListFromDb();
        context.read<NodeBloc>().add(
              const UpdateMenuIndexEvent(index: 1),
            ); */
      }
    }).onError((error, stackTrace) async {
      EasyLoading.dismiss(); //TODO: more error handling
      EasyLoading.showSuccess("网络获取节点失败，正在为您获取内置节点！",
          maskType: EasyLoadingMaskType.clear,
          duration: const Duration(seconds: 20));
      Logger().d("error is :");
      Logger().d(error);
      await _getServerListFromDb();
      context.read<NodeBloc>().add(
            const UpdateMenuIndexEvent(index: 1),
          );
    });
  }

  _getServerListFromDb() async {
    final dataList = await DBHelper.selectAll(DBHelper.nodeTable);

    final nodeList = dataList
        .map((item) => NodeModel(
              ip: item['ip'],
              host: item['host'],
              passwd: item['passwd'],
              port: item['port'],
              country: item['country'],
              city: item['city'],
            ))
        .toList();

    context.read<NodeBloc>().add(
          AddNodeEvent(nodeList: nodeList),
        );
  }
}
