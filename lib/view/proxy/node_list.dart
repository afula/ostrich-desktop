import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';
import 'package:ostrich_flutter/unit/native_api.dart';
import 'dart:io';
import 'dart:async';
import '../../../node/bloc/node_bloc.dart';
import '../../../node/models/node_model.dart';
import '../../../unit/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:process_run/cmd_run.dart';
import '../../../unit/serverConfig.dart';
import 'package:local_notifier/local_notifier.dart';
import 'package:system_tray/system_tray.dart';
import 'package:window_manager/window_manager.dart';
import '../../generated/l10n.dart';

class NodelistPage extends StatefulWidget {
  const NodelistPage({Key? key}) : super(key: key);

  @override
  State<NodelistPage> createState() => _NodelistPageState();
}

class _NodelistPageState extends State<NodelistPage> {
  MaterialAccentColor launchColor = Colors.deepOrangeAccent;
  final Menu _menu = Menu();
  final SystemTray _systemTray = SystemTray();

  @override
  void initState() {
    NodeState state = context.read<NodeBloc>().state;
    bool isConnected = state.connectStatus;
    super.initState();
    _initSystemTray();
    _buildTray(isConnected);
  }

  @override
  void dispose() {
    _systemTray.destroy();
    super.dispose();
  }

  void _initSystemTray() {
    NodeState state = context.read<NodeBloc>().state;
    bool isConnected = state.connectStatus;
    _systemTray.initSystemTray(
        iconPath: isConnected
            ? 'assets/images/tray_icon.ico'
            : 'assets/images/tray_icon_gray.ico');
  }

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
                    color: state.connectStatus
                        ? Colors.greenAccent
                        : Colors.blueAccent,
                    pressedOpacity: .5,
                    onPressed: () async {
                      if ((state.connectedNode.ip ==
                              state.nodeModel[state.currentNodeIndex].ip) &&
                          state.connectStatus) {
                        String connected = S.of(context).connected;
                        EasyLoading.showSuccess(
                            "$connected: ${state.connectedNode.country}-${state.connectedNode.city}",
                            maskType: EasyLoadingMaskType.clear);
                        return;
                      }
                      try {
                        _switchNode();
                        ostrichSwitchSuccessNotification(S.of(context).changed);
                      } catch (_) {
                        ostrichSwitchFailedNotification(
                            S.of(context).changeFailure);
                      }
                    },
                    child: state.connectStatus
                        ? RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: S.of(context).change,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                    text:
                                        '\n${S.of(context).connected}: ${state.connectedNode.country}-${state.connectedNode.city}',
                                    style: const TextStyle(
                                        // fontStyle: FontStyle.italic,
                                        fontSize: 12,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w100)),
                              ],
                            ),
                          )
                        : Text(S.of(context).change)))
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
          title: Text(
              "${state.nodeModel[index].country}--${state.nodeModel[index].city}"),
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
    var isRunning = await nativeApi.isRunning();
    if (isRunning) {
      // 关闭
      try {
        // Execute!
        EasyLoading.showSuccess(S.of(context).starting,
            maskType: EasyLoadingMaskType.clear,
            duration: const Duration(seconds: 20));
        await nativeApi.leafShutdown().then((_) async {
          final runInShell = Platform.isWindows;
          var cmd2 = ProcessCmd('taskkill', ['/IM', 'tun2socks.exe', '/F'],
              runInShell: runInShell);
          await runCmd(cmd2, stdout: stdout).then((_) async {
            ostrichCloseSuccessNotification(S.of(context).started);
            _ostrichStart();
            _buildTray(true);
          });
        });
      } catch (e) {
        EasyLoading.showInfo("清理旧的代理失败" + e.toString());
        context.read<NodeBloc>().add(
              const UpdateConnectStatusEvent(status: false),
            );
        _buildTray(false);
        ostrichCloseFailedNotification(S.of(context).proxyInitFailure);
        rethrow;
      }
      return;
    }

    try {
      EasyLoading.showSuccess(S.of(context).starting,
          maskType: EasyLoadingMaskType.clear,
          duration: const Duration(seconds: 20));
      _ostrichStart();
      _buildTray(true);
    } catch (_) {
      _buildTray(false);
      rethrow;
    }
  }

  void _buildTray(bool isConnected) async {
    await _systemTray.destroy();
    _initSystemTray();
    NodeState state = context.read<NodeBloc>().state;

    _systemTray.setSystemTrayInfo(
        iconPath: isConnected
            ? 'assets/images/tray_icon.ico'
            : 'assets/images/tray_icon_gray.ico');
    await _menu.buildFrom([
      state.nodeModel.isEmpty
          ? MenuSeparator()
          : MenuItemLabel(
              label: isConnected ? S.of(context).close : S.of(context).launch,
              onClicked: (menuItem) async {
                if (isConnected) {
                  await nativeApi.leafShutdown().then((_) async {
                    final runInShell = Platform.isWindows;
                    var cmd2 = ProcessCmd(
                        'taskkill', ['/IM', 'tun2socks.exe', '/F'],
                        runInShell: runInShell);
                    await runCmd(cmd2, stdout: stdout).then((_) async {
                      ostrichCloseSuccessNotification(S.of(context).closed);
                      context.read<NodeBloc>().add(
                            const UpdateConnectStatusEvent(status: false),
                          );
                      _buildTray(false);
                    });
                  });
                } else {
                  try {
                    _ostrichStart();

                    _buildTray(true);
                  } catch (_) {
                    return;
                  }
                }
              },
            ),
      MenuSeparator(),
      MenuItemLabel(
          label: S.of(context).setting,
          onClicked: (menuItem) async {
            await windowManager.show();
            await windowManager.focus();
            Navigator.of(context).pushNamed("/main_menu_setting");
          }),
      MenuSeparator(),
      MenuItemLabel(
          label: S.of(context).exit,
          onClicked: (menuItem) async {
            var running = await nativeApi.isRunning();
            if (running) {
              await _winKillPid();
            }
            exit(0);
          }),
    ]);
    await _systemTray.setContextMenu(_menu);

    _systemTray.registerSystemTrayEventHandler((eventName) {
      if (eventName == kSystemTrayEventClick) {
        _systemTray.popUpContextMenu();
      }
/*       else if (eventName == kSystemTrayEventRightClick) {
        _systemTray.popUpContextMenu();
      } else if (eventName == kSystemTrayEventDoubleClick) {} */
    });
  }

  _winKillPid() async {
    NodeState state = context.read<NodeBloc>().state;
    try {
      // Execute!
      // EasyLoading.showSuccess("正在清理旧的代理");
      await nativeApi.leafShutdown();
      // EasyLoading.showSuccess("已经清理旧的代理");
      final runInShell = Platform.isWindows;
      var cmd2 = ProcessCmd('taskkill', ['/IM', 'tun2socks.exe', '/F'],
          runInShell: runInShell);
      await runCmd(cmd2, stdout: stdout);

      ostrichCloseSuccessNotification(S.of(context).closed);
    } catch (e) {
      EasyLoading.showInfo("清理旧的代理失败$e");
      ostrichCloseFailedNotification(S.of(context).closedFailure);
    }
  }

  _ostrichStart() async {
    NodeState state = context.read<NodeBloc>().state;
/*     var isRunning = await nativeApi.isRunning();
     Logger().d("isRunning $isRunning");
    if (isRunning) {
      // 关闭
      _winKillPid();
    } */
/*     EasyLoading.showToast("正在启动新的代理,请稍后！",
        maskType: EasyLoadingMaskType.clear,
        duration: const Duration(seconds: 10)); */

    NodeModel node = state.nodeModel[state.currentNodeIndex];
    var configRes = await ServerFileCofig().changeConfig(node);
    Logger().d(configRes);
    Logger().d("准备启动");
    final prefs = await SharedPreferences.getInstance();
    var configDir = prefs.getString("configDir");
    Directory dir = Directory(configDir!);
    var libDir = dir.path.replaceAll("/", "\\");
    Logger().d(libDir);
    var configPath = "$libDir\\latest.json";
    var tunPath = "$libDir\\wintun.dll";
    var socksPath = "$libDir\\tun2socks.exe";
    const timeout = Duration(seconds: 1);
    var count = 0;
    try {
      nativeApi.leafRun(
              configPath: configPath,
              wintunPath: tunPath,
              tun2SocksPath: socksPath)
          /*          .then((_) async {
        Timer.periodic(timeout, (timer) {
          //callback function
          //1s 回调一次
          count = count + 1;
          if (count > 10) {
            timer.cancel();
            context.read<NodeBloc>().add(
                  const UpdateConnectStatusEvent(status: false),
                );
            EasyLoading.showToast("启动新的代理失败");
            ostrichStartFailedNotification();
            return;
            // EasyLoading.showToast("连接失败");
          }
          _checkConnect(timer);
          // nativeApi.nativeNotification(); //TODO 多次触发
        });

        context.read<NodeBloc>().add(
              UpdateConnectedNodeEvent(node: node),
            );
        context.read<NodeBloc>().add(
              const UpdateConnectStatusEvent(status: true),
            );
        ostrichStartSuccessNotification(); //TODO 多次触发
      }) */
          ;

      Timer.periodic(timeout, (timer) {
        //callback function
        //1s 回调一次
        count = count + 1;
        if (count > 10) {
          timer.cancel();
          context.read<NodeBloc>().add(
                const UpdateConnectStatusEvent(status: false),
              );
          EasyLoading.showToast("启动新的代理失败");
          ostrichStartFailedNotification(S.of(context).proxyInitFailure);
          return;
          // EasyLoading.showToast("连接失败");
        }
        _checkConnect(timer);
        // nativeApi.nativeNotification(); //TODO 多次触发
      });

      context.read<NodeBloc>().add(
            UpdateConnectedNodeEvent(node: node),
          );
      context.read<NodeBloc>().add(
            const UpdateConnectStatusEvent(status: true),
          );
      ostrichStartSuccessNotification(S.of(context).started); //TODO 多次触发
    } catch (e) {
      ostrichStartFailedNotification(S.of(context).proxyInitFailure);
      rethrow;
    }
  }

  _checkConnect(Timer timer) async {
    var running = await nativeApi.isRunning();
    if (running) {
      timer.cancel();
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
