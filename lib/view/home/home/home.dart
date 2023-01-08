import 'dart:async';
import 'dart:io';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ostrich_flutter/unit/native_api.dart';
import 'package:process_run/cmd_run.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart' hide MenuItem;
import 'package:flutter/material.dart';
// import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';
// import 'package:tray_manager/tray_manager.dart' as tray_manager;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ostrich_flutter/node/bloc/node_bloc.dart';
import 'node.dart';
import 'server_list.dart';
import '../../../node/models/node_model.dart';
import '../../../unit/utils.dart';

import 'package:system_tray/system_tray.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TrayListener, WindowListener {
  final List<Widget> _pages = [const NodeService(), const ServerlistPage()];
  // String iconPath = 'assets/images/tray_icon_gray.ico';
  int _currentIndex = 0;
  final List<String> _titles = [
    '设置',
    '节点',
  ];

  void _closeApp() async {
    await windowManager.setPreventClose(true);
    setState(() {});
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

  _winKillPid() async {
    try {
      // Execute!
      await nativeApi.leafShutdown();
      final runInShell = Platform.isWindows;
      var cmd2 = ProcessCmd('taskkill', ['/IM', 'tun2socks.exe', '/F'],
          runInShell: runInShell);
      await runCmd(cmd2, stdout: stdout);
      // _buildTray();
      EasyLoading.showSuccess("已关闭代理");
      ostrichCloseNotification();
    } catch (e) {
      EasyLoading.showInfo("关闭代理失败" + e.toString());
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
    print("888888888888888888888888888 ostrich---start--");
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
    nativeApi.nativeNotification(); //TODO 多次触发

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
      // ostrichStartNotification();//TODO 多次触发
    });
  }

  _checkConnect(Timer timer) async {
    var running = await nativeApi.isRunning();
    if (running) {
      // setState(() {
      //   launchColor = Colors.greenAccent;
      //   // isConnected = true;
      //   // connectStatus = "已连接";
      // });
      context.read<NodeBloc>().add(
            const UpdateConnectStatusEvent(status: true),
          );
      EasyLoading.showToast("已启动新的代理");
      print("已启动代理");
      timer.cancel();
    }
/*     else {
      // setState(() {
      //   launchColor = Colors.deepOrangeAccent;
      //   // isConnected = false;
      //   // connectStatus = "未连接";
      // });

      print("代理没有开启 server");
    } */
  }

  @override
  void initState() {
    super.initState();
    trayManager.addListener(this);
    windowManager.addListener(this);
    _closeApp();
    _buildTray();
  }

  @override
  void dispose() {
    trayManager.removeListener(this);
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowClose() async {
    // bool _isClose = await windowManager.isPreventClose();
    windowManager.hide();
/*     if (!_isClose) {
      // Navigator.of(context).pop(); // Dismiss alert dialog
      await windowManager.hide();
    } else {
      showDialog<void>(
        context: context,
        // false = user must tap button, true = tap outside dialog
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('警告'),
            content: const Text('即将关闭代理，是否继续？'),
            actions: <Widget>[
              TextButton(
                child: const Text('不关闭'),
                onPressed: () async {
                  Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                  await windowManager.hide();
                },
              ),
              TextButton(
                child: const Text('关闭'),
                onPressed: () async {
                  Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                  var running = await nativeApi.isRunning();
                  if (running) {
                    await _winKillPid();
                  }
                  Future.delayed(const Duration(milliseconds: 1500), () {
                    exit(0);
                  });
                },
              ),
            ],
          );
        },
      );
    } */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<NodeBloc, NodeState>(
        // bloc:,
        builder: (context, state) {
      return Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.white,
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      if (index != state.currentMenuIndex) {
                        context.read<NodeBloc>().add(
                              UpdateMenuIndexEvent(index: index),
                            );
                      }
                      _currentIndex = index;
                      setState(() {});
                    },
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      child: Text(
                        _titles[index],
                        style: TextStyle(
                            color: state.currentMenuIndex == index
                                ? Colors.white
                                : Colors.black),
                      ),
                      color: state.currentMenuIndex == index
                          ? Colors.blue.withOpacity(.8)
                          : Colors.white,
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Container(
                    height: 1,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Divider(color: Colors.grey[200]),
                  );
                },
                itemCount: _titles.length,
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: IndexedStack(
              index: state.currentMenuIndex,
              children: _pages,
            ),
          )
        ],
      );
    }));
  }

  @override
  Future<void> onTrayIconRightMouseDown() async {
    await trayManager.popUpContextMenu();
    // do something
  }

  @override
  void onWindowFocus() {
    print('onWindowFocus');
    // Make sure to call once.
    // setState(() {});
    // do something
  }

  @override
  Future<void> onTrayIconMouseDown() async {
    // do something, for example pop up the menu
    print("onTrayIconMouseDown");
    // await windowManager.show();
  }

  @override
  void onTrayIconRightMouseUp() {
    // do something
  }

  _startTray() async {
    List<tray_manager.MenuItem> trayItem = [
      tray_manager.MenuItem(
        label: "启动",
      ),
      tray_manager.MenuItem.separator(),
      tray_manager.MenuItem(label: "设置"),
      tray_manager.MenuItem.separator(),
      tray_manager.MenuItem(label: "退出程序"),
    ];
    await trayManager.setIcon('assets/images/tray_icon_gray.ico');
    await trayManager.setContextMenu(tray_manager.Menu(items: trayItem));
  }

  _closetTray() async {
    List<tray_manager.MenuItem> trayItem = [
      tray_manager.MenuItem(
        label: "关闭",
      ),
      tray_manager.MenuItem.separator(),
      tray_manager.MenuItem(label: "设置"),
      tray_manager.MenuItem.separator(),
      tray_manager.MenuItem(label: "退出程序"),
    ];
    await trayManager.setIcon('assets/images/tray_icon.ico');
    await trayManager.setContextMenu(tray_manager.Menu(items: trayItem));
  }

  @override
  Future<void> onTrayMenuItemClick(tray_manager.MenuItem menuItem) async {
    print(menuItem.toJson());
    switch (menuItem.label) {
      case "退出程序":
        {
          var running = await nativeApi.isRunning();
          if (running) {
            await _winKillPid();
          }
          exit(0);
          /*          Future.delayed(const Duration(milliseconds: 100), () {
            exit(0);
          }); */
        }
      case "设置":
        {
          await windowManager.show();
          await windowManager.focus();
          Navigator.of(context).pushNamed("/main_menu_setting");
        }
        break;
/*       case "启动":
        {
          print("_ostrichStart");
          _ostrichStart();
          context.read<NodeBloc>().add(
                const UpdateConnectStatusEvent(status: true),
              );
          // EasyLoading.showToast("已启动代理");
          _closetTray();
        }
        break;
      case "关闭":
        {
          _winKillPid();
          context.read<NodeBloc>().add(
                const UpdateConnectStatusEvent(status: false),
              );
          // EasyLoading.showToast("已关闭代理");
          _startTray();
        }
        break; */
    }
  }

  @override
  void onWindowMinimize() {
    print("mini ---");
    windowManager.hide();
  }
}
