import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ostrich_flutter/unit/native_api.dart';
import 'dart:io';
import 'dart:async';
import '../../../node/bloc/node_bloc.dart';
import '../../../node/models/node_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:tray_manager/tray_manager.dart' as tray_manager;
// import 'package:window_manager/window_manager.dart';
import 'package:process_run/cmd_run.dart';

class ServerlistPage extends StatefulWidget {
  const ServerlistPage({Key? key}) : super(key: key);

  @override
  State<ServerlistPage> createState() => _ServerlistPageState();
}

class _ServerlistPageState extends State<ServerlistPage> {
  MaterialAccentColor launchColor = Colors.deepOrangeAccent;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<NodeBloc, NodeState>(builder: (context, state) {
/*         return Container(
            margin: const EdgeInsets.all(10),
            child: ListView(
              children: getList(state),
            )); */

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ListView(
                children: getList(state),
              ),
            ),
            Container(
                padding: const EdgeInsets.only(left: 10),
                child: CupertinoButton(
                    child: const Text("切换 "),
                    color: Colors.blueAccent,
                    pressedOpacity: .5,
                    onPressed: () async {
                      _buildTray(state);
                    }))
          ],
        );
      }),
    );
  }

  getList(NodeState state) {
    List<Widget> nodeList = [];
    for (int index = 0; index < state.nodeModel.length; index++) {
      nodeList.add(Container(
        margin: const EdgeInsets.all(10),
        child: CheckboxListTile(
          title: Text(state.nodeModel[index].country +
              "--" +
              state.nodeModel[index].city),
          value: state.currentNodeIndex == index ? true : false,
          checkColor: Colors.green,
          activeColor: Colors.greenAccent,
          onChanged: (value) {
            context.read<NodeBloc>().add(
                  UpdateNodeIndexEvent(index: index),
                );
          },
        ),
      ));
    }
    return nodeList;
  }

  _winKillPid(NodeState state) async {
    // bool isConnected = state.connectStatus;
    try {
      // Execute!
      await nativeApi.leafShutdown();
      final runInShell = Platform.isWindows;
      var cmd2 = ProcessCmd('taskkill', ['/IM', 'tun2socks.exe', '/F'],
          runInShell: runInShell);
      await runCmd(cmd2, stdout: stdout);
      setState(() {
        launchColor = Colors.deepOrangeAccent;
        // isConnected = false;
        context.read<NodeBloc>().add(
              const UpdateConnectStatusEvent(status: false),
            );

        // connectStatus = "未连接";
      });
      EasyLoading.showSuccess("已关闭");
    } catch (e) {
      EasyLoading.showInfo("关闭失败" + e.toString());
    }
  }

  _buildTray(NodeState state) async {
    bool isConnected = state.connectStatus;
    print("build tray");
    List<tray_manager.MenuItem> trayItem = [
      tray_manager.MenuItem(
          label: isConnected ? " 关闭" : " 启动",
          onClick: (menuItem) async {
            if (isConnected) {
              setState(() {
                menuItem.label = " 开启";
                // isConnected = false;
              });
              context.read<NodeBloc>().add(
                    const UpdateConnectStatusEvent(status: false),
                  );
              _winKillPid(state);
              // _buildTray(state);
            } else {
              setState(() {
                menuItem.label = " 关闭";
                // isConnected = true;
              });
              context.read<NodeBloc>().add(
                    const UpdateConnectStatusEvent(status: true),
                  );
              _ostrichStart(state);
              // _buildTray(state);
              // String iconPath = 'assets/images/tray_icon.ico';
              // await trayManager.setIcon(iconPath);
            }
          }),
      //  tray_manager.MenuItem.separator(),
      //  tray_manager.MenuItem(
      //   label: "服务器列表"
      // ),
      tray_manager.MenuItem.separator(),
      tray_manager.MenuItem(label: " 设置"),
      tray_manager.MenuItem.separator(),
      tray_manager.MenuItem(label: "退出程序"),
    ];
    String iconPath = 'assets/images/tray_icon_gray.ico';
    await trayManager.setIcon(iconPath);
    await trayManager.setContextMenu(tray_manager.Menu(items: trayItem));
  }

  _ostrichStart(NodeState state) async {
    var isRunning = await nativeApi.isRunning();
    print(isRunning);
    if (isRunning) {
      // 关闭
      _winKillPid(state);
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
        // isConnected = true;
        // connectStatus = "已连接";
      });
      context.read<NodeBloc>().add(
            const UpdateConnectStatusEvent(status: true),
          );
      EasyLoading.showToast("已开启");
      print("代理已开启");
      timer.cancel();
    } else {
      setState(() {
        launchColor = Colors.deepOrangeAccent;
        // isConnected = false;
        // connectStatus = "未连接";
      });
      context.read<NodeBloc>().add(
            const UpdateConnectStatusEvent(status: false),
          );
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
}
