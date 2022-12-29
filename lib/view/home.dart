import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:dart_ping/dart_ping.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart' hide MenuItem;
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:ostrich_flutter/unit/current_page.dart';
import 'package:ostrich_flutter/unit/native_api.dart';
import 'package:ostrich_flutter/unit/serverConfig.dart';
import 'package:ostrich_flutter/widget/open_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:process_run/cmd_run.dart';
import 'dart:async';
import 'package:process_run/shell.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http_network;
import 'package:tray_manager/tray_manager.dart';
import 'package:tray_manager/tray_manager.dart' as tray_manager;
import 'package:window_manager/window_manager.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with TrayListener, WindowListener {
  var adminPasswd = "";
  MaterialAccentColor launchColor = Colors.deepOrangeAccent;
  var isConnected = false;
  var connectStatus = "未连接";
  var serverBabel = "当前服务器地址";
  bool isFirstConnect = true;
  late final nativeApi = getDyLibApi();
  List<DropdownMenuItem<String>> serverDropMenuItem = [];
  List<String> savedItem = [];
  var chooseItem;
  Menu? _menu;
  @override
  void initState() {
    super.initState();
    // CurrentPage.currentPage = "home_page";
    trayManager.addListener(this);
    windowManager.addListener(this);
    _isExistServerList();
    _buildTray();
  }

  @override
  void dispose() {
    trayManager.removeListener(this);
    windowManager.removeListener(this);
    super.dispose();
  }

  _buildTray() async {
    List<tray_manager.MenuItem> trayItem = [
      tray_manager.MenuItem(
          label: isConnected ? "关闭" : "启动",
          onClick: (menuItem) async {
            if (isConnected) {
              setState(() {
                menuItem.label = "开启";
                isConnected = false;
              });
              _winKillPid();
              _buildTray();
            } else {
              setState(() {
                menuItem.label = "关闭";
                isConnected = true;
              });
              _ostrichStart();
              _buildTray();
              String iconPath = 'assets/images/tray_icon.ico';
              await trayManager.setIcon(iconPath);
            }
          }),
      //  tray_manager.MenuItem.separator(),
      //  tray_manager.MenuItem(
      //   label: "服务器列表"
      // ),
      tray_manager.MenuItem.separator(),
      tray_manager.MenuItem(label: "设置"),
      tray_manager.MenuItem(label: "退出程序"),
    ];
    String iconPath = 'assets/images/tray_icon_gray.ico';
    await trayManager.setIcon(iconPath);
    await trayManager.setContextMenu(tray_manager.Menu(items: trayItem));
  }

  _isExistServerList() async {
/*     final prefs = await SharedPreferences.getInstance();
    //如果没有配置
    // prefs.remove("server_list");
    final serverList = prefs.getString("server_list");
    if(serverList==null || serverList == ""){
    await  windowManager.show();
      Future getReturnResult = Navigator.of(context).pushNamed("/add_server");
      getReturnResult.then((value) => {
        print("路由传值"),
        _dealServerListData(),

      });
    }else{
     await windowManager.hide();
      _dealServerListData();
    } */

    Navigator.of(context).pushNamed("/main_menu");
  }

  _dealServerListData() async {
    final prefs = await SharedPreferences.getInstance();
    final serverList = prefs.getString("server_list");
    List serverData = json.decode(serverList.toString());
    List<DropdownMenuItem<String>> menuItem = [];
    serverData.forEach((element) {
      menuItem.add(DropdownMenuItem(
        child: Text(element["country"] + "--" + element["city"]),
        value: element["country"] + "--" + element["city"],
      ));
      savedItem.add(element["country"] + "--" + element["city"]);
    });
    setState(() {
      chooseItem = serverData[0]["country"] + "--" + serverData[0]["city"];
      serverDropMenuItem = menuItem;
    });
  }

  _winKillPid() async {
    try {
      // Execute!
      await nativeApi.leafShutdown();
      final runInShell = Platform.isWindows;
      var cmd2 = ProcessCmd('taskkill', ['/IM', 'tun2socks.exe', '/F'],
          runInShell: runInShell);
      await runCmd(cmd2, stdout: stdout);
      setState(() {
        launchColor = Colors.deepOrangeAccent;
        isConnected = false;
        connectStatus = "未连接";
      });
      EasyLoading.showSuccess("已关闭");
    } catch (e) {
      EasyLoading.showInfo("关闭失败" + e.toString());
    }
  }

  //开启或关闭代理
  //windows平台
  _winStartOrClose() async {
    final prefs = await SharedPreferences.getInstance();
    var configDir = prefs.getString("configDir");
    Directory dir = Directory(configDir!);
    File jsonFile = File(dir.path + "/latest.json");
    print(await jsonFile.path);
    var jsonExist = await jsonFile.exists();
    if (!jsonExist) {
      EasyLoading.showError("请先添加服务器配置！");
      return;
    }
    var isRunning = await nativeApi.isRunning();
    print(isRunning);
    if (isRunning) {
      // 关闭
      _winKillPid();
    } else {
      // 开启
      // setState(() {
      //       launchColor = Colors.greenAccent;
      //       isConnected = true;
      //       connectStatus = "已连接";
      //     });
      var libDir = dir.path.replaceAll("/", "\\");
      print(libDir);
      var configPath = "$libDir\\latest.json";
      var tunPath = "$libDir\\wintun.dll";
      var socksPath = "$libDir\\tun2socks.exe";
      const timeout = Duration(seconds: 1);
      var count = 0;
      Timer.periodic(timeout, (timer) {
        //callback function
        //1s 回调一次
        count = count + 1;
        print(count);
        if (count > 10) {
          timer.cancel();
          // EasyLoading.showToast("连接失败");
        }
        _checkConnect(timer);
      });
      print("ostrich---start--");
      var result = await nativeApi.leafRun(
          configPath: configPath,
          wintunPath: tunPath,
          tun2SocksPath: socksPath);
      print(result);
    }
  }

  _ostrichStart() async {
    var isRunning = await nativeApi.isRunning();
    print(isRunning);
    if (isRunning) {
      // 关闭
      _winKillPid();
    } else {
      final prefs = await SharedPreferences.getInstance();
      var configDir = prefs.getString("configDir");
      Directory dir = Directory(configDir!);
      var libDir = dir.path.replaceAll("/", "\\");
      print(libDir);
      var configPath = "$libDir\\latest.json";
      var tunPath = "$libDir\\wintun.dll";
      var socksPath = "$libDir\\tun2socks.exe";
      const timeout = Duration(seconds: 1);
      var count = 0;
      Timer.periodic(timeout, (timer) {
        //callback function
        //1s 回调一次
        count = count + 1;
        print(count);
        if (count > 10) {
          timer.cancel();
          // EasyLoading.showToast("连接失败");
        }
        _checkConnect(timer);
      });
      print("ostrich---start--");
      var result = await nativeApi.leafRun(
          configPath: configPath,
          wintunPath: tunPath,
          tun2SocksPath: socksPath);
      print(result);
    }
  }

  _checkConnect(Timer timer) async {
    var running = await nativeApi.isRunning();
    if (running) {
      setState(() {
        launchColor = Colors.greenAccent;
        isConnected = true;
        connectStatus = "已连接";
      });

      EasyLoading.showToast("已开启");
      print("代理已开启");
      timer.cancel();
    } else {
      setState(() {
        launchColor = Colors.deepOrangeAccent;
        isConnected = false;
        connectStatus = "未连接";
      });
      EasyLoading.showToast("开启失败");
      print("代理没有开启");
    }
  }

//  检查代理连接情况
  Future _checkNetwork() async {
    //todo
    var result = await nativeApi.ping(host: "google.com", port: 433);
    if (result == "time out") {
      EasyLoading.showToast("ping google timeout!");
    } else {
      EasyLoading.showToast("ping google $result ms");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.title),
            const Text("  "),
            Text(
              connectStatus,
              style: const TextStyle(fontSize: 12),
            )
          ],
        ),
        centerTitle: true,
        // leading: IconButton(
        //   icon: const Icon(Icons.add),
        //   tooltip: "添加服务器配置",
        //   onPressed: () {
        //     print("click 添加服务器");
        //     Navigator.of(context).pushNamed("/add_server");
        //   },
        // ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.wifi),
            tooltip: "检查代理网络连接",
            onPressed: () {
              _checkNetwork();
            },
          ),
          //增加清除密码的功能
        ],
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                serverBabel,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              DropdownButton(
                  value: chooseItem,
                  items: serverDropMenuItem,
                  onChanged: (value) async {
                    if (isConnected) {
                      setState(() {
                        isConnected = false;
                      });
                      _winKillPid();
                      List<tray_manager.MenuItem> trayItem = [
                        tray_manager.MenuItem(
                            label: isConnected ? "关闭" : "启动",
                            onClick: (menuItem) async {
                              if (isConnected) {
                                setState(() {
                                  menuItem.label = "开启";
                                  isConnected = false;
                                });
                                _winKillPid();
                                _buildTray();
                              } else {
                                setState(() {
                                  menuItem.label = "关闭";
                                  isConnected = true;
                                });
                                _ostrichStart();
                                _buildTray();
                                String iconPath = 'assets/images/tray_icon.ico';
                                await trayManager.setIcon(iconPath);
                              }
                            }),
                        tray_manager.MenuItem.separator(),
                        tray_manager.MenuItem(label: "服务器列表"),
                        tray_manager.MenuItem.separator(),
                        tray_manager.MenuItem(label: "设置"),
                        tray_manager.MenuItem(label: "退出程序"),
                      ];
                      String iconPath = 'assets/images/tray_icon_gray.ico';
                      await trayManager.setIcon(iconPath);
                      await trayManager
                          .setContextMenu(tray_manager.Menu(items: trayItem));
                    }

                    int itemIndex = savedItem.indexOf(value.toString());
                    ServerFileCofig.changeConfig(itemIndex);
                    setState(() {
                      chooseItem = value;
                    });
                    windowManager.hide();
                  })
            ],
          )
        ]),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //    _winStartOrClose();
      //   },
      //   tooltip: "点击开启或者关闭代理",
      //   backgroundColor: launchColor,
      //   child: const Icon(
      //     Icons.airplanemode_active,
      //   ),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void onWindowFocus() {
    print('onWindowFocus');
    // Make sure to call once.
    setState(() {});
    // do something
  }

  @override
  Future<void> onTrayIconMouseDown() async {
    // do something, for example pop up the menu
    print("onTrayIconMouseDown");
    await windowManager.show();
    setState(() {
      serverBabel = "当前服务器地址";
    });
  }

  @override
  Future<void> onTrayIconRightMouseDown() async {
    await trayManager.popUpContextMenu();
    // do something
  }

  @override
  void onTrayIconRightMouseUp() {
    // do something
  }

  @override
  Future<void> onTrayMenuItemClick(MenuItem menuItem) async {
    print(menuItem.toJson());
    switch (menuItem.label) {
      case "退出程序":
        {
          var running = await nativeApi.isRunning();
          if (running) {
            _winKillPid();
          }
          Future.delayed(Duration(milliseconds: 1500), () {
            exit(0);
          });
        }
        break;
      case "设置":
        {
          // if (CurrentPage.currentPage == "home_page") {
          //   Future getReturnResult =
          //       Navigator.of(context).pushNamed("/add_server");
          //   getReturnResult.then((value) => {
          //         _dealServerListData(),
          //       });
          // }

          Navigator.of(context).pushNamed("/main_menu");

          await windowManager.show();
          await windowManager.focus();
          setState(() {
            serverBabel = "当前服务器地址";
          });
        }
    }

    if (menuItem.label == "服务器列表") {
      await windowManager.show();
      await windowManager.focus();
      setState(() {
        serverBabel = "当前服务器地址";
      });
      if (Navigator.of(context).canPop() &&
          CurrentPage.currentPage == "server_page") {
        Navigator.of(context).pop();
        CurrentPage.currentPage = "home_page";
      }
    }
  }

  @override
  void onWindowClose() async {
    bool _isPreventClose = await windowManager.isPreventClose();
    if (_isPreventClose) {
      windowManager.hide();
    }
    // print(_isPreventClose);
  }

  @override
  void onWindowMinimize() {
    print("mini ---");
    windowManager.hide();
  }
}
