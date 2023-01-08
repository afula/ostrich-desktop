import 'package:flutter/cupertino.dart';
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
import 'package:process_run/cmd_run.dart';
import '../../../unit/serverConfig.dart';
import 'package:local_notifier/local_notifier.dart';

class ServerlistPage extends StatefulWidget {
  const ServerlistPage({Key? key}) : super(key: key);

  @override
  State<ServerlistPage> createState() => _ServerlistPageState();
}

class _ServerlistPageState extends State<ServerlistPage> {
  MaterialAccentColor launchColor = Colors.deepOrangeAccent;

  LocalNotification? ostrichSwitchNotification = LocalNotification(
    identifier: 'ostrichSwitchNotification',
    title: "Ostrich",
    body: "代理已经切换!",
/*     actions: [
      LocalNotificationAction(
        text: 'Yes',
      ),
      LocalNotificationAction(
        text: 'No',
      ),
    ], */
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<NodeBloc, NodeState>(builder: (context, state) {
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
                padding: const EdgeInsets.only(bottom: 70),
                child: CupertinoButton(
                    child: state.connectStatus
                        ? RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: '切换 ',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                    text: '\n已连接: ${state.connectedNode}',
                                    style: const TextStyle(
                                        // fontStyle: FontStyle.italic,
                                        fontSize: 12,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w100)),
                              ],
                            ),
                          )
                        : const Text("切换 "),
                    color: state.connectStatus
                        ? Colors.greenAccent
                        : Colors.blueAccent,
                    pressedOpacity: .5,
                    onPressed: () async {
                      _switchNode();
                      ostrichSwitchNotification?.show();
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

  _switchNode() async {
    NodeState state = context.read<NodeBloc>().state;
    bool isConnected = state.connectStatus;
    NodeModel node = state.nodeModel[state.currentNodeIndex];
    print("node: $node, index: ${state.currentNodeIndex}");
    ServerFileCofig.changeConfig(node);
    print("build tray, connect status $isConnected");
    /*   if (isConnected) {
      await _winKillPid();
      print("_ostrichStart");
      Future.delayed(Duration(milliseconds: 1500), () {});
      _ostrichStart();
      context.read<NodeBloc>().add(
            const UpdateConnectStatusEvent(status: true),
          );
    } else {
      print("_ostrichStart");
      _ostrichStart();
      context.read<NodeBloc>().add(
            const UpdateConnectStatusEvent(status: true),
          );
    } */
    // print("_winKillPid");
    // await _winKillPid();

    // Future.delayed(Duration(milliseconds: 1500), () {});
    context.read<NodeBloc>().add(
          const UpdateConnectStatusEvent(status: true),
        );
    context.read<NodeBloc>().add(
          UpdateConnectedNodeEvent(node: "${node.country}-${node.city}"),
        );
    print("_ostrichStart: ${node.country}-${node.city}");
     _ostrichStart();
    _buildTray();
  }

  _buildTray() async {
    NodeState state = context.read<NodeBloc>().state;
    bool isConnected = state.connectStatus;

    tray_manager.MenuItem menuItem = tray_manager.MenuItem.separator();

    if (state.nodeModel.isNotEmpty) {
      menuItem = tray_manager.MenuItem(
          label: isConnected ? "关闭" : "启动",
          onClick: (menuItem) async {
            if (isConnected) {
              _winKillPid();
/*               setState(() {
                menuItem.label = " 启动";
                // isConnected = false;
              }); */
              context.read<NodeBloc>().add(
                    const UpdateConnectStatusEvent(status: false),
                  );
               _buildTray();
            } else {
               _ostrichStart();
/*               setState(() {
                menuItem.label = " 关闭";
                // isConnected = true;
              }); */
              context.read<NodeBloc>().add(
                    const UpdateConnectStatusEvent(status: true),
                  );
               _buildTray();
            }
          });
    }

    List<tray_manager.MenuItem> trayItem = [
      menuItem,
      tray_manager.MenuItem.separator(),
      tray_manager.MenuItem(label: "设置"),
      tray_manager.MenuItem.separator(),
      tray_manager.MenuItem(label: "退出程序"),
    ];
    await trayManager.setIcon(isConnected
        ? 'assets/images/tray_icon.ico'
        : 'assets/images/tray_icon_gray.ico');
    await trayManager.setContextMenu(tray_manager.Menu(items: trayItem));
  }

  _closetTray() async {
    List<tray_manager.MenuItem> trayItem = [
      tray_manager.MenuItem(
          label: "关闭",
          onClick: (menuItem) async {
            _winKillPid();
            context.read<NodeBloc>().add(
                  const UpdateConnectStatusEvent(status: false),
                );
            // EasyLoading.showToast("已关闭代理");
            _startTray();
          }),
      tray_manager.MenuItem.separator(),
      tray_manager.MenuItem(label: "设置"),
      tray_manager.MenuItem.separator(),
      tray_manager.MenuItem(label: "退出程序"),
    ];
    await trayManager.setIcon('assets/images/tray_icon.ico');
    await trayManager.setContextMenu(tray_manager.Menu(items: trayItem));
  }

  _startTray() async {
    List<tray_manager.MenuItem> trayItem = [
      tray_manager.MenuItem(
          label: "启动",
          onClick: (menuItem) async {
            print("_ostrichStart");
            await _ostrichStart();
            context.read<NodeBloc>().add(
                  const UpdateConnectStatusEvent(status: true),
                );
            // EasyLoading.showToast("已启动代理");
            _closetTray();
          }),
      tray_manager.MenuItem.separator(),
      tray_manager.MenuItem(label: "设置"),
      tray_manager.MenuItem.separator(),
      tray_manager.MenuItem(label: "退出程序"),
    ];
    await trayManager.setIcon('assets/images/tray_icon_gray.ico');
    await trayManager.setContextMenu(tray_manager.Menu(items: trayItem));
  }

  _winKillPid() async {
    NodeState state = context.read<NodeBloc>().state;
    try {
      // Execute!
      EasyLoading.showSuccess("正在清理旧的代理");
      await nativeApi.leafShutdown();
      final runInShell = Platform.isWindows;
      var cmd2 = ProcessCmd('taskkill', ['/IM', 'tun2socks.exe', '/F'],
          runInShell: runInShell);
      await runCmd(cmd2, stdout: stdout);
      setState(() {
        launchColor = Colors.deepOrangeAccent;
        // isConnected = false;
        // connectStatus = "未连接";
      });
      EasyLoading.showSuccess("已经清理旧的代理");
    } catch (e) {
      EasyLoading.showInfo("经清理旧的代理失败" + e.toString());
    }
  }

  _ostrichStart() async {
    NodeState state = context.read<NodeBloc>().state;
    var isRunning = await nativeApi.isRunning();
    print("isRunning $isRunning");
    if (isRunning) {
      // 关闭
      _winKillPid();
    }
    EasyLoading.showToast("正在启动新的代理");
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
    print("7777777777777777777777777777 ostrich---start--");
    var result = nativeApi.leafRun(
        configPath: configPath, wintunPath: tunPath, tun2SocksPath: socksPath);
    print("leafRun $result");
    NodeModel node = state.nodeModel[state.currentNodeIndex];
    context.read<NodeBloc>().add(
          UpdateConnectedNodeEvent(node: "${node.country}-${node.city}"),
        );
    context.read<NodeBloc>().add(
          const UpdateConnectStatusEvent(status: true),
        );

    Timer.periodic(timeout, (timer) {
      //callback function
      //1s 回调一次
      count = count + 1;
      print(count);
      if (count > 10) {
        timer.cancel();
        context.read<NodeBloc>().add(
              const UpdateConnectStatusEvent(status: false),
            );
        EasyLoading.showToast("启动新的代理失败");
        // EasyLoading.showToast("连接失败");
      }
      _checkConnect(timer);
      nativeApi.nativeNotification(); //TODO 多次触发
    });
  }

  _checkConnect(Timer timer) async {
    var running = await nativeApi.isRunning();
    if (running) {
/*       setState(() {
        launchColor = Colors.greenAccent;
        // isConnected = true;
        // connectStatus = "已连接";
      }); */
/*       context.read<NodeBloc>().add(
            const UpdateConnectStatusEvent(status: true),
          ); */
      EasyLoading.showToast("已启动新的代理");
      print("已启动代理");
      timer.cancel();
    } else {
/*       setState(() {
        launchColor = Colors.deepOrangeAccent;
        // isConnected = false;
        // connectStatus = "未连接";
      });
 */
      print("代理没有开启 server");
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
