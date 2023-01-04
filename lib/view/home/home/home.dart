import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' hide MenuItem;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:process_run/cmd_run.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tray_manager/tray_manager.dart' as tray_manager;
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ostrich_flutter/node/bloc/node_bloc.dart';
import '../../../unit/native_api.dart';
import 'node.dart';
import 'server_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TrayListener, WindowListener  {
  final List<Widget> _pages = [const NodeService(), const ServerlistPage()];
  String iconPath = 'assets/images/tray_icon_gray.ico';

  final List<String> _titles = [
    '设置',
    '节点',
  ];

  int _currentIndex = 0;

  void _closeApp() async {
    await windowManager.setPreventClose(true);
    setState(() {});
  }

  _buildTray() async {
    NodeState state =  context.read<NodeBloc>().state;
    bool isConnected = state.connectStatus;
    print("home页面_buildTray");
    print(isConnected);

    List<tray_manager.MenuItem> trayItem = [
      tray_manager.MenuItem(
          label: isConnected ? "关闭" : "启动",
          onClick: (menuItem) async {
            if (isConnected) {
              // setState(() {
              //   menuItem.label = "开启";
              //   iconPath = 'assets/images/tray_icon_gray.ico';
              // });
              _winKillPid();
              context.read<NodeBloc>().add(
                const UpdateConnectStatusEvent(status: false),
              );
            } else {
              // setState(() {
              //   menuItem.label = "关闭";
              //   iconPath = 'assets/images/tray_icon.ico';
              // });
              _ostrichStart();
              context.read<NodeBloc>().add(
                const UpdateConnectStatusEvent(status: true),
              );
            }
          }
          ),
      tray_manager.MenuItem.separator(),
      tray_manager.MenuItem(label: "设置"),
      tray_manager.MenuItem.separator(),
      tray_manager.MenuItem(label: "退出程序"),
    ];
    await trayManager.setIcon(isConnected?'assets/images/tray_icon.ico':'assets/images/tray_icon_gray.ico');
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
      _buildTray();
      EasyLoading.showSuccess("已关闭");
    } catch (e) {
      EasyLoading.showInfo("关闭失败" + e.toString());
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
      await nativeApi.leafRun(
          configPath: configPath,
          wintunPath: tunPath,
          tun2SocksPath: socksPath);

    }
  }

  _checkConnect(Timer timer) async {
    var running = await nativeApi.isRunning();
    if (running) {
      context.read<NodeBloc>().add(
        const UpdateConnectStatusEvent(status: true),
      );
      _buildTray();
      EasyLoading.showToast("已开启");
      print("代理已开启");
      timer.cancel();
    } else {
      context.read<NodeBloc>().add(
        const UpdateConnectStatusEvent(status: false),
      );
      _buildTray();
      EasyLoading.showToast("开启失败");
      print("代理没有开启");
    }
  }

  @override
  void initState() {
    trayManager.addListener(this);
    super.initState();
    windowManager.addListener(this);
    _closeApp();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowClose() async {
    bool _isClose = await windowManager.isPreventClose();
    if (_isClose) {
      showDialog<void>(
        context: context,
        // false = user must tap button, true = tap outside dialog
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('警告'),
            content: const Text('即将关闭本程序，是否继续？'),
            actions: <Widget>[
              TextButton(
                child: const Text('取消'),
                onPressed: () {
                  Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                },
              ),
              TextButton(
                child: const Text('关闭'),
                onPressed: () async {
                  Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                  await windowManager.destroy();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _buildTray();
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
                      print(
                          "index $index, currentIndex: ${state.currentMenuIndex}");
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
}
